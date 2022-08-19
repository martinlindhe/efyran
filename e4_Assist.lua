local Assist = {}

function Assist.Init()

    mq.bind("/assiston", function(mobID)

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

        mobID = mq.TLO.Target.ID()
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

return Assist
