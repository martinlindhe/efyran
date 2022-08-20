-- quality of life tweaks

local QoL = {}

function QoL.Init()

    -- rof2 client has no persistent setting for /tgb on, afaik
    mq.cmd.tgb("on")

    joinCurrentHealChannel()

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            mq.cmd.dgtell("Missing component", name)
            mq.cmd.beep(1)
        end
    end)

    mq.event("tell", "#1# tells you, #2#", function(text, name, msg)
        local s = string.lower(msg)
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background? we enqueue it to a zone channel !!!
            mq.cmd.dgtell("XXX FIXME handle 'buffme' tell from ", name)
            mq.cmd.beep(1)
        else
            mq.cmd.dgtell("all GOT A TELL FROM ", name, ": ", msg)
            mq.cmd.beep(1)
        end
    end)

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        mq.cmd.dgtell("i zoned into ", zone)
        mq.delay(2000)
        pet.ConfigureTaunt()

        joinCurrentHealChannel()
    end)
end

-- joins/changes to the heal channel for current zone
function joinCurrentHealChannel()
    -- orchestrator only joins to watch the numbers
    local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

    if orchestrator or me_healer() then
        if heal.CurrentHealChannel() == botSettings.healme_channel then
            mq.cmd.dgtell("all unexpected: asked to join heal channel a second time", botSettings.healme_channel)
            mq.cmd.beep(1)
            return
        end

        if botSettings.healme_channel ~= "" then
            mq.cmd.dleave(botSettings.healme_channel)
        end

        botSettings.healme_channel = heal.CurrentHealChannel()
        mq.cmd.djoin(botSettings.healme_channel) -- new zone
    end
end

function me_healer()
    return is_healer(mq.TLO.Me.Class.ShortName())
end

function me_priest()
    return is_priest(mq.TLO.Me.Class.ShortName())
end

function me_tank()
    return is_tank(mq.TLO.Me.Class.ShortName())
end

-- true if CLR,DRU,SHM,PAL,RNG,BST
function is_healer(class)
    if class == nil then
        mq.cmd.dgtell("all is_healer called without class. did you mean me_healer() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM" or class == "PAL" or class == "RNG" or class == "BST"
end

-- true if CLR,DRU,SHM
function is_priest(class)
    if class == nil then
        mq.cmd.dgtell("all is_priest called without class. did you mean me_priest() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM"
end

function is_tank(class)
    if class == nil then
        mq.cmd.dgtell("all is_tank called without class. did you mean me_tank() ?")
        mq.cmd.beep(1)
    end
    return class == "WAR" or class == "PAL" or class == "SHD"
end

-- XXX add more:
-- Silk (ENC,MAG,NEC,WIZ)
-- Chain (ROG,BER,SHM,RNG)
-- Leather (DRU,BST,MNK)
-- Plate (WAR,BRD,CLR,PAL,SHD)
-- Knight(PAL,SHD)
-- Melee(BRD,BER,BST,MNK,PAL,RNG,ROG,SHD,WAR)
-- Hybrid (PAL,SHD,RNG,BST)

-- runs every second
function QoL.Tick()
    -- close f2p nag screen
    if mq.TLO.Window("AlertWnd").Open() then
        mq.cmd.dgtell("closing f2p nag screen")
        mq.cmd.notify("AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto accept trades
    if mq.TLO.Window("tradewnd").Open() then
        if mq.TLO.Target() ~= nil and mq.TLO.DanNet(mq.TLO.Target())() ~= nil then
            mq.cmd.dgtell("Accepting trade in 5s with", mq.TLO.Target())
            mq.delay(5000) -- 5.0s
            mq.cmd.notify("tradewnd TRDW_Trade_Button leftmouseup")
        else
            mq.cmd.dgtell("Ignoring trade from unknown toon ", mq.TLO.Target())
            mq.cmd.beep(1)
        end
    end

    if mq.TLO.Me.Class.ShortName() == "WIZ" and mq.TLO.Me.Pet.ID() ~= 0 then
        print("dropping wiz familiar ...", mq.TLO.Me.Pet.ID(), type(mq.TLO.Me.Pet.ID()))
        mq.cmd.pet("get lost")
    end

    if mq.TLO.Me.MaxMana() > 0 then
        if mq.TLO.Me.PctMana() < 70 and mq.TLO.Me.Standing() then
            mq.cmd.dgtell("all low mana, medding! ", mq.TLO.Me.PctMana())
            mq.cmd.sit("on")
        elseif mq.TLO.Me.PctMana() >= 100 and not mq.TLO.Me.Standing() and not mq.TLO.Window("SpellBookWnd").Open() then
            mq.cmd.dgtell("mana is good, standing up! ", mq.TLO.Me.PctMana(), "standing=",mq.TLO.Me.Standing())
            mq.cmd.sit("off")
        end
    end

end

return QoL