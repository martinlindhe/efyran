local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local hail    = require("e4_Hail")

local bci = broadCastInterfaceFactory()

local function execute()
    hail.PerformHail()
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

local function createHailAllCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/hailit")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- hail or talk to nearby recognized NPC
mq.bind("/hailit", createCommand)

-- tells all peers to hail or talk to nearby recognized NPC
mq.bind("/hailall", createHailAllCommand)
