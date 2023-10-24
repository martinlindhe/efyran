local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local log          = require("knightlinc/Write")
local assist       = require("lib/assisting/Assist")

local bci = broadCastInterfaceFactory()

---@class KillItCommand
---@field SpawnId integer
---@field Filter string

---@param command KillItCommand
local function execute(command)
    local filter = command.Filter
    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("Not matching filter, giving up: %s", filter)
        return
    end

    local spawn = spawn_from_id(command.SpawnId)
    if spawn == nil or (spawn.Type() ~= "NPC" and spawn.Type() ~= "Pet") then
        return
    end

    if spawn.Distance() > 400 then
        log.Error("Wont attack, too far away %f", spawn.Distance())
        return
    end

    -- if already killing something, enqueue existing target and start killing new one
    if assist.IsAssisting() then
        if command.SpawnId == assist.targetID then
            return
        end

        log.Info("got told to kill but already on target, ending current fight")
        assist.EndFight()
    end

    log.Debug("Killing %s, type %s", spawn.DisplayName(), spawn.Type())
    assist.handleAssistCall(spawn)
end

local function createAssistOnCommand(...)
    local filter = args_string(...)
    local spawnID = nil
    local tokens = split_str(filter, "/")
    if #tokens == 2 then
        --log.Info("assiston: splitting filter into two: %s    AND   %s", tokens[1], tokens[2])
        if string.len(tokens[1]) > 0 then
            spawnID = trim(tokens[1])
            filter = "/" .. tokens[2]
            --log.Info("assiston: updating filter to '%s'", filter)
        end
    end

    local spawn = nil
    if spawnID == nil then
        spawnID = mq.TLO.Target.ID()
    end
    spawn = spawn_from_id(spawnID)

    if spawn == nil or spawn() == nil or spawn.Type() == "PC" then
        log.Warn("GIVING UP ASSIST CALL ON %s, filter %s", tostring(spawnID), tostring(filter))
        return
    end

    local exe = string.format("/killit %d", spawn.ID())
    if filter ~= nil then
        exe = exe .. " " .. filter
    end

    bci.ExecuteZoneCommand(exe)
    commandQueue.Enqueue(function() execute({ SpawnId = toint(spawn.ID()), Filter = filter }) end)
end

local function createKillItCommand(mobID, ...)
    if is_gm() then
        return
    end

    local filter = args_string(...)
    commandQueue.Enqueue(function() execute({ SpawnId = toint(mobID), Filter = filter }) end)
end

bind("/killit", createKillItCommand)
bind("/assiston", createAssistOnCommand)
