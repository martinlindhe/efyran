local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local assist         = require("lib/assisting/Assist")
local botSettings    = require("lib/settings/BotSettings")

local bci = broadCastInterfaceFactory()


local xpBuffs = {
    "Bottle of Shared Adventure III", -- 50% xp bonus, 4h
    "Bottle of Shared Adventure II",
    "Bottle of Shared Adventure I",
    "Lesson of the Devoted", -- veteran AA, X hours reuse
}

-- report active XP buffs
bind("/bonusxpactive", function()
    -- instant output, no queue needed

    for _, buffName in pairs(xpBuffs) do
        if have_buff(buffName) then
            all_tellf("%s active for %s", buffName, mq.TLO.Me.Buff(buffName).Duration.TimeHMS())
        end
    end
end)

-- report available XP buffs
bind("/bonusxpready", function()
    -- instant output, no queue needed

    if is_alt_ability_ready("Lesson of the Devoted") then
        all_tellf("Lesson ready!")
        return
    end

    for _, buffName in pairs(xpBuffs) do
        if have_item_inventory(buffName) then
            all_tellf("Have %d x %s in inventory", inventory_item_count(buffName), buffName)
        end
    end
end)
