---@type PeerSettings
local settings = { }

settings.debug = true

settings.meditate = 50

settings.gems = {
    ["Weaken"] = 1,
    ["enc_slow"] = 2, -- slow
    ["Mesmerize"] = 3, -- mez L55
    ["Lull"] = 4,

    ["enc_tash"] = 6,
    ["enc_haste"] = 7,
    --["Juli's Animation"] = 7, -- pet
    ["enc_self_shield"] = 8,
}

settings.self_buffs = {
    "enc_self_shield",
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
