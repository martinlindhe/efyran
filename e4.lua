-- restart all: /bcaa //multiline ; /lua stop e4 ; /timed 5 /lua run e4

mq = require('mq')

buffs   = require('e4_Buffs')
dannet  = require('e4_DanNet')
follow  = require('e4_Follow')
group   = require('e4_Group')

dannet.Init()
follow.Init()
group.Init()

local doRefreshBuffs = true -- XXX move property to "buffs" object (class?)

mq.cmd.dgtell('all E4 started')

while true do
    if doRefreshBuffs then
        buffs.RefreshBuffs()
    end

    -- close f2p nag screen (TODO: does it need to run in main loop?)
    if mq.TLO.Window('AlertWnd').Open() then
        mq.cmd.dgtell('DEBUG: closing f2p nag screen')
        mq.cmd.notify('AlertWnd ALW_Dismiss_Button leftmouseup')
    end

    mq.doevents()
end
