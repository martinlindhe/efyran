combatAbilityAuras = {
    "Myrmidon's Aura",      -- WAR/55: Increase Proc Modifier by 1%, Slot 12: 60 AC
    "Champion's Aura",      -- WAR/70: Increase Proc Modifier by 2%, Slot 12: 90 AC
    "Disciple's Aura",      -- MNK/55: 5% riposte, 5% parry, 5% block
    "Master's Aura",        -- MNK/70: 10% riposte, 10% parry, 10% block
    "Aura of Rage",         -- BER/55: Increase melee Critical Damage by 20%
    "Bloodlust Aura",       -- BER/70: Increase melee Critical Damage by 30%
}

spellAuras = {
    "Aura of Insight",      -- BRD/55: Spell Damage 1-15%, Melee Overhaste 15%
    "Aura of the Muse",     -- BRD/70: Spell Damage 1-30%, Melee Overhaste 25%
    "Aura of the Zealot",   -- CLR/55: Slot 2: Mitigate Melee Damage by 1%
    "Aura of the Pious",    -- CLR/70: Slot 2: Mitigate Melee Damage by 3%
    "Aura of the Grove",    -- DRU/55: Slot 11: +10 hp/tick, -2 disease counter
    "Aura of Life",         -- DRU/70: Slot 11: +30 hp/tick, -4 disease counter
    "Beguiler's Aura",      -- ENC/55: Slot 11: +4 mana/tick
    "Illusionist's Aura",   -- ENC/70: Slot 11: +6 mana/tick
    "Holy Aura",            -- PAL/55: Spell Damage 1-15%, Melee Overhaste 15%
    "Blessed Aura",         -- PAL/70: Spell Damage 1-30%, Melee Overhaste 25%
}

-- is run at script start, so in order to update state one need to restart the script (TODO trigger event to reload and recalc all settings)
function findBestAura()
    local aura = nil
    for k, n in pairs(combatAbilityAuras) do
        if mq.TLO.Me.CombatAbility(n)() then
            aura = n
        end
    end
    if aura == nil then
        for k, n in pairs(spellAuras) do
            if mq.TLO.Me.Book(n)() then
                aura = n
            end
        end
    end
    return aura
end

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

    -- /buffit: asks bots to cast group buffs on current target
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


-- returns a object
function parseSpellLine(s)
    -- Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction

    local o = {}

	local name = ""
    for token in string.gmatch(s, "[^/]+") do
        -- separate token on | "key" + "val"
        local key = ""
        local i = 0
        for v in string.gmatch(token, "[^|]+") do
            if i == 0 then
                key = v
            end
            if i == 1 then
                -- print(key, " = ", v)
                o[key] = v
            end
            i = i + 1
        end
        if i == 1 then
            o.SpellName = token
        end
    end

    return o
end

-- returns true if a buff was casted
function Buffs.RefreshSelfBuffs()
    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        if refreshBuff(buffItem, mq.TLO.Me.Name()) then
            -- end after first successful buff
            return true
        end
    end
    return false
end

function queryBot(peer, q)
    local fullQuery = peer .. ' -q ' .. q
    mq.cmd.dquery(fullQuery)
    mq.delay(1000, function()
        local state = mq.TLO.DanNet(peer).Query(q).Received()
        --print("delay ", peer, " q", q, state)
        if state == nil then
            return false
        end
        return state > 0
    end)

    local res = mq.TLO.DanNet.Q()
    --print("  bot query ",q, " == ", res)
    return res
end


-- refreshes buff on self or another bot, returns true if buff was cast
function refreshBuff(buffItem, botName)

    --print("refreshBuff ", buffItem, ", botName:",botName)

    local spawn = mq.TLO.Spawn("pc =" .. botName)
    --print("PC MATCH", botName, " ", spawn, " ", type(spawn))
    if tostring(spawn) == "NULL" then
        --print("SKIP BUFFING, NOT IN ZONE ", botName)
        return false
    end
    local spawnID = spawn.ID()

    if not spellConfigAllowsCasting(buffItem, botName) then
        return false
    end

    local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!

    local spell = getSpellFromBuff(spellConfig.SpellName) -- XXX parse this once on script startup too, dont evaluate all the time !
    if spell == nil then
        mq.cmd.dgtell("Buffs.refreshBuff: getSpellFromBuff ", buffItem, " FAILED")
        mq.cmd.beep(1)
        return false
    end

    -- only refresh fading & missing buffs
    if mq.TLO.Me() == botName then
        if mq.TLO.Me.Buff(spell.Name)() ~= nil and mq.TLO.Me.Buff(spell.Name).Duration.Ticks() > 4 then
            return false
        end
    else
        -- check buff time remaining on this bot

        -- XXX LATER: rework to use /dobserve
        local res = queryBot(botName, 'Me.Buff["' .. spell.Name() .. '"].Duration.Ticks')
        if (res ~= nil and res ~= "NULL") and tonumber(res) > 4 then
            --print("SKIPPING BUFF WITH DURATION ", botName, ": ", spellConfig.SpellName, " ", tonumber(res) )
            return false
        end
    end

    print("buffing bot ", botName, " (id ",spawnID,"): ", spellConfig.SpellName)
    castSpell(spellConfig.SpellName, spawnID)
    return true
