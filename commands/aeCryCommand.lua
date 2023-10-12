local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    cast_ae_cry()
end

-- MGB BER war cry
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/aecry", createCommand)
