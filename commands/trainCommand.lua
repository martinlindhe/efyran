local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

local trainLanguage = require 'commands/train/language'

local trainers = {
    language = trainLanguage,
}

---@class TrainCommand
---@field Skill string

---@param command TrainCommand
local function execute(command)
    log.Info("XXX train skill %s", command.Skill)

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
