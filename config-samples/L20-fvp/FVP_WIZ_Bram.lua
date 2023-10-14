---@type PeerSettings
local settings = { }

settings.gems = {
    ["Fire Bolt"] = 1,

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
            "Fire Bolt/MaxHP|75/NoAggro/MinMana|20",
        },
    },
}

return settings
