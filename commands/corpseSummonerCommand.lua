local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    use_corpse_summoner()
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/usecorpsesummoner")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/usecorpsesummoner", createCommand)
