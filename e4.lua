require("ezmq")

local log = require("knightlinc/Write")

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
assist.Init()
qol.Init() -- NOTE: qol.Init() also verifies spell lines, so it should be called last

log.Info("E4 started")


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

    follow.Tick()
end
