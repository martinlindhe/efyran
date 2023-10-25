local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local bard    = require("lib/classes/Bard")

local bci = broadCastInterfaceFactory()

---@class PlayMelodyCommand
---@field Name string

---@param command PlayMelodyCommand
local function execute(command)
    if not is_brd() then
        return
    end
    all_tellf("Playing melody [+y+]%s[+x+]", command.Name)
    bard.PlayMelody(command.Name)
end

local function createCommand(name)
  if not name then
    all_tellf("<name> param is not set.")
    return nil
  end

  if is_orchestrator() then
    bci.ExecuteZoneCommand(string.format("/playmelody %s", name))
  end

  if is_brd() then
    commandQueue.Enqueue(function() execute({ Name = name }) end)
  end
end

bind("/playmelody", createCommand)
