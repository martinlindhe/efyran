local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    if is_alt_ability_ready("Secondary Recall") then
        use_alt_ability("Secondary Recall")
    elseif have_alt_ability("Secondary Recall") then
        all_tellf("ERROR: \arSecondary Recall not ready\ax (in %s)", mq.TLO.Me.AltAbilityTimer("Secondary Recall").TimeHMS())
    end
end

local function createCommand(peer, filter)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/secondaryrecall")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/secondaryrecall", createCommand)
