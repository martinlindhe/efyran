local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

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

mq.bind("/dropinvis", createCommand)
