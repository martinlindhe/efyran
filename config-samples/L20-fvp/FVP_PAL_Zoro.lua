---@type PeerSettings
local settings = { }

settings.gems = {
    ["Light Healing"] = 1,

    ["Yaulp"] = 7,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
}

settings.combat_buffs = {
    "Yaulp",
}

settings.healing = {
    life_support = {
        "Light Healing/HealPct|50/MinMana|5",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 100,
    stick_point = "Front",
}

return settings
