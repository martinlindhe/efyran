local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local buffs   = require("e4_Buffs")

local bci = broadCastInterfaceFactory()

---@class BuffItCommand
---@field SpawnId number

---@param command BuffItCommand
local function execute(command)
    buffs.BuffIt(command.SpawnId)
end

local function createCommand()
    local spawnId = mq.TLO.Target.ID()
    if not spawnId or spawnId == 0 then
        return
    end

    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/buffit %d", spawnId))
    end

    commandQueue.Enqueue(function() execute({SpawnId = spawnId}) end)
end

bind("/buffit", createCommand)
bind("/buffme", function()
    bci.ExecuteZoneCommand(string.format("/buffit %d", mq.TLO.Me.ID()))
end)
