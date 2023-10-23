---@type PeerSettings
local settings = { }

settings.gems = {
    ["Jonthan's Whistling Warsong"] = 1,
    ["Chant of Battle"] = 2,

    ["Elemental Rhythms"] = 6, -- fr, cr, magic resist
    ["Purifying Rhythms"] = 7, -- pr, dr, magic resist
    ["brd_runspeed"] = 8,
}

settings.songs = {
    general = {
        -- PERCUSSION
        "brd_runspeed", -- XXX resolve

        -- PERCUSSION
        "Purifying Rhythms",

        -- SINGING
        --"Jonthan's Whistling Warsong",

        -- PERCUSSION
        "Chant of Battle",
    },
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,
}

return settings
