local mq = require("mq")
local commandQueue = require('e4_commandQueue')

local function execute()
    loot_my_corpse()
end

-- Ask peer owners of nearby corpses to consent me
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

-- tell peers to attempt to loot their corpses
local function createLootAllCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /lootmycorpse")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/lootmycorpse", createCommand)
mq.bind("/lootallcorpses", createLootAllCommand)

