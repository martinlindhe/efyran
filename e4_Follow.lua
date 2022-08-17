local Follow = {}

function Follow.Init()

    -- MQ2AdvPath provides /afollow
    if mq.TLO.Plugin('MQ2AdvPath')() == nil then
        mq.cmd.plugin('MQ2AdvPath')
        print('WARNING: MQ2AdvPath was not loaded')
    end

    -- XXX: followme command that tells all to follow me... why no /netfollow on ????
    -- XXX register aliases!!!


    mq.bind('/clickit', function(name)
        print('CLICKING NEARBY DOOR xxx name')
        -- XXX click nearby door. like pok stones etc
    
        -- XXX spawn check if door within X radius
        mq.cmd.dgae('/doortarget')
        mq.delay(500)
        mq.cmd.dgae('/click left door')
    end)

    mq.bind('/followon', function()
        mq.cmd.dgze("/afollow spawn ${Me.ID}")
    end)
    mq.bind('/followme', function()
        mq.cmd.dgze("/afollow spawn ${Me.ID}")
    end)
    mq.bind('/followoff', function()
        mq.cmd.dgze("/afollow off")
    end)
    mq.bind('/followstop', function()
        mq.cmd.dgze("/afollow off")
    end)
end

return Follow
