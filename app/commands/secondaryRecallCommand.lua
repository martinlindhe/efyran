local mq = require("mq")
local commandQueue = require('app/commandQueue')

local function execute()
    if is_alt_ability_ready("Secondary Recall") then
        use_alt_ability("Secondary Recall")
    elseif have_alt_ability("Secondary Recall") then
        all_tellf("ERROR: \arSecondary Recall not ready\ax (in %s)", mq.TLO.Me.AltAbilityTimer("Secondary Recall").TimeHMS())
    end
end

local function createCommand(peer, filter)
    if is_orchestrator() then
        cmdf("/dgzexecute /secondaryrecall")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/teleportbind", createCommand)
mq.bind("/tlbind", createCommand)
