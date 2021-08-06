local NetBots = {}

function NetBots.Init()
    if not mq.TLO.Plugin('MQ2EQBC').Name.Length() then
        mq.cmd.plugin('MQ2EQBC')
        print('WARNING: MQ2EQBC was not loaded')
    end

    if not mq.TLO.Plugin('MQ2NetBots').Name.Length() then
        mq.cmd.plugin('MQ2NetBots')
        print('WARNING: MQ2NetBots was not loaded')
    end

    mq.cmd.squelch('/netbots on')
    mq.cmd.squelch('/netbots grab on')
    mq.cmd.squelch('/netbots send on')

    print('DONE: NetBots.Init')
end

return NetBots


