local Follow = {}

function Follow.Init()
    --[[
    -- XXX do we need moveutils ????
    if mq.TLO.Plugin('MQ2MoveUtils')() == 'NULL' then
        mq.cmd.plugin('MQ2MoveUtils')
        print('WARNING: MQ2MoveUtils was not loaded')
    end
    ]]--

    -- MQ2AdvPath provides /afollow
    if mq.TLO.Plugin('MQ2AdvPath')() == 'NULL' then
        mq.cmd.plugin('MQ2AdvPath')
        print('WARNING: MQ2AdvPath was not loaded')
    end

    -- XXX: followme command that tells all to follow me... why no /netfollow on ????
    -- XXX register aliases!!!


    mq.bind('/clickit', function(name)
        print('CLICKING NEARBY DOOR xxx name')
        -- XXX click nearby door. like pok stones etc
    
        -- XXX spawn check if door within X radius
        mq.cmd.dgaexecute('/doortarget')
        mq.delay(500)
        mq.cmd.dgaexecute('/click left door')
    end)

    -- XXX only write on inital setup for first toon ?!?!? like below, it writes 1 alias line in ini for each bot, messing it up!
    --[[
    mq.cmd.alias('/followme /dge /afollow spawn ${Me.ID}')
    mq.cmd.alias('/followstop=/dge /afollow off')
    mq.cmd.alias('/followon=/dge /afollow spawn ${Me.ID}')
    mq.cmd.alias('/followoff=/dge /afollow off')
    ]]--

    print('DONE: Follow.Init')
end

return Follow
