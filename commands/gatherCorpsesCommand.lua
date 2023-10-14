local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local log          = require("knightlinc/Write")

local function execute()
    consent_me()
    local spawnQuery = 'pccorpse radius 100'
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn.Distance() > 20 then
            log.Info("Gathering corpse %s", spawn.Name())
            target_id(spawn.ID())
            delay(10)
            --if is_peer(spawn.DisplayName()) then
            --    cmdf("/dexecute %s /consent %s", spawn.DisplayName(), mq.TLO.Me.Name())
            --    delay(100)
            --end
            cmd("/corpse")
            delay(1000, function() return spawn() ~= nil and spawn.Distance() < 20 end)
        end
    end
end

-- summon nearby corpses into a pile
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/gathercorpses", createCommand)
