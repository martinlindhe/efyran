local mq = require("mq")
local log          = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

local function execute()
    if not have_alt_ability("Radiant Cure") then
        return
    end
    if is_alt_ability_ready("Radiant Cure") then
        all_tellf("\agRadiant Cure inc ...\ax")
        use_alt_ability("Radiant Cure")
    else
        all_tellf("Radiant Cure is \arready in %s\ax", mq.TLO.Me.AltAbilityTimer("Radiant Cure").TimeHMS())
    end
end

local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/rc")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- auto cure target (usage: is requested by another toon)
bind("/rc", createCommand)
