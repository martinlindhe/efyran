local mq = require("mq")
local log = require("knightlinc/Write")
local globalSettings = require("e4_Settings")

local Follow = {
    spawn = nil, -- the current spawn I am following
}

function Follow.Stop()
    if globalSettings.followMode:lower() == "mq2nav" and mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        cmd("/afollow off")
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        cmd("/stick off")
    end
    Follow.spawn = nil
end

-- called from QoL.Tick() on every tick
function Follow.Update()
    local exe = ""
    if Follow.spawn ~= nil and Follow.spawn.Distance3D() > Follow.spawn.MaxRangeTo() then
        if globalSettings.followMode:lower() == "mq2nav" then
            if not mq.TLO.Navigation.MeshLoaded() then
                all_tellf("MISSING NAVMESH FOR %s", zone_shortname())
                return
            end
            if not mq.TLO.Navigation.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
                exe = string.format("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
                lastHeading = Follow.spawn.HeadingTo()
            end
        elseif globalSettings.followMode:lower() == "mq2advpath" then
            if not mq.TLO.AdvPath.Following() or lastHeading ~= Follow.spawn.HeadingTo() then
                exe = string.format("/afollow spawn %d", Follow.spawn.ID())
            end
        elseif globalSettings.followMode:lower() == "mq2moveutils" then
            --if not mq.TLO.Stick.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
                cmdf("/target id %d", Follow.spawn.ID())
                exe = string.format("/stick hold 15 uw") -- face upwards to better run over obstacles
                --exe = string.format("/moveto id %d", Follow.spawn.ID())
            --end
        end
    end
    if exe ~= "" then
        log.Info("Follow.Update: %s", exe)
        cmd(exe)
    end
end

---@param startingPeer string peer name
function Follow.RunToZone(startingPeer)
    unflood_delay()

    -- run across (need pos + heading from orchestrator)
    local spawn = spawn_from_peer_name(startingPeer)
    if spawn == nil then
        all_tellf("ERROR: /rtz requested from peer not found: %s", startingPeer)
        return
    end

    local oldZone = zone_shortname()
    log.Info("MOVING THRU ZONE FROM %s", oldZone)

    cmd("/stick off")

    -- move to initial position
    move_to(spawn.ID())

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
end

return Follow
