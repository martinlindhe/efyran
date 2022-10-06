require("ezmq")

require("knightlinc/Write")

require("e4_Loot")
require("e4_Hail")

items   = require("e4_Items")

groupBuffs = require("e4_GroupBuffs")
local commandQueue = require("e4_CommandQueue")

botSettings = require("e4_BotSettings")
follow  = require("e4_Follow")

assist  = require("e4_Assist")
buffs   = require("e4_Buffs")
group   = require("e4_Group")
heal    = require("e4_Heal")
pet     = require("e4_Pet")
qol     = require("e4_QoL")

local bard = require("Class_Bard")

-- MAIN PROGRAM
seed_process()

botSettings.Init()
assist.Init()
buffs.Init()
follow.Init()
group.Init()
heal.Init()
qol.Init()
items.Init()


all_tellf("E4 started")
bard.resumeMelody()

while true do
    heal.Tick()
    doevents()
    delay(1)

    buffs.Tick()
    doevents()
    delay(1)

    commandQueue.Process()
    doevents()
    delay(1)

    qol.Tick()
    doevents()
    delay(1)
end
