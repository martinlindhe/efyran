---@type PeerSettings
local settings = { }

settings.loot = true

settings.gems = {
    ["shm_heal"] = 1,
    ["shm_cold_nuke"] = 2,

    ["shm_dex"] = 4,

    ["shm_poison_cure"] = 6,
    ["shm_slow"] = 7,
    ["shm_str"] = 8,
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
        "shm_heal/HealPct|80/MinMana|5",
    },

    tanks = {
        "Zoro",
        "Nullius",
    },

    tank_heal = {
        "shm_heal/HealPct|70/MinMana|5",
    },

    all_heal = {
        "shm_heal/HealPct|63/MinMana|5",
    },
}

settings.assist = {
    nukes = {
        main = {
            -- prefer mana to buffs
            "shm_cold_nuke/NoAggro/MinMana|70",
        },
    },
    debuffs = {
        "shm_slow/MinMana|90",
    },
}

return settings
