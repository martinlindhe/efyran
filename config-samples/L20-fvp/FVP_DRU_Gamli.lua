---@type PeerSettings
local settings = { }

settings.debug = true

settings.gems = {
    ["Healing"] = 1,
    ["Snare"] = 2,
    ["Spirit of Wolf"] = 3,
    ["Ignite"] = 4, -- nuke

    ["Cure Disease"] = 6,
    ["Cure Poison"] = 7,
    ["dru_skin"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "dru_self_ds/MinMana|80",
}

settings.healing = {
    life_support = {
        "lib/healing/HealPct|80/MinMana|5",
    },

    tanks = {
        "Zoro",
        "Nullius",
    },

    tank_heal = {
        "lib/healing/HealPct|68/MinMana|5",
    },

    all_heal = {
        "lib/healing/HealPct|65/MinMana|15",
    },
}

settings.assist = {
    --type = "Melee",

    nukes = {
        main = {
            "Ignite/MaxHP|90/NoAggro/MinMana|40",
        },
    },

    dots = {
        "Snare/MaxHP|30/MaxTries|2/Not|raid",
    },

}

return settings
