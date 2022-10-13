require("ezmq")

local log = require("knightlinc/Write")

local timer = require("Timer")

require("e4_Loot")
require("e4_Hail")

local commandQueue = require("e4_CommandQueue")
local botSettings  = require("e4_BotSettings")

local assist  = require("e4_Assist")
local buffs   = require("e4_Buffs")
local group   = require("e4_Group")
local follow  = require("e4_Follow")
local heal    = require("e4_Heal")
local qol     = require("e4_QoL")

seed_process()

botSettings.Init()
buffs.Init()
group.Init()
heal.Init()
qol.Init()
assist.Init()

log.Info("E4 started")

local followUpdateTimer = timer.new_expired(5 * 1) -- 5s

-- MAIN LOOP
while true do
    heal.Tick()
    doevents()

    buffs.Tick()
    doevents()

    commandQueue.Process()
    doevents()

    qol.Tick()
    doevents()
    delay(1)

    assist.Tick()
    doevents()
    delay(1)

    if followUpdateTimer:expired() then
        follow.Update()
        followUpdateTimer:restart()
    end
end
