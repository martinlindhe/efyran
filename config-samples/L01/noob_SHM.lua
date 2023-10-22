---@type PeerSettings
local settings = { }

settings.gems = {
    ["Minor Healing"] = 1,
}

settings.swap = {
    main = "",
}

settings.healing = {
    life_support = {
    },

    tanks = {
        "Knullius",
    },

    tank_heal = {
        "Minor lib/healing/HealPct|45/MinMana|5",
    },

    all_heal = {
        "Minor lib/healing/HealPct|44/MinMana|20",
    },

    ["who_to_heal"] = "Tanks/All",
}

settings.self_buffs = {
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,
}

return settings
