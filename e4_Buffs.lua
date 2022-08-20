require('e4_Spells')

local Buffs = { aura = findBestAura() }

function Buffs.Init()
    mq.bind("/buffon", function()
        botSettings.toggles.refresh_buffs = true
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/buffon")
        end
    end)

    mq.bind("/buffoff", function()
        botSettings.toggles.refresh_buffs = false
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/buffoff")
        end
    end)

    -- if filter == "all", drop all. else drop partially matched buffs
    mq.bind("/dropbuff", function(filter)
        if filter == nil then
            return
        end
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/dropbuff", filter)
        end

        if filter == "all" then
            for i=1,mq.TLO.Me.MaxBuffSlots() do
                if mq.TLO.Me.Buff(i).ID() ~= nil then
                    print("removing buff ", i, "id:",mq.TLO.Me.Buff(i).ID(), ",name:", mq.TLO.Me.Buff(i).Name())
                    mq.cmd.removebuff(mq.TLO.Me.Buff(i).Name())
                    mq.delay(1)
                end
            end
        else
            mq.cmd.removebuff(filter)
        end
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
        --mq.cmd.dgtell("all buffit ", spawnID)
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            spawnID = mq.TLO.Target.ID()
            if spawnID ~= 0 then
                mq.cmd.dgzexecute("/buffit", spawnID)
            end
        end

        if botSettings.settings.group_buffs == nil then
            return
        end

        local spawn = mq.TLO.Spawn("id " .. spawnID)
        if tostring(spawn) == "NULL" then
            mq.cmd.dgtell("all BUFFIT FAIL, cannot find target id in zone ", spawnID)
            return false
        end

        local level = spawn.Level()

        for key, buffs in pairs(botSettings.settings.group_buffs) do
            print("finding best group buff ", key)

            -- XXX find the one with highest MinLevel
            local minLevel = 0
            local spellName = ""
            if type(buffs) ~= "table" then
                mq.cmd.dgtell("all FATAL ERROR, group buffdata ", buffs, " should be a table")
                return
            end

            for k, buff in pairs(buffs) do
                local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
                local n = tonumber(spellConfig.MinLevel)
                if n == nil then
                    mq.cmd.dgtell("all FATAL ERROR, group buff ", buff, " does not have a MinLevel setting")
                    return
                end
                if n > minLevel and level >= n then
                    minLevel = n
                    spellName = spellConfig.SpellName
                    print("Best ", key, " buff so far is L",spellConfig.MinLevel, " ", spellConfig.SpellName, " target ", spawn.Name() ," L", level)
                end
            end

            if minLevel > 0 then
                if spellConfigAllowsCasting(spellName, spawn.Name()) then
                    castSpellRaw(spellName, spawnID, "-maxtries|3")
                    -- XXX wait until cast is finished !!!
                    mq.delay(10000) -- XXX 10s
                end
            else
                print("Failed to find a matching group buff ", key, ", target ", spawn.Name(), " L", level)
            end
        end

    end)
end

-- returns true if a buff was casted
function Buffs.RefreshSelfBuffs()
    if botSettings.settings.self_buffs == nil then
        return false
    end
    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        if refreshBuff(buffItem, mq.TLO.Me.Name()) then
            -- end after first successful buff
            return true
        end
    end
    return false
end

-- returns true if spell was cast
function Buffs.RefreshBotBuffs()

    if botSettings.settings.bot_buffs == nil then
        return
    end

    --print("Buffs.RefreshBotBuffs")

    for buff, names in pairs(botSettings.settings.bot_buffs) do
        --print("xxx ",buff)

        local spellConfig = parseSpellLine(buff) -- XXX cache, dont do this all the time!

        local spell = getSpellFromBuff(spellConfig.SpellName) -- XXX parse this once on script startup too, dont evaluate all the time !
        if spell == nil then
            mq.cmd.dgtell("Buffs.RefreshBotBuffs: getSpellFromBuff ", buff, " FAILED")
            mq.cmd.beep(1)
            return false
        end

        for k, bot in pairs(names) do
            if refreshBuff(buff, bot) then
                return true
            end
        end
    end

    return false
end

-- returns true if a buff was casted
function Buffs.RefreshAura()
    if Buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil then
        return false
    end
    castSpell(Buffs.aura, mq.TLO.Me.ID())
    return true
end

return Buffs

