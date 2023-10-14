---@type PeerSettings
local settings = { }

settings.gems = {
    ["Healing"] = 1,
    ["Burst of Flame"] = 2,

    ["Dexterous Aura"] = 4,

    ["Cure Poison"] = 6,
    ["Cure Disease"] = 7,
    ["Strengthen"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
        "Healing/HealPct|80/MinMana|5",
    },

    tanks = {
        "Zoro",
        "Nullius",
    },

    tank_heal = {
        "Healing/HealPct|70/MinMana|5",
    },

    all_heal = {
        "Healing/HealPct|63/MinMana|5",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,

    nukes = {
        main = {
            --"Burst of Flame/NoAggro/MinMana|20",
        },
    },
}

return settings