end




-- XXX refactor more. need to be usable with pet buffs too (should take a spawn id instead of bot name, and then derive if its a bot in zone or a pet)
-- returns bool
function spellConfigAllowsCasting(buffItem, botName)

    local spawn = mq.TLO.Spawn("pc =" .. botName)
    --print("PC MATCH", botName, " ", spawn, " ", type(spawn))
    if tostring(spawn) == "NULL" then
        --print("SKIP BUFFING, NOT IN ZONE ", botName)
        return false
    end
    local spawnID = spawn.ID()

    local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!

    local spell = getSpellFromBuff(spellConfig.SpellName) -- XXX parse this once on script startup too, dont evaluate all the time !
    if spell == nil then
        mq.cmd.dgtell("Buffs.refreshBuff: getSpellFromBuff ", buffItem, " FAILED")
        mq.cmd.beep(1)
        return false
    end

    -- AERange is used for group spells
    if spell.TargetType() == "Group v2" then
        if spawn.Distance() >= spell.AERange() then
            mq.cmd.dgtell("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", botName, " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    else
        if spell.TargetType() ~= "Self" and spawn.Distance() >= spell.Range() then
            mq.cmd.dgtell("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", botName, " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    end

    if spellConfig.Shrink ~= nil and mq.TLO.Me.Height() <= 2.03 then
        --print("will not shrink myself with ", spellConfig.SpellName, " because my height is already ", mq.TLO.Me.Height())
        return false
    end

    if spellConfig.MinMana ~= nil then
        if mq.TLO.Me.PctMana() < tonumber(spellConfig.MinMana) then
            print("SKIP BUFFING, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig.MinMana)
            return false
        end
    end
    if spellConfig.CheckFor ~= nil then
        -- if we got this buff on, then skip.
        if mq.TLO.Me() ~= botName then
            -- XXX LATER: rework to use /dobserve
            local res = queryBot(botName, 'Me.Buff["' .. spellConfig.CheckFor .. '"].ID')

            if res ~= "NULL" then
                print("SKIP BUFFING of ", spellConfig.SpellName, ", target bot ", botName, " has ", spellConfig.CheckFor)
                return false
            end
        else
            if mq.TLO.Me.Buff(spellConfig.CheckFor)() ~= nil then
                print("SKIP BUFFING ", spellConfig.SpellName, ", I have buff ", spellConfig.CheckFor, " on me")
                return false
            end
        end
    end
    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
            mq.cmd.dgtell("SKIP BUFFING ", spellConfig.SpellName, ", I'm out of reagent ", spellConfig.Reagent)
            return false
        end
    end

    return true
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

-- helper for casting spell, clicky, AA, combat ability
function castSpell(name, spawnId)
    if mq.TLO.Me.CombatAbility(name)() ~= nil then
        mq.cmd.dgtell("castSpell: /disc", name)
        mq.cmd.disc(name)
    else
        if mq.TLO.Me.Class.ShortName() == "BRD" then
            mq.cmd.dgtell("castSpell: /medley queue", name)
            mq.cmd.medley('queue "' .. name .. '"')
        else
            castSpellRaw(name, spawnId, "-maxtries|2")
        end
    end
end

function castSpellRaw(name, spawnId, extraArgs)
    if spawnId == nil then
        mq.cmd.dgtell("castSpellRaw: called with nil spawnId, name = ", name, " extraArgs=", extraArgs)
        mq.cmd.beep(1)
        return
    end
    local castingArg = '"' .. name .. '" -targetid|'.. spawnId .. ' ' .. extraArgs
    mq.cmd.dgtell("castSpell: /casting", castingArg)
    mq.cmd.casting(castingArg)
end

function getSpellFromBuff(name)
    if mq.TLO.FindItem(name).ID() ~= nil then
        return mq.TLO.FindItem(name).Clicky.Spell
    elseif mq.TLO.Me.Book(name)() ~= nil then
        return mq.TLO.Me.Book(mq.TLO.Me.Book(name))
    elseif mq.TLO.Me.AltAbility(name)() ~= nil then
        return mq.TLO.Me.AltAbility(name).Spell
    elseif mq.TLO.Me.CombatAbility(name)() ~= nil then
        return mq.TLO.Me.CombatAbility(mq.TLO.Me.CombatAbility(name))
    else
        mq.cmd.dgtell("getSpellFromBuff ERROR: can't find buff", name)
        mq.cmd.beep(1)
        return nil
    end
end

-- memorizes all spells listed in character settings.gems in their correct position
function memorizeListedSpells()
    if botSettings.settings.gems == nil then
        print("no gems configured")
        return
    end
    for k, n in pairs(botSettings.settings.gems) do
        print("gem ",k, " n ",n)
    end
end

return Buffs

