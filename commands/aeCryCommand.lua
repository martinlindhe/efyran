local mq = require("mq")
local commandQueue = require('commandQueue')

local function execute()
    cast_ae_cry()
end

-- MGB BER war cry
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/aecry", createCommand)
