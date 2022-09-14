-- quality of life tweaks

local mq = require("mq")

local QoL = {}

local maxFactionLoyalists = false

function QoL.Init()

    QoL.loadRequiredPlugins()

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

    clear_cursor()

    QoL.verifySpellLines()

    local dead = function(text, killer)
        cmd("/dgtell all I died. Killed by "..killer)
        cmd("/beep") -- the beep of death
    end

    mq.event("died", "You have been slain by #*#", dead)
    mq.event("died", "You died.", dead)

    mq.event("zoning", "LOADING, PLEASE WAIT...", function(text)
        --print("zoning. waiting")
        --delay(15000) -- 15s
    end)

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        if zone == "an area where levitation effects do not function" then
            return
        end

        print("I zoned into ", zone)
        delay(3000) -- 3s
        pet.ConfigureTaunt()

        joinCurrentHealChannel()
        memorizeListedSpells()
    end)

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            cmd("/dgtell all Missing component "..name)
            cmd("/beep 1")
        end
    end)

    mq.event("tell", "#1# tells you, #2#", function(text, name, msg)
        local s = msg:lower()
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background? we enqueue it to a zone channel !!!
            cmd("/dgtell all XXX FIXME handle 'buffme' tell from "..name)
            cmd("/beep 1")
        else
            -- excludes tells from "Player`s pet" (Permutation Peddler, NPC), "Player`s familiar" (Summoned Banker, Pet)
            local spawn = spawn_from_query('="'..name..'"')
            if spawn ~= nil and (spawn.Type() == "NPC" or spawn.Type() == "Pet") then
                --print("IGNORING TELL FROM "..spawn.Type().." '".. name.. "': ", msg)
                return
            end
            if spawn ~= nil then
                cmd("/dgtell all GOT A IN-ZONE TELL FROM "..name..": "..msg.." type "..spawn.Type())
            else
                cmd("/dgtell all GOT A TELL FROM "..name..": "..msg)
            end

            cmd("/beep 1")
        end
    end)

    mq.event("skillup", "You have become better at #1#! (#2#)", function(text, name, num)
        cmd("/dgtell skillup "..name.." ("..num.."/"..skill_cap(name)..")")
    end)

    mq.event("xp", "You gain experience!", function()
        cmd("/dgtell xp Gained xp")
    end)

    mq.event("faction_oow_loyalists", "Your faction standing with Dranik Loyalists could not possibly get any better.", function()
        if not maxFactionLoyalists then
            cmd("/dgtell xp Maxed loyalist faction")
            maxFactionLoyalists = true
        end
    end)

    -- reports faction status
    mq.bind("/faction", function()
        if maxFactionLoyalists then
            print("Dranik Loyalists: max ally")
        else
            cmd("/dgtell all WARN: not max ally with Dranik Loyalists")
        end
    end)

    -- tell all peers to report faction status
    mq.bind("/factionall", function()
        cmd("/dgaexecute all /faction")
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
        cmd("/dgtell all Exiting")
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
        print("FIXME impl /running: report all running scripts on all toons")
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

    -- reports all currently worn auguments
    mq.bind("/wornaugs", function()
        print("Currently worn auguments:")
        local hp = 0
        local mana = 0
        local endurance = 0
        local ac = 0
        for i=0,22 do
            if mq.TLO.Me.Inventory(i).ID() then
                for a=0,mq.TLO.Me.Inventory(i).Augs() do
                    if mq.TLO.Me.Inventory(i).AugSlot(a)() ~= nil then
                        local item = mq.TLO.Me.Inventory(i).AugSlot(a).Item
                        hp = hp + item.HP()
                        mana = mana + item.Mana()
                        endurance = endurance + item.Endurance()
                        ac = ac + item.AC()
                        print(inventory_slot_name(i), " #", a, ": ", item.ItemLink("CLICKABLE")(), " ", item.HP(), " HP")
                    end
                end
            end
        end
        print("Augument total: ", hp, " HP, ", mana, " mana, ", endurance, " endurance, ", ac, " AC")
    end)

    -- reports all owned clickies (worn, inventory, bank) worn auguments
    mq.bind("/clickies", function()
        print("My clickies:")

        for i=0,32 do -- equipment: 0-22 is worn gear, 23-32 is inventory top level
            if mq.TLO.Me.Inventory(i).ID() then
                local inv = mq.TLO.Me.Inventory(i)
                if inv.Container() > 0 then
                    for c = 1, inv.Container() do
                        local item = inv.Item(c)
                        if item.Clicky() ~= nil then
                            print(inventory_slot_name(i), " # "..c.." ", item.ItemLink("CLICKABLE")(), " effect: ", item.Clicky.Spell.Name())
                        end
                    end
                else
                    if inv.Clicky() ~= nil then
                        print(inventory_slot_name(i), " ", inv.ItemLink("CLICKABLE")(), " effect: ", inv.Clicky.Spell.Name())
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
                        if item.Clicky() ~= nil then
                            print(key, " # "..c.." ", item.ItemLink("CLICKABLE")(), " effect: ", item.Clicky.Spell.Name())
                        end
                    end
                else
                    if inv.Clicky() ~= nil then
                        print(key, " ", inv.ItemLink("CLICKABLE")(), " effect: ", inv.Clicky.Spell.Name())
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

        print(aaName.." is not ready. Ready in "..mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())

        if not is_orchestrator() then
            return
        end

        -- if my banker is not ready, check all nearby peers if one is ready and use it.
        local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. " radius 50"

        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            local peer = spawn.Name()
            if is_peer(peer) then
                local value = query_peer(peer, 'Me.AltAbilityReady['..aaName..']', 0)
                if value == "TRUE" then
                    print("Asking ", peer, " to activate banker ...")
                    cmd("/dexecute "..peer.." /banker")
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
            print("Asking "..spawn.DisplayName().." for consent ...")
            cmd("/dexecute "..spawn.DisplayName().." /consent "..mq.TLO.Me.Name())
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
        cmd("/dgtell all Instructing peers to leave expedition ...")
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

end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2DanNet",
        "MQ2Debuffs", -- XXX not used yet. to be used for auto-cure feature
        "MQ2AdvPath", -- XXX /afollow or /stick ?
        --"MQ2ConstantAffinity", -- XXX
        "MQ2MoveUtils",
        "MQ2Cast",
    }
    for k, v in pairs(requiredPlugins) do
        if not is_plugin_loaded(v) then
            load_plugin(v)
            print("WARNING: "..v.." was not loaded")
        end
    end

    if is_rof2() then
        local requiredEmuPlugins = {
            "MQMountClassicModels", -- XXX make use of
        }
        for k, v in pairs(requiredEmuPlugins) do
            if not is_plugin_loaded(v) then
                load_plugin(v)
                print("WARNING: "..v.." was not loaded")
            end
        end
    end
end

function QoL.verifySpellLines()
    -- make sure I know all listed abilities

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

    if botSettings.settings.group_buffs ~= nil then
        for k, v in pairs(botSettings.settings.group_buffs) do
            verifySpellLines(k, v)
        end
    end

    if botSettings.settings.pet ~= nil then
        verifySpellLines("pet_heals", botSettings.settings.pet.heals)
        verifySpellLines("pet_buffs", botSettings.settings.pet.buffs)
    end

    -- XXX TODO validate more fields
end

-- warns if you lack any item etc listed in `lines`.
function verifySpellLines(label, lines)
    if lines == nil then
        return
    end
    for k, row in pairs(lines) do
        local spellConfig = parseSpellLine(row)
        if not known_spell_ability(spellConfig.Name) then
            cmd("/dgtell all Missing "..label..": "..spellConfig.Name)
            cmd("/beep 1")
        end
    end
end

-- runs every second
function QoL.Tick()
    -- close f2p nag screen
    if window_open("AlertWnd") then
        cmd("/notify AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto accept trades
    if window_open("tradewnd") and not has_cursor_item() then
        if has_target() and is_peer(mq.TLO.Target.Name()) then
            cmd("/dgtell all Accepting trade in 5s with "..mq.TLO.Target.Name())
            delay(5000, function() return has_cursor_item() end)
            if not has_cursor_item() then
                cmd("/notify tradewnd TRDW_Trade_Button leftmouseup")
            end
        else
            cmd("/dgtell all \arWARN\ax Ignoring trade from non-peer "..mq.TLO.Target.Name())
            cmd("/beep 1")
        end
    end

    if class_shortname() == "WIZ" and have_pet() then
        cmd("/pet get lost")
    end

end

return QoL