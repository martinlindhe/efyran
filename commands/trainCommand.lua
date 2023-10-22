local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

local trainers = {
    language = require 'commands/train/language',
}

---@class TrainCommand
---@field Skill string

---@param command TrainCommand
local function execute(command)
    local trainer = trainers[command.Skill]
    if trainer == nil then
        all_tellf("ERROR: /train unhandled skill %s", command.Skill)
        return
    end
    trainer()
end

local function createCommand(name)
    name = name:lower()
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/train %s", name))
    end
    commandQueue.Enqueue(function() execute({Skill = name}) end)
end

bind("/train", createCommand)
