---@type PeerSettings
local settings = { }

settings.gems = {
    ["Fire Bolt"] = 1,

    ["Shielding"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "Shielding",
}

settings.healing = {
    life_support = {
        --"Distillate of Divine Healing XI/HealPct|10",
    },
}

settings.assist = {
    --type = "Melee",
    --engage_percent = 98,

    nukes = {
        main = {
            "Fire Bolt/MaxHP|75/NoAggro/MinMana|20",
        },
    },
}

return settings
