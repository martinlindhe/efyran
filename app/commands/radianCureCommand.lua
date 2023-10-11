local commandQueue = require('app/commandQueue')
local log          = require("efyran/knightlinc/Write")

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
        mq.cmd("/dgzexecute /rc")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- auto cure target (usage: is requested by another toon)
mq.bind("/rc", createCommand)
