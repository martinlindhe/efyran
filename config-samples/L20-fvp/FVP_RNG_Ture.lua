---@type PeerSettings
local settings = { }

settings.gems = {
    ["Minor Healing"] = 1,

    ["Snare"] = 7,
    ["Thistlecoat"] = 8, -- ac + ds
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "Thistlecoat",
}

settings.healing = {
    life_support = {
        --"Distillate of Divine Healing XI/HealPct|10",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,

    abilities = {
        "Kick",
    },

    dots = {
        "Snare/MaxHP|30/MaxTries|2/Not|raid",
    },

}

return settings
