local commandQueue = require('e4_CommandQueue')

local function execute()
    ae_rez()
end

-- Rezzes nearby player corpses
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


bind("/aerez", createCommand)
