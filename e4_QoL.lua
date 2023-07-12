-- quality of life tweaks

local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local assist  = require("efyran/e4_Assist")
local follow  = require("efyran/e4_Follow")
local commandQueue = require("efyran/e4_CommandQueue")
local botSettings = require("efyran/e4_BotSettings")
local pet     = require("efyran/e4_Pet")
local buffs   = require("efyran/e4_Buffs")

require("efyran/autobank")

local QoL = {}

local maxFactionLoyalists = false

local currentAAXP = mq.TLO.Me.PctAAExp()

function QoL.Init()

    if mq.TLO.FrameLimiter() ~= "TRUE" then
        all_tellf("Enabling framelimiter (was %s) ...", mq.TLO.FrameLimiter())
        cmd("/framelimiter enable")
    end

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
        commandQueue.ZoneEvent()
    end)

    mq.event("camping", "It will take you about 30 seconds to prepare your camp.", function(text, name)
        -- "It will take about 25 more seconds to prepare your camp."
        all_tellf("I am camping. Ending all macros.")
        cmd("/lua stop")
        os.exit()
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
        --log.Info("skill name %s, num %d", name, num)
        cmdf("/dgtell skillup %s (%d/%d)", name, num, skill_cap(name))
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


    -- mana check
    mq.bind("/mana", function()
        if is_orchestrator() then
            cmdf("/dgzexecute /mana")
        end
        if mq.TLO.Me.MaxMana() == 0 or mq.TLO.Me.PctMana() == 100 then
            return
        end
        all_tellf("MANA %d %%", mq.TLO.Me.PctMana())
    end)

    -- tell peers to kill target until dead
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/assiston", function(...)
        local spawn = mq.TLO.Target
        if spawn() == nil or spawn.Type() == "PC" then
            return
        end
        local exe = string.format("/dgzexecute /killit %d", spawn.ID())
        local filter = trim(args_string(...))
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

    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/followon", function(...)
        local exe = string.format("/dgzexecute /followid %d", mq.TLO.Me.ID())
        local filter = trim(args_string(...))
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        follow.Stop()
    end)

    -- follows another peer in LoS
    ---@param spawnID string
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/followid", function(spawnID, ...)
        local filter = trim(args_string(...))
        if filter ~= nil and not matches_filter(filter) then
            log.Info("followid: Not matching filter, giving up: %s", filter)
            return
        end
        follow.Start(toint(spawnID))
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
            mq.cmd("/dgaexecute /throne")
        end
        commandQueue.Add("use-veteran-aa", "Throne of Heroes")
    end)

    -- tell group to use Lesson of the Devoted
    mq.bind("/lesson", function()
        if is_orchestrator() then
            mq.cmd("/dggexecute /lesson") -- XXX filter!!!
        end
        commandQueue.Add("use-veteran-aa", "Lesson of the Devoted")
    end)

    -- XXX filter argument!!!
    mq.bind("/lessonsactive", function()
        mq.cmd("/noparse /dgzexecute /if (${Me.Buff[Lesson of the Devoted].ID}) /dgtell all LESSON ACTIVE: ${Me.Buff[Lesson of the Devoted].Duration.TimeHMS}")
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

    ---@param ... string|nil filter, such as "/only|ROG"
    local movetome = function(...)
        local exe = string.format("/dgzexecute /movetoid %d", mq.TLO.Me.ID())
        local filter = trim(args_string(...))
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
    end

    mq.bind("/movetome", movetome)
    mq.bind("/mtm", movetome)

    -- move to spawn ID
    ---@param spawnID string
    ---@param ... string|nil filter, such as "/only|ROG"
    mq.bind("/movetoid", function(spawnID, ...)
        if is_orchestrator() then
            cmdf("/dgzexecute /movetoid %d", spawnID)
        end
        local filter = trim(args_string(...))
        commandQueue.Add("movetoid", spawnID, filter)
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

    -- report special stats
    mq.bind("/combateffects", function() mq.cmd("/noparse /dgaexecute all /if (${Select[${Me.Class.ShortName},ROG,BER,MNK]}) /dgtell all COMBAT EFFECT ${Me.CombatEffectsBonus}") end)
    mq.bind("/accuracy", function() mq.cmd("/noparse /dgaexecute all /if (${Select[${Me.Class.ShortName},WAR,PAL,RNG,SHD,MNK,BRD,ROG,BST,BER]}) /dgtell all ACCURACY ${Me.AccuracyBonus}/150") end)
    mq.bind("/strikethru", function() mq.cmd("/noparse /dgaexecute all /if (${Select[${Me.Class.ShortName},RNG,MNK,BRD,ROG,BST,BER]}) /dgtell all STRIKE THRU ${Me.StrikeThroughBonus}/35") end)
    mq.bind("/shielding", function() mq.cmd("/noparse /dgaexecute all /dgtell all SHIELDING ${Me.ShieldingBonus}") end)

    mq.bind("/dotshield", function() mq.cmd("/noparse /dgaexecute all /dgtell all DoT SHIELD ${Me.DoTShieldBonus}") end)
    mq.bind("/spellshield", function() mq.cmd("/noparse /dgaexecute all /dgtell all SPELL SHIELD ${Me.SpellShieldBonus}") end)
    mq.bind("/avoidance", function() mq.cmd("/noparse /dgaexecute all /dgtell all AVOIDANCE ${Me.AvoidanceBonus}/100") end)
    mq.bind("/stunresist", function() mq.cmd("/noparse /dgaexecute all /dgtell all STUN RESIST ${Me.StunResistBonus}") end)

    -- "free inventory slots": only lists melees as looter classes for minimal disruption
    mq.bind("/fis", function()
        mq.cmd("/noparse /dgaexecute all /if (${Select[${Me.Class.ShortName},MNK,ROG,BER,RNG]} && ${Me.FreeInventory} > 20) /dgtell all FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- "free inventory slots all"
    mq.bind("/fisa", function()
        mq.cmd("/noparse /dgaexecute all /if (${Me.FreeInventory} > 20) /dgtell all FREE INVENTORY SLOTS: ${Me.FreeInventory}")
    end)

    -- report all with few free inventory slots
    mq.bind("/fewinventoryslots", function()
        mq.cmd("/noparse /dgaexecute all /if (${Me.FreeInventory} <= 20) /dgtell all FULL INVENTORY, ${Me.FreeInventory} FREE SLOTS")
    end)


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
            cmd("/lua stop efyran/combine")
        end
        cmd("/lua run efyran/combine")
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

    -- auto banks items from tradeskills.ini
    mq.bind("/autobank", function() commandQueue.Add("autobank") end)

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
    mq.bind("/cohgroup", function() mq.cmd("/lua run efyran/cohgroup") end)

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

    -- track XP
    local xpGain = function(text)
        local aaDiff = mq.TLO.Me.PctAAExp() - currentAAXP
        log.Info("Gained XP. AA %d %%", aaDiff)
        currentAAXP = mq.TLO.Me.PctAAExp()

        if in_raid() then
            return
        end

        if not in_group() then
            all_tellf("\agI got solo Exp (%d %% AA)", aaDiff)
        elseif is_group_leader() then

            all_tellf("\agMy group got Exp (%d %% AA)", aaDiff)
        end
    end

    mq.event("xp1", "You gain experience!", xpGain)
    mq.event('xp2', 'You gain party experience!!', xpGain)
    --mq.event("xp3", "You gained raid experience!", xpGain)

    mq.event("ding", "You have gained a level! Welcome to level #1#!", function(text, level)
        all_tellf("\agDing L%d", level)
    end)

    mq.event("dingAA", "You have gained an ability point#*#", function(text)
        if mq.TLO.Me.AAPoints() <= 1 or mq.TLO.Me.AAPoints() >= 100 then
            return
        end
        all_tellf("\agDing AA - %d unspent", mq.TLO.Me.AAPoints())
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

    QoL.verifySpellLines()
end

function QoL.loadRequiredPlugins()
    local requiredPlugins = {
        "MQ2DanNet",
        "MQ2Debuffs", -- XXX not used yet. to be used for auto-cure feature
        "MQ2MoveUtils",
        "MQ2Cast",

        "MQ2AdvPath", -- XXX /afollow or /stick ?
        -- XXX which follow mode to use?
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

local qolClearCursorTimer = timer.new_expired(60 * 1) -- 60s

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

    -- auto skill-up Sense Heading
    if skill_value("Sense Heading") < skill_cap("Sense Heading") and is_ability_ready("Sense Heading") then
        --log.Info("Training Sense Heading")
        cmd('/doability "Sense Heading"')
        delay(100)
    end

    if class_shortname() == "WIZ" and have_pet() then
        cmd("/pet get lost")
    end

    if mq.TLO.Me.TributeActive() and not (zone_shortname() == "anguish" or zone_shortname() == "tacvi") then
        all_tellf("\arTRIBUTE WAS ACTIVE IN %s, TURNING OFF!", zone_shortname())
        disable_tribute()
    end

    if qolClearCursorTimer:expired() then
        clear_cursor()
        qolClearCursorTimer:restart()
    end

end

return QoL
