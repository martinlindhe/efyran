local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

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
        bci.ExecuteZoneCommand("/lootmycorpse")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/lootmycorpse", createCommand)
bind("/lootallcorpses", createLootAllCommand)

