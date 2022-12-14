-- quality of life tweaks

local mq = require("mq")
local log = require("knightlinc/Write")

local assist  = require("e4_Assist")
local follow  = require("e4_Follow")
local commandQueue = require("e4_CommandQueue")
local botSettings = require("e4_BotSettings")
local pet     = require("e4_Pet")
local buffs   = require("e4_Buffs")

local QoL = {}

local maxFactionLoyalists = false

function QoL.Init()

    QoL.loadRequiredPlugins()

    if botSettings.settings.debug ~= nil and botSettings.settings.debug then
        log.loglevel = "debug"
    end

    cmdf("/setwintitle %s", mq.TLO.Me.Name())

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

    pet.ConfigureTaunt()

    local dead = function(text, killer)
        all_tellf("I died. Killed by %s", killer)
        mq.cmd("/beep") -- the beep of death
    end
    mq.event("died1", "You have been slain by #*#", dead)
    mq.event("died2", "You died.", dead)

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        if zone == "an area where levitation effects do not function" then
            return
        end
        commandQueue.Clear()
        commandQueue.Add("zoned")
    end)

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            all_tellf("Missing component %s", name)
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

    -- change spell set
    mq.bind("/spellset", function(name)
        if is_orchestrator() then
            cmdf("/dgzexecute /spellset %s", name)
        end
        log.Info("Changed spellset to %s", name)
        assist.spellSet = name
    end)

    -- tell peers to kill target until dead
    ---@param ... string|nil such as "/only|ROG"
    mq.bind("/assiston", function(...)
        local filter = trim(args_string(...))
        local spawn = mq.TLO.Target
        if spawn() == nil or spawn.Type() == "PC" then
            return
        end
        local exe = string.format("/dgzexecute /killit %d", spawn.ID())
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        log.Info("Calling assist on %s, type %s", spawn.DisplayName(), spawn.Type())
        mq.cmdf(exe)
        commandQueue.Add("killit", tostring(spawn.ID()), filter)
    end)

    -- auto assist on mob until dead
    ---@param mobID string
    ---@param ... string|nil
    mq.bind("/killit", function(mobID, ...)
        if is_gm() then
            return
        end
        local filter = trim(args_string(...))
        commandQueue.Add("killit", mobID, filter)
    end)

    mq.bind("/quickburns", function()
        if is_orchestrator() then
            cmd("/dgzexecute /quickburns")
        end
        commandQueue.Add("burns", "quickburns")
    end)
    mq.bind("/longburns", function()
        if is_orchestrator() then
            cmd("/dgzexecute /longburns")
        end
        commandQueue.Add("burns", "longburns")
    end)
    mq.bind("/fullburns", function()
        if is_orchestrator() then
            cmd("/dgzexecute /fullburns")
        end
        commandQueue.Add("burns", "fullburns")
    end)

    -- Use cure ward AA "Ward of Purity" (CLR)
    mq.bind("/cureward", function() commandQueue.Add("ward", "cure") end)

    -- Use heal ward AA (CLR/DRU/SHM)
    mq.bind("/healward", function() commandQueue.Add("ward", "heal") end)

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
        commandQueue.Add("dropbuff", filter)
    end)

    mq.bind("/dropinvis", function()
        if is_orchestrator() then
            cmd("/dgzexecute /dropinvis")
        end
        commandQueue.Add("dropinvis")
    end)

    mq.bind("/reportmana", function()
        if is_orchestrator() then
            cmd("/dgzexecute /reportmana")
        end
        if not mq.TLO.Me.Class.CanCast() then
            return
        end
        if mq.TLO.Me.PctMana() < 100 then
            all_tellf("%dm", mq.TLO.Me.PctMana())
        end
    end)

    -- make all clerics cast their curing group heal spell
    mq.bind("/groupheal", function()
        if is_orchestrator() then
            cmd("/dgzexecute /groupheal")
        end
        commandQueue.Add("groupheal")
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
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
        buffs.refreshBuffs = true
        if is_orchestrator() then
            cmd("/dgzexecute /buffon")
        end
    end)

    mq.bind("/buffoff", function()
        buffs.refreshBuffs = false
        if is_orchestrator() then
            cmd("/dgzexecute /buffoff")
        end
    end)

    -- Perform rez on target (CLR,DRU,SHM,PAL will auto use >= 90% rez spells) or delegate it to nearby cleric
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

            spawnID = tostring(spawn.ID())
            if spawn.Type() ~= "Corpse" then
                log.Error("/rezit: Target is not a corpse. Type %s",  spawn.Type())
                return
            end

            -- non-cleric orchestrator asks nearby CLR to rez spawnID
            if not me_priest() and not is_pal() then
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

        commandQueue.Add("rezit", spawnID)
    end)

    mq.bind("/mounton", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mounton")
        end
        commandQueue.Add("mount-on")
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
    mq.bind("/clickit", function(...)
        local filter = trim(args_string(...))

        if is_orchestrator() then
            mq.cmdf("/dgzexecute /clickit %s", filter)
        end
        commandQueue.Add("clickit", filter)
    end)

    mq.bind("/portto", function(name)
        name = name:lower()
        if is_orchestrator() then
            mq.cmdf("/dgzexecute /portto %s", name)
        end
        commandQueue.Add("portto", name)
    end)

    mq.bind("/followon", function()
        mq.cmdf("/dgzexecute /followid %d", mq.TLO.Me.ID())
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        follow.Stop()
    end)

    -- follows another peer in LoS
    ---@param spawnID string
    mq.bind("/followid", function(spawnID) follow.Start(toint(spawnID)) end)

    mq.bind("/evac", function(name)
        if is_orchestrator() then
            mq.cmd("/dgzexecute /evac")
        end
        -- clear queue so that evac happens next
        commandQueue.Clear()
        commandQueue.Add("evacuate")
    end)

    -- cast Radiant Cure
    mq.bind("/rc", function(name)
        if is_orchestrator() then
            mq.cmd("/dgzexecute /rc")
        end
        commandQueue.Add("radiantcure")
    end)

    -- tell peers in zone to use Throne of Heroes
    mq.bind("/throne", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /throne")
        end
        commandQueue.Add("use-veteran-aa", "Throne of Heroes")
    end)

    mq.bind("/movetome", function() mq.cmdf("/dgzexecute /movetoid %d", mq.TLO.Me.ID()) end)
    mq.bind("/mtm", function()  mq.cmd("/movetome") end)

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
    mq.bind("/factionsall", function() mq.cmd("/dgaexecute all /factions") end)

    -- clear all chat windows on current peer
    mq.bind("/clr", function() mq.cmd("/clear") end)

    -- clear all chat windows on all peers
    mq.bind("/cls", function() mq.cmd("/dgaexecute /clear") end)

    mq.bind("/self", function() mq.cmd("/target myself") end)

    -- hide existing corpses
    mq.bind("/hce", function() mq.cmd("/hidec all") end)

    -- hide looted corpses
    mq.bind("/hcl", function() mq.cmd("/hidec looted") end)

    -- hide no corpses
    mq.bind("/hcn", function() mq.cmd("/hidec none") end)

    -- report toons with few free buff slots
    mq.bind("/freebuffslots", function(name) mq.cmd("/noparse /dgaexecute all /if (${Me.FreeBuffSlots} <= 1) /dgtell all FREE BUFF SLOTS: ${Me.FreeBuffSlots}") end)
    mq.bind("/fbs", function(name) mq.cmd("/freebuffslots") end)

    -- /raidinvite shorthand
    mq.bind("/ri", function(name) mq.cmdf("/raidinvite %s", name) end)

    -- quickly exits all eqgame.exe instances using task manager
    mq.bind("/exitall", function()
        mq.cmd('/exec TASKKILL "/F /IM eqgame.exe" bg')
    end)

    -- quickly exits my eqgame.exe instance using task manager
    mq.bind("/exitme", function()
        all_tellf("Exiting")
        mq.cmd('/exec TASKKILL "/F /PID '..tostring(mq.TLO.EverQuest.PID())..'" bg')
    end)

    mq.bind("/exitnotinzone", function() mq.cmdf("/noparse /dgaexecute all /if (!${SpawnCount[pc =%s]}) /exitme", mq.TLO.Me.Name()) end)

    mq.bind("/exitnotingroup", function() mq.cmd("/noparse /dgaexecute all /if (!${Group.Members}) /exitme") end)

    mq.bind("/exitnotinraid", function() mq.cmd("/noparse /dgaexecute all /if (!${Raid.Members}) /exitme") end)

    -- report all peers who are not in current zone
    mq.bind("/notinzone", function() mq.cmdf("/noparse /dgaexecute all /if (!${SpawnCount[pc =%s]}) /dgtell all I'm in ${Zone.ShortName}", mq.TLO.Me.Name()) end)

    mq.bind("/notingroup", function() mq.cmd("/noparse /dgaexecute all /if (!${Me.Grouped}) /dgtell all NOT IN GROUP") end)

    mq.bind("/ingroup", function() mq.cmd("/noparse /dgaexecute all /if (${Me.Grouped}) /dgtell all IN GROUP") end)

    mq.bind("/notinraid", function() mq.cmd("/noparse /dgaexecute all /if (!${Raid.Members}) /dgtell all NOT IN RAID") end)

    mq.bind("/inraid", function() mq.cmd("/noparse /dgaexecute all /if (${Raid.Members}) /dgtell all IN RAID") end)

    -- report all peers who are not levitating
    mq.bind("/notlevi", function() mq.cmd("/noparse /dgaexecute all /if (!${Me.Levitating}) /dgtell all NOT LEVI") end)

    mq.bind("/notitu", function() mq.cmd("/noparse /dgaexecute all (!${Me.Buff[Sunskin].ID}) /dgtell all NOT ITU") end)

    -- report all peers who are not invisible
    mq.bind("/notinvis", function() mq.cmd("/noparse /dgaexecute all /if (!${Me.Invis}) /dgtell all NOT INVIS") end)

    mq.bind("/invis", function() mq.cmd("/noparse /dgaexecute all /if (${Me.Invis}) /dgtell all INVIS") end)

    -- make peers in zone face my target
    mq.bind("/facetarget", function() mq.cmdf("/dgaexecute %s /face fast id %d", dannet_zone_channel(), mq.TLO.Target.ID()) end)
    mq.bind("/facetgt", function() mq.cmd("/facetarget") end)

    -- make peers in zone face me
    mq.bind("/faceme", function() mq.cmdf("/dgzexecute /face fast id %d", mq.TLO.Me.ID()) end)

    -- useful when AE FD is cast (oow, wos Shadowhunter, Cleric 1.5 fight in lfay and so on)
    mq.bind("/standall", function()
        log.Info("Requested ALL peers to /stand")
        mq.cmd("/noparse /dgaexecute all /if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /stand")
    end)

    mq.bind("/sitall", function()
        log.Info("Requested ALL peers to /sit")
        mq.cmd("/noparse /dgaexecute all /if (${Me.Standing}) /sit")
    end)

    -- report all peers who are not standing
    mq.bind("/notstanding", function() mq.cmd("/noparse /dgaexecute all /if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /bc NOT STANDING") end)

    -- open loot window on closest corpse
    mq.bind("/lcorpse", function() commandQueue.Add("open-nearby-corpse") end)

    -- reports all toons that are not running e4
    mq.bind("/note4", function() mq.cmd("/dgaexecute /lua run note4") end)

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
    mq.bind("/wornaugs", function() commandQueue.Add("reportwornaugs") end)

    -- reports all owned clickies (worn, inventory, bank) worn auguments
    mq.bind("/clickies", function() commandQueue.Add("reportclickies") end)

    -- cast Summon Clockwork Banker veteran AA yourself, or the first available nearby peer
    mq.bind("/banker", function() commandQueue.Add("summonbanker") end)

    -- MAG: use Call of the Hero to summon the group to you
    mq.bind("/cohgroup", function() mq.cmd("/lua run cohgroup") end)

    -- Ask peer owners of nearby corpses to consent me
    mq.bind("/consentme", function() commandQueue.Add("consentme") end)

    -- summon nearby corpses into a pile
    mq.bind("/gathercorpses", function() commandQueue.Add("gathercorpses") end)

    -- loot all my nearby corpses
    mq.bind("/lootcorpses", function() commandQueue.Add("lootcorpse") end)

    -- tell peers to attempt to loot their corpses
    mq.bind("/lootallcorpses", function()
        if is_orchestrator() then
            cmd("/dgzexecute /lootcorpses")
        end
        commandQueue.Add("lootcorpse")
    end)

    -- make all peer quit expedition
    mq.bind("/quitexp", function()
        all_tellf("Instructing peers to leave expedition ...")
        cmd("/dgaexecute /dzquit")
    end)

    -- hide all dz windows
    mq.bind("/dzhide", function() mq.cmd("/noparse /dgaexecute /if (${Window[dynamiczonewnd]}) /windowstate dynamiczonewnd close") end)

    -- report peers with at least 10 unspent AA:s
    mq.bind("/unspentaa", function() mq.cmd("/noparse /dgaexecute /if (${Me.AAPoints} >= 10 && ${Me.AAPoints} < 100) /dgtell all UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with less than 10 unspent AA:s
    mq.bind("/lowunspentaa", function() mq.cmd("/noparse /dgaexecute /if (${Me.AAPoints} > 1 && ${Me.AAPoints} < 10) /dgtell all UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with any unspent AA:s
    mq.bind("/allunspentaa", function() mq.cmd("/noparse /dgaexecute /if (${Me.AAPoints} > 0) /dgtell all UNSPENT AA: ${Me.AAPoints}") end)

    -- report all peer total AA:s
    mq.bind("/totalaa", function() mq.cmd("/noparse /dgaexecute /dgtell all TOTAL AA: ${Me.AAPointsTotal}") end)

    -- finds item by name in inventory/bags. NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    mq.bind("/fdi", function(...)
        local name = trim(args_string(...))
        if name ~= "" then
            commandQueue.Add("finditem", name)
        end
    end)

    -- find missing item
    mq.bind("/fmi", function(...)
        local name = trim(args_string(...))
        if name ~= "" then
            commandQueue.Add("findmissingitem", name)
        end
    end)

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber) commandQueue.Add("recallgroup", name, groupNumber) end)

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

    -- Rezzes nearby player corpses
    mq.bind("/aerez", function() commandQueue.Add("aerez") end)

    -- MGB CLR Celestial Regeneration
    mq.bind("/aecr", function() commandQueue.Add("mgb", "Celestial Regeneration") end)

    -- MGB DRU Spirit of the Wood
    mq.bind("/aesow",  function() commandQueue.Add("mgb", "Spirit of the Wood") end)
    mq.bind("/aesotw", function() commandQueue.Add("mgb", "Spirit of the Wood") end)

    -- MGB SHM Ancestral Aid
    mq.bind("/aeaa", function() commandQueue.Add("mgb", "Ancestral Aid") end)

    -- MGB DRU Flight of Eagles
    mq.bind("/aefoe", function() commandQueue.Add("mgb", "Flight of Eagles") end)

    -- MGB NEC Dead Men Floating
    mq.bind("/aedmf", function() commandQueue.Add("mgb", "Dead Men Floating") end)

    -- MGB ENC Rune of Rikkukin
    mq.bind("/aerr", function() commandQueue.Add("mgb", "Rune of Rikkukin") end)

    -- MGB BST Paragon of Spirit
    mq.bind("/aepos", function() commandQueue.Add("mgb", "Paragon of Spirit") end)

    -- MGB RNG Auspice of the Hunter
    mq.bind("/aeaoh",  function() commandQueue.Add("mgb", "Auspice of the Hunter") end)
    mq.bind("/aeaoth", function() commandQueue.Add("mgb", "Auspice of the Hunter") end)

    -- MGB BER war cry
    mq.bind("/aecry", function() commandQueue.Add("aecry") end)

    -- MGB BER Bloodthirst
    mq.bind("/aebloodthirst", function() commandQueue.Add("aebloodthirst") end)

    clear_cursor()

    QoL.verifySpellLines()
end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2DanNet",
        "MQ2Debuffs", -- XXX not used yet. to be used for auto-cure feature
        "MQ2AdvPath", -- XXX /afollow or /stick ?
        "MQ2MoveUtils",
        --"MQ2Nav",
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
            --"MQMountClassicModels", -- TODO make use of
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

    verifySpellLines("self_buffs", botSettings.settings.self_buffs)

    if botSettings.settings.assist ~= nil then
        verifySpellLines("taunts", botSettings.settings.assist.taunts)
        verifySpellLines("debuffs", botSettings.settings.assist.debuffs)
        verifySpellLines("dots", botSettings.settings.assist.dots)
        verifySpellLines("debuffs_on_command", botSettings.settings.assist.debuffs_on_command)
        verifySpellLines("dots_on_command", botSettings.settings.assist.dots_on_command)
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
            all_tellf("Missing %s: %s (row = %s)", label, spellConfig.Name, row)
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
end

return QoL
