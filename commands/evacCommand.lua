local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    cast_evac_spell()
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/evac")
    end

    -- clear queue so that evac happens next
    commandQueue.Clear()
    commandQueue.Enqueue(function() execute() end)
end

bind("/evac", createCommand)
