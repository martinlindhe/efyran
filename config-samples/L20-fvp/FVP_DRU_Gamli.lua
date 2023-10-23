---@type PeerSettings
local settings = { }

settings.debug = true

settings.autoloot = true

settings.gems = {
    ["dru_heal"] = 1,
    ["dru_snare"] = 2,
    ["dru_runspeed"] = 3,
    ["dru_fire_nuke"] = 4,

    ["dru_str"] = 6,
    ["dru_poison_cure"] = 7,
    ["dru_skin"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "dru_self_ds/MinMana|50",
}

settings.healing = {
    life_support = {
        "dru_heal/HealPct|80/MinMana|5",
    },

    tanks = {
        "Zoro",
        "Nullius",
    },

    tank_heal = {
        "dru_heal/HealPct|68/MinMana|5",
    },

    all_heal = {
        "dru_heal/HealPct|65/MinMana|15",
    },
}

settings.assist = {
    nukes = {
        main = {
            "dru_fire_nuke/MaxHP|90/NoAggro/MinMana|40",
        },
    },

    dots = {
        "dru_snare/MaxHP|50/MaxTries|2/Not|raid",
    },
}

return settings
