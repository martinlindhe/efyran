-- restart all: /bcaa //multiline ; /lua stop e4 ; /timed 5 /lua run e4

mq = require('mq')

aliases   = require('e4_Aliases')
autogroup = require('e4_AutoGroup')
buffs     = require('e4_Buffs')
eqbc      = require('e4_EQBC')
netbots   = require('e4_NetBots')

aliases.Init()
autogroup.Init()
netbots.Init()
eqbc.Init()

local doRefreshBuffs = true

mq.cmd.bc('E4 started')

while true do
    if doRefreshBuffs then
        buffs.RefreshBuffs()
    end
    mq.doevents()
end
