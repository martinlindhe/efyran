-- quality of life tweaks

local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local assist  = require("efyran/e4_Assist")
local follow  = require("efyran/e4_Follow")
local commandQueue = require("efyran/e4_CommandQueue")
local botSettings = require("efyran/e4_BotSettings")
local loot  = require("efyran/e4_Loot")
local buffs   = require("efyran/e4_Buffs")
local globalSettings = require("efyran/e4_Settings")

require("efyran/autobank")

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

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        if zone == "an area where levitation effects do not function" then
            return
        end
        commandQueue.ZoneEvent()
    end)

    mq.event("mob-mezzed", "#*# has been mesmerized.", function(text, name)
        log.Info("Mezzed %s", name)
        mq.cmdf("/popup MEZZED %s", name)
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
            all_tellf("Missing component \ar%s\ax.", name)
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
    mq.bind("/gotflag", function()
        if is_orchestrator() then
            cmdf("/dgexecute /gotflag")
        end
        if gotFlag then
            all_tellf("\agGOT FLAG\ax")
        end
    end)

    -- report who did not get a flag
    mq.bind("/noflag", function()
        if is_orchestrator() then
            cmdf("/dgexecute /noflag")
        end
        if not gotFlag then
            all_tellf("\arNO FLAG\ax")
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


    -- mana check
    mq.bind("/mana", function()
        if is_orchestrator() then
            cmdf("/dgzexecute /mana")
        end
        if mq.TLO.Me.MaxMana() == 0 or mq.TLO.Me.PctMana() == 100 then
            return
        end
        if mq.TLO.Me.PctMana() < 50 then
            all_tellf("MANA \ar%d %%\ax", mq.TLO.Me.PctMana())
        elseif mq.TLO.Me.PctMana() < 75 then
            all_tellf("MANA \ay%d %%\ax", mq.TLO.Me.PctMana())
        else
            all_tellf("MANA \ag%d %%\ax", mq.TLO.Me.PctMana())
        end
    end)

    -- tell peers to kill target until dead
    ---@param string|nil spawnID spawn ID
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/assiston", function(...)
        local filter = args_string(...)
        local spawnID = nil
        local tokens = split_str(filter, "/")
        if #tokens == 2 then
            --log.Info("assiston: splitting filter into two: %s    AND   %s", tokens[1], tokens[2])
            if string.len(tokens[1]) > 0 then
                spawnID = trim(tokens[1])
                filter = "/" .. tokens[2]
                --log.Info("assiston: updating filter to '%s'", filter)
            end
        end

        local spawn = nil
        if spawnID == nil then
            spawnID = mq.TLO.Target.ID()
        end
        spawn = spawn_from_id(spawnID)

        if spawn == nil or spawn() == nil or spawn.Type() == "PC" then
            log.Info("GIVING UP ASSIST CALL ON %s, filter %s", tostring(spawnID), tostring(filter))
            return
        end

        local exe = string.format("/dgzexecute /killit %d", spawn.ID())
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        --log.Debug("Calling assist on %s, type %s (filter %s)", spawn.DisplayName(), spawn.Type(), filter)
        mq.cmdf(exe)
        commandQueue.Add("killit", tostring(spawn.ID()), filter)
    end)

    -- auto assist on mob until dead
    ---@param mobID string
    ---@param ... string|nil filter
    mq.bind("/killit", function(mobID, ...)
        if is_gm() then
            return
        end
        local filter = args_string(...)
        commandQueue.Add("killit", mobID, filter)
    end)

    -- ends assist call
    ---@param ... string|nil filter
    mq.bind("/backoff", function(...)
        local filter = args_string(...)
        if is_orchestrator() then
            local exe = "/dgzexecute /backoff"
            if filter ~= nil then
                exe = exe .. " " .. filter
            end
            mq.cmdf(exe)
        end
        commandQueue.Add("backoff", filter)
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

    -- teleport bind for all wizards (port groups to bind point)
    local tlBind = function()
        if is_orchestrator() then
            cmdf("/dgzexecute /teleportbind")
        end
        commandQueue.Add("teleportbind")
    end
    mq.bind("/teleportbind", tlBind)
    mq.bind("/tlbind", tlBind)

    local secondaryRecall = function()
        if is_orchestrator() then
            cmdf("/dgzexecute /secondaryrecall")
        end
        commandQueue.Add("secondaryrecall")
    end
    mq.bind("/secondaryrecall", secondaryRecall)

    -- list all active tasks
    mq.bind("/listtasks", function(...)
        local name = args_string(...)
        if is_orchestrator() then
            mq.cmdf("/dgzexecute /listtasks %s", name)
        end
        commandQueue.Add("listtasks", name)
    end)

    -- report all toons that have task `name` active
    mq.bind("/hastask", function(...)
        local name = args_string(...)
        if is_orchestrator() then
            mq.cmdf("/dgzexecute /hastask %s", name)
        end
        commandQueue.Add("hastask", name)
    end)

    -- Use heal ward AA (CLR/DRU/SHM, OOW)
    mq.bind("/healward", function() commandQueue.Add("ward", "heal") end)

    -- Summon all available heal wards (CLR/DRU/SHM, OOW)
    mq.bind("/healwards", function() cmdf("/dgzexecute /healward") end)

    -- Use cure ward AA "Ward of Purity" (CLR, DoDH)
    mq.bind("/cureward", function() commandQueue.Add("ward", "cure") end)

    -- Summon all available cure wards (CLR, DoDH)
    mq.bind("/curewards", function() cmdf("/dgzexecute /cureward") end)

    -- Used by orchestrator to start pbae
    mq.bind("/pbaeon", function(...)
        local filter = args_string(...)

       if is_orchestrator() then
            local exe = string.format("/dgzexecute /pbaestart %s", mq.TLO.Me.Name())
            if filter ~= nil then
                exe = exe .. " " .. filter
            end
            mq.cmdf(exe)
        end
        if botSettings.settings.assist.pbae == nil then
            return
        end
        commandQueue.Add("pbae-start", mq.TLO.Me.Name(), filter)
    end)

    mq.bind("/pbaestart", function(peer, ...)
        local filter = args_string(...)
        if botSettings.settings.assist.pbae == nil then
            return
        end
        commandQueue.Add("pbae-start", peer, filter)
    end)

    mq.bind("/pbaeoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /pbaeoff")
        end
        if assist.PBAE == true then
            assist.PBAE = false
            all_tellf("PBAE OFF")
        end
    end)

    -- disband all peers from raid/group
    mq.bind("/disbandall", function()
        commandQueue.Add("disbandall")
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

    -- report if MGB is ready
    mq.bind("/mgbready", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mgbready")
        end
        commandQueue.Add("is-mgb-ready")
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

    -- tell everyone else to click door/object (pok stones, etc) near the sender
    mq.bind("/clickit", function(...)
        local filter = args_string(...)

        if is_orchestrator() then
            mq.cmdf("/dgzexecute /clickdoor %s %s", mq.TLO.Me.Name(), filter)
        end
        commandQueue.Add("clickdoor", mq.TLO.Me.Name(), filter)
    end)

    mq.bind("/clickdoor", function(sender, ...)
        local filter = args_string(...)
        commandQueue.Add("clickdoor", sender, filter)
    end)

    mq.bind("/portto", function(name)
        name = name:lower()
        if is_orchestrator() then
            mq.cmdf("/dgzexecute /portto %s", name)
        end
        commandQueue.Add("portto", name)
    end)

    local followOn = function(...)
        local exe = string.format("/dgzexecute /followplayer %s", mq.TLO.Me.Name())
        local filter = args_string(...)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
    end

    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/followon", followOn)
    mq.bind("/followme", followOn) -- alias for e3 compatibility

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        follow.Stop()
    end)

    -- follows another peer
    ---@param spawnName string
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/followplayer", function(spawnName, ...)
        local filter = args_string(...)
        if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
            log.Info("followid: Not matching filter \ay%s\ax", filter)
            return
        end
        follow.Start(spawnName, false)
    end)

    mq.bind("/usecorpsesummoner", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /usecorpsesummoner")
        end
        commandQueue.Add("usecorpsesummoner")
    end)

    mq.bind("/refreshillusion", function()
        commandQueue.Add("refreshillusion")
    end)

    mq.bind("/refreshillusions", function()
        cmd("/bcaa //refreshillusion")
    end)

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

    -- auto cure target (usage: is requested by another toon)
    mq.bind("/cure", function(name, kind)
        commandQueue.Add("cure", name, kind)
    end)

    -- reports all peers with debuffs
    mq.bind("/counters", function()
        cmdf("/noparse /bcaa //if (${NetBots[${Me.Name}].Counters}) /bc DEBUFFED: ${NetBots[${Me.Name}].Counters} counters in ${NetBots[${Me.Name}].Detrimentals} debuffs: ${NetBots[${Me.Name}].Detrimental}")
    end)

    -- report DoN crystals count on all connected peers
    mq.bind("/doncrystals", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /doncrystals")
        end
        commandQueue.Add("report-don-crystals")
    end)

    -- tell peers in zone to use Origin
    mq.bind("/origin", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /origin")
        end
        commandQueue.Add("origin")
    end)

    -- tell peers in zone to use Throne of Heroes
    mq.bind("/throne", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /throne")
        end
        commandQueue.Add("use-veteran-aa", "Throne of Heroes")
    end)

    -- tell all peers to use Throne of Heroes
    mq.bind("/throneall", function()
        if is_orchestrator() then
            mq.cmd("/bca //throne")
        end
        commandQueue.Add("use-veteran-aa", "Throne of Heroes")
    end)

    -- Peer proximity count
    mq.bind("/count", function() commandQueue.Add("count-peers") end)
    mq.bind("/cnt", function() commandQueue.Add("count-peers") end)


    -- tell group to use Lesson of the Devoted
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/lesson", function(...)
        local filter = args_string(...)
        if is_orchestrator() then
            mq.cmdf("/dggexecute /lesson %s", filter)
        end
        commandQueue.Add("use-veteran-aa", "Lesson of the Devoted", filter)
    end)

    mq.bind("/lessonsactive", function()
        mq.cmd("/noparse /dgzexecute /if (${Me.Buff[Lesson of the Devoted].ID}) /bc ACTIVE: ${Me.Buff[Lesson of the Devoted].Duration.TimeHMS}")
    end)

    mq.bind("/staunch", function()
        commandQueue.Add("use-veteran-aa", "Staunch Recovery")
    end)

    mq.bind("/armor", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /armor") -- XXX filter
        end
        commandQueue.Add("use-veteran-aa", "Armor of Experience")
    end)

    mq.bind("/infusion", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /infusion") -- XXX filter
        end
        commandQueue.Add("use-veteran-aa", "Infusion of the Faithful")
    end)

    mq.bind("/intensity", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /intensity") -- XXX filter
        end
        commandQueue.Add("use-veteran-aa", "Intensity of the Resolute")
    end)

    mq.bind("/expedient", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /expedient") -- XXX filter
        end
        commandQueue.Add("use-veteran-aa", "Expedient Recovery")
    end)

    -- report naked toons
    mq.bind("/naked", function()
        if is_orchestrator() then
            mq.cmd("/dgzexecute /naked")
        end
        if is_naked() then
            all_tellf("IM NAKED IN \ay%s\ax", zone_shortname())
        end
    end)

    ---@param ... string|nil filter, such as "/only|ROG"
    local movetome = function(...)
        local exe = string.format("/dgzexecute /movetopeer %s", mq.TLO.Me.Name())
        local filter = args_string(...)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
    end

    mq.bind("/movetome", movetome)
    mq.bind("/mtm", movetome)

    -- move to spawn ID
    ---@param peer string Peer name
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/movetopeer", function(peer, ...)
        local filter = args_string(...)
        commandQueue.Add("movetopeer", peer, filter)
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

    -- pick up ground spawn
    mq.bind("/pickup", function()
        mq.cmd("/itemtarget")
        mq.cmd("/click left item")
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

    mq.bind("/bark", function(...)
        local arg = args_string(...)
        local spawnID = mq.TLO.Target.ID()
        if spawnID == nil then
            log.Error("No target to bark at!")
            return
        end
        if is_orchestrator() then
            cmdf("/dgzexecute /barkit %d %s", spawnID, arg)
        end
        cmdf("/barkit %d %s", spawnID, arg)
    end)

    mq.bind("/barkit", function(spawnID, ...)
        local arg = args_string(...)

        local id = toint(spawnID)
        target_id(id)
        unflood_delay()
        cmdf("/say %s", arg)
    end)

    -- wiz: cast AE TL spell
    mq.bind("/aetl", function()
        if not is_wiz() then
            return
        end
        commandQueue.Add("aetl")
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
    mq.bind("/factionsall", function() mq.cmd("/squelch /dgzexecute /factions") end)

    -- clear all chat windows on current peer
    mq.bind("/clr", function() mq.cmd("/clear") end)

    -- clear all chat windows on all peers
    mq.bind("/cls", function() mq.cmd("/squelch /bcaa //clear") end)

    mq.bind("/self", function() mq.cmd("/target myself") end)

    -- hide existing corpses
    mq.bind("/hce", function() mq.cmd("/hidec all") end)

    -- hide looted corpses
    mq.bind("/hcl", function() mq.cmd("/hidec looted") end)

    -- hide no corpses
    mq.bind("/hcn", function() mq.cmd("/hidec none") end)

    -- report toons with few free buff slots
    mq.bind("/freebuffslots", function(name) mq.cmd("/noparse /bcaa //if (${Me.FreeBuffSlots} <= 1) /bc FREE BUFF SLOTS: ${Me.FreeBuffSlots}") end)
    mq.bind("/fbs", function(name) mq.cmd("/freebuffslots") end)

    -- /raidinvite shorthand
    mq.bind("/ri", function(name) mq.cmdf("/raidinvite %s", name) end)

    -- quickly exits all eqgame.exe instances using task manager
    mq.bind("/exitall", function()
        mq.cmd('/squelch /exec TASKKILL "/F /IM eqgame.exe" bg')
    end)

    -- quickly exits my eqgame.exe instance using task manager
    mq.bind("/exitme", function()
        all_tellf("Exiting")
        mq.cmd('/squelch /exec TASKKILL "/F /PID '..tostring(mq.TLO.EverQuest.PID())..'" bg')
    end)

    mq.bind("/exitnotinzone", function() mq.cmdf("/noparse /bcaa //if (!${SpawnCount[pc =%s]}) /exitme", mq.TLO.Me.Name()) end)

    mq.bind("/exitnotingroup", function() mq.cmd("/noparse /bcaa //if (!${Group.Members}) /exitme") end)

    mq.bind("/exitnotinraid", function(force)
        if not in_raid() and force ~= "force" then
            all_tellf("ERROR: not exiting since you are not raided! Force with /exitnotinraid force")
            cmd("/beep")
            return
        end
        mq.cmd("/noparse /bcaa //if (!${Raid.Members}) /exitme")
    end)

    -- report all peers who are not in current zone
    mq.bind("/notinzone", function() mq.cmdf("/noparse /bcaa //if (!${SpawnCount[pc =%s]}) /bc I'm in \ar${Zone.ShortName}\ax", mq.TLO.Me.Name()) end)

    mq.bind("/notingroup", function() mq.cmd("/noparse /bcaa //if (!${Me.Grouped}) /bc NOT IN GROUP") end)

    mq.bind("/ingroup", function() mq.cmd("/noparse /bcaa //if (${Me.Grouped}) /bc IN GROUP") end)

    mq.bind("/notinraid", function() mq.cmd("/noparse /bcaa //if (!${Raid.Members}) /bc NOT IN RAID") end)

    mq.bind("/inraid", function() mq.cmd("/noparse /bcaa //if (${Raid.Members}) /bc IN RAID") end)

    -- report all peers who are not levitating
    mq.bind("/notlevi", function() mq.cmd("/noparse /bcaa //if (!${Me.Levitating}) /bc NOT LEVI") end)

    mq.bind("/notitu", function() mq.cmd("/noparse /bcaa //if (!${Me.Buff[Sunskin].ID}) /bc NOT ITU") end)

    -- report all peers who are not invisible
    mq.bind("/notinvis", function() mq.cmd("/noparse /bcaa //if (!${Me.Invis}) /bc NOT INVIS") end)


    -- report special stats
    mq.bind("/combateffects", function() mq.cmd("/noparse /bcaa //if (${Select[${Me.Class.ShortName},ROG,BER,MNK]}) /bc COMBAT EFFECT ${Me.CombatEffectsBonus}") end)
    mq.bind("/accuracy", function() mq.cmd("/noparse /bcaa //if (${Select[${Me.Class.ShortName},WAR,PAL,RNG,SHD,MNK,BRD,ROG,BST,BER]}) /bc ACCURACY ${Me.AccuracyBonus}/150") end)
    mq.bind("/strikethru", function() mq.cmd("/noparse /bcaa //if (${Select[${Me.Class.ShortName},RNG,MNK,BRD,ROG,BST,BER]}) /bc STRIKE THRU ${Me.StrikeThroughBonus}/35") end)
    mq.bind("/shielding", function() mq.cmd("/noparse /bcaa //bc SHIELDING ${Me.ShieldingBonus}") end)

    mq.bind("/dotshield", function() mq.cmd("/noparse /bcaa //bc DoT SHIELD ${Me.DoTShieldBonus}") end)
    mq.bind("/spellshield", function() mq.cmd("/noparse /bcaa //bc SPELL SHIELD ${Me.SpellShieldBonus}") end)
    mq.bind("/avoidance", function() mq.cmd("/noparse /bcaa //bc AVOIDANCE ${Me.AvoidanceBonus}/100") end)
    mq.bind("/stunresist", function() mq.cmd("/noparse /bcaa //bc STUN RESIST ${Me.StunResistBonus}") end)

    -- "free inventory slots": only lists melees as looter classes for minimal disruption
    mq.bind("/fis", function()
        mq.cmd("/noparse /bcaa //if (${Select[${Me.Class.ShortName},MNK,ROG,BER,RNG]} && ${Me.FreeInventory} > 20) /bc FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- "free inventory slots all"
    mq.bind("/fisa", function()
        mq.cmd("/noparse /bcaa //if (${Me.FreeInventory} > 20) /bc FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- report all with few free inventory slots
    mq.bind("/fewinventoryslots", function()
        mq.cmd("/noparse /bcaa //if (${Me.FreeInventory} <= 20) /bc FULL INVENTORY, ${Me.FreeInventory} FREE SLOTS")
    end)

    -- make peers in zone face my target
    mq.bind("/facetarget", function() mq.cmdf("/squelch /dgzexecute /face fast id %d", mq.TLO.Target.ID()) end)
    mq.bind("/facetgt", function() mq.cmd("/facetarget") end)

    -- make peers in zone face me
    mq.bind("/faceme", function() mq.cmdf("/squelch /dgzexecute /face fast id %d", mq.TLO.Me.ID()) end)

    -- useful when AE FD is cast (oow, wos Shadowhunter, Cleric 1.5 fight in lfay and so on)
    mq.bind("/standall", function()
        log.Info("Requested ALL peers to /stand")
        mq.cmd("/noparse /bcaa //if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /stand")
    end)

    mq.bind("/sitall", function()
        log.Info("Requested ALL peers to /sit")
        mq.cmd("/noparse /bcaa //if (${Me.Standing}) /sit on")
    end)

    -- report all peers who are not standing
    mq.bind("/notstanding", function() mq.cmd("/noparse /bcaa //if (${Me.Feigning} || ${Me.Ducking} || ${Me.Sitting}) /bc NOT STANDING") end)

    -- open loot window on closest corpse
    mq.bind("/lcorpse", function() commandQueue.Add("open-nearby-corpse") end)

    -- reports all toons that are not running e4
    mq.bind("/note4", function() mq.cmd("/bcaa //lua run note4") end)

    mq.bind("/running", function()
        -- XXX reports all running scripts on all toons
        log.Error("FIXME impl /running: report all running scripts on all toons")
    end)

    -- runs combine.lua tradeskill script. NOTE: /combine is reserved for MacroQuest.
    mq.bind("/combineit", function()
        if is_script_running("combine") then
            cmd("/lua stop efyran/combine")
        end
        cmd("/lua run efyran/combine")
    end)

    mq.bind("/handin", function()
        commandQueue.Add("handin")
    end)

    mq.bind("/handinall", function()
        cmd("/bcaa //handin")
    end)

    -- make peers surround you in a circle
    mq.bind("/circleme", function(dist)
        commandQueue.Add("circleme", dist)
    end)

    local mmrl = function()
        cmdf("/dex %s /makeraidleader %s", mq.TLO.Raid.Leader(), mq.TLO.Me.Name())
    end
    mq.bind("/makemeraidleader", mmrl)
    mq.bind("/mmrl", mmrl)

    -- reports all currently worn auguments
    mq.bind("/wornaugs", function() commandQueue.Add("reportwornaugs") end)

    -- reports all owned clickies (worn, inventory, bank) worn auguments
    mq.bind("/listclickies", function() commandQueue.Add("list-clickies") end)

    -- cast Summon Clockwork Banker veteran AA yourself, or the first available nearby peer
    mq.bind("/banker", function() commandQueue.Add("summonbanker") end)

    -- auto banks items from tradeskills.ini
    mq.bind("/autobank", function() commandQueue.Add("autobank") end)

    -- report if tribute is too low (under 140k)
    mq.bind("/lowtribute", function()
        mq.cmd("/noparse /bcaa //if (${Me.CurrentFavor} < 140000) /bc LOW TRIBUTE ${Me.CurrentFavor}")
    end)

    -- report if tribute is active
    -- TODO add filter for /tributeactive /only|tanks
    mq.bind("/tributeactive", function()
        mq.cmd("/noparse /bcaa //if (${Me.TributeActive}) /bc TRIBUTE ACTIVE, COST ${Me.ActiveFavorCost}, STORED ${Me.CurrentFavor}")
    end)

    -- report your GoD tongue quest status
    mq.bind("/tongues", function()
        if have_item("Assistant Researcher's Symbol") then
            all_tellf("tongues: DONE")
            -- TODO check if we have any tongues that is wasting bag space if we got the reward
            return
        end
        local tongues = {
            "Ikaav Tongue",
            "Mastruq Tongue",
            "Aneuk Tongue",
            "Ra'Tuk Tongue",
            "Noc Tongue",
            "Kyv Tongue",
            "Ukun Tongue",
            "Ixt Tongue",
            "Tongue of the Zun'muram",
            "Tongue of the Tunat'muram",
        }

        local s = ""
        local missing = 0
        for k, name in pairs(tongues) do
            if not have_item(name) then
                missing = missing + 1
                s = s .. name .. ", "
            end
        end

        if s == "" then
            s = "tongues: OK"
        else
            s = string.format("tongues NEED %d: %s", missing, s)
        end

        all_tellf(s)
    end)

    -- report your CoA auguments
    mq.bind("/coaaugs", function()
        local augs = {
            "Abhorrent Brimstone of Charring",
            "Gem of Unnatural Regrowth",
            "Kyv Eye of Marksmanship",
            "Orb of Forbidden Laughter",
            "Petrified Girplan Heart",
            "Rune of Astral Celerity",
            "Rune of Futile Resolutions",
            "Rune of Grim Portents",
            "Rune of Living Lightning",
            "Stone of Horrid Transformation",
            "Stone of Planar Protection",
        }
        local s = ""
        local missing = 0
        for k, name in pairs(augs) do
            if not have_item(name) then
                missing = missing + 1
                s = s .. name .. ", "
            end
        end

        if s == "" then
            s = "coaaugs: OK"
        else
            s = string.format("coaaugs NEED %d: %s", missing, s)
        end

        all_tellf(s)
    end)

    -- report your Lucid Shards
    mq.bind("/lucidshards", function()

        -- 22198 The Scepter of Shadows
        if have_item_id(22198) then
            all_tellf("lucidshards: OK (KEYED)")
            return
        end

        -- 17324 Unadorned Scepter of Shadows
        if have_item_id(17324) then
            all_tellf("lucidshards: OK")
            return
        end

        local shards = {
            [22185] = "The Grey",
            [22186] = "Fungus Grove",
            [22187] = "Scarlet Desert",
            [22188] = "The Deep",
            [22189] = "Ssraeshza Temple",
            [22190] = "Akheva Ruins",
            [22191] = "Dawnshroud Peaks",
            [22192] = "Maiden's Eye",
            [22193] = "Acrylia Caverns",
            [22194] = "Sanctus Seru / Katta",
            [17323] = "Akheva Ruins Container", -- Shadowed Scepter Frame
        }
        local s = ""
        local missing = 0
        for id, name in pairs(shards) do
            if not have_item_id(id) then
                missing = missing + 1
                s = s .. name .. ", "
            end
        end

        if s == "" then
            s = "lucidshards: OK"
        else
            s = string.format("lucidshards NEED %d: %s", missing, s)
        end

        all_tellf(s)
    end)

    -- MAG: use Call of the Hero to summon the group to you
    mq.bind("/cohgroup", function() commandQueue.Add("coh-group") end)

    -- Ask peer owners of nearby corpses to consent me
    mq.bind("/consentme", function() commandQueue.Add("consentme") end)

    -- summon nearby corpses into a pile
    mq.bind("/gathercorpses", function() commandQueue.Add("gathercorpses") end)

    -- loot all my nearby corpses
    mq.bind("/lootmycorpse", function() commandQueue.Add("lootmycorpse") end)

    -- turn auto loot on
    mq.bind("/looton", function()
        loot.autoloot = true
    end)

    -- turn auto loot off
    mq.bind("/lootoff", function()
        loot.autoloot = false
    end)

    -- tell peers to attempt to loot their corpses
    mq.bind("/lootallcorpses", function()
        if is_orchestrator() then
            cmd("/dgzexecute /lootmycorpse")
        end
        commandQueue.Add("lootmycorpse")
    end)

    -- tell all peers to click yes on dialog (rez, etc)
    mq.bind("/yes", function()
        if is_orchestrator() then
            cmd("/dgzexecute /yes")
        end
        commandQueue.Add("click-yes")
    end)

    -- tell all peers to click no on dialog (aetl, rez, etc)
    mq.bind("/no", function()
        if is_orchestrator() then
            cmd("/dgzexecute /no")
        end
        commandQueue.Add("click-no")
    end)

    -- tell clerics to use word heals
    mq.bind("/wordheal", function()
        if is_orchestrator() then
            cmd("/dgzexecute /wordheal")
        end
        if not is_clr() then
            return
        end
        commandQueue.Add("wordheal")
    end)

    -- make all peer quit expedition
    mq.bind("/quitexp", function()
        all_tellf("Instructing peers to leave expedition / shared task ...")
        cmd("/bcaa //dzquit")   -- Expedition (PoP, LDoN, GoD, OOW)
        cmd("/bcaa //taskquit") -- Shared task (DoN)
    end)

    -- hide all dz windows
    mq.bind("/dzhide", function() mq.cmd("/noparse /bcaa //if (${Window[dynamiczonewnd]}) /windowstate dynamiczonewnd close") end)

    -- report peers with at least 5 unspent AA:s
    mq.bind("/unspentaa", function() mq.cmd("/noparse /bcaa //if (${Me.AAPoints} >= 5 && ${Me.AAPoints} < 50) /bc UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with less than 10 unspent AA:s
    mq.bind("/lowunspentaa", function() mq.cmd("/noparse /bcaa //if (${Me.AAPoints} >= 1 && ${Me.AAPoints} < 50) /bc UNSPENT AA: ${Me.AAPoints}") end)

    -- report peers with any unspent AA:s
    mq.bind("/allunspentaa", function() mq.cmd("/noparse /bcaa //if (${Me.AAPoints} >= 1) /bc UNSPENT AA: ${Me.AAPoints} (SPENT ${Me.AAPointsSpent})") end)

    -- report all peer total AA:s
    mq.bind("/totalaa", function() mq.cmd("/noparse /bcaa //bc ${Me.AAPointsTotal} TOTAL (${Me.AAPoints} unspent, ${Me.AAPointsSpent} spent)") end)

    -- finds item by name in inventory/bags
    -- NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    -- arg: item name + optional /filter arguments as strings
    mq.bind("/fdi", function(...)
        local name = args_string(...)
        local filter = nil
        local tokens = split_str(name, "/")
        if #tokens == 2 then
            name = trim(tokens[1])
            filter = "/" .. tokens[2]
        end
        if name ~= "" then
            commandQueue.Add("find-item", name, filter)
        end
    end)

    -- find missing item
    -- arg: item name + optional /filter arguments as strings
    mq.bind("/fmi", function(...)
        local name = args_string(...)
        local filter = nil
        local tokens = split_str(name, "/")
        if #tokens == 2 then
            name = trim(tokens[1])
            filter = "/" .. tokens[2]
        end
        if name ~= "" then
            commandQueue.Add("find-missing-item", name, filter)
        end
    end)

    -- find missing item by id
    mq.bind("/fmid", function(id)
        commandQueue.Add("find-missing-item-id", id)
    end)

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber) commandQueue.Add("recallgroup", name, groupNumber) end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        if is_peer(sender) then
            commandQueue.Add("joingroup")
        end
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        if not is_peer(sender) then
            all_tellf("Got raid invite from %s", sender)
            if not globalSettings.allowStrangers then
                all_tellf("ERROR: Ignoring Raid invite from unknown player %s", sender)
                return
            end
        end
        commandQueue.Add("joinraid")
    end)

    -- track xp, auto adjust level / AA xp and auto loot
    local xpGain = function(text)

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

        --log.Info("Gained XP. AA %.2f %%", aaDiff)
        QoL.currentExp = mq.TLO.Me.PctExp()
        QoL.currentAAXP = mq.TLO.Me.PctAAExp()

        local msg = ""

        if not in_raid() then
            if xpDiff > 0. then
                msg = string.format("(%.1f %% XP)", xpDiff)
            else
                msg = string.format("(%.1f %% AA)", aaDiff)
            end
            if not in_group() then
                msg = "Solo XP " .. msg
            elseif is_group_leader() then
                msg = "Group XP " .. msg
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
        all_tellf("\agDing L%d", level)
    end)

    mq.event("ding-aa", "You have gained an ability point#*#", function(text)
        if mq.TLO.Me.AAPoints() <= 1 or mq.TLO.Me.AAPoints() >= 50 then
            return
        end
        all_tellf("\agDing AA - %d unspent", mq.TLO.Me.AAPoints())
    end)

    mq.event('summoned', '#*#You have been summoned#*#', function(text, sender) -- XXX improve
        cmdf("/popup SUMMONED")
        log.Info("You was summoned to %d, %d", mq.TLO.Me.Y(), mq.TLO.Me.X())
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

    -- api: used by one peer to tell other peers about what corpses are already rezzed
    mq.bind("/ae_rezzed", function(...)
        local name = args_string(...)
        mark_ae_rezzed(name)
    end)

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


    -- XXX

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
    cmd("/netbots on grab=on send=on")

    QoL.verifySpellLines()
    perform_zoned_event()
end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2EQBC",
        "MQ2NetBots",

        "MQ2DanNet",  -- XXX drop mq2dannet for MQ2NetBots
        "MQ2Debuffs",
        "MQ2MoveUtils", -- for /stick, /moveto
        "MQ2Cast",
        "MQ2Medley",  -- Bard songs

        --"MQ2TributeManager", -- adds /tribute command. does not work on emu

        --"MQ2AdvPath",   -- for /afollow, currently unused
        --"MQ2Nav", -- TODO requires mesh files etc
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
            all_tellf("Missing %s: \ar%s\ax (\ay%s\ax)", label, spellConfig.Name, row)
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
            if not globalSettings.allowStrangers then
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
    if window_open("tradewnd") and not has_cursor_item() then
        if has_target() and is_peer(mq.TLO.Target.Name()) then
            all_tellf("Accepting trade in 5s with %s", mq.TLO.Target.Name())
            delay(5000, function() return not window_open("tradewnd") or has_cursor_item() end)
            if not has_cursor_item() then
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

-- summon corpse using the corpse summoner in guild lobby
function use_corpse_summoner()

    if zone_shortname() ~= "guildlobby" then
        log.Error("Must be in guild lobby, west wing opening to use corpse summoner script")
        return
    end

    follow.Stop()

    if not is_naked() then
        log.Info("Not naked, ignoring corpse summoner")
        return
    end

    if have_corpse_in_zone() then
        log.Info("I have a corpse in zone, not summoning another !")
        return
    end

    if not is_within_distance_to_loc(412, 180, 2, 25) then
        all_tellf("ERROR: Not at correct spot in guild lobby. Go to west wing opening and try again!")
        return
    end

    unflood_delay()

    local soulstone, price = get_best_soulstone()

    if not have_item(soulstone) and mq.TLO.Me.Platinum() < price then
        -- pick up plat from banker
        if mq.TLO.Me.PlatinumBank() < price then
            all_tellf("ERROR: Not enough plat in bank for corpse summoner. Need %d, have %d", price, mq.TLO.Me.PlatinumBank())
            cmd("/beep 1")
            return
        end

        log.Info("Not enough cash, need to pick up from bank ...")

        move_to_loc(415, 250, 2)    -- middle point
        delay(1000)

        move_to_loc(477, 190, 2)    -- banker
        delay(1000)

        open_banker()

        if not window_open("BigBankWnd") then
            all_tellf("ERROR failed to open bank")
            return
        end

        -- withdraw plat
        --:ammountofplat
        if not window_open("QuantityWnd") then
            cmd("/notify BigBankWnd BIGB_Money0 leftmouseup")
        end

        delay(100)

        delay(5, function() window_open("QuantityWnd") end)

        for i = 1, 9 do
            cmd("/keypress backspace chat")
            delay(20)
        end

        local costString = string.format("%d", price)

        for c in costString:gmatch"." do
            cmdf("/keypress %s chat", c)
            delay(30)
        end

        cmd("/notify QuantityWnd QTYW_Accept_Button leftmouseup")
        delay(20)
        cmd("/autoinventory")

        close_window("BigBankWnd")

        move_to_loc(415, 250, 2)    -- middle point
        delay(1000)
    end

    if not have_item(soulstone) then
        log.Info("Purchasing soulstone \ag%s\ax, price %d platinum", soulstone, price)

        target_npc_name("A Disciple of Luclin")

        move_to_loc(350, 191, 2)    -- A Disciple of Luclin
        delay(1000)

        cmd("/click right target")
        delay(1000)
        if not window_open("MerchantWnd") then
            all_tellf("ERROR corpse summoning: Fail to open MerchantWnd")
            return
        end

        cmdf("/nomodkey /notify MerchantWnd ItemList listselect %d", mq.TLO.Window("MerchantWnd").Child("ItemList").List("="..soulstone, 2)())
        delay(60)
        cmd("/notify MerchantWnd MW_Buy_Button leftmouseup")
        delay(1000, function() return have_item(soulstone) end)

        if have_item(soulstone) then
            cmd("/nomodkey /notify MerchantWnd MW_Done_Button leftmouseup")
        else
            all_tellf("ERROR failed to purchase soulstone !")
            return
        end
    end


    local item = find_item(soulstone)
    if item == nil then
        all_tellf("ERROR: cant find soulstone %s", soulstone)
        return
    end

    -- move to summoner
    move_to_loc(321, 270, 2) -- corpse summoner
    delay(1000)

    target_npc_name("A Priest of Luclin")

    -- pick up soulstone
    cmdf("/nomodkey /ctrl /itemnotify in Pack%d %d leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
    delay(200)
    delay(1000, function() return has_cursor_item() end)

    -- give it
    cmd("/click left target")
    delay(200)

    delay(1000, function() return not has_cursor_item() end)
    cmd("/notify GiveWnd GVW_Give_Button leftmouseup")

    delay(1000)

    move_to_loc(320, 300, 2)    -- sw corner
end


-- form bots in a circle around orchestrator
---@param dist integer|nil Distance from the center
function make_peers_circle_me(dist)

	local n = peer_count()
    if dist == nil then
        dist = 20
    end

    cmd("/dgze /followoff")

    for i, peer in pairs(get_peers()) do
        local angle = (360 / n) * i
        if is_peer_in_zone(peer) then
            local y = mq.TLO.Me.Y() + (dist * math.sin(angle))
            local x = mq.TLO.Me.X() + (dist * math.cos(angle))
            cmdf("/dex %s /moveto loc %d %d", peer, y, x)
        end
    end
end


return QoL
