local mq = require("mq")
local log = require("knightlinc/Write")
local timer = require("lib/Timer")

local serverSettings = require("lib/settings/default/ServerSettings")

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
    if serverSettings.followMode:lower() == "mq2nav" and not mq.TLO.Navigation.MeshLoaded() then
        all_tellf("MQ2Nav: MISSING NAVMESH FOR %s. Rebuild with MeshGenerator.exe and reload MQ2Nav plugin", zone_shortname())
        return
    end

    if not is_peer(spawnName) then
        all_tellf("\arERROR: /followplayer failed: %s is not a peer. Giving up", spawnName)
        Follow.Stop()
        return
    end
    local spawn = spawn_from_peer_name(spawnName)
    if spawn == nil then
        return
    end
    if serverSettings.followMode:lower() == "mq2advpath" and not force and not spawn.LineOfSight() then
        all_tellf("I cannot see [+r+]%s[+x+]", spawn.Name())
        return
    end

    if serverSettings.followMode:lower() == "mq2advpath" and spawn.Distance() > 500 then
        all_tellf("Too far away to [+r+]%s[+x+]: %d", spawn.Name(), spawn.Distance())
        return
    end

    if not is_standing() then
        cmd("/stand")
    end

    if mq.TLO.Me.Rooted() then
        all_tellf("WARN: I am [+r+]rooted[+x+], following when I can!")
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
    end
    Follow.Pause()
end

-- Resumes following a peer if we was following
function Follow.Resume()
    if is_feigning() then
        cmd("/stand")
    end
    if Follow.lastFollowName ~= "" then
        Follow.Start(Follow.lastFollowName, true)
        Follow.lastFollowName = ""
    end
end

-- pause follow for now, in all possible ways
function Follow.Pause()
    if is_plugin_loaded("MQ2Nav") and mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    end
    if is_plugin_loaded("MQ2AdvPath") and mq.TLO.AdvPath.Following() then
        cmd("/afollow off")
    end
    if is_plugin_loaded("MQ2MoveUtils") and mq.TLO.Stick.Active() then
        cmd("/stick off")
    end
    if is_plugin_loaded("MQ2MoveUtils") and mq.TLO.MoveTo.Moving() then
        cmd("/moveto off")
    end
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

-- called from Follow.Tick() in main loop, restores auto follow after a Follow.Pause() call
---@param force boolean
function Follow.Update(force)
    if Follow.spawnName == "" then
        return
    end

    local spawn = spawn_from_peer_name(Follow.spawnName)
    if spawn == nil or spawn() == nil then
        -- happens when following a toon across zoneline and the toon has yet to zone
        log.Warn("Follow update fail on %s", Follow.spawnName)
        return
    end
    local spawnID = spawn.ID()
    if spawnID == nil or spawnID == 0 then
        return
    end

    local maxRange = 5 -- spawn.MaxRangeTo()

    --log.Debug("Follow.Update, mode %s, distance %f", serverSettings.followMode, spawn.Distance3D())

    if serverSettings.followMode:lower() == "mq2nav" then
        if not mq.TLO.Navigation.Active() and spawn.Distance() > 10 then
            log.Info("Follow.Update: Navigate to %s activated", Follow.spawnName)
            mq.cmdf("/nav spawn PC =%s | distance=%d log=trace", spawn.Name(), maxRange)
        end
    elseif serverSettings.followMode:lower() == "mq2advpath" then
        if mq.TLO.AdvPath.WaitingWarp() then
            force = true
            all_tellf("AdvPath: WaitingWarp - force follow")
        end
        if force or not mq.TLO.AdvPath.Following() then
            mq.cmdf("/afollow spawn %d", spawnID)
        end
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

    if spawn.Distance() > 200 then
        all_tellf("ERROR: /rtz requested from peer out of range: %d", spawn.Distance())
        return
    end

    local oldZone = zone_shortname()
    log.Info("MOVING THRU ZONE FROM %s", oldZone)

    if not is_standing() then
        cmd("/stand")
    end

    if is_casting() then
        cmd("/interrupt")
    end

    Follow.Pause()

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

    if spawn == nil or spawn() == nil then
        all_tellf("RTZ: lost spawn, giving up")
        return
    end

    -- face the same direction the orchestrator is facing
    cmdf("/squelch /face fast heading %f", spawn.Heading.Degrees() * -1)

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
