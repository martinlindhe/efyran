local mq = require("mq")
local commandQueue = require('e4_commandQueue')

local function execute()
    ae_rez()
end

-- Rezzes nearby player corpses
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/aerez", createCommand)
