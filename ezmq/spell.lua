
-- returns true if `name` is a spell currently memorized in a gem
---@param name string
---@return boolean
local function is_memorized(name)
    return mq.TLO.Me.Gem(mq.TLO.Spell(name).RankName())() ~= nil
end

-- Is spell in my spellbook?
---@param name string
---@return boolean
local function has_spell(name)
    if have_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names.
        -- We work around this by pretending to lack those spells if we have the AA.
        -- Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        return false
    end

    return mq.TLO.Me.Book(mq.TLO.Spell(name).RankName())() ~= nil
end


---@param name string
---@return spell|nil
function get_spell(name)
    local spell = mq.TLO.Spell(name)
    if spell ~= nil then
        return mq.TLO.Spell(spell.RankName())
    end
    return nil
end

return {
    is_memorized = is_memorized,
    has_spell = has_spell,
    get_spell = get_spell,
}
