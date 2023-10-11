local mq = require("mq")
local commandQueue = require('e4_commandQueue')

local function execute()
    castSpellAbility(nil, "Teleport")
end

local function createCommand()
    if not is_wiz() then
        return
    end

    commandQueue.Enqueue(function() execute() end)
end

    -- wiz: cast AE TL spell
mq.bind("/aetl", createCommand)
