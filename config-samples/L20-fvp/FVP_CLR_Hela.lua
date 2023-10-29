---@type PeerSettings
local settings = { }

settings.debug = true

settings.autoloot = false

settings.gems = {
    ["Healing"] = 1,
    ["clr_ac"] = 2,
    ["clr_symbol"] = 3,
    ["Divine Aura"] = 4,

    ["clr_magic_nuke"] = 6,
    ["Cure Disease"] = 7,
    ["clr_aegolism"] = 8,
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
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
    nukes = {
        main = {
            --"clr_magic_nuke/NoAggro/Gem|7/MinMana|30/Not|raid",
        }
    },
}

return settings
