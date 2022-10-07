-- quality of life tweaks

local mq = require("mq")
local log = require("knightlinc/Write")

local assist  = require("e4_Assist")
local follow  = require("e4_Follow")
local commandQueue = require("e4_CommandQueue")
local botSettings = require("e4_BotSettings")

local QoL = {}

local maxFactionLoyalists = false

function QoL.Init()

    QoL.loadRequiredPlugins()

    if botSettings.settings.debug ~= nil and botSettings.settings.debug then
        log.loglevel = "debug"
    end

    if is_rof2() then
        cmd("/consent raid") -- XXX persistent raid consent setting on in INI

        if in_guild() then
            -- enable auto consent for guild
            --cmd("/consent guild")
        end

        -- rof2 client has no persistent setting for /tgb on. it has been permanently auto enabled on live
        cmd("/tgb on")
    end

    -- default loot setting: hide looted corpses
    cmd("/hidec looted")

    if mq.TLO.Me.Combat() then
        cmd("/attack off")
    end

    if is_orchestrator() then
        cmd("/djoin skillup")
        cmd("/djoin xp")
    end

    if not is_script_running("agents/healme") then
        cmd("/lua run agents/healme")
    end

    local dead = function(text, killer)
        all_tellf("I died. Killed by %s", killer)
        cmd("/beep") -- the beep of death
    end

    mq.event("died1", "You have been slain by #*#", dead)
    mq.event("died2", "You died.", dead)

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        if zone == "an area where levitation effects do not function" then
            return
        end

        log.Debug("I zoned into ", zone)
        commandQueue.Add("zoned")
    end)

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            all_tellf("Missing component %s", name)
            cmd("/beep 1")
        end
    end)

    mq.event("tell", "#1# tells you, #2#", function(text, name, msg)
        local s = msg:lower()
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background? we enqueue it to a zone channel !!!
            all_tellf("FIXME handle 'buffme' tell from %s", name)
            cmd("/beep 1")
        else
            -- excludes tells from "Player`s pet" (Permutation Peddler, NPC), "Player`s familiar" (Summoned Banker, Pet)
            local spawn = spawn_from_query('="'..name..'"')
            if spawn ~= nil and (spawn.Type() == "NPC" or spawn.Type() == "Pet") then
                log.Debug("Ignoring tell from "..spawn.Type().." '".. name.. "': "..msg)
                return
            end
            if spawn ~= nil then
                all_tellf("GOT A IN-ZONE TELL FROM "..name..": "..msg.." type "..spawn.Type())
            else
                all_tellf("GOT A TELL FROM "..name..": "..msg)
            end

            cmd("/beep 1")
        end
    end)

    mq.event("skillup", "You have become better at #1#! (#2#)", function(text, name, num)
        cmdf("/dgtell skillup %s (%d/%d)", name, num, skill_cap(name))
    end)

    mq.event("xp", "You gain experience!", function()
        cmd("/dgtell xp Gained xp")
    end)

    mq.event("faction_maxed", "Your faction standing with #1# could not possibly get any better.", function(text, faction)
        if faction == "Dranik Loyalists" then
            if not maxFactionLoyalists then
                log.Info("Maxed loyalist faction")
                maxFactionLoyalists = true
            end
        end
    end)

    -- tells all bards to play given melody name
    mq.bind("/playmelody", function(name)
        if is_orchestrator() then
            cmdf("/dgexecute brd /playmelody %s", name)
        end
        if is_brd() then
            commandQueue.Add("playmelody", name)
        end
    end)

    -- tell peers to kill target until dead
    mq.bind("/assiston", function()
        -- XXX impl "/assiston /not|WAR" filter

        local spawn = mq.TLO.Target
        if spawn() == nil then
            return
        end
        if spawn.Type() ~= "PC" then
            if assist.target ~= nil then
                log.Debug("Backing off existing target before assisting new")
                assist.backoff()
            end
            log.Info("Calling assist on %s, type %s", spawn.DisplayName(), spawn.Type())

            -- tell everyone else to attack
            cmdf("/dgzexecute /killit %d", spawn.ID())
        end
    end)

    -- auto assist on mob until dead
    ---@param mobID string
    mq.bind("/killit", function(mobID)
        commandQueue.Add("killit", mobID)
    end)

    -- ends assist call
    mq.bind("/backoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /backoff")
        end
        assist.backoff()
    end)

    mq.bind("/pbaeon", function()
        if is_orchestrator() then
            cmd("/dgzexecute /pbaeon")
        end
        if botSettings.settings.assist.pbae == nil then
            return
        end
        commandQueue.Add("pbaeon")
    end)

    -- if filter == "all", drop all. else drop partially matched buffs
    mq.bind("/dropbuff", function(filter)
        if filter == nil then
            return
        end
        if is_orchestrator() then
            cmdf("/dgzexecute /dropbuff %s", filter)
        end

        if filter == "all" then
            drop_all_buffs()
        else
            cmdf("/removebuff %s", filter)
        end
    end)

    mq.bind("/dropinvis", function()
        if is_orchestrator() then
            cmd("/dgzexecute /dropinvis")
        end
        commandQueue.Add("dropinvis")
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
        log.Debug("buffit %s", spawnID)
        if is_orchestrator() then
            spawnID = mq.TLO.Target.ID()
            if spawnID ~= 0 then
                cmdf("/dgzexecute /buffit %d", spawnID)
            end
        end

        commandQueue.Add("buffit", spawnID)
    end)

    mq.bind("/buffme", function()
        cmdf("/dgzexecute /buffit %d", mq.TLO.Me.ID())
    end)

    mq.bind("/buffon", function()
        botSettings.toggles.refresh_buffs = true
        if is_orchestrator() then
            cmd("/dgzexecute /buffon")
        end
    end)

    mq.bind("/buffoff", function()
        botSettings.toggles.refresh_buffs = false
        if is_orchestrator() then
            cmd("/dgzexecute /buffoff")
        end
    end)

    -- Perform rez on target or delegate it to nearby cleric
    ---@param spawnID string
    mq.bind("/rezit", function(spawnID)
        if is_orchestrator() then
            if not has_target() then
                log.Error("/rezit: No corpse targeted.")
                return
            end
            local spawn = get_target()
            if spawn == nil then
                log.Error("/rezit: No target to rez.")
                return
            end

            spawnID = spawn.ID()
            if spawn.Type() ~= "Corpse" then
                log.Error("/rezit: Target is not a corpse. Type %s",  spawn.Type())
                return
            end

            if not is_clr() then
                local clrName = nearest_peer_by_class("CLR")
                if clrName == nil then
                    all_tellf("\arERROR\ax: Cannot request rez, no cleric nearby.")
                    return
                end
                log.Info("Requesting rez for \ay%s\ax from \ag%s\ax.", spawn.Name(), clrName)
                cmdf("/dexecute %s /rezit %d", clrName, spawn.ID())
                return
            end
        end

        commandQueue.Add("rezit", tostring(spawnID))
    end)

    mq.bind("/mounton", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mounton")
        end

        if botSettings.settings.mount ~= nil then

            if not mq.TLO.Me.CanMount() then
                all_tellf("MOUNT ERROR, cannot mount in %s", zone_shortname())
                return
            end

            -- XXX see if mount clicky buff is on us already

            local spell = getSpellFromBuff(botSettings.settings.mount)
            if spell == nil then
                all_tellf("/mounton: getSpellFromBuff %s FAILED", botSettings.settings.mount)
                cmd("/beep 1")
                return false
            end

            if have_buff(spell.RankName()) then
                log.Error("I am already mounted.")
                return false
            end

            -- XXX dont summon if we are already mounted.
            log.Info("Summoning mount %s ...", botSettings.settings.mount)
            castSpellAbility(nil, botSettings.settings.mount)
        end
    end)

    mq.bind("/mountoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mountoff")
        end
        log.Info("Dismounting ...")
        cmd("/dismount")
    end)

    mq.bind("/shrinkall", function()
        cmd("/dgzexecute /shrinkgroup")
    end)

    mq.bind("/shrinkgroup", function()
        commandQueue.Add("shrinkgroup")
    end)

    -- tell everyone else to click nearby door/object (pok stones, etc)
    mq.bind("/clickit", function()
        commandQueue.Add("clickit")
    end)

    mq.bind("/portto", function(name)
        name = name:lower()
        if is_orchestrator() then
            cmdf("/dgzexecute /portto %s", name)
        end

        commandQueue.Add("portto", name)
    end)

    mq.bind("/followon", function()
        cmdf("/dgzexecute /followid %d", mq.TLO.Me.ID())
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        follow.Pause()
        follow.spawn = nil
    end)

    -- follows another peer in LoS
    ---@param spawnID integer
    mq.bind("/followid", function(spawnID)
        if not is_peer_id(spawnID) then
            all_tellf("ERROR: /followid called on invalid spawn ID %d", spawnID)
            return
        end

        follow.spawn = spawn_from_id(spawnID)
    end)

    mq.bind("/evac", function(name)

        if is_orchestrator() then
            cmd("/dgzexecute /evac")
        end

        if botSettings.settings.evac == nil then
            return
        end

        -- chose first one we have and use it (skip Exodus if AA is down)
        for key, evac in pairs(botSettings.settings.evac) do
            log.Info("Finding available evac spell %s: %s", key, evac)
            if mq.TLO.Me.AltAbility(evac)() ~= nil then
                if mq.TLO.Me.AltAbilityReady(evac)() then
                    castSpellRaw(evac, mq.TLO.Me.ID(), "-maxtries|3")
                    return
                end
            else
                castSpellRaw(evac, mq.TLO.Me.ID(), "gem5 -maxtries|3")
            end
        end
    end)

    -- tell peers in zone to use Throne of Heroes
    mq.bind("/throne", function()
        if is_orchestrator() then
            cmd("/dgzexecute /throne")
        end
        cast_veteran_aa("Throne of Heroes")
    end)

    local moveToMe = function()
        cmdf("/dgzexecute /movetoid %d", mq.TLO.Me.ID())
    end
    mq.bind("/movetome", moveToMe)
    mq.bind("/mtm", moveToMe)

    -- move to spawn ID
    ---@param spawnID string
    mq.bind("/movetoid", function(spawnID)
        if is_orchestrator() then
            cmdf("/dgzexecute /movetoid %d", spawnID)
        end
        commandQueue.Add("movetoid", spawnID)
    end)

    -- run through zone based on the position of startingPeer
    -- stand near a zoneline and face in the direction of the zoneline, run command for bots to move forward to the other zone
    mq.bind("/rtz", function(startingPeerName)
        if is_orchestrator() then
            -- tell the others to cross zone line
            cmdf("/dgzexecute /rtz %s", mq.TLO.Me.Name())
            return
        end
        commandQueue.Add("rtz", startingPeerName)
    end)

    -- hail or talk to nearby recognized NPC
    mq.bind("/hailit", function()
        commandQueue.Add("hailit")
    end)

    -- tells all peers to hail or talk to nearby recognized NPC
    mq.bind("/hailall", function()
        if is_orchestrator() then
            cmd("/dgzexecute /hailit")
        end
        commandQueue.Add("hailit")
    end)

    -- reports faction status
    mq.bind("/factions", function()
        if maxFactionLoyalists then
            log.Debug("Dranik Loyalists: max ally")
        else
            all_tellf("FACTION: Not max ally with Dranik Loyalists")
        end
    end)

    -- tell all peers to report faction status
    mq.bind("/factionsall", function()
        cmd("/dgaexecute all /factions")
    end)

    -- clear all chat windows on current peer
    mq.bind("/clr", function()
        cmd("/clear")
    end)

    -- clear all chat windows on all peers
    mq.bind("/cls", function()
        cmd("/dgaexecute /clear")
    end)

    mq.bind("/self", function()
        cmd("/target myself")
    end)

    -- hide existing corpses
    mq.bind("/hce", function()
        cmd("/hidec all")
    end)

    -- hide looted corpses
    mq.bind("/hcl", function()
        cmd("/hidec looted")
    end)

    -- hide no corpses
    mq.bind("/hcn", function()
        cmd("/hidec none")
    end)

    -- report toons with few free buff slots
    mq.bind("/freebuffslots", function(name)
        cmd("/noparse /dgaexecute all /if (${Me.FreeBuffSlots} <= 1) /dgtell all FREE BUFF SLOTS: ${Me.FreeBuffSlots}")
    end)
    mq.bind("/fbs", function(name) cmd("/freebuffslots") end)

    -- /raidinvite shorthand
    mq.bind("/ri", function(name)
        cmd("/raidinvite "..name)
    end)

    -- quickly exits all eqgame.exe instances using task manager
    mq.bind("/exitall", function()
        cmd('/exec TASKKILL "/F /IM eqgame.exe" bg')
    end)

    -- quickly exits my eqgame.exe instance using task manager
    mq.bind("/exitme", function()
        all_tellf("Exiting")
        cmd('/exec TASKKILL "/F /PID '..tostring(mq.TLO.EverQuest.PID())..'" bg')
    end)

    mq.bind("/exitnotinzone", function()
        local me = mq.TLO.Me.Name()
        cmd("/noparse /dgaexecute all /if (!${SpawnCount[pc ="..me.."]}) /exitme")
    end)

    mq.bind("/exitnotingroup", function()
        cmd("/noparse /dgaexecute all /if (!${Group.Members}) /exitme")
    end)

    mq.bind("/exitnotinraid", function()
        cmd("/noparse /dgaexecute all /if (!${Raid.Members}) /exitme")
    end)

    -- report all peers who are not in current zone
    mq.bind("/notinzone", function()
        cmd("/noparse /dgaexecute all /if (!${Zone.ShortName.Equal["..zone_shortname().."]}) /dgtell all I'm in ${Zone.ShortName}")
    end)

    mq.bind("/notingroup", function()
        cmd("/noparse /dgaexecute all /if (!${Me.Grouped}) /dgtell all NOT IN GROUP")
    end)

    mq.bind("/ingroup", function()
        cmd("/noparse /dgaexecute all /if (${Me.Grouped}) /dgtell all IN GROUP")
    end)

    mq.bind("/notinraid", function()
        cmd("/noparse /dgaexecute all /if (!${Raid.Members}) /dgtell all NOT IN RAID")
    end)

    mq.bind("/inraid", function()
        cmd("/noparse /dgaexecute all /if (${Raid.Members}) /dgtell all IN RAID")
    end)

    -- report all peers who are not levitating
    mq.bind("/notlevi", function()
        cmd("/noparse /dgaexecute all /if (!${Me.Levitating}) /dgtell all NOT LEVI")
    end)

    mq.bind("/notitu", function()
        cmd("/noparse /dgaexecute all (!${Me.Buff[Sunskin].ID}) /dgtell all NOT ITU")
    end)

    -- report all peers who are not invisible
    mq.bind("/notinvis", function()
        cmd("/noparse /dgaexecute all /if (!${Me.Invis}) /dgtell all NOT INVIS")
    end)

    mq.bind("/invis", function()
        cmd("/noparse /dgaexecute all /if (${Me.Invis}) /dgtell all INVIS")
    end)

    -- useful when AE FD is cast (Cleric 1.5 fight in lfay and so on)
    mq.bind("/standall", function()
        cmd("/noparse /dgaexecute all /if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /stand")
    end)

    -- report all peers who are not standing
    mq.bind("/notstanding", function()
        cmd("/noparse /dgaexecute all /if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /bc NOT STANDING")
    end)

    -- open loot window on closest corpse
    mq.bind("/lcorpse", function()
        if has_target() ~= nil then
            cmd("/squelch /target clear")
        end
        cmd("/target corpse radius 100")
        delay(500, function()
            return has_target()
        end)
        cmd("/loot")
    end)

    -- reports all toons that are not running e4
    mq.bind("/note4", function()
        cmd("/dgaexecute /lua run note4")
    end)

    mq.bind("/running", function()
        -- XXX reports all running scripts on all toons
        log.Error("FIXME impl /running: report all running scripts on all toons")
    end)

    -- runs combine.lua tradeskill script. NOTE: /combine is reserved for MacroQuest.
    mq.bind("/combineit", function()
        if is_script_running("combine") then
            cmd("/lua stop combine")
        end
        cmd("/lua run combine")
    end)

    mq.bind("/handin", function()
        cmd("/lua run handin")
    end)

    local mmrl = function()
        cmdf("/dex %s /makeraidleader %s", mq.TLO.Raid.Leader(), mq.TLO.Me.Name())
    end
    mq.bind("/makemeraidleader", mmrl)
    mq.bind("/mmrl", mmrl)

    -- reports all currently worn auguments
    mq.bind("/wornaugs", function()
        log.Info("Currently worn auguments:")
        local hp = 0
        local mana = 0
        local endurance = 0
        local ac = 0
        for i = 0, 22 do
            if mq.TLO.Me.Inventory(i).ID() then
                for a = 0, mq.TLO.Me.Inventory(i).Augs() do
                    if mq.TLO.Me.Inventory(i).AugSlot(a)() ~= nil then
                        local item = mq.TLO.Me.Inventory(i).AugSlot(a).Item
                        hp = hp + item.HP()
                        mana = mana + item.Mana()
                        endurance = endurance + item.Endurance()
                        ac = ac + item.AC()
                        log.Info(inventory_slot_name(i).." #"..a..": "..item.ItemLink("CLICKABLE")().." "..item.HP().." HP")
                    end
                end
            end
        end
        log.Info("Augument total: "..hp.." HP, "..mana.." mana, "..endurance.." endurance, "..ac.." AC")
    end)

    -- reports all owned clickies (worn, inventory, bank) worn auguments
    mq.bind("/clickies", function()
        log.Info("My clickies:")

        -- XXX TODO skip expendables

        -- XXX 15 sep 2022: item.Expendables() seem to be broken, always returns false ? https://discord.com/channels/511690098136580097/840375268685119499/1019900421248126996

        for i = 0, 32 do -- equipment: 0-22 is worn gear, 23-32 is inventory top level
            if mq.TLO.Me.Inventory(i).ID() then
                local inv = mq.TLO.Me.Inventory(i)
                if inv.Container() > 0 then
                    for c = 1, inv.Container() do
                        local item = inv.Item(c)
                        if item.Clicky() ~= nil and (not item.Expendable()) then
                            --print ( "one ", item.Name(), " ", item.Charges() , " ", item.Expendable())
                            log.Info(inventory_slot_name(i).." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                        end
                    end
                else
                    if inv.Clicky() ~= nil and (not inv.Expendable()) then
                        --print ( "two ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                        log.Info(inventory_slot_name(i).." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                    end
                end
            end
        end

        for i = 1, 26 do -- bank top level slots: 1-24 is bank bags, 25-26 is shared bank
            if mq.TLO.Me.Bank(i)() ~= nil then
                local key = "bank"..tostring(i)
                local inv = mq.TLO.Me.Bank(i)
                if inv.Container() > 0 then
                    for c = 1, inv.Container() do
                        local item = inv.Item(c)
                        if item.Clicky() ~= nil and (not item.Expendable()) then
                            --print ( "three ", item.Name(), " ", item.Charges(), " ", item.Expendable())
                            log.Info(key.." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                        end
                    end
                else
                    if inv.Clicky() ~= nil and (not inv.Expendable()) then
                        --print ( "four ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                        log.Info(key.." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                    end
                end
            end
        end
    end)

    -- cast Summon Clockwork Banker veteran AA yourself, or the first available nearby peer
    mq.bind("/banker", function()
        local aaName = "Summon Clockwork Banker"
        if is_alt_ability_ready(aaName) then
            cast_alt_ability(aaName, mq.TLO.Me.ID())
            return
        end

        log.Warn(aaName.." is not ready. Ready in "..mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())

        if not is_orchestrator() then
            return
        end

        -- if my banker is not ready, check all nearby peers if one is ready and use it.
        local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. " radius 50"

        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            local peer = spawn.Name()
            if is_peer(peer) then
                local value = query_peer(peer, "Me.AltAbilityReady["..aaName.."]", 0)
                if value == "TRUE" then
                    log.Info("Asking %s to activate banker ...", peer)
                    cmdf("/dexecute %s /banker", peer)
                    return
                end
            end
            delay(1)
            doevents()
        end

    end)

    mq.bind("/cohgroup", function()
        cmd("/lua run cohgroup")
    end)

    -- Tell nearby peer corpses to consent me
    mq.bind("/consentme", function()
        local spawnQuery = 'pccorpse radius 500'
        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            log.Info("Asking %s for consent ...", spawn.DisplayName())
            cmdf("/dexecute %s /consent %s", spawn.DisplayName(), mq.TLO.Me.Name())
        end
    end)

    -- summon nearby corpses into a pile
    mq.bind("/gathercorpses", function()
        local spawnQuery = 'pccorpse radius 100'
        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            target_id(spawn.ID())
            delay(2)
            cmd("/corpse")
            delay(1000, function() return spawn.Distance() < 20 end)
        end
    end)

    -- make all peer quit expedition
    mq.bind("/quitexp", function()
        all_tellf("Instructing peers to leave expedition ...")
        cmd("/dgaexecute /dzquit")
    end)

    -- hide all dz windows
    mq.bind("/dzhide", function()
        cmd("/noparse /dgaexecute /if (${Window[dynamiczonewnd]}) /windowstate dynamiczonewnd close")
    end)

    -- report peers with at least 10 unspent AA:s
    mq.bind("/unspentaa", function()
        cmd("/noparse /dgaexecute /if (${Me.AAPoints} >= 10 && ${Me.AAPoints} < 100) /dgtell all UNSPENT AA: ${Me.AAPoints}")
    end)

    -- report peers with less than 10 unspent AA:s
    mq.bind("/lowunspentaa", function()
        cmd("/noparse /dgaexecute /if (${Me.AAPoints} > 1 && ${Me.AAPoints} < 10) /dgtell all UNSPENT AA: ${Me.AAPoints}")
    end)

    -- report peers with any unspent AA:s
    mq.bind("/allunspentaa", function()
        cmd("/noparse /dgaexecute /if (${Me.AAPoints} > 0) /dgtell all UNSPENT AA: ${Me.AAPoints}")
    end)

    -- report all peer total AA:s
    mq.bind("/totalaa", function()
        cmd("/noparse /dgaexecute /dgtell all TOTAL AA: ${Me.AAPointsTotal}")
    end)

    -- finds item by name in inventory/bags. NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    mq.bind("/fdi", function(...)
        local name = trim(args_string(...))
        name = strip_link(name)

        log.Info("Ssearching for %s", name)

        if is_orchestrator() then
            cmdf("/dgzexecute /fdi %s", name)
        end

        local item = find_item(name)
        if item == nil then
            --all_tellf("%s not found", name)
            return
        end

        local cnt = getItemCountExact(item.Name())
        all_tellf("%s in %s (count: %d)", item.ItemLink("CLICKABLE")(), inventory_slot_name(item.ItemSlot()), cnt)
    end)

    -- find missing item
    mq.bind("/fmi", function(...)
        local name = trim(args_string(...))
        name = strip_link(name)

        if is_orchestrator() then
            cmdf("/dgzexecute /fmi %s", name)
        end

        local item = find_item(name)
        if item == nil then
            all_tellf("I miss %s", name)
            return
        end
    end)

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber)
        commandQueue.Add("recallgroup", name, groupNumber)
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        if is_peer(sender) then
            commandQueue.Add("joingroup")
        end
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        if is_peer(sender) then
            commandQueue.Add("joinraid")
        end
    end)

    -- toggles debug output on/off
    mq.bind("/debug", function()
        if log.loglevel == "debug" then
            log.loglevel = "info"
            log.Info("Toggle debug info OFF")
        else
            log.loglevel = "debug"
            log.Info("Toggle debug info ON")
        end
    end)

    clear_cursor()

    QoL.verifySpellLines()
end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2DanNet",
        "MQ2Debuffs", -- XXX not used yet. to be used for auto-cure feature
        "MQ2AdvPath", -- XXX /afollow or /stick ?
        "MQ2MoveUtils",
        "MQ2Nav",
        "MQ2Cast",
    }
    for k, v in pairs(requiredPlugins) do
        if not is_plugin_loaded(v) then
            load_plugin(v)
            log.Warn(v.." was not loaded")
        end
    end

    if is_rof2() then
        local requiredEmuPlugins = {
            "MQ2ConstantAffinity",
            "MQMountClassicModels", -- XXX make use of
        }
        for k, v in pairs(requiredEmuPlugins) do
            if not is_plugin_loaded(v) then
                load_plugin(v)
                log.Warn(v.." was not loaded")
            end
        end
    end
end

-- make sure I know all listed abilities
function QoL.verifySpellLines()

    verifySpellLines("evac", botSettings.settings.evac)
    verifySpellLines("self_buffs", botSettings.settings.self_buffs)

    if botSettings.settings.assist ~= nil then
        verifySpellLines("taunts", botSettings.settings.assist.taunts)
        verifySpellLines("pbae", botSettings.settings.assist.pbae)
        verifySpellLines("abilities", botSettings.settings.assist.abilities)
        verifySpellLines("quickburns", botSettings.settings.assist.quickburns)
        verifySpellLines("longburns", botSettings.settings.assist.longburns)
        verifySpellLines("fullburns", botSettings.settings.assist.fullburns)

        if botSettings.settings.assist.nukes ~= nil then
            for k, v in pairs(botSettings.settings.assist.nukes) do
                verifySpellLines(k, v)
            end
        end
    end

    if botSettings.settings.healing ~= nil then
        verifySpellLines("life_support", botSettings.settings.healing.life_support)
        verifySpellLines("tank_heal", botSettings.settings.healing.tank_heal)
        verifySpellLines("important_heal", botSettings.settings.healing.important_heal)

        if botSettings.settings.healing.cures ~= nil then
            for k, v in pairs(botSettings.settings.healing.cures) do
                verifySpellLines("cures", {k})
            end
        end
    end

    if botSettings.settings.songs ~= nil then
        for k, v in pairs(botSettings.settings.songs) do
            verifySpellLines(k, v)
        end
    end

    if botSettings.settings.pet ~= nil then
        verifySpellLines("pet_heals", botSettings.settings.pet.heals)
        verifySpellLines("pet_buffs", botSettings.settings.pet.buffs)
    end
end

-- Warns if you lack any item etc listed in `lines`.
function verifySpellLines(label, lines)
    if lines == nil then
        return
    end
    for k, row in pairs(lines) do
        local spellConfig = parseSpellLine(row)
        if not known_spell_ability(spellConfig.Name) then
            all_tellf("Missing %s: %s", label, spellConfig.Name)
            cmd("/beep 1")
        end
    end
end

-- Runs every second.
function QoL.Tick()
    -- close f2p nag screen
    if window_open("AlertWnd") then
        cmd("/notify AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto accept trades
    if window_open("tradewnd") and not has_cursor_item() then
        if has_target() and is_peer(mq.TLO.Target.Name()) then
            all_tellf("Accepting trade in 5s with %s", mq.TLO.Target.Name())
            delay(5000, function() return has_cursor_item() end)
            if not has_cursor_item() then
                cmd("/notify tradewnd TRDW_Trade_Button leftmouseup")
            end
        else
            all_tellf("\arWARN\ax Ignoring trade from non-peer %s", mq.TLO.Target.Name())
            cmd("/beep 1")
        end
    end

    if class_shortname() == "WIZ" and have_pet() then
        cmd("/pet get lost")
    end

    follow.Update()

end

return QoL