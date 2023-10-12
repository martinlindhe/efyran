local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    if have_alt_ability("Mass Group Buff") then
        if not is_alt_ability_ready("Mass Group Buff") then
            all_tellf("\arMass Group Buff is not available...\ax Ready in %s", mq.TLO.Me.AltAbilityTimer("Mass Group Buff").TimeHMS())
        else
            all_tellf("\agMass Group Buff is ready!\ax")
        end
    end
end

local function createCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /mgbready")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/mgbready", createCommand)
