local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local globalSettings = require("efyran/e4_Settings")

local Follow = {
    spawn = nil, -- the current spawn I am following
    lastFollowID = 0, -- the spawn I was following, auto resume follow this after a fight
}

-- Starts to follow spawn ID (usually the orchestrator)
---@param spawnID integer
---@param force boolean
function Follow.Start(spawnID, force)
    if not is_peer_id(spawnID) then
        all_tellf("ERROR: /followid called on invalid spawn ID %d", spawnID)
        return
    end
    local spawn = spawn_from_id(spawnID)
    if spawn == nil then
        return
    end
    if not force and not spawn.LineOfSight() then
        all_tellf("I cannot see %s", spawn.Name())
        return
    end
    log.Debug("Follow start on %d %s", spawnID, spawn.Name())
    Follow.spawn = spawn
    Follow.Update()
end

--- Returns true if I am in follow mode
---@return boolean
function Follow.IsFollowing()
    return Follow.spawn ~= nil or Follow.lastFollowID ~= 0
end

function Follow.PauseForKill()
    Follow.lastFollowID = 0
    if Follow.spawn ~= nil then
        Follow.lastFollowID = Follow.spawn.ID()
        Follow.spawn = nil
        Follow.Pause()
    end
end

function Follow.ResumeAfterKill()
    if Follow.lastFollowID ~= 0 then
        Follow.Start(Follow.lastFollowID, true)
        Follow.lastFollowID = 0
    end
end

-- pause follow for the moment
function Follow.Pause()
    if globalSettings.followMode:lower() == "mq2nav" then
        cmd("/nav stop")
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        cmd("/afollow off")
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        cmd("/stick off")
    else
        all_tellf("FATAL followMode unhandled '%s'", globalSettings.followMode:lower())
    end
end

-- stops following completely
function Follow.Stop()
    Follow.spawn = nil
    Follow.lastFollowID = 0
    Follow.Pause()
end

local followUpdateTimer = timer.new_expired(15 * 1) -- 15s

function Follow.Tick()
    if followUpdateTimer:expired() then
        if globalSettings.followMode:lower() == "mq2moveutils" then
            -- don't update for mq2advpath / mq2nav as they will get confused
            Follow.Update()
        end
        followUpdateTimer:restart()
    end
end

local lastHeading = ""

-- called from Follow.Tick() in main loop, restores auto follow after a Follow.Pause() call
function Follow.Update()
    -- XXX fixme Follow.spawn is invalid after zoning, use PC name instead
    if Follow.spawn == nil then
        return
    end

    local exe = ""
    local maxRange = 10 -- Follow.spawn.MaxRangeTo()

    log.Debug("Follow.Update, mode %s, distance %f", globalSettings.followMode, Follow.spawn.Distance3D())
    if globalSettings.followMode:lower() == "mq2nav" then
        if not mq.TLO.Navigation.MeshLoaded() then
            all_tellf("MISSING NAVMESH FOR %s", zone_shortname())
            return
        end
        if not mq.TLO.Navigation.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
            exe = string.format("/nav id %d | dist=%d log=critical", Follow.spawn.ID(), maxRange)
            lastHeading = Follow.spawn.HeadingTo()
        end
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        if not mq.TLO.AdvPath.Following() or lastHeading ~= Follow.spawn.HeadingTo() then
            exe = string.format("/afollow spawn %d", Follow.spawn.ID())
        end
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        --if not mq.TLO.Stick.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
            mq.cmdf("/target id %d", Follow.spawn.ID())
            exe = string.format("/stick hold %d uw", maxRange) -- face upwards to better run over obstacles
            --exe = string.format("/moveto id %d", Follow.spawn.ID())
        --end
    end

    if exe ~= "" then
        log.Info("Follow.Update: %s", exe)
        mq.cmd(exe)
    end
end

---@param startingPeer string peer name
function Follow.RunToZone(startingPeer)
    -- run across (need pos + heading from orchestrator)
    local spawn = spawn_from_peer_name(startingPeer)
    if spawn == nil then
        all_tellf("ERROR: /rtz requested from peer not found: %s", startingPeer)
        return
    end

    local oldZone = zone_shortname()
    log.Info("MOVING THRU ZONE FROM %s", oldZone)

    Follow.Stop()

    -- move to initial position
    move_to(spawn.ID())

    if not is_within_distance(spawn, 16) then
        -- unlikely
        all_tellf("/rtz ERROR: failed to move near %s, my distance is %f", spawn.Name(), spawn.Distance())
        return
    end

    Follow.Pause()

    -- face the same direction the orchestrator is facing
    cmdf("/face fast heading %f", spawn.Heading.Degrees() * -1)

    unflood_delay()

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
