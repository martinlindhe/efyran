local mq = require("mq")
local commandQueue = require("lib/CommandQueue")
local sellItems = require("lib/looting/sell")

local function execute()
    sellItems()
end

local function createSellAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/dosell", createSellAllCommand)

