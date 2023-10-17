local mq = require 'mq'
local log = require 'knightlinc/Write'
local broadcast = require 'broadcast/broadcast'
local target = require 'target'
local assist = require("e4_Assist")
local mezzSpells = require("crowdcontrol/mesmerize_spells")
local repository = require 'crowdcontrol/repository'

local immunities = {}

local function getMezzSpell(category)
    local classMesmermizeSpells = mezzSpells[mq.TLO.Me.Class.ShortName()]
    if classMesmermizeSpells == nil or classMesmermizeSpells[category] == nil then
        return
    end

    return classMesmermizeSpells[category]
end


local function canCastOn(spawn, spell)
    if spawn.Distance() > spell.Range() then
      return false
    end

    if spawn.Type() == "Corpse" then
      return false
    end

    if not spawn.Aggressive() then
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

local function doMezz()
    local mezzSpell = getMezzSpell("single_mez")
    if not mezzSpell then
      log.Error("No mezz spell defined!")
      return
    end

    local maTargetId = assist.targetID
    local mezzTargetCount = mq.TLO.SpawnCount("npc los targetable radius 100")()

    for i=1, mezzTargetCount do
      local mezzSpawn = mq.TLO.NearestSpawn(i, "npc los targetable radius 100") --[[@as spawn]]
      local mezzName = mezzSpawn.Name()
      if immunities and immunities[mezzName] then
        log.Info("[%s] is immune to mesmerize, skipping.", mezzName)
      elseif maTargetId ~= mezzSpawn.ID() and target.IsMaybeAggressive(mezzSpawn --[[@as spawn]]) then
        if target.EnsureTarget(mezzSpawn.ID()) and performSpellAbility(mq.TLO.Target.ID(), mezzSpell) then
          log.Info("Attempting to mezz [%s] with <%s>.", mezzName, mezzSpell.Name())
          local castResult = mq.TLO.Cast.Result()
          if castResult == "CAST_IMMUNE" then
            immunities[mezzName] = "immune"
          elseif castResult == "CAST_RESIST" then
            log.Info("[%s] resisted <%s> %d times, retrying next run.", mezzName, mezzSpell.Name(), mezzSpell.MaxResists)
          elseif castResult == "CAST_SUCCESS" then
            log.Info("[%s] mezzed with <%s>.", mezzName, mezzSpell.Name())
            broadcast.Success("[%s] mezzed with <%s>.", mezzName, mezzSpell.Name())
            repository.Add(mezzSpawn, mezzSpell)
          else
            log.Info("[%s] <%s> mezz failed with. [%s]", mezzName, mezzSpell.Name(), castResult)
          end
        end
      end
    end
  end
