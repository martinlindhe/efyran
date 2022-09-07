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

    mq.bind("/followon", function()
        mq.cmd.dgzexecute("/followid", mq.TLO.Me.ID())
    end)

    mq.bind("/followoff", function(s)
        if is_orchestrator() then
            mq.cmd.dgzexecute("/followoff")
        end
        Follow.Pause()
        Follow.spawn = nil
    end)

    -- follows another peer in LoS
    mq.bind("/followid", function(spawnID)
        if not is_peer_id(spawnID) then
            mq.cmd.dgtell("all ERROR: /followid called on invalid spawnID", spawnID)
            return
        end

        if is_spawn_los(spawnID) then
            Follow.spawn = spawn_from_id(spawnID)
            Follow.Resume()
        else
            mq.cmd.dgtell("all Spawn ", spawnID, " is not in LoS")
        end
    end)

    mq.bind("/portto", function(name)
        name = string.lower(name)
        if is_orchestrator() then
            mq.cmd.dgzexecute("/portto", name)
        end

        local spellName
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

        if is_orchestrator() then
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

    -- tell peers in zone to use Throne of Heroes
    mq.bind("/throne", function()
        if is_orchestrator() then
            mq.cmd.dgzexecute("/throne")
        end
        cast_veteran_aa("Throne of Heroes")
    end)

    mq.bind("/movetome", function()
        mq.cmd.dgzexecute("/movetoid", mq.TLO.Me.ID())
    end)

    -- move to me
    mq.bind("/mtm", function()
        mq.cmd.dgzexecute("/movetoid", mq.TLO.Me.ID())
    end)

    -- move to spawn ID
    mq.bind("/movetoid", function(spawnID)
        if is_orchestrator() then
            mq.cmd.dgzexecute("/movetoid", spawnID)
        end

        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            mq.cmd.dgtell("all No such spawn: ", spawnID)
            return
        end
        move_to(spawn)
    end)

    -- run through zone based on the position of startingPeer
    -- stand near a zoneline and face in the direction of the zoneline, run command for bots to move forward to the other zone
    mq.bind("/rtz", function(startingPeer)

        if is_orchestrator() then
            -- tell the others to cross zone line
            mq.cmd.dgzexecute("/rtz", mq.TLO.Me.Name())
            return
        end

        -- run across (need pos + heading from orchestrator)
        local spawn = spawn_from_peer_name(startingPeer)
        if spawn == nil then
            mq.cmd.dgtell("all ERROR: /rtz requested from peer not found: ", startingPeer)
            return
        end

        local oldZone = mq.TLO.Zone.ShortName()
        print("MOVING THRU ZONE FROM ", oldZone)

        mq.cmd.stick("off")

        -- move to initial position
        move_to(spawn)

        if not is_within_distance(spawn, 15) then
            -- unlikely
            mq.cmd.dgtell("all /rtz ERROR: failed to move near ", spawn.Name(), ", my distance is ", spawn.Distance())
            return
        end

        -- face the direction of the orchestration
        local headingArg = "fast heading "..tostring(spawn.Heading.Degrees() * -1)
        mq.cmd.face(headingArg)
        mq.delay(5)

        -- move forward
        mq.cmd.keypress("forward hold")
        mq.delay(6000, function()
            local zoned = mq.TLO.Zone.ShortName() ~= oldZone
            if zoned then
                print("I ZONED INTO ", mq.TLO.Zone.ShortName())
            end
            return zoned
        end)

        if mq.TLO.Zone.ShortName() == oldZone then
            mq.cmd.dgtell("all ERROR failed to run across zone line in", oldZone)
            mq.cmd.beep(1)
        end

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

return Follow
