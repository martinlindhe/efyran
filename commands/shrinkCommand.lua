local mq = require("mq")
local log          = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local botSettings = require("lib/settings/BotSettings")

local bci = broadCastInterfaceFactory()

local function execute()
    -- find the shrink clicky/spell if we got one
    local shrinkClicky = nil
    local spellConfig
    for key, buff in pairs(botSettings.settings.self_buffs) do
        spellConfig = parseSpellLine(buff)
        if spellConfig.Shrink ~= nil and spellConfig.Shrink then
            shrinkClicky = buff
            break
        end
    end

    if shrinkClicky == nil or not in_group() then
        log.Error("No Shrink clicky declared in self_buffs, giving up.")
        return
    end

    local item = find_item(spellConfig.Name)
    if item == nil then
        all_tellf("\arERROR\ax: Did not find Shrink clicky in inventory: %s", spellConfig.Name)
        return
    end
    log.Info("Shrinking group members with %s", item.ItemLink("CLICKABLE")())

    -- make sure shrink is targetable check buff type
    local spell = getSpellFromBuff(spellConfig.Name)
    if spell ~= nil and (spell.TargetType() == "Single" or spell.TargetType() == "Group v1") then
        -- loop over group, shrink one by one starting with yourself
        for n = 0, 5 do
            for i = 1, 3 do
                if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                    log.Info("Shrinking member %s from height %d", mq.TLO.Group.Member(n)(), mq.TLO.Group.Member(n).Height())
                    castSpell(spellConfig.Name, mq.TLO.Group.Member(n).ID())
                    -- sleep for the Duration
                    delay(item.Clicky.CastTime() + spell.RecastTime())
                end
            end
        end
    end
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/shrinkgroup", createCommand)
bind("/shrinkall", function()
    bci.ExecuteZoneCommand("/shrinkgroup")
end)
