local Follow = {}

function Follow.Init()
    -- XXX
    if tostring(mq.TLO.Plugin('MQ2MoveUtils')) == 'NULL' then
        mq.cmd.plugin('MQ2MoveUtils')
        print('WARNING: MQ2MoveUtils was not loaded')
    end

    print('DONE: Follow.Init')
end

return Follow
