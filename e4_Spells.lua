
-- parses a spell/ability etc line with properties, returns a object
function parseSpellLine(s)
    -- Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction

    local o = {}
    local idx = 0

    --print("parseSpellLine ", s)

    -- split on / separator
    for token in string.gmatch(s, "[^/]+") do
        idx = idx + 1
        --print("token", idx, token)

        -- separate token on | "key" + "val"
        local found, _ = string.find(token, "|")
        if found then
            local key = ""
            local subIndex = 0
            for v in string.gmatch(token, "[^|]+") do
                if subIndex == 0 then
                    key = v
                end
                if subIndex == 1 then
                    --print(key, " = ", v)
                    o[key] = v
                end
                subIndex = subIndex + 1
            end
        else
            if idx == 1 then
                o.Name = token
            else
                -- expanding boolean property
                o[token] = true
            end
        end
    end

    return o
end

auraNames = {
    "Myrmidon's Aura",      -- WAR/55: Increase Proc Modifier by 1%, Slot 12: 60 AC
    "Champion's Aura",      -- WAR/70: Increase Proc Modifier by 2%, Slot 12: 90 AC
    "Disciple's Aura",      -- MNK/55: 5% riposte, 5% parry, 5% block
    "Master's Aura",        -- MNK/70: 10% riposte, 10% parry, 10% block
    "Aura of Rage",         -- BER/55: Increase melee Critical Damage by 20%
    "Bloodlust Aura",       -- BER/70: Increase melee Critical Damage by 30%
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
    for k, n in pairs(auraNames) do
        if mq.TLO.Me.CombatAbility(n)() or mq.TLO.Me.Book(n)() then
            aura = n
        end
    end
    return aura
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
function refreshBuff(buffItem, spawn)

    --print("refreshBuff ", buffItem, ", target Name:", spawn.CleanName())

    if spawn.Type() ~= "PC" and spawn.Type() ~= "Pet" then
        print("will not buff ", spawn.Type(), " ", spawn.Name(), ": ", spawn.CleanName())
        if spawn.Type() ~= "Corpse" then
            mq.cmd.dgtell("all WILL NOT BUFF ", spawn.Type(), ": ", spawn.CleanName())
            mq.cmd.beep(1)
        end
        return false
    end

    local spawnID = spawn.ID()

    if not spellConfigAllowsCasting(buffItem, spawn) then
        --print("wont allow casting ", buffItem)
        return false
    end

    local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!

    local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
    if spell == nil then
        mq.cmd.dgtell("refreshBuff: getSpellFromBuff ", buffItem, " FAILED")
        mq.cmd.beep(1)
        return false
    end

    local spellName = spellConfig.Name
    if is_spell_in_book(spellConfig.Name) then
        spellName = spell.RankName()
    end

    -- only refresh fading & missing buffs
    if mq.TLO.Me.ID() == spawn.ID() then
        -- IMPORTANT: on live, f2p restricts all spells to rank 1, so we need to look for both forms
        if have_buff(spell.RankName) and mq.TLO.Me.Buff(spell.RankName).Duration.Ticks() >= 6 then
            --print("target have ranked buff with remaining ticks:", mq.TLO.Me.Buff(spell.RankName).Duration.Ticks())
            return false
        end
        if have_buff(spell.Name) and mq.TLO.Me.Buff(spell.Name).Duration.Ticks() >= 6 then
            --print("target have buff with remaining ticks:", mq.TLO.Me.Buff(spell.Name).Duration.Ticks())
            return false
        end

        if is_spell_in_book(spellName) and not spell.Stacks() then
            mq.cmd.dgtell("all ERROR cannot selfbuff with ", spellName, " (dont stack with current buffs)")
            return false
        end
    elseif spawn.Type() == "Pet" and spawn.ID() == mq.TLO.Me.Pet.ID() then
        -- IMPORTANT: on live, f2p restricts all spells to rank 1, so we need to look for both forms

        if mq.TLO.Me.Pet.Buff(spell.RankName)() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.RankName)).Duration.Ticks() >= 6 then
            print("refreshBuff: SKIP PET BUFFING ", spell.RankName, ", duration is ", mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.RankName)).Duration.Ticks(), " ticks")
            return false
        end

        if mq.TLO.Me.Pet.Buff(spell.Name)() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name)).Duration.Ticks() >= 6 then
            print("refreshBuff: SKIP PET BUFFING ", spell.Name, ", duration is ", mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name)).Duration.Ticks(), " ticks")
            return false
        end
        if is_spell_in_book(spellName) and spell.StacksPet() then
            --mq.cmd.dgtell("all ERROR cannot buff pet with ", spellName, " (dont stack with current buffs)")
            return false
        end
    else
        mq.cmd.dtell("all FATAL ERROR refreshBuff called with invalid spawn ", spawn.Name())
        return
    end

    if not is_spell_ability_ready(spellName) and is_spell_in_book(spellName) and not is_memorized(spellName) then
        local gem = 5
        if spellConfig.Gem ~= nil then
            gem = spellConfig.Gem
        end
        --print("attempting to memorize ", spellName .. " ... GEM ", gem)
        mq.cmd.memorize('"'..spellName..'"', gem)
        mq.delay(3000) -- XXX 3s
    end

    if not have_item(spellConfig.Name) and mq.TLO.Me.CurrentMana() < spell.Mana() then
        print("SKIPPING BUFF, not enough mana. Have ", mq.TLO.Me.CurrentMana(), ", need ", spell.Mana() )
        return false
    end

    if is_alt_ability(spellName) and not is_alt_ability_ready(spellName) then
        --print("SKIPPING BUFF, AA ", spellName, " is not ready")
        return false
    end

    if spawn.Type() == "Pet" then
        print("Buffing \agmy pet ", spawn.CleanName(), "\ax with \ay", spellName)
    else
        print("Buffing \agmyself\ax with \ay", spellName)
    end
    castSpell(spellName, spawnID)
    return true
