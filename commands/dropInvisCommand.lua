local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    drop_invis()
end

local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/dropinvis")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/dropinvis", createCommand)
