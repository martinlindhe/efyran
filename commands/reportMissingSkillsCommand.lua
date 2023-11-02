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
        "Dragon Punch",             -- L25, shows as Tail Rake for Iksars
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
        "Taunt",                    -- L01
        "Bash",                     -- L06
        "Dodge",                    -- L10
        "Meditate",                 -- L12
        "Parry",                    -- L17
        "Double Attack",            -- L20
        "Specialize Alteration",    -- L30
        "Riposte",                  -- L30
        "Disarm",                   -- L40
    },
    SHD = {
        "Taunt",                    -- L01
        "Bash",                     -- L06
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Parry",                    -- L17
        "Double Attack",            -- L20
        "Specialize Alteration",    -- L30
        "Riposte",                  -- L30
        "Disarm",                   -- L40
    },
    RNG = {
        "Taunt",                    -- L01
        "Kick",                     -- L05
        "Dodge",                    -- L08
        "Meditate",                 -- L12
        "Dual Wield",               -- L17
        "Parry",                    -- L18
        "Double Attack",            -- L20
        "Specialize Alteration",    -- L30
        "Disarm",                   -- L35
        "Riposte",                  -- L35
        "Tracking",                 -- L01
        "Forage",                   -- L03
        "Sneak",                    -- L10
        "Hide",                     -- L25
    },
    WAR = {
        "Kick",                     -- L01
        "Slam",                     -- L01
        "Taunt",                    -- L01
        "Bash",                     -- L06
        "Dodge",                    -- L06
        "Parry",                    -- L10
        "Dual Wield",               -- L13
        "Double Attack",            -- L15
        "Riposte",                  -- L25
        "Disarm",                   -- L35
    },
    CLR = {
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Specialize Alteration",    -- L30
    },
    DRU = {
        "Forage",                   -- L05
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Tracking",                 -- L20
        "Specialize Alteration",    -- L30
    },
    SHM = {
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Specialize Alteration",    -- L30
    },
    WIZ = {
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Specialize Alteration",    -- L20
    },
    MAG = {
        "Meditate",                 -- L08
        "Dodge",                    -- L22
        "Specialize Alteration",    -- L20
    },
    ENC = {
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Specialize Alteration",    -- L20
    },
    NEC = {
        "Meditate",                 -- L08
        "Dodge",                    -- L15
        "Specialize Alteration",    -- L20
    },
    BST = {
        "Kick",                     -- L05
        "Dodge",                    -- L10
        "Meditate",                 -- L12
        "Dual Wield",               -- L17
        "Block",                    -- L25
        "Riposte",                  -- L40
    },
    BER = {
        "Kick",                     -- L01
        "Frenzy",                   -- L06
        "Dodge",                    -- L10
        "Parry",                    -- L10
        "Double Attack",            -- L15
        "Riposte",                  -- L25
        "Disarm",                   -- L35
    },
}

local function execute()
    local class = class_shortname()
    local skills = classSkills[class]
    if skills == nil then
        all_tellf("UNLIKELY: class skills missing for %s", class)
        return
    end

    local missing = ""

    for _, skill in pairs(skills) do
        --log.Debug("Checking for %s", skill)
        if not have_skill(skill) then
            missing = skill .. ", " .. missing
        end
    end
    if missing ~= "" then
        all_tellf("Missing skills (%s): %s", class, missing)
    end
end

local function createCommand()
    if is_orchestrator() then
        bci.ExecuteAllCommand("/missingskills")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/missingskills", createCommand)
