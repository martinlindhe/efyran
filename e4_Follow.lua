local mq = require("mq")

local Follow = {
    spawn = nil, -- the current spawn I am following
}

function Follow.Init()

    -- tell everyone else to click nearby door/object (pok stones, etc)
    mq.bind("/clickit", function(name)

        -- XXX spawn check if door within X radius
        cmd("/doortarget")
        print("CLICKING NEARBY DOOR ", mq.TLO.DoorTarget.Name(), " id ", mq.TLO.DoorTarget.ID())

        if is_orchestrator() then
            cmd("/dgzexecute /clickit")
        else
            unflood_delay()
            cmd("/click left door")
        end
    end)

    mq.bind("/followon", function()
        cmd("/dgzexecute /followid "..mq.TLO.Me.ID())
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            cmd("/dgzexecute /followoff")
        end
        Follow.Pause()
        Follow.spawn = nil
    end)

    -- follows another peer in LoS
    mq.bind("/followid", function(spawnID)
        if not is_peer_id(spawnID) then
            cmd("/dgtell all ERROR: /followid called on invalid spawn ID "..spawnID)
            return
        end

        if is_spawn_los(spawnID) then
            Follow.spawn = spawn_from_id(spawnID)
            Follow.Resume()
        else
            cmd("/dgtell all Spawn "..spawnID.." is not in LoS")
        end
    end)

    mq.bind("/portto", function(name)
        name = name:lower()
        if is_orchestrator() then
            cmd("/dgzexecute /portto "..name)
        end

        local spellName
        if class_shortname() == "WIZ" then
            spellName = aliases.Wizard["port " .. name]
        elseif class_shortname() == "DRU" then
            spellName = aliases.Druid["port " .. name]
        else
            return
        end

        cmd("/dgtell all Porting to " .. name .. " (" .. spellName .. ")")
        unflood_delay()

        if spellName == nil then
            cmd("/dgtell all ERROR: no such port "..name)
        end

        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
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
            print("finding available evac spell ", key, ": ", evac)
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
        cmd("/dgzexecute /movetoid "..mq.TLO.Me.ID())
    end
    mq.bind("/movetome", moveToMe)
    mq.bind("/mtm", moveToMe)

    -- move to spawn ID
    mq.bind("/movetoid", function(spawnID)
        if is_orchestrator() then
            cmd("/dgzexecute /movetoid "..spawnID)
        end

        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            cmd("/dgtell all No such spawn ID "..spawnID)
            return
        end
        move_to(spawn)
    end)

    -- run through zone based on the position of startingPeer
    -- stand near a zoneline and face in the direction of the zoneline, run command for bots to move forward to the other zone
    mq.bind("/rtz", function(startingPeer)

        if is_orchestrator() then
            -- tell the others to cross zone line
            cmd("/dgzexecute /rtz "..mq.TLO.Me.Name())
            return
        end

        unflood_delay()

        -- run across (need pos + heading from orchestrator)
        local spawn = spawn_from_peer_name(startingPeer)
        if spawn == nil then
            cmd("/dgtell all ERROR: /rtz requested from peer not found: "..startingPeer)
            return
        end

        local oldZone = zone_shortname()
        print("MOVING THRU ZONE FROM ", oldZone)

        cmd("/stick off")

        -- move to initial position
        move_to(spawn)

        if not is_within_distance(spawn, 15) then
            -- unlikely
            cmd("/dgtell all /rtz ERROR: failed to move near "..spawn.Name()..", my distance is "..spawn.Distance())
            return
        end

        -- face the same direction the orchestrator is facing
        cmd("/face fast heading "..tostring(spawn.Heading.Degrees() * -1))
        delay(5)

        -- move forward
        cmd("/keypress forward hold")
        delay(6000, function()
            local zoned = zone_shortname() ~= oldZone
            if zoned then
                print("I ZONED INTO ", zone_shortname())
            end
            return zoned
        end)

        if zone_shortname() == oldZone then
            cmd("/dgtell all ERROR failed to run across zone line in "..oldZone)
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
    cmd("/afollow off")
    --cmd("/stick off")
end

function Follow.Resume()
    if Follow.spawn == nil then
        return
    end
    cmd("/afollow spawn "..Follow.spawn.ID())

    --cmd("/target id "..Follow.spawn.ID())
    --cmd("/stick hold 15 uw") -- face upwards to better run over obstacles
end

return Follow
