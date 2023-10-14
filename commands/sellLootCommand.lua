local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local sellItems = require 'looting/sell'

local function execute()
    sellItems()
end

local function createLootAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.unbind('/doloot')
mq.bind("/doloot", createLootAllCommand)

