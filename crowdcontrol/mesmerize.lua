local mq = require 'mq'
local log = require 'knightlinc/Write'
local broadcast = require 'broadcast/broadcast'
local target = require 'target'
local assist = require("e4_Assist")
local spellGroups = require 'e4_SpellGroups'
local botSettings = require 'e4_BotSettings'
local ezmq = require("ezmq/spell")
local mezzSpells = require("crowdcontrol/mesmerize_spells")
local repository = require 'crowdcontrol/repository'

local immunities = {}

local function getMezzSpellGroup(category)
    local classMesmermizeSpells = mezzSpells[mq.TLO.Me.Class.ShortName()]
    if classMesmermizeSpells == nil or classMesmermizeSpells[category] == nil then
        return nil
    end

    return spellGroups[classMesmermizeSpells[category]]
end

local function getMezzSpell(category)
    local spellGroup = getMezzSpellGroup(category)
    if not spellGroup then
        return nil
    end

    for _, mezzSpell in ipairs(spellGroup) do
        if ezmq.is_memorized(mezzSpell.Name) then
            return mezzSpell
        end
    end

    return nil
end

local function canCast(spell)
    if is_stunned() then
        log.Debug("Unable to cast <%s>, I am stunned.", spell.Name())
      return false
    end

    if ezmq.is_casting() then
        log.Debug("Unable to cast <%s>, already casting <%s>.", spell.Name(), me.Casting.Name())
      return false
    end

    local me = mq.TLO.Me
    if spell.Mana() > me.CurrentMana() then
        log.Debug("Unable to cast <%s>, not enough mana.", spell.Name())
      return false
    end

    if not ezmq.is_spell_ready(spell.Name()) then
        return false
    end

    return true
end


local function canCastOn(spawn, spell)
    if not canCast(spell) then
        return false
    end

    if spawn.Distance() > spell.Range() then
        return false
    end

    if spawn.Type() == "Corpse" then
        return false
    end

    if not spawn.Aggressive() then
        return false
    end

    if spell.MaxLevel() < spawn.Level() then
        return false
    end

    local currentDebuffs = repository.TryGet(spawn, spell)
    for _, currentDebuff in pairs(currentDebuffs) do
        if currentDebuff.ID() == spell.ID() then
            return false
        elseif not mq.TLO.Spell(currentDebuff.spellId).WillStack(spell.Name()) then
            return false
        end
    end

    return true
end

local function doSingleMezz()
    local mezzSpell = getMezzSpell("single_mez")
    if not mezzSpell then
      log.Error("No mezz spell defined!")
      return
    end

    local mqSpell = ezmq.get_spell(mezzSpell.Name)

    local maTargetId = assist.targetID
    local mezzTargetCount = mq.TLO.SpawnCount("npc los targetable radius 100")()
    for i=1, mezzTargetCount do
        local mezzSpawn = mq.TLO.NearestSpawn(i, "npc los targetable radius 100") --[[@as spawn]]
        local mezzName = mezzSpawn.Name()
        if immunities and immunities[mezzName] then
            log.Info("[%s] is immune to mesmerize, skipping.", mezzName)
        elseif maTargetId ~= mezzSpawn.ID() and target.IsMaybeAggressive(mezzSpawn --[[@as spawn]]) and canCastOn(mezzSpawn, mqSpell) then
            if castSpellAbility(mezzSpawn.ID(), mezzSpell) then
                log.Info("Attempting to mezz [%s] with <%s>.", mezzName, mezzSpell.Name)
                local castResult = mq.TLO.Cast.Result()
                if castResult == "CAST_IMMUNE" then
                    immunities[mezzName] = "immune"
                elseif castResult == "CAST_RESIST" then
                    log.Info("[%s] resisted <%s>, retrying next run.", mezzName, mezzSpell.Name)
                elseif castResult == "CAST_SUCCESS" then
                    log.Info("[%s] mezzed with <%s>.", mezzName, mezzSpell.Name)
                    broadcast.Success("[%s] mezzed with <%s>.", mezzName, mezzSpell.Name)
                    repository.Add(mezzSpawn, mqSpell)
                else
                    log.Info("[%s] <%s> mezz failed with. [%s]", mezzName, mezzSpell.Name, castResult)
                end
            end
        end
    end
end


local function tick()
    if botSettings.settings.automezz ~= true
    or (not is_brd() and not is_enc()) then
        return
    end

    doSingleMezz()
end

return {
    Tick = tick
}
