local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('commandQueue')

local function execute()
    count_peers()
end

-- Peer proximity count
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/count", createCommand)
mq.bind("/cnt", createCommand)
