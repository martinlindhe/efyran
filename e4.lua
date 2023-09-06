require("efyran/ezmq")

local log = require("efyran/knightlinc/Write")

require("efyran/e4_Loot")
require("efyran/e4_Hail")

local commandQueue = require("efyran/e4_CommandQueue")

local assist  = require("efyran/e4_Assist")
local buffs   = require("efyran/e4_Buffs")
local group   = require("efyran/e4_Group")
local follow  = require("efyran/e4_Follow")
local heal    = require("efyran/e4_Heal")
local qol     = require("efyran/e4_QoL")

seed_process()

buffs.Init()
group.Init()
heal.Init()
assist.Init()

-- NOTE: qol.Init() also verifies spell lines, so it must be called last
qol.Init()

follow.StopFully()

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

    assist.Tick()
    doevents()

    follow.Tick()
    doevents()
    delay(1)
end
