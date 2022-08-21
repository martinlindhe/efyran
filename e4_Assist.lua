follow = require('e4_Follow')

local Assist = {
    spawn = nil,  -- the current assist target
}


-- return spawn or nil
function getSpawn(spawnID)
    local spawn = mq.TLO.Spawn("id " .. spawnID)
    if tostring(spawn) == "NULL" then
        return nil
    end
    return spawn
end


function Assist.Init()

    -- assist on mob until dead
    mq.bind("/assiston", function(mobID)

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

        local spawn
        if orchestrator then
            spawn = mq.TLO.Target
        else
            spawn = getSpawn(mobID)
        end

        if spawn.Type() ~= "PC" then
            print("calling assist on spawn type ", spawn.Type)

            -- TODO ranged & caster assist ...

            if orchestrator then
                -- tell everyone else to attack
                mq.cmd.dgze("/assiston", spawn.ID())
            elseif botSettings.settings.assist.type == "Melee" then
                -- we dont auto attack with main driver. XXX impl "/assiston /not|WAR" filter

                Assist.spawn = spawn
                meleeAssist(spawn)
            end
        else
            mq.cmd.dgtell("all IGNORING ASSIST CALL ON PC ", spawn.Name(), ", mobID=", mobID)
        end

    end)

    -- ends assist call
    mq.bind("/backoff", function()
        -- XXX
        Assist.spawn = nil
    end)

end

-- stick and perform melee attacks
-- spawn is "userdata" type spawn
function meleeAssist(spawn)
    print("meleeAssist ",spawn.Name)
    if spawn == nil then
        mq.cmd.dgtell("ERROR ASSSIST ON ",spawn.Name)
        return
    end

    mq.cmd.target("id "..spawn.ID())
    mq.cmd.attack("on")

    follow.Pause()

    if botSettings.settings.assist.melee_distance == "MaxMelee" then
        botSettings.settings.assist.melee_distance = 25 -- XXX should be a global config for MaxMelee value
    end

    --tprint(botSettings.settings.assist) -- XXX respect settings

    local stickArg = ""
    if spawnID ~= nil then
        stickArg = "spawnID " .. spawn.ID() .. " "
    end

    if botSettings.settings.assist.stick_point == "Front" then
        stickArg = stickArg .. "hold front " .. botSettings.settings.assist.melee_distance .. " uw"
        mq.cmd.dgtell("STICKING IN FRONT TO ",spawn.Name, " ", stickArg)
        mq.cmd.stick(stickArg)
    else
        mq.cmd.stick("snaproll uw")
        --/delay 20 ${Stick.Behind} && ${Stick.Stopped}
        mq.cmd.delay(20, mq.TLO.Stick.Behind and mq.TLO.Stick.Stopped)
        stickArg = stickArg .. "hold moveback behind " .. botSettings.settings.assist.melee_distance .. " uw"
        mq.cmd.dgtell("STICKING IN BACK TO ",spawn.Name, " ", stickArg)
        mq.cmd.stick(stickArg)
    end

    -- XXX loop here until spawn is dead

    while true do
        if spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end


        -- XXX able to break when /backoff is called

        mq.doevents()
        mq.delay(100)
    end

    print("SPAWN MUST HAVE DIED")
    Assist.spawn = nil

    follow.Resume()

end

return Assist
