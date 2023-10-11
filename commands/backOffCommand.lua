local mq = require("mq")
local commandQueue = require('commandQueue')
local log          = require("efyran/knightlinc/Write")
local assist       = require("efyran/e4_Assist")

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
        local exe = "/dgzexecute /backoff"
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
    end

    commandQueue.Enqueue(function() execute({ Filter = filter }) end)
end

mq.bind("/backoff", createCommand)
