---@type PeerSettings
local settings = { }

settings.gems = {
    ["wiz_fire_nuke"] = 1,

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
            "wiz_fire_nuke/MaxHP|90/NoAggro/MinMana|20",
        },
    },
}

return settings
