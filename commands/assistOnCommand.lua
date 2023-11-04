local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local log          = require("knightlinc/Write")
local assist       = require("lib/assisting/Assist")

local bci = broadCastInterfaceFactory()

---@class KillItCommand
---@field Sender string Peer name
---@field SpawnId integer
---@field Filter string

---@param command KillItCommand
local function execute(command)
    if not is_peer_in_zone(command.Sender) then
        log.Info("Ignoring KillIt command, sender \ay%s\ax is not in zone !", command.Sender)
        return
    end
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
    local spawnName = ""
    if spawnID == nil then
        spawnID = mq.TLO.Target.ID()
        spawnName = mq.TLO.Target.Name()
    end
    spawn = spawn_from_id(spawnID)

    if spawn == nil or spawn() == nil or spawn.Type() == "PC" then
        log.Warn("GIVING UP ASSIST CALL ON %s %s, filter %s", tostring(spawnID), spawnName, tostring(filter))
        return
    end

    local exe = string.format("/killit %s %d", mq.TLO.Me.Name(), spawn.ID())
    if filter ~= nil then
        exe = exe .. " " .. filter
    end

    bci.ExecuteAllCommand(exe)
    commandQueue.Enqueue(function() execute({ Sender = mq.TLO.Me.Name(), SpawnId = toint(spawn.ID()), Filter = filter }) end)
end

---@param sender string Name of sender peer
---@param mobID integer
---@param ... string
local function createKillItCommand(sender, mobID, ...)
    if is_gm() then
        return
    end

    local filter = args_string(...)
    commandQueue.Enqueue(function() execute({ Sender = sender, SpawnId = toint(mobID), Filter = filter }) end)
end

bind("/killit", createKillItCommand)
bind("/assiston", createAssistOnCommand)
