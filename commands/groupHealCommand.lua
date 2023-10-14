local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local buffGroups = require("e4_BuffGroups")

local bci = broadCastInterfaceFactory()

local function execute()
    for _, groupHeal in pairs(buffGroups.CLR.GroupHeals) do
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
