-- restart all: /dgaexecute /multiline ; /lua stop e4 ; /timed 5 /lua run e4

require("ezmq")

mq.imgui.init('imgui-init', function()
end)

math.randomseed(mq.TLO.EverQuest.PID() + (os.clock() * 1000))

require("debug")


require("e4_Loot")
require("e4_Hail")

items   = require("e4_Items")

groupBuffs = require("e4_GroupBuffs")


aliases = require("settings/Spell Aliases")

botSettings = require("e4_BotSettings")
follow  = require("e4_Follow")

assist  = require("e4_Assist")
buffs   = require("e4_Buffs")
group   = require("e4_Group")
heal    = require("e4_Heal")
pet     = require("e4_Pet")
qol     = require("e4_QoL")


bard    = require("Class_Bard")


botSettings.Init()

assist.Init()
buffs.Init()
follow.Init()
group.Init()
heal.Init()
qol.Init()
items.Init()

mq.cmd.dgtell("all E4 started")

while true do
    buffs.Tick()
    mq.doevents()
    mq.delay(1)

    qol.Tick()
    mq.doevents()
    mq.delay(1)

    heal.Tick()
    mq.doevents()
    mq.delay(1)
end

