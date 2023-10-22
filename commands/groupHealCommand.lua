local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")
local spellGroups = require("lib/spells/SpellGroups")

local bci = broadCastInterfaceFactory()

-- the first spell in list that is memorized and not on cooldown will be used
local function execute()
    for _, groupHeal in pairs(spellGroups.CLR.clr_group_heal) do
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
