local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

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
        bci.ExecuteZoneCommand("/mgbready")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/mgbready", createCommand)
