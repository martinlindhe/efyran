---@type PeerSettings
local settings = { }

settings.debug = true

settings.gems = {
    ["Healing"] = 1,

    ["Symbol of Transal"] = 3,
    ["Divine Aura"] = 4,

    ["Cure Poison"] = 6,
    ["Cure Disease"] = 7,
    ["Courage"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
        -- quick heals:
        -- L01 Minor Healing (10 hp, 1s cast, 10 mana)
        -- L05 Light Healing (26-33 hp, 2s cast, 25 mana)
        -- L14 Healing (14-100 hp, 3s cast, 60 mana)
        "Healing/HealPct|80/MinMana|5",

        -- 15 min reuse, 18s invuln
        "Divine Aura/HealPct|40/MinMobs|2/Not|raid",
    },

    tanks = {
        "Zoro",
        "Nullius",
    },

    tank_heal = {
        "Healing/HealPct|85/MinMana|5",
    },

    all_heal = {
        "Healing/HealPct|75/MinMana|20",
    },
}

settings.assist = {
    --type = "Melee",
    --engage_percent = 98,
}

return settings
