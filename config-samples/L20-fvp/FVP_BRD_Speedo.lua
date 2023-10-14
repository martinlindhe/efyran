---@type PeerSettings
local settings = { }

settings.gems = {
    ["Jonthan's Whistling Warsong"] = 1,
    ["Chant of Battle"] = 2,

    ["Elemental Rhythms"] = 6, -- fr, cr, magic resist
    ["Purifying Rhythms"] = 7, -- pr, dr, magic resist
    ["Selo's Accelerando"] = 8,
}

settings.songs = {
    general = {
        -- PERCUSSION
        "Selo's Accelerando",

        -- PERCUSSION
        "Purifying Rhythms",

        -- SINGING
        --"Jonthan's Whistling Warsong",

        -- PERCUSSION
        "Chant of Battle",
    },
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
        --"Distillate of Divine Healing XI/HealPct|10",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,
}

return settings
