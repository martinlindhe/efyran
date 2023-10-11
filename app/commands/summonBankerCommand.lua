local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('app/commandQueue')

local function execute()
    local aaName = "Summon Clockwork Banker"
    if is_alt_ability_ready(aaName) then
        use_alt_ability(aaName, nil)
        return
    end

    log.Warn(aaName.." is not ready. Ready in "..mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())

    if not is_orchestrator() then
        return
    end

    ask_nearby_peer_to_activate_aa(aaName)
end

-- cast Summon Clockwork Banker veteran AA yourself, or the first available nearby peer
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/banker", createCommand)
