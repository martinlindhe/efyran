local mq = require("mq")
local log = require("knightlinc/Write")
local commandQueue = require("lib/CommandQueue")
local loot = require("lib/looting/Loot")

local cantLoot = false
mq.event("cannot-loot", "You may not loot this corpse at this time.", function(line)
    cantLoot = true
end)

-- loot up several  nearby corpses at once
local function execute()
    local seekRadius = 60
    local maxTries = 50

    local tries = 0

    -- reset state when starting over
    cantLoot = false

    while true do
        local count = spawn_count(string.format("npccorpse zradius 50 radius %d", seekRadius))
        if count == 0 then
            log.Debug("/doloot: Finished looting area!")
            break
        end
        if tries >= maxTries or cantLoot then
            log.Info("/doloot: Giving up, %d corpse nearby, try %d, cantLoot %s", count, tries, tostring(cantLoot))
            break
        end
        if not loot.LootNearestCorpse(seekRadius) then
            log.Debug("/doloot: Giving up, lootNearestCorpse failed. %d corpse nearby, try %d", count, tries)
        end
        tries = tries + 1
        mq.doevents()
    end
end

local function createLootAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/doloot", createLootAllCommand)

