local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local bard    = require("Class_Bard")

local bci = broadCastInterfaceFactory()

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
    bci.ExecuteCommand(string.format("/playmelody %s", name), {"brd"})
  end

  if is_brd() then
    commandQueue.Enqueue(function() execute({ Name = name }) end)
  end
end

bind("/playmelody", createCommand)
