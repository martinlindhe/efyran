-- restart all: /dgaexecute /multiline ; /lua stop e4 ; /timed 5 /lua run e4

mq      = require('mq')

utils   = require('e4_Utils')

aliases = require('settings/Spell Aliases')

botSettings = require('e4_BotSettings')

assist  = require('e4_Assist')
buffs   = require('e4_Buffs')
follow  = require('e4_Follow')
group   = require('e4_Group')
pet     = require('e4_Pet')
qol     = require('e4_QoL')



CLR     = require('Class_Cleric')

BRD     = require('Class_Bard')

WAR     = require('Class_Warrior')

botSettings.Init()

assist.Init()
buffs.Init()
follow.Init()
group.Init()
qol.Init()



local refreshBuffsTimer = utils.Timer.new(4 * 1) -- 4s
refreshBuffsTimer:expire()


mq.cmd.dgtell('all E4 started')


while true do
    if botSettings.toggles.refresh_buffs and refreshBuffsTimer:expired() and not mq.TLO.Me.Moving() and not mq.TLO.Me.Invis()
    and (mq.TLO.Me.Class.ShortName() == "BRD" or not mq.TLO.Me.Casting()) then
        if not buffs.RefreshSelfBuffs() then
            if not buffs.RefreshAura() then
                if not pet.BuffMyPet() then
                    buffs.RefreshBotBuffs()
                end
            end
        end
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

    pet.Summon()

    qol.Tick()
    mq.delay(1000) -- 1.0s
end

