local Follow = {}

function Follow.Init()

    if mq.TLO.Plugin('MQ2DanNet')() == nil then
        mq.cmd.plugin('MQ2DanNet')
        print('WARNING: MQ2DanNet was not loaded')
    end

    if mq.TLO.Plugin("MQ2AdvPath")() == nil then
        mq.cmd.plugin("MQ2AdvPath")
        print("WARNING: MQ2AdvPath was not loaded")
    end

    if mq.TLO.Plugin("MQ2MoveUtils")() == nil then
        -- XXX currently used for /stick when assisting. would prefer to drop it fully
        mq.cmd.plugin("MQ2MoveUtils")
        print("WARNING: MQ2MoveUtils was not loaded")
    end

    if mq.TLO.Plugin("MQ2Cast")() == nil then
        mq.cmd.plugin("MQ2Cast")
        print("WARNING: MQ2Cast was not loaded")
    end

    if mq.TLO.Plugin("MQ2Medley")() == nil then
        mq.cmd.plugin("MQ2Medley")
        print("WARNING: MQ2Medley was not loaded")
    end

    mq.bind("/clickit", function(name)
        print("CLICKING NEARBY DOOR xxx name")
        -- XXX click nearby door. like pok stones etc
    
        -- XXX spawn check if door within X radius
        mq.cmd.dgae("/doortarget")
        mq.delay(500)
        mq.cmd.dgae("/click left door")
    end)

    mq.bind("/followon", function()
        mq.cmd.dgze("/afollow spawn ${Me.ID}")
    end)
    mq.bind("/followme", function()
        mq.cmd.dgze("/afollow spawn ${Me.ID}")
    end)
    mq.bind("/followoff", function()
        mq.cmd.dgze("/afollow off")
    end)
    mq.bind("/followstop", function()
        mq.cmd.dgze("/afollow off")
    end)

    mq.bind("/portto", function(name)
        name = string.lower(name)
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

        if orchestrator then
            -- tell porters in current zone
            -- XXX instead, tell all in zone and in raid... ?
            mq.cmd.dgexecute("wiz", "/portto", name)
            mq.cmd.dgexecute("dru", "/portto", name) 
        end
    
        local spellName = ""
        if mq.TLO.Me.Class.ShortName() == "WIZ" then
            spellName = aliases.Wizard["port " .. name]
        elseif mq.TLO.Me.Class.ShortName() == "DRU" then
            spellName = aliases.Druid["port " .. name]
        else
            return
        end

        mq.cmd.dgtell("Porting to " .. name .. " (" .. spellName .. ")")

        if spellName == nil then
            mq.cmd.dgtell("ERROR: no such port ", name)
        end

        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
    end)

end

return Follow
