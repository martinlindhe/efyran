local mq = require("mq")
local commandQueue = require('e4_commandQueue')
local groupBuffs = require("efyran/e4_GroupBuffs")

local function execute()
    for _, groupHeal in pairs(groupBuffs.GroupHealSpells) do
        if is_spell_ready(groupHeal) then
            all_tellf("Casting group heal \ag%s\ax ...", groupHeal)
            castSpellRaw(groupHeal, nil)
            return
        end
    end
end

local function createCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /groupheal")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/groupheal", createCommand)
