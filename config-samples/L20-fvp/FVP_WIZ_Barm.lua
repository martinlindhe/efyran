---@type PeerSettings
local settings = { }

settings.loot = false -- holds Runes so inventory gets full

settings.gems = {
    ["wiz_fire_nuke"] = 1,
    ["Flame Shock"] = 2,

    ["wiz_self_shield"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "wiz_self_shield",
}

settings.healing = {
    life_support = {
    },
}

settings.assist = {
    nukes = {
        main = {
            "wiz_fire_nuke/Delay|6/MaxHP|95/NoAggro/Only|group raid",
            "Flame Shock/Delay|10/MaxHP|95/NoAggro/Not|group raid", -- avoid xp steal with lesser nuke
        },
    },
}

return settings
