local mq = require("mq")
local commandQueue = require('app/commandQueue')

---@class DropBuffCommand
---@field Filter string

---@param command DropBuffCommand
local function execute(command)
    if command.Filter == nil then
        return
    end
    if is_orchestrator() then
        cmdf("/dgzexecute /dropbuff %s", command.Filter)
    end

    if command.Filter == "all" then
        drop_all_buffs()
    else
        cmdf('/removebuff "%s"', command.Filter)
    end
end

local function createCommand(filter)
    commandQueue.Enqueue(function() execute({Filter = filter}) end)
end

mq.bind("/dropbuff", createCommand)