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
    if not mq.TLO.Navigation.MeshLoaded() then
        all_tellf("MQ2Nav: MISSING NAVMESH FOR %s. Rebuild with MeshGenerator.exe and reload MQ2Nav plugin", zone_shortname())
        return
    end

    if not is_peer(spawnName) then
        all_tellf("ERROR: /folloplayer failed: %s is not a peer", spawnName)
        cmd("/beep")
        -- fixed by unload+reload mq2dannet, or zone, or relog
        return
    end
    local spawn = spawn_from_peer_name(spawnName)
    if spawn == nil then
        return
    end
    if not force and not spawn.LineOfSight() then
        all_tellf("I cannot see \ar%s\ax", spawn.Name())
        return
    end

    if spawn.Distance() > 500 then
        all_tellf("Too far away to \ar%s\ax: %d", spawn.Name(), spawn.Distance())
        return
    end


    if Follow.IsFollowing() then
        Follow.Pause()
    end

    log.Debug("Follow start on %s", spawn.Name())
    Follow.spawnName = spawn.Name()
    Follow.Update(true)
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
    if is_plugin_loaded("MQ2Nav") and mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    end
    if is_plugin_loaded("MQ2AdvPath") then
        cmd("/afollow off")
    end
    if is_plugin_loaded("MQ2MoveUtils") then
        cmd("/stick off")
    end
    cmd("/moveto off")
end

-- stops following completely
function Follow.Stop()
    Follow.spawnName = ""
    Follow.lastFollowName = ""
    Follow.Pause()
end

local followUpdateTimer = timer.new_expired(1 * 1) -- 1s

function Follow.Tick()
    if not followUpdateTimer:expired() then
        return
    end
    Follow.Update(false)
    followUpdateTimer:restart()
end

local lastHeading = ""

-- called from Follow.Tick() in main loop, restores auto follow after a Follow.Pause() call
---@param force boolean
function Follow.Update(force)
    if Follow.spawnName == "" then
        return
    end

    local spawn = spawn_from_peer_name(Follow.spawnName)
    if spawn == nil then
        -- happens when following a toon across zoneline and the toon has yet to zone
        log.Warn("Follow update fail on %s", Follow.spawnName)
        return
    end

    local exe = ""
    local maxRange = 5 -- spawn.MaxRangeTo()

    --log.Debug("Follow.Update, mode %s, distance %f", globalSettings.followMode, spawn.Distance3D())
    if globalSettings.followMode:lower() == "mq2nav" then
        if mq.TLO.Navigation.Active() then
            mq.cmd("/nav stop")
            delay(10)
        end
        exe = string.format("/nav spawn PC =%s | distance=%d log=trace", spawn.Name(), maxRange)
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        if mq.TLO.AdvPath.WaitingWarp() then
            force = true
            all_tellf("AdvPath: WaitingWarp - force follow")
        end

        if force or not mq.TLO.AdvPath.Following() then
            exe = string.format("/afollow spawn %d", spawn.ID())
        end
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        exe = string.format("/stick hold %d uw", maxRange) -- face upwards to better run over obstacles
    end

    if exe ~= "" then
        --if not force and spawn.Distance() < 8 then
        --    log.Info("XXX skip follow update, we are nearby!")
        --    return
        --end
        log.Info("XXX follow update: %s", exe)
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

    if not is_within_distance(spawn, 10) then
        -- move to initial position
        move_to(spawn.ID())
        delay(600)
    end

    if not is_within_distance(spawn, 18) then
        -- unlikely
        all_tellf("/rtz ERROR: failed to move near %s, my distance is %f", spawn.Name(), spawn.Distance())
        return
    end

    unflood_delay()

    Follow.Pause()

    -- face the same direction the orchestrator is facing
    cmdf("/face fast heading %f", spawn.Heading.Degrees() * -1)

    -- move forward
    cmd("/keypress forward hold")
    delay(5000, function()
        return zone_shortname() ~= oldZone
    end)

    if zone_shortname() == oldZone then
        -- return to starting peer
        move_to(spawn.ID())
        delay(4000)

        if zone_shortname() ~= oldZone then
            return true
        end

        all_tellf("ERROR failed to run across zone line in %s", oldZone)
        cmd("/beep 1")

    end
end

return Follow
