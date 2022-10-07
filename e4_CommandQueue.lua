local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")
local hail = require("e4_Hail")
local buffs   = require("e4_Buffs")
local bard = require("Class_Bard")
local assist  = require("e4_Assist")
local pet     = require("e4_Pet")
local group   = require("e4_Group")
local aliases = require("settings/Spell Aliases")

---@class CommandQueueValue
---@field public Name string Name
---@field public Arg string Argument
---@field public Arg2 string Second argument

local CommandQueue = {
    ---@type CommandQueueValue[]
    queue = {},
}

---@param name string
---@param arg? string optional argument
---@param arg2? string optional argument
function CommandQueue.Add(name, arg, arg2)
    table.insert(CommandQueue.queue, {
        ["Name"] = name,
        ["Arg"] = arg,
        ["Arg2"] = arg2,
    })
end

function CommandQueue.Remove(name)
    local idx = -1

    for k, v in pairs(CommandQueue.queue) do
        if v.Name == name then
            idx = k
        end
    end

    if idx ~= -1 then
        table.remove(CommandQueue.queue, idx)
    end
end

---@return CommandQueueValue|nil
function CommandQueue.PeekFirst()
    for k, v in pairs(CommandQueue.queue) do
        return v
    end
    return nil
end

function CommandQueue.Process()
    --log.Debug("CommandQueue.Process()")

    local v = CommandQueue.PeekFirst()
    if v == nil then
        return
    end

    log.Info("Performing command %s", v.Name)

    CommandQueue.Remove(v.Name)

    if v.Name == "joingroup" then
        wait_until_not_casting()
        cmd("/squelch /target clear")
        delay(100)
        cmd("/squelch /invite")
    elseif v.Name == "joinraid" then
        wait_until_not_casting()
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
        cmd("/squelch /raidaccept")
    elseif v.Name == "zoned" then
        pet.ConfigureTaunt()

        joinCurrentHealChannel()
        memorizeListedSpells()
        buffs.AnnounceAvailablity()
    elseif v.Name == "dropinvis" then
        drop_invis()
    elseif v.Name == "playmelody" then
        bard.PlayMelody(v.Arg)
    elseif v.Name == "buffit" then
        buffs.BuffIt(toint(v.Arg))
    elseif v.Name == "killit" then
        local spawn = spawn_from_id(toint(v.Arg))
        if spawn == nil then
            return
        end
        if spawn.Type() ~= "PC" then
            if assist.target ~= nil then
                log.Debug("Backing off existing target before assisting new")
                assist.backoff()
            end
            log.Debug("Killing %s, type %s", spawn.DisplayName(), spawn.Type())
            assist.handleAssistCall(spawn)
        end
    elseif v.Name == "pbaeon" then
        local nearbyPBAEilter = "npc radius 50 zradius 50 los"

        if spawn_count(nearbyPBAEilter) == 0 then
            all_tellf("Ending PBAE. No nearby mobs.")
            return
        end

        memorizePBAESpells()

        all_tellf("PBAE ON")
        while true do
            -- TODO: break this loop with /pbaeoff
            if spawn_count(nearbyPBAEilter) == 0 then
                all_tellf("Ending PBAE. No nearby mobs.")
                break
            end

            if not is_casting() then
                for k, spellRow in pairs(botSettings.settings.assist.pbae) do
                    local spellConfig = parseSpellLine(spellRow)
                    if is_spell_ready(spellConfig.Name) then
                        log.Info("Casting PBAE spell %s", spellConfig.Name)
                        castSpellAbility(mq.TLO.Me, spellRow)
                    end

                    doevents()
                    delay(50)
                end
            end
        end
    elseif v.Name == "shrinkgroup" then
        -- find the shrink clicky/spell if we got one
        local shrinkClicky = nil
        local spellConfig
        for key, buff in pairs(botSettings.settings.self_buffs) do
            spellConfig = parseSpellLine(buff)
            if spellConfig.Shrink ~= nil and spellConfig.Shrink then
                shrinkClicky = buff
                break
            end
        end

        if shrinkClicky == nil or not in_group() then
            log.Error("No Shrink clicky declared in self_buffs, giving up.")
            return
        end

        local item = find_item(spellConfig.Name)
        if item == nil then
            all_tellf("\arERROR\ax: Did not find Shrink clicky in inventory: %s", spellConfig.Name)
            return
        end
        log.Info("Shrinking group members with %s", item.ItemLink("CLICKABLE")())

        -- make sure shrink is targetable check buff type
        local spell = getSpellFromBuff(spellConfig.Name)
        if spell ~= nil and (spell.TargetType() == "Single" or spell.TargetType() == "Group v1") then
            -- loop over group, shrink one by one starting with yourself
            for n = 0, 5 do
                for i = 1, 3 do
                    if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                        log.Info("Shrinking member %s from height %d", mq.TLO.Group.Member(n)(), mq.TLO.Group.Member(n).Height())
                        castSpell(spellConfig.Name, mq.TLO.Group.Member(n).ID())
                        -- sleep for the Duration
                        delay(item.Clicky.CastTime() + spell.RecastTime())
                    end
                end
            end
        end
    elseif v.Name == "clickit" then
        -- XXX check if door within X radius
        cmd("/doortarget")
        log.Info("CLICKING NEARBY DOOR %s, id %d", mq.TLO.DoorTarget.Name(), mq.TLO.DoorTarget.ID())

        if is_orchestrator() then
            cmd("/dgzexecute /clickit")
        else
            unflood_delay()
            cmd("/click left door")
        end
    elseif v.Name == "portto" then
        local name = v.Name
        local spellName
        if class_shortname() == "WIZ" then
            spellName = aliases.Wizard["port " .. name]
        elseif class_shortname() == "DRU" then
            spellName = aliases.Druid["port " .. name]
        else
            return
        end

        all_tellf("Porting to %s (%s)", name, spellName)
        unflood_delay()

        if spellName == nil then
            all_tellf("ERROR: no such port %s", name)
        end

        wait_until_not_casting()
        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
        wait_until_not_casting()
    elseif v.Name == "movetoid" then
        local spawnID = toint(v.Arg)
        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            all_tellf("ERROR: No such spawn ID %d", spawnID)
            return
        end
        move_to(spawn)
    elseif v.Name == "rtz" then
        local startingPeerName = v.Arg
        unflood_delay()

        -- run across (need pos + heading from orchestrator)
        local spawn = spawn_from_peer_name(startingPeerName)
        if spawn == nil then
            all_tellf("ERROR: /rtz requested from peer not found: %s", startingPeerName)
            return
        end

        local oldZone = zone_shortname()
        log.Info("MOVING THRU ZONE FROM %s", oldZone)

        cmd("/stick off")

        -- move to initial position
        move_to(spawn)

        if not is_within_distance(spawn, 15) then
            -- unlikely
            all_tellf("/rtz ERROR: failed to move near %s, my distance is %f", spawn.Name(), spawn.Distance())
            return
        end

        -- face the same direction the orchestrator is facing
        cmdf("/face fast heading %f", spawn.Heading.Degrees() * -1)
        delay(5)

        -- move forward
        cmd("/keypress forward hold")
        delay(6000, function()
            local zoned = zone_shortname() ~= oldZone
            if zoned then
                log.Info("I ZONED INTO %s", zone_shortname())
            end
            return zoned
        end)

        if zone_shortname() == oldZone then
            all_tellf("ERROR failed to run across zone line in %s", oldZone)
            cmd("/beep 1")
        end
    elseif v.Name == "hailit" then
        hail.PerformHail()
    elseif v.Name == "recallgroup" then
        group.RecallGroup(v.Arg, v.Arg2)
    elseif v.Name == "rezit" then
        local spawnID = toint(v.Arg)
        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            -- unlikely
            all_tellf("ERROR: tried to rez spawnid %s which is not in zone %s", spawnID, zone_shortname())
            return
        end
        log.Info("Performing rez on %s, %d %s", spawn.Name(), spawnID, type(spawnID))

        -- try 3 times to get a rez spell before giving up (to wait for ability to become ready...)
        for i = 1, 3 do
            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                all_tellf("Rezzing \ag%s\ax with \ay%s\ax. %d/3", spawn.Name(), rez, i)
                castSpellAbility(spawn, rez)
                break
            else
                all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax. %d/3", spawn.Name(), i)
            end
            doevents()
            delay(2000) -- 2s delay
        end
    elseif v.Name == "aerez" then
        local spawnQuery = 'pccorpse radius 100'
        local corpses = spawn_count(spawnQuery)

        all_tellf("AERez started in %s (%d corpses) ...", zone_shortname(), corpses)
        wait_until_not_casting()

        for i = 1, corpses do
            ---@type spawn
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            if spawn ~= nil and spawn ~= "NULL" then
                log.Info("Trying to rez %s", spawn.Name())
                target_id(spawn.ID())

                local rez = get_rez_spell_item_aa()
                if rez ~= nil then
                    if spawn ~= nil then
                        all_tellf("Rezzing %s with %s", spawn.Name(), rez)
                        castSpellRaw(rez, spawn.ID())
                        delay(3000)
                        wait_until_not_casting()
                    end
                else
                    all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax.", spawn.Name())
                end
            end
            doevents()
            delay(12000)
        end
        log.Info("AEREZ ENDING")
    else
        all_tellf("ERROR unknown command in queue: %s", v.Name)
    end
end

return CommandQueue
