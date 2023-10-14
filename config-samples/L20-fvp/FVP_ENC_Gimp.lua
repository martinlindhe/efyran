---@type PeerSettings
local settings = { }

settings.debug = true

settings.meditate = 50

settings.gems = {
    ["Weaken"] = 1,
    ["Languid Pace"] = 2, -- slow
    ["Mesmerize"] = 3, -- mez L55
    ["Lull"] = 4,

    ["Tashani"] = 6,
    ["Alacrity"] = 7,
    --["Juli's Animation"] = 7, -- pet
    ["Major Shielding"] = 8,
}

settings.self_buffs = {
    "Major Shielding",
}

settings.healing = {
    life_support = {
    },
}

settings.assist = {
    debuffs = {
        "Weaken/MinMana|90",
    },
}

return settings
