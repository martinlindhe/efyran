local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

local alcoholTrainer      = require("commands/train/alcohol")
local begTrainer          = require("commands/train/begging")
local feignTrainer        = require("commands/train/feign")
local hideAndSneakTrainer = require("commands/train/hide")
local languageTrainer     = require("commands/train/language")
local songTrainer         = require("commands/train/songs")
local spellTrainer        = require("commands/train/spells")

local trainers = {
    alc = alcoholTrainer,
    alcohol = alcoholTrainer,
    beg = begTrainer,
    begging = begTrainer,
    fd = feignTrainer,
    feign = feignTrainer,
    hide = hideAndSneakTrainer,
    lang = languageTrainer,
    language = languageTrainer,
    languages = languageTrainer,
    mend = feignTrainer,
    sneak = hideAndSneakTrainer,
    song = songTrainer,
    songs = songTrainer,
    spell = spellTrainer,
    spells = spellTrainer,
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
