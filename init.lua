require("ezmq")
require("commands")
require("looting/markItemForDestroying")
require("looting/markItemForSelling")

local log = require("knightlinc/Write")

local commandQueue = require("CommandQueue")

local assist  = require("assisting/Assist")
local buffs   = require("spells/Buffs")
local group   = require("following/Group")
local follow  = require("following/Follow")
local heal    = require("healing/Heal")
local qol     = require("quality/QoL")
local tribute = require("quality/Tribute")
local alerts  = require("quality/Alerts")

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
