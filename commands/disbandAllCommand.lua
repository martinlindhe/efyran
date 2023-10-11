local mq = require("mq")
local commandQueue = require('commandQueue')

local function execute()
    disband_all_peers()
end

local function createCommand()
    commandQueue.Enqueue(execute)
end

mq.bind("/disbandall", createCommand)
