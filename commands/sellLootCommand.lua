local mq = require("mq")

local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local commandQueue = require("lib/CommandQueue")

local sellItems = require("lib/looting/sell")

local function execute()
    sellItems()
end

local function createSellAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/dosell", createSellAllCommand)

mq.bind("/sellall", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/dosell")
    end
    createSellAllCommand()
end)
