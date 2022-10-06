--local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")
local bard = require("Class_Bard")
local assist  = require("e4_Assist")
local aliases = require("settings/Spell Aliases")

---@class CommandQueueValue
---@field public Name string Name
---@field public Arg string Argument

local CommandQueue = {
    ---@type CommandQueueValue[]
    queue = {},
}

---@param name string
---@param arg? string optional argument
function CommandQueue.Add(name, arg)
    table.insert(CommandQueue.queue, {
        ["Name"] = name,
        ["Arg"] = arg,
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
    elseif v.Name == "dropinvis" then
        drop_invis()
    elseif v.Name == "playmelody" then
        bard.PlayMelody(v.Arg)
    elseif v.Name == "buffit" then
        local spawnID = v.Arg
        log.Debug("Handling /buffit request for spawn %s", spawnID)

        local spawn = spawn_from_query("id "..spawnID)
        if spawn == nil then
            all_tellf("BUFFIT FAIL, cannot find spawn ID %d in %s", spawnID, zone_shortname())
            return false
        end

        local level = spawn.Level()

        for key, buffs in pairs(botSettings.settings.group_buffs) do
            log.Debug("/buffit on %s, type %s, finding best group buff %s", spawn, type(spawn), key)

            -- XXX find the one with highest MinLevel
            local minLevel = 0
            local spellName = ""
            if type(buffs) ~= "table" then
                all_tellf("FATAL ERROR, buffdata %s should be a table", buffs)
                return
            end

            for k, buff in pairs(buffs) do
                local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
                local n = tonumber(spellConfig.MinLevel)
                if n == nil then
                    all_tellf("FATAL ERROR, group buff %s does not have a MinLevel setting", buff)
                    return
                end
                if n > minLevel and level >= n then
                    minLevel = n
                    spellName = spellConfig.Name
                    local spell = get_spell(spellName)
                    if spell == nil then
                        all_tellf("FATAL ERROR cant lookup %s", spellName)
                        return
                    end
                    if is_spell_in_book(spellName) then
                        spellName = spell.RankName()
                        if not spell.StacksTarget() then
                            all_tellf("ERROR cannot buff %s with %s (dont stack with current buffs)", spawn.Name(), spellName)
                            return
                        end
                    end

                    log.Debug("Best %s buff so far is MinLevel %d, Name %s, target L%d %s", key, spellConfig.MinLevel, spellConfig.Name, level, spawn.Name())
                end
            end

            if minLevel > 0 then
                if spellConfigAllowsCasting(spellName, spawn) then
                    all_tellf("Buffing \ag%s\ax with %s (%s)", spawn.Name(), spellName, key)
                    castSpellRaw(spellName, spawnID, "-maxtries|3")

                    -- sleep for the Duration
                    local spell = getSpellFromBuff(spellName)
                    if spell ~= nil then
                        delay(3000 + spell.MyCastTime() + spell.RecastTime()) -- XXX 3s for "memorize spell". need a better "memorize if needed and wait while memorizing"-helper
                    end
                end
            else
                log.Error("Failed to find a matching group buff %s, target L%d %s", key, level, spawn.Name())
            end
        end
    elseif v.Name == "killit" then
        local spawn = spawn_from_id(v.Arg)
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
                        local spellName = spellConfig.Name
                        if is_spell_in_book(spellConfig.Name) then
                            local spell = get_spell(spellConfig.Name)
                            if spell ~= nil then
                                spellName = spell.RankName()
                            end
                        end
                        castSpell(spellName, mq.TLO.Me.ID())
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
        PerformHail()
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
                castSpell(rez, spawn.ID())
                break
            else
                all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax. %d/3", spawn.Name(), i)
            end
            doevents()
            delay(2000) -- 2s delay
        end
    else
        all_tellf("ERROR unknown command in queue: %s", v.Name)
    end
end

return CommandQueue
