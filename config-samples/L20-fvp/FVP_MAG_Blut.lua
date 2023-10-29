---@type PeerSettings
local settings = { }

settings.autoloot = true

settings.gems = {
    ["mag_fire_nuke"] = 1,
    ["mag_pet_weapon"] = 2,
    --["mag_pet_heal"] = 3,
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
    --type = "Melee",
    nukes = {
        main = {
            "mag_fire_nuke/MaxHP|95/NoAggro",
        },
    },
}

settings.pet = {
    heals = {
        --"mag_pet_heal/HealPct|40",
    },
    buffs = {
        "mag_pet_haste",
    },
    taunt = false,
}

return settings
