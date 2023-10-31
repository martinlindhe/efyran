---@type PeerSettings
local settings = { }

--settings.debug = true
settings.autoloot = true

settings.weapons = {
    main = {
        mainhand = "Dragoon Dirk",
        offhand = "Hand Drum",
    },
}

settings.gems = {
    ["brd_nuke"] = 1,
    ["Chant of Battle"] = 2,
    ["brd_haste"] = 3,

    --["Elemental Rhythms"] = 6, -- fr, cr, magic resist
    ["Purifying Rhythms"] = 6, -- pr, dr, magic resist

    ["brd_slow"] = 7,
    ["brd_runspeed"] = 8,
}

settings.songs = {
    general = {
        "brd_runspeed",             -- PERCUSSION
        "Purifying Rhythms",        -- PERCUSSION
        "brd_haste",                -- SINGING
        "Chant of Battle",          -- PERCUSSION
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
    engage_at = 98,

    nukes = {
        main = {
            "brd_nuke",
        }
    },
    debuffs = {
        "brd_slow",
    },
}

return settings
