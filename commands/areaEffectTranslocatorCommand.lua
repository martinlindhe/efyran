local commandQueue = require("CommandQueue")

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
bind("/aetl", createCommand)
