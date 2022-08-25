-- restart all: /dgaexecute /multiline ; /lua stop e4 ; /timed 5 /lua run e4

require("ezmq")

require("debug")


items   = require("e4_Items")


aliases = require("settings/Spell Aliases")

botSettings = require("e4_BotSettings")
follow  = require("e4_Follow")

assist  = require("e4_Assist")
buffs   = require("e4_Buffs")
group   = require("e4_Group")
heal    = require("e4_Heal")
loot    = require("e4_Loot")
pet     = require("e4_Pet")
qol     = require("e4_QoL")



CLR     = require("Class_Cleric")

bard    = require("Class_Bard")

WAR     = require("Class_Warrior")

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

    qol.Tick()

    heal.Tick()
    mq.delay(1000) -- 1.0s  XXX cant block here for more than few millisec

end

