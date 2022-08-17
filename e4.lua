-- restart all: /dgaexecute /multiline ; /lua stop e4 ; /timed 5 /lua run e4

mq      = require('mq')

utils   = require('e4_Utils')

aliases = require('settings/Spell Aliases')

botSettings = require('e4_BotSettings')
buffs   = require('e4_Buffs')
follow  = require('e4_Follow')
group   = require('e4_Group')
qol     = require('e4_QoL')



CLR     = require('Class_Cleric')

BRD     = require('Class_Bard')

WAR     = require('Class_Warrior')

botSettings.Init()
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

    local class = mq.TLO.Me.Class.ShortName()
    if class == "CLR" then CLR.DoEvents()
    --[[
    elseif class == "SHM" then ShamanEvents()
    elseif class == "DRU" then DruidEvents()
    elseif class == "WIZ" then WizardEvents()
    elseif class == "MAG" then MagicianEvents()
    elseif class == "ENC" then EnchanterEvents()
    elseif class == "NEC" then NecromancerEvents()
    elseif class == "ROG" then RogueEvents()
    elseif class == "MNK" then MonkEvents()
    elseif class == "BER" then BerserkerEvents()
    ]]--
    elseif class == "BRD" then BRD.DoEvents()
    --elseif class == "BST" then BeastlordEvents()
    --elseif class == "RNG" then RangerEvents()
    elseif class == "WAR" then WAR.DoEvents()
    --elseif class == "SHD" then ShadowknightEvents()
    --elseif class == "PAL" then PaladinEvents()
    end

    mq.doevents()
    qol.Tick()
    mq.delay(1000) -- 1.0s
end

