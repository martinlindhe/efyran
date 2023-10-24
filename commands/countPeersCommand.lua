local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("lib/CommandQueue")

local function execute()
    count_peers()
end

-- Peer proximity count
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/count", createCommand)
bind("/cnt", createCommand)
