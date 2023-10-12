local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

local function execute()
    count_peers()
end

-- Peer proximity count
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/count", createCommand)
mq.bind("/cnt", createCommand)
