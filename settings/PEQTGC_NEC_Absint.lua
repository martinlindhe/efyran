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
        -- haste
        -- L23 Intensify Death (25-33 str, 21-30% haste, 6-8 ac)
        -- L35 Augment Death (37-45 str, 45-55% haste, 9-12 ac
        -- L55 Augmentation of Death (52-55 str, 65% haste, 14-15 ac)
        -- L62 Rune of Death (65 str, 70% haste, 18 ac)
        -- L67 Glyph of Darkness (5% skills dmg mod, 84 str, 70% haste, 23 ac)
        -- L72 Sigil of the Unnatural (6% skills dmg mod, 96 str, 70% haste, 28 ac)
        -- L77 Sigil of the Aberrant Rk. II (10% skills dmg mod, 122 str, 70% haste, 36 ac)
        "Glyph of Darkness/MinMana|30",

        "Tiny Companion/Shrink",

        --"Algae Covered Stiletto/Shrink", -- XXX farm this clicky in powater
    },
}

return settings
