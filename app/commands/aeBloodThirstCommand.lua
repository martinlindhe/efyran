local mq = require("mq")
local commandQueue = require('app/commandQueue')

local function execute()
    cast_ae_bloodthirst()
end

-- MGB BER Bloodthirst
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/aebloodthirst", createCommand)
