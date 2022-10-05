local mq = require("mq")
local log = require("knightlinc/Write")

local aliases = require("settings/Spell Aliases")

local Follow = {
    spawn = nil, -- the current spawn I am following
}

function Follow.Init()

    -- tell everyone else to click nearby door/object (pok stones, etc)
    mq.bind("/clickit", function()

        -- XXX spawn check if door within X radius
        cmd("/doortarget")
        log.Info("CLICKING NEARBY DOOR %s, id %d", mq.TLO.DoorTarget.Name(), mq.TLO.DoorTarget.ID())

        if is_orchestrator() then
            cmd("/dgzexecute /clickit")
        else
            unflood_delay()
            cmd("/click left door")
        end
    end)

    mq.bind("/followon", function()
        cmdf("/dgzexecute /followid %d", mq.TLO.Me.ID())
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        Follow.Pause()
        Follow.spawn = nil
    end)

    -- follows another peer in LoS
    ---@param spawnID integer
    mq.bind("/followid", function(spawnID)
        if not is_peer_id(spawnID) then
            cmdf("/dgtell all ERROR: /followid called on invalid spawn ID %d", spawnID)
            return
        end

        Follow.spawn = spawn_from_id(spawnID)
    end)

    mq.bind("/portto", function(name)
        name = name:lower()
        if is_orchestrator() then
            cmdf("/dgzexecute /portto %s", name)
        end

        local spellName
        if class_shortname() == "WIZ" then
            spellName = aliases.Wizard["port " .. name]
        elseif class_shortname() == "DRU" then
            spellName = aliases.Druid["port " .. name]
        else
            return
        end

        cmdf("/dgtell all Porting to %s (%s)", name, spellName)
        unflood_delay()

        if spellName == nil then
            cmdf("/dgtell all ERROR: no such port %s", name)
        end

        wait_until_not_casting()
        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
        wait_until_not_casting()
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
    ---@param spawnID integer
    mq.bind("/movetoid", function(spawnID)
        if is_orchestrator() then
            cmdf("/dgzexecute /movetoid %d", spawnID)
        end

        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            cmdf("/dgtell all No such spawn ID %d", spawnID)
            return
        end
        move_to(spawn)
    end)

    -- run through zone based on the position of startingPeer
    -- stand near a zoneline and face in the direction of the zoneline, run command for bots to move forward to the other zone
    mq.bind("/rtz", function(startingPeer)

        if is_orchestrator() then
            -- tell the others to cross zone line
            cmdf("/dgzexecute /rtz %s", mq.TLO.Me.Name())
            return
        end

        unflood_delay()

        -- run across (need pos + heading from orchestrator)
        local spawn = spawn_from_peer_name(startingPeer)
        if spawn == nil then
            cmdf("/dgtell all ERROR: /rtz requested from peer not found: %s", startingPeer)
            return
        end

        local oldZone = zone_shortname()
        log.Info("MOVING THRU ZONE FROM %s", oldZone)

        cmd("/stick off")

        -- move to initial position
        move_to(spawn)

        if not is_within_distance(spawn, 15) then
            -- unlikely
            cmdf("/dgtell all /rtz ERROR: failed to move near %s, my distance is %f", spawn.Name(), spawn.Distance())
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
            cmdf("/dgtell all ERROR failed to run across zone line in %s", oldZone)
            cmd("/beep 1")
        end
    end)

    -- hail or talk to nearby recognized NPC
    mq.bind("/hailit", function()
        PerformHail()
    end)

    -- tells all peers to hail or talk to nearby recognized NPC
    mq.bind("/hailall", function()
        if is_orchestrator() then
            cmd("/dgzexecute /hailit")
        end
        PerformHail()
    end)
end

function Follow.Pause()
    if mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    end

    --cmd("/afollow off")
    --cmd("/stick off")
end

local lastHeading = ""

-- TODO LATER: allow toggle which nav module to use: MQ2Nav, MQ2AdvPath, MQ2MoveUtils
-- MQ2Nav:   cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
-- MQ2AdvPath: cmdf("/afollow spawn %d", Follow.spawn.ID())
-- MQ2MoveUtils: cmdf("/target id %d", Follow.spawn.ID())       cmd("/stick hold 15 uw") -- face upwards to better run over obstacles

-- called from QoL.Tick() on every tick
function Follow.Update()
    if Follow.spawn == nil then
        return
    end

    if Follow.spawn.Distance3D() > Follow.spawn.MaxRangeTo() then
        if not mq.TLO.Navigation.Active() then
            cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
        elseif lastHeading ~= Follow.spawn.HeadingTo() then
            cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
            lastHeading = Follow.spawn.HeadingTo()
        end
    end
end

return Follow
