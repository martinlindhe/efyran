local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")
local log          = require("knightlinc/Write")
local assist       = require("assisting/Assist")

local bci = broadCastInterfaceFactory()

---@class BackOffCommand
---@field Filter string

---@param command BackOffCommand
local function execute(command)
    if command.Filter ~= nil and not matches_filter(command.Filter, mq.TLO.Me.Name()) then
        log.Info("BACKOFF: Not matching filter, giving up: %s", command.Filter)
        return
    end
    assist.backoff()
end

local function createCommand(...)
    local filter = args_string(...)
    if is_orchestrator() then
        local exe = "/backoff"
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end

    commandQueue.Enqueue(function() execute({ Filter = filter }) end)
end

bind("/backoff", createCommand)
