local Follow = {
    spawn = nil, -- the current spawn I am following
}

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

    mq.bind("/clickit", function(name)
        print("CLICKING NEARBY DOOR xxx name")
        -- XXX click nearby door. like pok stones etc
    
        -- XXX spawn check if door within X radius
        mq.cmd.dgze("/doortarget")
        mq.delay(500)
        mq.cmd.dgze("/click left door")
    end)

    -- NOTE: can't seem to register /followon and /followoff
    mq.bind("/followme", function()
        mq.cmd.dgzexecute("/followid", mq.TLO.Me.ID())
    end)

    -- follows another peer in LoS
    mq.bind("/followid", function(spawnID)
        print("followid called")
        if is_peer_id(spawnID) then
            if is_spawn_los(spawnID) then
                Follow.spawn = spawn_from_id(spawnID)
                Follow.Resume()
            else
                mq.cmd.dgtell("all spawn ", spawnID, " not LoS")
            end
        else
            mq.cmd.dgtell("all ERROR: /followid called on invalid spawnID", spawnID)
        end
    end)
    
    mq.bind("/stopfollow", function(s)
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/stopfollow")
        end
        Follow.Pause()
        Follow.spawn = nil
    end)

    mq.bind("/portto", function(name)
        name = string.lower(name)
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

        if orchestrator then
            mq.cmd.dgzexecute("/portto", name)
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

    mq.bind("/evac", function(name)

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/evac")
        end

        if botSettings.settings.evac == nil then
            return
        end

        -- chose first one we have and use it (skip Exodus if AA is down)
        for key, evac in pairs(botSettings.settings.evac) do
            print("finding available evac spell ", key, ": ", evac)
            if mq.TLO.Me.AltAbility(evac)() ~= nil then
                if mq.TLO.Me.AltAbilityReady(evac)() then
                    castSpellRaw(evac, mq.TLO.Me.ID(), "-maxtries|3")
                    return
                end
            else
                castSpellRaw(evac, mq.TLO.Me.ID(), "gem5 -maxtries|3")
            end

        end
    end)

    mq.bind("/throne", function()
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/throne")
        end
        castVeteranAA("Throne of Heroes")
    end)
end

function Follow.Pause()
    mq.cmd.afollow("off")
end

function Follow.Resume()
    if Follow.spawn ~= nil then
        print("resuming follow")
        mq.cmd("/afollow spawn", Follow.spawn.ID())
    else
        print("Follow.Resume: failed. spawnID is nil")
    end
end

function castVeteranAA(name)
    if mq.TLO.Me.AltAbility(name)() ~= nil then
        if mq.TLO.Me.AltAbilityReady(name)() then
            castSpell(name, mq.TLO.Me.ID())
        else
            mq.cmd.dgtell("ERROR:", name, "is not ready, ready in", mq.TLO.Me.AltAbilityTimer(name).TimeHMS() )
        end
    else
        mq.cmd.dgtell("ERROR: i do not have AA", name)
    end
end

return Follow
