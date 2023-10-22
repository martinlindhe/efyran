local mq = require("mq")
local commandQueue = require("CommandQueue")
local lootNearestCorpse = require 'looting/lootNearestCorpse'

local function execute()
    lootNearestCorpse()
end

local function createLootAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.unbind('/doloot')
mq.bind("/doloot", createLootAllCommand)

