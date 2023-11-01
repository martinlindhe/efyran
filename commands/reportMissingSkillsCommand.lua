local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local log          = require("knightlinc/Write")

local bci = broadCastInterfaceFactory()

local classSkills = {
    ROG = {
        "Sneak",
        "Hide",
        "Dodge",
        "Pick Lock",
        "Pick Pockets",
        "Sense Traps",
        "Disarm Traps",
        "Safe Fall",
        "Backstab",
        "Parry",
        "Dual Wield",
        "Double Attack",            -- L16
        "Instill Doubt",            -- L22
        "Disarm",                   -- L27
        "Riposte",                  -- L30
    },
    MNK = {
        "Dodge",
        "Safe Fall",
        "Dual Wield",
        "Kick",
        "Mend",
        "Sneak",
        "Throwing",
        "Round Kick",
        "Tiger Claw",
        "Block",
        "Double Attack",
        "Feign Death",
        "Intimidation",
        "Eagle Strike",             -- L20
        -- XXX Dragon Punch / Tail Rake  -- L25
        "Disarm",                   -- L27
        "Flying Kick",              -- L30
        "Riposte",                  -- L35
    },
    BRD = {
        "Singing",
        "Percussion Instruments",   -- L05
        "Stringed Instruments",     -- L08
        "Brass Instruments",        -- L11
        "Wind Instruments",         -- L14
        "Meditate",                 -- L10
        "Dodge",
        "Dual Wield",
        "Intimidation",
        "Parry",
        "Riposte",
        "Sneak",
        "Sense Traps",
        "Safe Fall",
        "Hide",
        "Disarm Traps",
        "Tracking",
        "Pick Lock",
    },
    PAL = {
        "Meditate",                 -- L12
        "Taunt",                    -- L01
        "Bash",                     -- L06
        "Dodge",                    -- L10
        "Parry",                    -- L17
        "Double Attack",            -- L20
        "Riposte",                  -- L30
        "Disarm",                   -- L40
    },
}

local function execute()
    local skills = classSkills[class_shortname()]
    if skills == nil then
        all_tellf("TODO add class skills for %s", class_shortname())
        return
    end

    local missing = ""

    for _, skill in pairs(skills) do
        log.Info("Checking for %s", skill)
        if not have_skill(skill) then
            missing = missing .. ", " .. skill
        end
    end
    if missing ~= "" then
        all_tellf("Missing skills: %s", missing)
    end
end

local function createCommand()
    if is_orchestrator() then
        --bci.ExecuteAllCommand("/reportskills")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/reportskills", createCommand)
