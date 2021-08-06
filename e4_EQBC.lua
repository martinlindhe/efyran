-- TODO: abstract to module to allow swapping netbots backend

local EQBC = {}

function EQBC.Init()
    if not mq.TLO.Plugin('MQ2EQBC').Name.Length() then
        mq.cmd.plugin('MQ2EQBC')
        print('WARNING: MQ2EQBC was not loaded')
    end

    if not mq.TLO.EQBC.Connected() then
        mq.cmd.bccmd('connect')
    end

    print('DONE: EQBC.Init')
end

return EQBC
