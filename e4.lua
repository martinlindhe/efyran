require("ezmq")

require("knightlinc/Write")

require("e4_Loot")
require("e4_Hail")

local commandQueue = require("e4_CommandQueue")

local botSettings = require("e4_BotSettings")

local assist  = require("e4_Assist")
local buffs   = require("e4_Buffs")
local group   = require("e4_Group")
local heal    = require("e4_Heal")
local qol     = require("e4_QoL")

seed_process()

botSettings.Init()
buffs.Init()
group.Init()
heal.Init()
qol.Init()
assist.Init()

all_tellf("E4 started")

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
end
