-- part of e4, but runs separate to always be running asking for heals.

local mq = require("mq")

require("ezmq")
heal = require("e4_Heal")
timer = require("Timer")

local askForHealTimer = timer.new_expired(5 * 1) -- 5s
local askForHealPct = 88 -- at what % HP to start begging for heals

while true do

    if not is_hovering() and mq.TLO.Me.PctHPs() <= askForHealPct and askForHealTimer:expired() then
        -- ask for heals if i take damage
        local s = mq.TLO.Me.Name().." "..mq.TLO.Me.PctHPs() -- "Avicii 82"
        --print(mq.TLO.Time, "HELP HEAL ME, ", s)
        mq.cmd.dgtell(heal.CurrentHealChannel(), s)
        askForHealTimer:restart()
    end

    mq.doevents()
    mq.delay(10)
end
