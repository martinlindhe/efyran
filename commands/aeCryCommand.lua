local commandQueue = require("lib/CommandQueue")

local function execute()
    cast_ae_cry()
end

-- MGB BER war cry
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


bind("/aecry", createCommand)
