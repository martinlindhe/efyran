---@type PeerSettings
local settings = { }

settings.gems = {
    ["Burn"] = 1,
    ["Summon Drink"] = 2,
    ["Summon Food"] = 3,
    ["Burnout"] = 4, -- pet buff

    ["Shield of Fire"] = 6, -- ds
    ["Minor Summoning: Water"] = 7, -- pet
    ["mag_self_shield"] = 8,
}

settings.self_buffs = {
    "mag_self_shield",
}

settings.healing = {
    life_support = {
    },
}

settings.assist = {
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
