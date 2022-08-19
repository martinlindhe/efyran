-- quality of life tweaks

local QoL = {}

function QoL.Init()

    -- rof2 client has no persistent setting for /tgb on, afaik
    mq.cmd.tgb("on")

    if mq.TLO.Plugin('MQ2AutoAccept')() == nil then
        mq.cmd.plugin('MQ2AutoAccept')
        print('WARNING: MQ2AutoAccept was not loaded')
    end

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            mq.cmd.dgtell("Missing component", name)
            mq.cmd.beep(1)
        end
    end)

    mq.event("tell", "#1# tells you, #2#", function(text, name, msg)
        local s = string.lower(msg)
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background?
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
    end)


    -- print('DONE: QoL.Init')
end

-- runs every second
function QoL.Tick()
    -- close f2p nag screen
    if mq.TLO.Window("AlertWnd").Open() then
        mq.cmd.dgtell("closing f2p nag screen")
        mq.cmd.notify("AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto accept trades
    if mq.TLO.Window("tradewnd").Open() then
        if mq.TLO.Target() ~= nil and mq.TLO.DanNet(mq.TLO.Target()) ~= nil then
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