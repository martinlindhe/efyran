local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

---@class TeleportToCommand
---@field ZoneName string

---@param command TeleportToCommand
local function execute(command)
    cast_port_to(command.ZoneName)
end

local function createCommand(name)
    name = name:lower()
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/portto %s", name))
    end

    commandQueue.Enqueue(function() execute({ZoneName = name}) end)
end


bind("/portto", createCommand)
