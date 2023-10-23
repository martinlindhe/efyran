local mq = require("mq")
local log = require("knightlinc/Write")
local commandQueue = require("CommandQueue")
local lootNearestCorpse = require("lib/looting/lootNearestCorpse")

-- loot up several  nearby corpses at once
local function execute()
    local seekRadius = 100
    local maxTries = 50

    local tries = 0

    while true do
        local count = spawn_count(string.format("npccorpse zradius 50 radius %d", seekRadius))
        if count == 0 or tries >= maxTries then
            log.Info("/doloot: Giving up, %d corpse nearby, try %d", count, tries)
            break
        end

        lootNearestCorpse(seekRadius)
        tries = tries + 1
    end
end

local function createLootAllCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.unbind('/doloot')
mq.bind("/doloot", createLootAllCommand)

