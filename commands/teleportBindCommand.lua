local mq = require("mq")
local commandQueue = require('commandQueue')

local function execute()
    if is_alt_ability_ready("Teleport Bind") then
        use_alt_ability("Teleport Bind")
    elseif have_alt_ability("Teleport Bind") then
        all_tellf("ERROR: \arTeleport Bind not ready\ax (in %s)", mq.TLO.Me.AltAbilityTimer("Teleport Bind").TimeHMS())
    end
end

local function createCommand(peer, filter)
    if is_orchestrator() then
        cmdf("/dgzexecute /teleportbind")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/teleportbind", createCommand)
mq.bind("/tlbind", createCommand)
