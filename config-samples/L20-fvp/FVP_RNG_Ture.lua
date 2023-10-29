---@type PeerSettings
local settings = { }

settings.autoloot = true

settings.weapons = {
    main = {
        mainhand = "Fine Steel Scimitar",
        offhand = "Pugius",
    },
}

settings.gems = {
    ["rng_heal"] = 1,

    ["rng_snare"] = 7,
    ["rng_self_ds"] = 8, -- ac + ds
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "rng_self_ds",
}

settings.healing = {
    life_support = {
        "rng_heal/HealPct|30",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,

    abilities = {
        "Kick",
    },

    dots = {
        "rng_snare/MaxHP|40/MaxTries|2/Not|raid",
    },

}

return settings
