local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local sellItems = require 'looting/sell'

local function execute()
    sellItems()
end

local function createSellAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.unbind('/dosell')
mq.bind("/dosell", createSellAllCommand)

