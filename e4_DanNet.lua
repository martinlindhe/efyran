-- TODO: abstract to module to allow swapping netbots backend

local DanNet = {}

function DanNet.Init()
    if tostring(mq.TLO.Plugin('MQ2DanNet')) == 'NULL' then
        mq.cmd.plugin('MQ2DanNet')
        print('WARNING: MQ2DanNet was not loaded')
    end

    print('DONE: DanNet.Init')
end

return DanNet
