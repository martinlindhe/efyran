local mq = require("mq")
local log          = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

---@class MoveToPeerCommand
---@field Peer string
---@field Filter string

---@param command MoveToPeerCommand
local function execute(command)
    local filter = command.Filter
    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("movetopeer: Not matching filter, giving up: %s", filter)
        return
    end
    local spawn = spawn_from_peer_name(command.Peer)
    if spawn ~= nil then
        move_to(spawn.ID())
    end
end

-- move to spawn ID
---@param peer string Peer name
---@param ... string|nil filter, such as "/only|ROG"
local function createCommand(peer, ...)
    local filter = args_string(...)
    commandQueue.Enqueue(function() execute({Peer = peer, Filter = filter}) end)
end

bind("/movetopeer", createCommand)


---@param ... string|nil filter, such as "/only|ROG"
local movetome = function(...)
    local exe = string.format("/movetopeer %s", mq.TLO.Me.Name())
    local filter = args_string(...)
    if filter ~= nil then
        exe = exe .. " " .. filter
    end
    bci.ExecuteZoneCommand(exe)
end

bind("/movetome", movetome)
bind("/mtm", movetome)
