---@type PeerSettings
local settings = { }

settings.gems = {
    ["Burn"] = 1,
    ["Summon Drink"] = 2,
    ["Summon Food"] = 3,
    ["Burnout"] = 4, -- pet buff

    ["Shield of Fire"] = 6, -- ds
    ["Minor Summoning: Water"] = 7, -- pet
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
            "Burn/MaxHP|95/NoAggro/MinMana|20",
        },
    },
}

settings.pet = {
    heals = {
    },

    buffs = {
        "Burnout",
    },

    taunt = false, -- XXX impl
}

return settings
