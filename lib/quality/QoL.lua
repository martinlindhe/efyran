-- quality of life tweaks

local mq = require("mq")
local log = require("knightlinc/Write")
local timer = require("lib/Timer")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'

local assist  = require("lib/assisting/Assist")
local follow  = require("lib/following/Follow")
local botSettings = require("lib/settings/BotSettings")
local buffs   = require("lib/spells/Buffs")
local serverSettings = require("lib/settings/default/ServerSettings")
local zonedCommand = require("commands/zonedCommand")

local bci = broadCastInterfaceFactory()

local QoL = {
    currentExp = 0.,
    currentAAXP = 0.,
    currentGroupLeaderXP =  0.,
    currentRaidLeaderXP = 0.,

    autoXP = {
        enabled = true, -- switch to 100% AA when max level, and back to 100% normal XP if needed
        maxLevel = 70, -- max level to reach before getting AA:s
        minTreshold = 50, -- if normal XP is below this %, we disable AA XP
        maxTreshold = 99, -- if normal XP is above or equal to this %, we enable 100% AA XP
    }
}

local maxFactionLoyalists = false


function QoL.Init()
    QoL.currentExp = mq.TLO.Me.PctExp()
    QoL.currentAAXP = mq.TLO.Me.PctAAExp()
    QoL.currentGroupLeaderXP =  mq.TLO.Me.PctGroupLeaderExp()
    QoL.currentRaidLeaderXP = mq.TLO.Me.PctRaidLeaderExp()

    if is_hovering() then
        all_tellf("ERROR: cannot start e4 successfully while in HOVERING mode")
        cmd("/beep 1")
        return
    end

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

    local dead = function(text, killer)
        all_tellf("\arI AM DEAD\ax")
        mq.cmd("/beep") -- the beep of death
        if in_raid() and not is_raid_leader() then
            mq.cmdf("/consent %s", mq.TLO.Raid.Leader())
        elseif in_group() and not is_group_leader() then
            mq.cmdf("/consent %s", mq.TLO.Group.Leader())
        end
        assist.EndFight()
    end
    mq.event("died1", "You have been slain by #*#", dead)
    mq.event("died2", "You died.", dead)

    local mobMezzed = function(text, name)
        log.Info("MEZZED > \ay%s\ax <", name)
        mq.cmdf("/popup MEZZED %s", name)
    end
    mq.event("mob-mezzed1", "#1# has been mesmerized.", mobMezzed) -- ENC Mesmerize
    mq.event("mob-mezzed2", "#1# has been enthralled.", mobMezzed) -- ENC Enthrall

    mq.event("mob-resisted", "Your target resisted the #1# spell.", function(text, name)
        log.Error("RESISTED > \ay%s\ax <", name)
        mq.cmdf("/popup RESISTED %s", name)
    end)

    mq.event("spell-interrrupted", "Your spell is interrupted.", function(text)
        log.Info("Spell interrupted ...")
        mq.cmd("/popup SPELL INTERRUPTED")
    end)

    -- for DoN solo tasks
    mq.event("replay-timer", "You have received a replay timer for '#1#': #2 remaining.", function(text, task, time)
        all_tellf("Got replay timer for \ag%s\ax: %s", task, time)
    end)

    mq.event("camping", "It will take you about 30 seconds to prepare your camp.", function(text, name)
        -- "It will take about 25 more seconds to prepare your camp."
        all_tellf("I am camping. Ending all macros.")
        cmd("/lua stop")
        mq.exit()
    end)

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            all_tellf("Missing component [+r+]%s[+x+].", name)
        end
    end)

    mq.event("tell", "#1# tells you, '#2#'", function(text, name, msg)
        local s = msg:lower()
        if s == "i'm busy right now." or s == "incoming pet weapons, hold still!" or s == "wait4rez" then
            return
        end
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background? we enqueue it to a zone channel !!!
            local spawn = spawn_from_query("PC "..name)
            if spawn == nil then
                all_tellf("BUFFIT FAIL, cannot find spawn %s in %s", name, zone_shortname())
                return
            end

            all_tellf("Delegating buff request from \ag%s\ax ...", name)
            cmd("/beep 1")
            buffs.BuffIt(spawn.ID())
        else
            -- excludes tells from "Player`s pet" (Permutation Peddler, NPC), "Player`s familiar" (Summoned Banker, Pet)
            local spawn = spawn_from_query('="'..name..'"')
            if spawn ~= nil and (spawn.Type() == "NPC" or spawn.Type() == "Pet") then
                --log.Debug("Ignoring tell from "..spawn.Type().." '".. name.. "': "..msg)
                return
            end
            if spawn ~= nil then
                all_tellf("GOT A IN-ZONE TELL FROM %s: %s, spawn type %s", name, msg, spawn.Type())
            else
                all_tellf("GOT A TELL FROM \ay%s\ax: \ap%s\ax", name, msg)
            end

            cmd("/beep 1")
        end
    end)

    mq.event("skillup", "You have become better at #1#! (#2#)", function(text, name, num)
        --log.Info("skill name %s, num %d", name, num)
        all_tellf("Skillup %s (%d/%d)", name, num, skill_cap(name))
    end)

    mq.event("faction_maxed", "Your faction standing with #1# could not possibly get any better.", function(text, faction)
        if faction == "Dranik Loyalists" then -- OOW armor faction
            if not maxFactionLoyalists then
                log.Info("Maxed loyalist faction")
                maxFactionLoyalists = true
            end
        end
    end)

    mq.event("faction_adjusted", "Your faction standing with #1# has been adjusted by #2#.", function(text, faction, value)
        if faction == "Norrath's Keepers" then -- DoN good side
            all_tellf("Faction: \ay%s\ax adjusted %s", faction, value)
        end
    end)

    local gotFlag = false
    local charFlag = function(text)
        all_tellf("I received char flag!")
        gotFlag = true
    end
    mq.event("char_flag-pop", "You receive a character flag#*#", charFlag) -- PoP / GoD
    mq.event("char_flag-ldon", "You have completed a step toward becoming a great adventurer. Well done!", charFlag) -- LDoN
    mq.event("char_flag-don", "You have received a character flag!", charFlag) -- DoN

    -- report who got the flag
    bind("/gotflag", function()
        if is_orchestrator() then
            bci.ExecuteAllCommand("/gotflag")
        end
        if gotFlag then
            all_tellf("\agGOT FLAG\ax")
        end
    end)

    -- report who did not get a flag
    bind("/noflag", function()
        if is_orchestrator() then
            bci.ExecuteAllCommand("/noflag")
        end
        if not gotFlag then
            all_tellf("\arNO FLAG\ax")
        end
    end)

    -- change spell set
    bind("/spellset", function(name)
        if is_orchestrator() then
            local cmd = string.format("/spellset %s", name)
            bci.ExecuteZoneCommand(cmd)
        end
        log.Info("Changed spellset to %s", name)
        assist.spellSet = name
    end)


    -- mana check
    bind("/mana", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/mana")
        end
        if not mq.TLO.Me.Class.CanCast() then
            return
        end
        if mq.TLO.Me.PctMana() < 50 then -- red
            all_tellf("MANA [+r+]%d %%", mq.TLO.Me.PctMana())
        elseif mq.TLO.Me.PctMana() < 75 then -- yellow
            all_tellf("MANA [+y+]%d %%", mq.TLO.Me.PctMana())
        else -- green
            all_tellf("MANA [+g+]%d %%", mq.TLO.Me.PctMana())
        end
    end)

    -- weight check
    bind("/weight", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/weight")
        end
        if mq.TLO.Me.CurrentWeight() > mq.TLO.Me.STR() then -- red
            all_tellf("WEIGHT [+r+]%d/%d", mq.TLO.Me.CurrentWeight(), mq.TLO.Me.STR())
        elseif mq.TLO.Me.CurrentWeight() + 20 > mq.TLO.Me.STR() then -- yellow
            all_tellf("WEIGHT [+y+]%d/%d", mq.TLO.Me.CurrentWeight(), mq.TLO.Me.STR())
        else -- green
            all_tellf("WEIGHT [+g+]%d/%d", mq.TLO.Me.CurrentWeight(), mq.TLO.Me.STR())
        end
    end)

    bind("/buffon", function()
        buffs.refreshBuffs = true
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/buffon")
        end
    end)

    bind("/buffoff", function()
        buffs.refreshBuffs = false
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/buffoff")
        end
    end)

    local followOn = function(...)
        local exe = string.format("/followplayer %s", mq.TLO.Me.Name())
        local filter = args_string(...)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end

        bci.ExecuteZoneCommand(exe)
    end

    ---@param ... string|nil filter, such as "/only|ROG"
    bind("/followon", followOn)
    bind("/followme", followOn) -- alias for e3 compatibility

    bind("/followoff", function(s)
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/followoff")
        end
        follow.Stop()
    end)

    -- follows another peer
    ---@param spawnName string
    ---@param ... string|nil filter, such as "/only|ROG"
    bind("/followplayer", function(spawnName, ...)
        local filter = args_string(...)
        if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
            log.Info("followid: Not matching filter \ay%s\ax", filter)
            return
        end
        follow.Start(spawnName, false)
    end)

    -- reports all peers with debuffs
    bind("/counters", function()
        bci.ExecuteZoneCommand("/if (${NetBots[${Me.Name}].Counters}) /bc DEBUFFED: ${NetBots[${Me.Name}].Counters} counters in ${NetBots[${Me.Name}].Detrimentals} debuffs: ${NetBots[${Me.Name}].Detrimental}")
    end)

    -- report naked toons
    bind("/naked", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/naked")
        end
        if is_naked() then
            all_tellf("IM NAKED IN \ay%s\ax", zone_shortname())
        end
    end)

    -- pick up ground spawn
    bind("/pickup", function()
        mq.cmd("/itemtarget")
        mq.cmd("/click left item")
    end)

    bind("/bark", function(...)
        local arg = args_string(...)
        local spawnID = mq.TLO.Target.ID()
        if spawnID == nil then
            log.Error("No target to bark at!")
            return
        end
        if is_orchestrator() then
            local cmd = string.format("/barkit %d %s", spawnID, arg)
            bci.ExecuteZoneCommand(cmd)
        end
        cmdf("/barkit %d %s", spawnID, arg)
    end)

    bind("/barkit", function(spawnID, ...)
        local arg = args_string(...)

        local id = toint(spawnID)
        target_id(id)
        unflood_delay()
        cmdf("/say %s", arg)
    end)

    -- reports faction status
    bind("/factions", function()
        if maxFactionLoyalists then
            log.Debug("Dranik Loyalists: max ally")
        else
            all_tellf("FACTION: Not max ally with Dranik Loyalists")
        end
    end)

    -- tell all peers to report faction status
    bind("/factionsall", function() bci.ExecuteZoneCommand("/factions") end)

    -- clear all chat windows on current peer
    bind("/clr", function() mq.cmd("/clear") end)

    -- clear all chat windows on all peers
    bind("/cls", function() bci.ExecuteAllWithSelfCommand("/clear") end)

    bind("/separator", function() mq.cmd("/bc ... <- [+r+]${Time.Time24}[+x+] -> ...") end)

    bind("/self", function() mq.cmd("/target myself") end)

    -- hide existing corpses
    bind("/hce", function() mq.cmd("/hidec all") end)

    -- hide looted corpses
    bind("/hcl", function() mq.cmd("/hidec looted") end)

    -- hide no corpses
    bind("/hcn", function() mq.cmd("/hidec none") end)

    -- report toons with few free buff slots
    bind("/freebuffslots", function() bci.ExecuteAllWithSelfCommand("/if (${Me.FreeBuffSlots} <= 1) /bc FREE BUFF SLOTS: ${Me.FreeBuffSlots}") end)
    bind("/fbs", function() mq.cmd("/freebuffslots") end)

    -- /raidinvite shorthand
    bind("/ri", function(name) mq.cmdf("/raidinvite %s", name) end)

    -- quickly exits all eqgame.exe instances using task manager
    bind("/exitall", function()
        mq.cmd('/squelch /exec TASKKILL "/F /IM eqgame.exe" bg')
    end)

    -- quickly exits my eqgame.exe instance using task manager
    bind("/exitme", function()
        all_tellf("Exiting")
        mq.cmd('/squelch /exec TASKKILL "/F /PID '..tostring(mq.TLO.EverQuest.PID())..'" bg')
    end)

    bind("/exitnotinzone", function() bci.ExecuteAllCommand(string.format("/if (!${SpawnCount[pc =%s]}) /exitme", mq.TLO.Me.Name())) end)

    bind("/exitnotingroup", function() bci.ExecuteAllWithSelfCommand("/if (!${Group.Members}) /exitme") end)

    bind("/exitnotinraid", function(force)
        if not in_raid() and force ~= "force" then
            all_tellf("ERROR: not exiting since you are not raided! Force with /exitnotinraid force")
            cmd("/beep")
            return
        end
        bci.ExecuteAllWithSelfCommand("/if (!${Raid.Members}) /exitme")
    end)

    -- report all peers who are not in current zone
    bind("/notinzone", function() bci.ExecuteAllWithSelfCommand(string.format("/if (!${SpawnCount[pc =%s]}) /bc I'm in \ar${Zone.ShortName}\ax", mq.TLO.Me.Name())) end)

    bind("/notingroup", function() bci.ExecuteAllWithSelfCommand("/if (!${Me.Grouped}) /bc NOT IN GROUP") end)

    bind("/ingroup", function() bci.ExecuteAllWithSelfCommand("/if (${Me.Grouped}) /bc IN GROUP") end)

    bind("/notinraid", function() bci.ExecuteAllWithSelfCommand("/if (!${Raid.Members}) /bc NOT IN RAID") end)

    bind("/inraid", function() bci.ExecuteAllWithSelfCommand("/if (${Raid.Members}) /bc IN RAID") end)

    -- report all peers who are not levitating
    bind("/notlevi", function() bci.ExecuteAllWithSelfCommand("/if (!${Me.Levitating}) /bc NOT LEVI") end)

    bind("/notitu", function() bci.ExecuteAllWithSelfCommand("/if (!${Me.Buff[Sunskin].ID}) /bc NOT ITU") end)

    -- report all peers who are not invisible
    bind("/notinvis", function() bci.ExecuteAllWithSelfCommand("/if (!${Me.Invis}) /bc NOT INVIS") end)


    -- report special stats
    bind("/combateffects", function() bci.ExecuteAllWithSelfCommand("/if (${Select[${Me.Class.ShortName},ROG,BER,MNK]}) /bc COMBAT EFFECT ${Me.CombatEffectsBonus}") end)

    bind("/accuracy", function() bci.ExecuteAllWithSelfCommand("/if (${Select[${Me.Class.ShortName},WAR,PAL,RNG,SHD,MNK,BRD,ROG,BST,BER]}) /bc ACCURACY ${Me.AccuracyBonus}/150") end)
    bind("/strikethru", function() bci.ExecuteAllWithSelfCommand("/if (${Select[${Me.Class.ShortName},RNG,MNK,BRD,ROG,BST,BER]}) /bc STRIKE THRU ${Me.StrikeThroughBonus}/35") end)
    bind("/shielding", function() bci.ExecuteAllWithSelfCommand("/bc SHIELDING ${Me.ShieldingBonus}") end)

    bind("/dotshield", function() bci.ExecuteAllWithSelfCommand("/bc DoT SHIELD ${Me.DoTShieldBonus}") end)
    bind("/spellshield", function() bci.ExecuteAllWithSelfCommand("/bc SPELL SHIELD ${Me.SpellShieldBonus}") end)
    bind("/avoidance", function() bci.ExecuteAllWithSelfCommand("/bc AVOIDANCE ${Me.AvoidanceBonus}/100") end)
    bind("/stunresist", function() bci.ExecuteAllWithSelfCommand("/bc STUN RESIST ${Me.StunResistBonus}") end)

    -- "free inventory slots": only lists melees as looter classes for minimal disruption
    bind("/fis", function()
        bci.ExecuteAllWithSelfCommand("/if (${Select[${Me.Class.ShortName},MNK,ROG,BER,RNG]} && ${Me.FreeInventory} > 20) /bc FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- "free inventory slots all"
    bind("/fisa", function()
        bci.ExecuteAllWithSelfCommand("/if (${Me.FreeInventory} > 20) /bc FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- report all with few free inventory slots
    bind("/fewinventoryslots", function()
        bci.ExecuteAllWithSelfCommand("/if (${Me.FreeInventory} <= 20) /bc FULL INVENTORY, ${Me.FreeInventory} FREE SLOTS")
    end)

    -- make peers in zone face my target
    bind("/facetarget", function() bci.ExecuteZoneCommand("/face fast id "..mq.TLO.Target.ID()) end)
    bind("/facetgt", function() mq.cmd("/facetarget") end)

    -- make peers in zone face me
    bind("/faceme", function() bci.ExecuteZoneCommand("/face fast id "..mq.TLO.Me.ID()) end)

    -- useful when AE FD is cast (oow, wos Shadowhunter, Cleric 1.5 fight in lfay and so on)
    bind("/standall", function() bci.ExecuteAllWithSelfCommand("/if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /stand") end)

    bind("/sitall", function() bci.ExecuteAllWithSelfCommand("/if (${Me.Standing}) /sit on") end)

    -- report all peers who are not standing
    bind("/notstanding", function() bci.ExecuteAllWithSelfCommand("/if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /bc NOT STANDING") end)

    -- reports all toons that are not running e4
    bind("/note4", function() bci.ExecuteAllWithSelfCommand("/lua run efyran/note4") end)

    bind("/running", function()
        -- XXX reports all running scripts on all toons
        log.Error("FIXME impl /running: report all running scripts on all toons")
    end)

    local mmrl = function()
        bci.ExecuteCommand(string.format("/makeraidleader %s", mq.TLO.Me.Name()), {mq.TLO.Raid.Leader()})
    end
    bind("/makemeraidleader", mmrl)
    bind("/mmrl", mmrl)

    -- report if tribute is too low (under 140k)
    bind("/lowtribute", function()
        bci.ExecuteAllWithSelfCommand("/if (${Me.CurrentFavor} < 140000) /bc LOW TRIBUTE ${Me.CurrentFavor}")
    end)

    -- report if tribute is active
    -- TODO add filter for /tributeactive /only|tanks
    bind("/tributeactive", function()
        bci.ExecuteAllWithSelfCommand("/if (${Me.TributeActive}) /bc TRIBUTE ACTIVE, COST ${Me.ActiveFavorCost}, STORED ${Me.CurrentFavor}")
    end)

    -- Ask peer owners of nearby corpses to consent me
    bind("/consentme", function() consent_me() end)

    -- turn auto loot on
    bind("/looton", function()
        all_tellf("Auto-loot ENABLED")
        botSettings.settings.autoloot = true
    end)

    -- turn auto loot off
    bind("/lootoff", function()
        all_tellf("Auto-loot DISABLED")
        botSettings.settings.autoloot = false
    end)

    -- make all peer quit expedition
    bind("/quitexp", function()
        all_tellf("Instructing peers to leave expedition / shared task ...")
        bci.ExecuteAllWithSelfCommand("/dzquit")   -- Expedition (PoP, LDoN, GoD, OOW)
        bci.ExecuteAllWithSelfCommand("/taskquit") -- Shared task (DoN)
    end)

    -- hide all dz windows
    bind("/dzhide", function() bci.ExecuteAllWithSelfCommand("/if (${Window[dynamiczonewnd]}) /windowstate dynamiczonewnd close") end)

    -- report peers with at least 5 unspent AA:s
    bind("/unspentaa", function() bci.ExecuteAllWithSelfCommand("/if (${Me.AAPoints} >= 5 && ${Me.AAPoints} < 50) /bc UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with less than 10 unspent AA:s
    bind("/lowunspentaa", function() bci.ExecuteAllWithSelfCommand("/if (${Me.AAPoints} >= 1 && ${Me.AAPoints} < 50) /bc UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with any unspent AA:s
    bind("/allunspentaa", function() bci.ExecuteAllWithSelfCommand("/if (${Me.AAPoints} >= 1) /bc UNSPENT AA: ${Me.AAPoints} (SPENT ${Me.AAPointsSpent})") end)

    -- report all peer total AA:s
    bind("/totalaa", function() bci.ExecuteAllWithSelfCommand("/bc ${Me.AAPointsTotal} TOTAL (${Me.AAPoints} unspent, ${Me.AAPointsSpent} spent)") end)

    -- track xp, auto adjust level / AA xp and auto loot
    local xpGain = function(text)

        if botSettings.settings.autoloot then
            mq.cmd("/doloot")
        end

        buffs.resumeTimer:restart()

        local xpDiff = mq.TLO.Me.PctExp() - QoL.currentExp
        if xpDiff < 0 then
            -- we dinged level
            xpDiff = 100 + mq.TLO.Me.PctExp() - QoL.currentExp -- XXX
        end

        local aaDiff = mq.TLO.Me.PctAAExp() - QoL.currentAAXP
        if aaDiff < 0 then
            -- we dinged AA
            aaDiff = 100 + mq.TLO.Me.PctAAExp() - QoL.currentAAXP
        end

        if aaDiff > 0. then
            log.Info("Gained AAXP %.2f %%", aaDiff)
        else
            log.Info("Gained XP %.2f %%", xpDiff)
        end

        QoL.currentExp = mq.TLO.Me.PctExp()
        QoL.currentAAXP = mq.TLO.Me.PctAAExp()

        local msg = ""

        if not in_raid() then
            if aaDiff > 0. then
                msg = string.format("(%.1f %% AA)", aaDiff)
            else
                msg = string.format("(%.1f %% XP)", xpDiff)
            end
            if not in_group() then
                msg = "[+g+]Solo XP[+x+] " .. msg
            elseif is_group_leader() then
                msg = "[+g+]Group XP[+x+] " .. msg
            else
                msg = ""
            end
        end

        -- leader xp
        if in_group() then
            local groupXpDiff = mq.TLO.Me.PctGroupLeaderExp() - QoL.currentGroupLeaderXP
            if groupXpDiff < 0 then
                -- we dinged AA
                groupXpDiff = 100 + mq.TLO.Me.PctGroupLeaderExp() - QoL.currentGroupLeaderXP
            end
            if groupXpDiff > 0 then
                msg = msg .. string.format(", group leader XP (%.1f %%)", groupXpDiff)
            end
        end
        QoL.currentGroupLeaderXP = mq.TLO.Me.PctGroupLeaderExp()

        if msg ~= "" and not in_raid() then
            all_tell(msg)
        end

        -- auto adjust XP / AA ratio
        if QoL.autoXP.enabled then
            local aaPct = toint(mq.TLO.Window("AAWindow").Child("AAW_PercentCount").Text.Left(-1)())
            if (mq.TLO.Me.Level() < QoL.autoXP.maxLevel or mq.TLO.Me.PctExp() <= QoL.autoXP.minTreshold) and aaPct > 0 then
                cmd("/squelch /alternateadv on 0")
                all_tellf("\ayAuto setting AA Exp to 0%%, at %d%% of Level %d", mq.TLO.Me.PctExp(), mq.TLO.Me.Level())
            elseif mq.TLO.Me.Level() == QoL.autoXP.maxLevel and mq.TLO.Me.PctExp() >= QoL.autoXP.maxTreshold and aaPct < 100 then
                cmd("/squelch /alternateadv on 100")
                all_tellf("\ayAuto setting AA Exp to 100%%, at %d%% of Level %d", mq.TLO.Me.PctExp(), mq.TLO.Me.Level())
            end
        end
    end

    mq.event("xp-solo", "You gain experience!!", xpGain)
    mq.event('xp-group', 'You gain party experience!!', xpGain)
    mq.event("xp-raid", "You gained raid experience!", xpGain)

    mq.event("raid_leader_xp", "You gain raid leadership experience!", function(text)
        local aaDiff = mq.TLO.Me.PctRaidLeaderExp() - QoL.currentRaidLeaderXP
        if aaDiff < 0 then
            -- we dinged AA
            aaDiff = 100 + mq.TLO.Me.PctRaidLeaderExp() - QoL.currentRaidLeaderXP
        end

        QoL.currentRaidLeaderXP = mq.TLO.Me.PctRaidLeaderExp()

        if aaDiff > 0 then
            log.Info("\agGained Raid leader XP (%.2f %%)", aaDiff)
        end
    end)

    mq.event("ding-level", "You have gained a level! Welcome to level #1#!", function(text, level)
        all_tellf("[+g+]Ding L%d", level)
    end)

    mq.event("ding-aa", "You have gained an ability point#*#", function(text)
        if mq.TLO.Me.AAPoints() <= 1 or mq.TLO.Me.AAPoints() >= 50 then
            return
        end
        all_tellf("\agDing AA - %d unspent", mq.TLO.Me.AAPoints())
    end)

    mq.event('summoned', '#*#You have been summoned#*#', function(text, sender)
        if follow.IsFollowing() then
            follow.Stop()
            log.Info("I was summoned to %d, %d, stopping auto follow", mq.TLO.Me.Y(), mq.TLO.Me.X())
        else
            log.Info("You was summoned to %d, %d", mq.TLO.Me.Y(), mq.TLO.Me.X())
        end
        cmdf("/popup SUMMONED")
    end)

    -- tell all toons to camp
    bind("/campall", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/camp desktop")
        end
        cmd("/camp desktop")
    end)

    -- toggles debug output on/off
    bind("/debug", function()
        if log.loglevel == "debug" then
            log.loglevel = "info"
            log.Info("Toggle debug info OFF")
        else
            log.loglevel = "debug"
            log.Info("Toggle debug info ON")
        end
    end)


    -- api: used by one peer to tell other peers about what corpses are already rezzed
    bind("/ae_rezzed", function(...)
        local name = args_string(...)
        mark_ae_rezzed(name)
    end)

    if not mq.TLO.EQBC.Connected() then
        log.Info("Connecting to EQBC server ...")
        cmd("/bccmd connect")
        delay(15000, function() return mq.TLO.EQBC.Connected() end)

        if not mq.TLO.EQBC.Connected() then
            cmdf("/beep")
            log.Fatal("ERROR: Could not connect to EQBCS! Please open EQBCS and try again.")
            all_tellf("ERROR: Could not connect to EQBCS! Please open EQBCS and try again.")
        end
    end

    -- enable MQ2NetBots
    --cmd("/netbots on grab=on send=on")

    QoL.verifyAllSpellLines()

    QoL.equipWeaponSet("main")

    zonedCommand.Enqueue(nil, 0)
end

-- Equips a weapon set
function QoL.equipWeaponSet(setName)
    if botSettings.settings.weapons == nil then
        return
    end
    local set = botSettings.settings.weapons[setName]
    if set == nil then
        all_tellf("ERROR: No such weapon set %s", setName)
    end

    for slotName, itemName in pairs(set) do
        if mq.TLO.Me.Inventory(slotName).Name() ~= itemName then
            if not have_item_inventory(itemName) then
                if not have_item_banked(itemName) then
                    all_tellf("ERROR: cannot equip %s %s %s, item not found", setName, slotName, itemName)
                else
                    all_tellf("ERROR: cannot equip %s %s %s, item is in bank", setName, slotName, itemName)
                end
                cmd("/beep")
                return
            end

            log.Info("equipWeaponSet %s: %s %s", setName, slotName, itemName)
            mq.cmdf('/exchange "%s" %s', itemName, slotName)
            mq.delay(50)
        end
    end
end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2Debuffs",
        "MQ2Exchange",  -- Equipment swapper
        "MQ2Medley",    -- Bard songs
        "MQ2Cast",      -- for /casting
        "MQ2LinkDB",    -- for /link and /findslot

        "MQ2MoveUtils", -- for MQ2AdvPath follow mode, /stick, /moveto
        "MQ2AdvPath",   -- for MQ2AdvPath follow mode, /afollow
        "MQ2Nav",       -- for MQ2Nav follow mode, requires meshes, /nav
    }
    if not is_plugin_loaded("MQ2EQBC") and not is_plugin_loaded("MQ2DanNet") then
        load_plugin("MQ2EQBC")
    end
    if is_plugin_loaded("MQ2EQBC") and not is_plugin_loaded("MQ2NetBots") then
        load_plugin("MQ2NetBots")
    end
    for k, v in pairs(requiredPlugins) do
        if not is_plugin_loaded(v) then
            load_plugin(v)
            log.Debug("Loaded base plugin %s, was not loaded", v)
        end
    end

    if is_rof2() then
        local requiredEmuPlugins = {
            "MQ2ConstantAffinity",  -- https://github.com/martinlindhe/MQ2ConstantAffinity
            --"MQMountClassicModels", -- TODO make use of
        }
        for k, v in pairs(requiredEmuPlugins) do
            if not is_plugin_loaded(v) then
                load_plugin(v)
                log.Debug("Loaded emu plugin %s, was not loaded", v)
            end
        end
    end
end

-- make sure I know all listed abilities
function QoL.verifyAllSpellLines()
    if is_naked() then
        return
    end

    verifySpellLines("self_buffs", botSettings.settings.self_buffs)
    verifySpellLines("combat_buffs", botSettings.settings.combat_buffs)

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
            all_tellf("Missing %s: [+r+]%s[+x+] ([+y+]%s[+x+])", label, spellConfig.Name, row)
            cmd("/beep 1")
        end
    end
end

local qolClearCursorTimer = timer.new_expired(60 * 1) -- 60s

-- auto accept shared task invites
function QoL.AcceptSharedTask()
    if not window_open("ConfirmationDialogBox") then
        return
    end
    local s = mq.TLO.Window("ConfirmationDialogBox").Child("CD_TextOutput").Text()

    if string.find(s, "has asked you to join the shared task") ~= nil then
        -- grab first word from sentence
        local i = 1
        local peer = ""
        for w in s:gmatch("%S+") do
            if i == 1 then
                peer = w
                break
            end
            i = i + 1
        end

        log.Debug("Got a shared task invite from %s", peer)
        if not is_peer(peer) then
            log.Warn("Got a shared task invite from \ay%s\ax: \ap%s\ax", peer, s)
            all_tellf("Got a shared task invite from \ay%s\ax: \ap%s\ax", peer, s)
            if not serverSettings.allowStrangers then
                cmd("/beep 1")
                delay(10000) -- 10s to not flood chat
                return
            end
        end

        all_tellf("Accepting shared task from \ag%s\ax ...", peer)
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
    end
end

-- Runs every second.
function QoL.Tick()

    -- close f2p nag screen
    if window_open("AlertWnd") then
        cmd("/squelch /notify AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto hide task window for non-focused peers
    if not is_orchestrator() and window_open("TaskWnd") then
        close_window("TaskWnd")
    end

    -- auto hide expedition window for non-focused peers
    if not is_orchestrator() and window_open("DynamicZoneWnd") then
        close_window("DynamicZoneWnd")
    end

    QoL.AcceptSharedTask()

    -- auto accept trades
    if window_open("tradewnd") and not have_cursor_item() then
        if has_target() and is_peer(mq.TLO.Target.Name()) then
            all_tellf("Accepting trade in 5s with %s", mq.TLO.Target.Name())
            delay(5000, function() return not window_open("tradewnd") or have_cursor_item() end)
            if not have_cursor_item() then
                cmd("/squelch /notify tradewnd TRDW_Trade_Button leftmouseup")
            end
        else
            all_tellf("\arWARN\ax Ignoring trade from non-peer %s", mq.TLO.Target.Name())
            delay(5000)
        end
    end

    -- auto skill-up Sense Heading
    if not in_combat() and skill_value("Sense Heading") > 0 and skill_value("Sense Heading") < skill_cap("Sense Heading") and is_ability_ready("Sense Heading") then
        --log.Info("Training Sense Heading")
        cmd('/doability "Sense Heading"')
        delay(100)
    end

    -- auto skill-up Tracking
    if not in_combat() and not obstructive_window_open() and skill_value("Tracking") > 0 and skill_value("Tracking") < skill_cap("Tracking") and is_ability_ready("Tracking") then
        log.Info("Training Tracking")
        cmd('/doability "Tracking"')
        delay(100)
    end

    -- auto skill-up Forage
    if not in_combat() and not obstructive_window_open() and is_standing() and free_inventory_slots() > 0 and skill_value("Forage") > 0 and skill_value("Forage") < skill_cap("Forage") and is_ability_ready("Forage") then
        log.Info("Training Forage")
        cmd('/doability "Forage"')
        delay(100)
        clear_cursor()
    end

    if is_wiz() and have_pet() then
        cmd("/pet get lost")
    end

    if mq.TLO.Me.Ducking() then
        log.Info("Standing up. Was ducking")
        cmd("/stand")
        delay(200)
    end

    if qolClearCursorTimer:expired() and not window_open("LootWnd") then
        clear_cursor()
        qolClearCursorTimer:restart()
    end
end

return QoL
