---@type PeerSettings
local settings = { }

settings.gems = {
    ["mag_fire_nuke"] = 1,
    ["Summon Drink"] = 2,
    ["Summon Food"] = 3,
    ["mag_pet_haste"] = 4,

    ["mag_ds"] = 6, -- ds
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
            "mag_fire_nuke/MaxHP|95/NoAggro/MinMana|20",
        },
    },
}

settings.pet = {
    heals = {
    },

    buffs = {
        "mag_pet_haste",
    },

    taunt = false, -- XXX impl
}

return settings
