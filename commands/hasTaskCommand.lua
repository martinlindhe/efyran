local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

---@class HasTaskCommand
---@field Name string

---@param command HasTaskCommand
local function execute(command)
    if mq.TLO.Task(command.Name).Index() ~= nil then
        all_tellf("Has task \ag%s\ax", mq.TLO.Task(command.Name).Title())
    else
        --all_tellf("Dont have task \ar%s\ax", command.Name)
    end
end

local function createCommand(...)
    local name = args_string(...)
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/listtasks %s", name))
    end

    commandQueue.Enqueue(function() execute({ Name = name }) end)
end

bind("/hastask", createCommand)
