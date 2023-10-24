local mq = require("mq")
local timer = require("lib/Timer")

--[[
    {
        [spawnId] = {
            [categoryId] = {
                [subCategoryId] = DebuffTracker
            }
        }
    }
]]

---@class DebuffTracker
---@field Spell spell
---@field Timer Timer

---@type { [number]: { [number]: { [number]: DebuffTracker[] } } }
local repository = {}

---@param debuffSpell spell
---@return number Recast time in milliseconds
local function createRecastTimer(debuffSpell)
    -- duration is number of ticks and one tick is 6 seconds
    local spellDuration = debuffSpell.Duration()*6*1000
    -- deduct cast time for refresh
    spellDuration = spellDuration - debuffSpell.CastTime()
    return spellDuration - 3000
  end

---@param spawn spawn
---@param spell spell
local function add (spawn, spell)
    local currentTrackers = repository[spawn.ID()]
    if not currentTrackers then
        currentTrackers = {
            [spell.CategoryID()] = {
                [spell.SubcategoryID()] = {
                    Spell = spell,
                    Timer = timer.new(createRecastTimer(spell))
                }
            }
        }

        return
    end

    local categories = currentTrackers[spell.CategoryID()]
    if not categories then
        categories[spell.CategoryID()] = {
            [spell.SubcategoryID()] = {
                Spell = spell,
                Timer = timer.new(createRecastTimer(spell))
            }
        }

        return
    end

    local subCategories = categories[spell.CategoryID()]
    if not subCategories then
        subCategories[spell.SubcategoryID()] = {}
    end

    table.insert(subCategories, {
        Spell = spell,
        Timer = timer.new(createRecastTimer(spell))
    })

end

---@param spawn spawn
---@param spell spell
---@return table<spell>
local function tryGet (spawn, spell)
    local currentDebuffs = {}
    local currentTrackers = repository[spawn.ID()]
    if not currentTrackers then
        return currentDebuffs
    end

    local categories = currentTrackers[spell.CategoryID()]
    if not categories then
        return currentDebuffs
    end

    local subCategories = categories[spell.SubcategoryID()]
    if not subCategories then
        return currentDebuffs
    end

    for _, debuff in pairs(subCategories) do
        if debuff.Timer:expired() then
            table.insert(currentDebuffs, debuff.Spell)
        end
    end

    return currentDebuffs
end

local function clear()
    repository = {}
end

return {
    Add = add,
    Clear = clear,
    TryGet = tryGet
}
