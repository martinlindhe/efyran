local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    local s = ""
    for i = 1, 29 do
        if mq.TLO.Task(i).Title() ~= "" then
            s = s .. string.format("%d:%s,", i, mq.TLO.Task(i).Title())
        end
    end
    if s ~= "" then
        all_tellf("Tasks: %s", s)
    end
end

local function createCommand(...)
    local name = args_string(...)
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/listtasks %s", name))
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/listtasks", createCommand)
