require("ezmq")
require("commands")
require("lib/looting/markItemForDestroying")
require("lib/looting/markItemForSelling")

local log           = require("knightlinc/Write")
local commandQueue  = require("lib/CommandQueue")
local assist        = require("lib/assisting/Assist")
local buffs         = require("lib/spells/Buffs")
local group         = require("lib/following/Group")
local follow        = require("lib/following/Follow")
local heal          = require("lib/healing/Heal")
local crowdcontrol  = require("lib/crowdcontrol/mesmerize")
local qol           = require("lib/quality/QoL")
local tribute       = require("lib/quality/Tribute")
local alerts        = require("lib/quality/Alerts")

--local hud           = require("hud/hud")

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

    crowdcontrol.Tick()
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
    delay(1)

--    if not hud.ShouldTerminate() and is_orchestrator() then
--        hud.Update()
--    end
end
