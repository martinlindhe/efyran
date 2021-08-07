-- quality of life tweaks

local QoL = {}

function QoL.Init()
    -- close f2p nag screen (TODO: does it need to run in main loop?)
    if mq.TLO.Window('AlertWnd').Open() then
        mq.cmd.dgtell('DEBUG: closing f2p nag screen')
        mq.cmd.notify('AlertWnd ALW_Dismiss_Button leftmouseup')
    end

    print('DONE: QoL.Init')
end

return QoL
