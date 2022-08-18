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

    mq.bind("/portto", function(name, called)
        name = string.lower(name)
        -- XXX if i am active, tell the 1st porter of each group to do /portto name
        -- TODO LATER: access ${FrameLimiter.Status} to see if we are in foreground, then assume we are active. now bug https://github.com/macroquest/macroquest/issues/607
        
        if not called then
            -- porters in current zone
            mq.cmd.dgexecute("wiz", "/portto", name, true)
            mq.cmd.dgexecute("dru", "/portto", name, true) 
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

        -- XXX cast it
        mq.cmd.casting('"'..spellName..'" gem5')

    end)

    mq.bind("/assiston", function(mobID)

        local orchestrator = false
        if mq.TLO.FrameLimiter.Status() == "Foreground" then
            mobID = mq.TLO.Target.ID()
            orchestrator = true
        end

        if botSettings.settings.assist.type == "Melee" then
            meleeAssist(mobID)
        end

        -- TODO ranged & caster assist ...

        if orchestrator then
            -- XXX tell everyone else to attack
                mq.cmd.dgze("/assiston", mobID)
        end
    end)


end

-- stick and perform melee attacks
-- id = spawn id
function meleeAssist(id)
    print("meleeAssist ",id)
    if id == nil then
        mq.cmd.dgtell("ERROR ASSSIST ON ",id)
        return
    end

    mq.cmd.target("id "..id)
    mq.cmd.attack("on")
    -- mq.cmd.afollow("spawn " .. id) -- # XXX afollow wont stick in front/back, etc. need more like /stick 

    if botSettings.settings.assist.melee_distance == "MaxMelee" then
        botSettings.settings.assist.melee_distance = 25 -- XXX should be a global config for MaxMelee value
    end

    --tprint(botSettings.settings.assist) -- XXX respect settings

    local stickArg = ""
    if id ~= nil then
        stickArg = "id " .. id .. " "
    end

    if botSettings.settings.assist.stick_point == "Front" then
        stickArg = stickArg .. "hold front " .. botSettings.settings.assist.melee_distance .. " uw"
        mq.cmd.dgtell("STICKING IN FRONT TO ",id, " ", stickArg)
        mq.cmd.stick(stickArg)
    else
        mq.cmd.stick("snaproll uw")
        --/delay 20 ${Stick.Behind} && ${Stick.Stopped}
        mq.cmd.delay(20, mq.TLO.Stick.Behind and mq.TLO.Stick.Stopped)
        stickArg = stickArg .. "hold moveback behind " .. botSettings.settings.assist.melee_distance .. " uw"
        mq.cmd.dgtell("STICKING IN BACK TO ",id, " ", stickArg)
        mq.cmd.stick(stickArg)
    end


end

return Follow
