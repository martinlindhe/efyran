-- restart all: /bcaa //multiline ; /lua stop e4 ; /timed 5 /lua run e4

mq = require('mq')

buffs   = require('e4_Buffs')
dannet  = require('e4_DanNet')
follow  = require('e4_Follow')
group   = require('e4_Group')
qol     = require('e4_QoL')

utils   = require('e4_Utils')

dannet.Init()
follow.Init()
group.Init()
qol.Init()





local doRefreshBuffs = true -- XXX move property to "buffs" object (class?)
local refreshBuffsTimer = utils.Timer.new(10 * 1) -- 10s
refreshBuffsTimer:expire()

mq.cmd.dgtell('all E4 started')


while true do
    if doRefreshBuffs and refreshBuffsTimer:expired() then
        buffs.RefreshBuffs()
        refreshBuffsTimer:restart()
    end

    mq.doevents()
end

