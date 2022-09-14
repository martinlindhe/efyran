local settings = { }

settings.self_buffs = {
}

settings.pet = {
    ["heals"] = {
        -- pet heals:
        -- L07 Mend Bones (22-32 hp)
        -- L26 Renew Bones (121-175 hp)
        -- L64 Touch of Death (1190-1200 hp, -24 dr, -24 pr, -24 curse, cost 290 mana)
        -- L69 Dark Salve (1635-1645 hp, -28 dr, -28 pr, -28 curse, cost 358 mana)
        -- L6x Replenish Companion AA Rank 1
        -- L69 Replenish Companion AA Rank 3
        -- L73 Chilling Renewal (2420-2440 hp, -34 dr, -34 pr, -34 curse, -8 corruption, cost 504 mana)

        "Replenish Companion/HealPct|40",

        "Dark Salve/HealPct|60",
    },

    ["buffs"] = {
        "Glyph of Darkness/MinMana|30", -- pet haste

        "Algae Covered Stiletto/Shrink", -- XXX farm this clicky in powater
    },
}

return settings
