local mq = require("mq")
local commandQueue = require('app/commandQueue')
local bard    = require("efyran/Class_Bard")

---@class PlayMelodyCommand
---@field Name string

---@param command PlayMelodyCommand
local function execute(command)
    bard.PlayMelody(command.Name)
end

local function createCommand(name)
  if not name then
    all_tellf("<name> param is not set.")
    return nil
  end

  if is_orchestrator() then
    cmdf("/dgexecute brd /playmelody %s", name)
  end

  if is_brd() then
    commandQueue.Enqueue(function() execute({ Name = name }) end)
  end
end

mq.bind("/playmelody", createCommand)
