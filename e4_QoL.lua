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

end

return QoL
