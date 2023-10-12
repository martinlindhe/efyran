local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local buffs   = require("e4_Buffs")

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
        cmdf("/dgzexecute /buffit %d", spawnId)
    end

    commandQueue.Enqueue(function() execute({SpawnId = spawnId}) end)
end

mq.bind("/buffit", createCommand)
mq.bind("/buffme", function()
    cmdf("/dgzexecute /buffit %d", mq.TLO.Me.ID())
end)
