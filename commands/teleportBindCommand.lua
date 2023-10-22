local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    if is_alt_ability_ready("Teleport Bind") then
        use_alt_ability("Teleport Bind")
    elseif have_alt_ability("Teleport Bind") then
        all_tellf("ERROR: \arTeleport Bind not ready\ax (in %s)", mq.TLO.Me.AltAbilityTimer("Teleport Bind").TimeHMS())
    end
end

local function createCommand(peer, filter)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/teleportbind")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/teleportbind", createCommand)
bind("/tlbind", createCommand)
