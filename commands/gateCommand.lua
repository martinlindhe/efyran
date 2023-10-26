local mq = require("mq")
local commandQueue = require("lib/CommandQueue")
local log          = require("knightlinc/Write")

local function execute()

    if not is_caster() or not is_priest() then
        log.Error("My class %s don't have the Gate spell, aborting", class_shortname())
        return
    end

    if not have_spell("Gate") then
        log.Error("Cannot Gate, I don't have Gate in spell book")
        return
    end

    clear_cursor(true)

    if is_sitting() then
        cmd("/stand")
    end

    all_tellf("Gating to bind ...")
    castSpell("Gate")
end

-- casts Gate
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/gate", createCommand)
