require("ezmq")
require("commands")

local log = require("knightlinc/Write")

require("e4_Hail")

local commandQueue = require("e4_CommandQueue")

local assist  = require("e4_Assist")
local buffs   = require("e4_Buffs")
local group   = require("e4_Group")
local follow  = require("e4_Follow")
local heal    = require("e4_Heal")
local tribute = require("e4_Tribute")
local qol     = require("e4_QoL")
local alerts  = require("e4_Alerts")

seed_process()

qol.loadRequiredPlugins()

buffs.Init()
group.Init()
heal.Init()
assist.Init()
alerts.Init()

-- NOTE: qol.Init() also verifies spell lines, so it must be called last
qol.Init()

follow.Pause()

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

    tribute.Tick()
    doevents()

    assist.Tick()
    doevents()

    follow.Tick()
    doevents()
    delay(10)
end
