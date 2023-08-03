local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local globalSettings = require("efyran/e4_Settings")

local Follow = {
    -- the current spawn I am following
    ---@type string
    spawnName = "",

    -- the spawn I was following, auto resume follow this after a fight
    ---@type string
    lastFollowName = "",
}

-- Starts to follow another player (usually the orchestrator)
---@param spawnName string
---@param force boolean
function Follow.Start(spawnName, force)
    if not is_peer(spawnName) then
        all_tellf("ERROR: /folloplayer called on invalid spawn %s", spawnName)
        return
    end
    local spawn = spawn_from_peer_name(spawnName)
    if spawn == nil then
        return
    end
    if not force and not spawn.LineOfSight() then
        all_tellf("I cannot see %s", spawn.Name())
        return
    end
    log.Debug("Follow start on %s", spawn.Name())
    Follow.spawnName = spawn.Name()
    Follow.Update()
end

--- Returns true if I am in follow mode
---@return boolean
function Follow.IsFollowing()
    return Follow.spawnName ~= "" or Follow.lastFollowName ~= ""
end

function Follow.PauseForKill()
    Follow.lastFollowName = ""
    if Follow.spawnName ~= "" then
        Follow.lastFollowName = Follow.spawnName
        Follow.spawnName = ""
        Follow.Pause()
    end
end

function Follow.ResumeAfterKill()
    if Follow.lastFollowName ~= "" then
        Follow.Start(Follow.lastFollowName, true)
        Follow.lastFollowName = ""
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
    Follow.spawnName = ""
    Follow.lastFollowName = ""
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
    if Follow.spawnName == "" then
        return
    end

    local spawn = spawn_from_peer_name(Follow.spawnName)
    if spawn == nil then
        all_tellf("ERROR: follow update fail on %s", Follow.spawnName)
        return
    end

    local exe = ""
    local maxRange = 10 -- spawn.MaxRangeTo()

    log.Debug("Follow.Update, mode %s, distance %f", globalSettings.followMode, spawn.Distance3D())
    if globalSettings.followMode:lower() == "mq2nav" then
        if not mq.TLO.Navigation.MeshLoaded() then
            all_tellf("MISSING NAVMESH FOR %s", zone_shortname())
            return
        end
        if not mq.TLO.Navigation.Active() or lastHeading ~= spawn.HeadingTo() then
            exe = string.format("/nav id %d | dist=%d log=critical", spawn.ID(), maxRange)
            lastHeading = spawn.HeadingTo()
        end
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        if not mq.TLO.AdvPath.Following() or lastHeading ~= spawn.HeadingTo() then
            exe = string.format("/afollow spawn %d", spawn.ID())
        end
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        --if not mq.TLO.Stick.Active() or lastHeading ~= spawn.HeadingTo() then
            mq.cmdf("/target id %d", spawn.ID())
            exe = string.format("/stick hold %d uw", maxRange) -- face upwards to better run over obstacles
            --exe = string.format("/moveto id %d", spawn.ID())
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

    if not is_within_distance(spawn, 18) then
        -- unlikely
        all_tellf("/rtz ERROR: failed to move near %s, my distance is %f", spawn.Name(), spawn.Distance())
        return
    end

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