end

-- XXX refactor more. need to be usable with pet buffs too (should take a spawn id instead of bot name, and then derive if its a bot in zone or a pet)
-- returns bool
function spellConfigAllowsCasting(buffItem, spawn)

    if spawn == nil then
        mq.cmd.dgtell("all ERROR: spellConfigAllowsCasting called with nil spawn for ", buffItem)
        mq.cmd.beep(1)
        return
    end

    local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!

    local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
    if spell() == nil then
        mq.cmd.dgtell("spellConfigAllowsCasting: getSpellFromBuff ", buffItem, " FAILED. Query = '"..spellConfig.Name.."'")
        mq.cmd.beep(1)
        return false
    end

    --print("spellConfigAllowsCasting ", buffItem, " ", spawn)

    -- AERange is used for group spells
    if spell.TargetType() == "Group v2" then
        if spawn.Distance() >= spell.AERange() then
            print("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", spawn.CleanName(), " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    else
        if spell.TargetType() ~= "Self" and spawn.Distance() >= spell.Range() then
            print("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", spawn.CleanName(), " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    end

    if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Height() <= 2.04 then
        --print("will not shrink myself with ", spellConfig.Name, " because my height is already ", mq.TLO.Me.Height())
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
        if mq.TLO.Me() ~= spawn.CleanName() then
            -- XXX LATER: rework to use /dobserve
            local res = queryBot(spawn.CleanName(), 'Me.Buff["' .. spellConfig.CheckFor .. '"].ID')

            if res ~= "NULL" then
                print("SKIP BUFFING of ", spellConfig.Name, ", target bot ", spawn.CleanName(), " has ", spellConfig.CheckFor)
                return false
            end
        else
            if have_buff(spellConfig.CheckFor) or have_song(spellConfig.CheckFor) then
                --print("SKIP BUFFING ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
                return false
            end
        end
    end
    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
            mq.cmd.dgtell("SKIP BUFFING ", spellConfig.Name, ", I'm out of reagent ", spellConfig.Reagent)
            return false
        end
    end

    return true
end


-- helper for casting spell, clicky, AA, combat ability
function castSpell(name, spawnId)

    if mq.TLO.Me.CombatAbility(name)() ~= nil then
        --mq.cmd.dgtell("castSpell: /disc", name)
        mq.cmd('/disc', name)               -- NOTE: /disc argument must NOT use quotes
    elseif mq.TLO.Me.Ability(name)() then
        print("castSpell: /doability", name)
        mq.cmd('/doability "'..name..'"')   -- NOTE: /doability argument must use quotes
    else
        -- spell / aa

        if is_brd() and is_casting() then
            mq.cmd.twist("stop")
            mq.delay(20)
        end

        castSpellRaw(name, spawnId, "-maxtries|3")

        if is_brd() then
            local item = get_item(name)
            if item ~= nil then
                -- item click
                print("item click sleep, ", item.Clicky.CastTime(), " + ", item.Clicky.Spell.RecastTime() )
                mq.delay(item.Clicky.CastTime() + item.Clicky.Spell.RecastTime() + 1500) -- XXX recast time is 0
            else
                -- spell / AA
                local spell = get_spell(name)
                if spell ~= nil then
                    local sleepTime = spell.MyCastTime() + spell.RecastTime()
                    --print("spell sleep for '", spell.Name(), "', my cast time:", spell.MyCastTime(), ", recast time", spell.RecastTime(), " = ", sleepTime)
                    mq.delay(sleepTime)
                end
            end
            print("ME BARD castSpell ", name, " -- SO I RESUME TWIST!")
            mq.cmd.twist("start")
        end

    end
end

function castSpellRaw(name, spawnId, extraArgs)
    if extraArgs == nil then
        extraArgs = ""
    end
    if spawnId == nil then
        mq.cmd.dgtell("castSpellRaw FATAL ERROR: called with nil spawnId, name = ", name, " extraArgs=", extraArgs)
        mq.cmd.beep(1)
        return
    end

    --print("-- castSpellRaw " , name, " spawnId ", spawnId, ", extraArgs ", extraArgs)

    local castingArg = '"' .. name .. '" -targetid|'.. spawnId .. ' ' .. extraArgs
    --print("castSpellRaw: /casting", castingArg)
    mq.cmd.casting(castingArg)
end

-- returns datatype spell or nil if not found
function getSpellFromBuff(name)

    if mq.TLO.FindItem(name).ID() ~= nil then
        return mq.TLO.FindItem(name).Clicky.Spell
    elseif mq.TLO.Me.Book(mq.TLO.Spell(name).RankName) ~= nil then
        return mq.TLO.Spell(name)
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
    for name, gem in pairs(botSettings.settings.gems) do
        local spell = get_spell(name)
        if spell == nil then
            mq.cmd.dgtell("all FATAL ERROR cant memorize spell", name)
            mq.cmd.beep(1)
            return
        end
        local nameWithRank = spell.RankName()

        if mq.TLO.Me.Gem(gem).Name() ~= nameWithRank then
            -- This is unusual, if gems is correctly set up
            mq.cmd.dgtell("all Memorizing", nameWithRank, "in gem", gem)
            mq.cmd.memorize('"'..nameWithRank..'"', gem)
            -- sleep until spell is memorized
            mq.delay(200)
            mq.delay(5000, function()
                return mq.TLO.Window("SpellBookWnd").Open() == false
            end)
            mq.delay(200)
        end
    end
end

-- returns true if name is ready to use (spell, aa, ability or combat ability)
function is_spell_ability_ready(name)

    if not is_brd() and is_casting() then
        return false
    end

    if mq.TLO.Me.AltAbilityReady(name)()  then
        --print("is_spell_ability_ready aa TRUE", name)
        return true
    end

    if mq.TLO.Me.Gem(name)() ~= nil and mq.TLO.Me.SpellReady(name)() then
        --print("is_spell_ability_ready spell TRUE", name)
        return true
    end

    if mq.TLO.Me.CombatAbilityReady(name)() then
        --print("is_spell_ability_ready combat ability TRUE", name)
        return true
    end

    if mq.TLO.Me.AbilityReady(name)() then
        --print("is_spell_ability_ready ability TRUE", name)
        return true
    end

    if mq.TLO.FindItem(name).Clicky() ~= nil and mq.TLO.FindItem(name).Timer.Ticks() == 0 then
        --print("is_spell_ability_ready item TRUE", name)
        return true
    end

    return false
end

function known_spell_ability(name)

    if mq.TLO.Me.AltAbility(name)()  then
        --print("known_spell_ability aa TRUE", name)
        return true
    end

    if mq.TLO.Me.Spell(name)() then
        --print("known_spell_ability spell TRUE", name)
        return true
    end

    if mq.TLO.Me.CombatAbility(name)() then
        --print("known_spell_ability combat ability TRUE", name)
        return true
    end

    if mq.TLO.Me.Ability(name)() then
        --print("known_spell_ability ability TRUE", name)
        return true
    end

    if mq.TLO.FindItem("="..name)() ~= nil then
        --print("known_spell_ability item TRUE", name)
        return true
    end

    return false
end