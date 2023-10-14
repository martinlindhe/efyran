local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local spellGroups = require("e4_SpellGroups")

local bci = broadCastInterfaceFactory()

local function execute()
    for _, groupHeal in pairs(spellGroups.CLR.GroupHeals) do
        if is_spell_ready(groupHeal) then
            all_tellf("Casting group heal \ag%s\ax ...", groupHeal)
            castSpellRaw(groupHeal, nil)
            return
        end
    end
end

local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/groupheal")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/groupheal", createCommand)
