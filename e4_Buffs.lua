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
function Buffs.RefreshBuffs()
    --print('-- RefreshBuffs ', mq.TLO.Me.Class.ShortName, ' ', mq.TLO.Time)

    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        local skip = false
        local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!
        if spellConfig["MinMana"] ~= nil then
            if mq.TLO.Me.PctMana() < tonumber(spellConfig["MinMana"]) then
                print("SKIP BUFFING, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig["MinMana"])
                skip = true
            end
        end
        if spellConfig["CheckFor"] ~= nil then
            -- if we got this buff on, then skip.
            if mq.TLO.Me.Buff(spellConfig["CheckFor"])() ~= nil then
                print("SKIP BUFFING ", spellConfig.SpellName, ", I have buff ", spellConfig["CheckFor"], " on me")
                skip = true
            end
        end
        if spellConfig["Reagent"] ~= nil then
            -- if we lack this item, then skip.
            if mq.TLO.FindItemCount("=" .. spellConfig["Reagent"])() == 0 then
                mq.cmd.dgtell("SKIP BUFFING ", spellConfig.SpellName, ", I'm out of reagent ", spellConfig["Reagent"])
                skip = true
            end
        end

        local spell = getSpellFromBuff(spellConfig.SpellName) -- XXX parse this once on script startup too, dont evaluate all the time !
        if spell == nil then
            mq.cmd.dgtell("Buffs.RefreshBuffs: getSpellFromBuff ",buffItem, " FAILED")
            return
        end

        -- print("considering buffing ", spell)

        if not skip then
            -- refresh missing buffs or ones fading within 4 ticks
            if mq.TLO.Me.Buff(spell.Name())() == nil or mq.TLO.Me.Buff(spell.Name()).Duration.Ticks() <= 4 then
                print("Refreshing buff ", spell.Name())

                castSpell(spellConfig.SpellName)

                -- end loop after first successful buff
                return true
            end
        end
    end
    return false
end

function Buffs.RefreshAura()
    if Buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil then
        return
    end
    castSpell(Buffs.aura)
end

-- helper for casting spell, clicky, AA, combat ability. auto handles bard twist. XXX
function castSpell(name)
    local spell = getSpellFromBuff(name)

    -- XXX check_ready and abort if spell is on a longer cooldown (with text error). like DI

    if mq.TLO.Me.CombatAbility(name)() ~= nil then
        mq.cmd.dgtell("castSpell: /disc", name)
        mq.cmd.disc(name)
    else
        if mq.TLO.Me.Class.ShortName() == "BRD" then
            mq.cmd.dgtell("castSpell: /medley queue", name)
            mq.cmd.medley('queue "' .. name .. '"')
        else
            local castingArg = ""
            if spell.TargetType() == "Self" then
                castingArg = '"' .. name .. '"'
            else
                castingArg = '"' .. name .. '" -targetid|'.. mq.TLO.Me.ID()
            end
            mq.cmd.dgtell("castSpell: /casting", castingArg)
            mq.cmd.casting(castingArg)
        end
    end
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

