local mq = require("mq")
local commandQueue = require("CommandQueue")
local log          = require("knightlinc/Write")

---@class MassGroupBuffCommand
---@field Name string

---@param command MassGroupBuffCommand
local function execute(command)
    if not have_spell(command.Name) and not have_alt_ability(command.Name) then
        all_tellf("FATAL: I cannot mgb this, dont have it: %s", command.Name)
        return
    end

    if in_neutral_zone() then
        all_tellf("MGB: Skipping MGB %s in neutral zone", command.Name)
        return
    end

    cast_mgb_spell(command.Name)
end

local function createCommand(name)
    commandQueue.Enqueue(function() execute({Name = name}) end)
end

-- MGB CLR Celestial Regeneration
bind("/aecr", function() createCommand("Celestial Regeneration") end)

-- MGB DRU Spirit of the Wood
bind("/aesow",  function() createCommand("Spirit of the Wood") end)
bind("/aesotw", function() createCommand("Spirit of the Wood") end)

-- MGB SHM Ancestral Aid
bind("/aeaa", function() createCommand("Ancestral Aid") end)

-- MGB DRU Flight of Eagles
bind("/aefoe", function() createCommand("Flight of Eagles") end)

-- MGB NEC Dead Men Floating
bind("/aedmf", function() createCommand("Dead Men Floating") end)

-- MGB ENC Rune of Rikkukin
bind("/aerr", function() createCommand("Rune of Rikkukin") end)

-- MGB BST Paragon of Spirit
bind("/aepos", function() createCommand("Paragon of Spirit") end)

-- MGB RNG Auspice of the Hunter
bind("/aeaoh",  function() createCommand("Auspice of the Hunter") end)
bind("/aeaoth", function() createCommand("Auspice of the Hunter") end)
