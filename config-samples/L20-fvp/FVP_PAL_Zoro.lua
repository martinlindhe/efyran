---@type PeerSettings
local settings = { }

settings.debug = true

settings.gems = {
    ["pal_heal"] = 1,

    ["pal_yaulp"] = 7,
}

settings.self_buffs = {
}

settings.combat_buffs = {
    "pal_yaulp",
}

settings.healing = {
    life_support = {
        "pal_heal/HealPct|50/MinMana|5",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 100,
    stick_point = "Front",
}

return settings
