---@type PeerSettings
local settings = { }

settings.debug = true

settings.meditate = 50

settings.gems = {
    ["Weaken"] = 1,
    ["enc_magic_nuke"] = 2,
    ["enc_mez"] = 3,
    ["enc_slow"] = 4,

    ["enc_tash"] = 6,
    ["enc_haste"] = 7,
    --["Juli's Animation"] = 7, -- pet
    ["enc_self_shield"] = 8,
}

settings.self_buffs = {
    "enc_self_shield",
    "enc_magic_resist",
}

settings.healing = {
    life_support = {
    },
}

settings.assist = {
    nukes = {
        main = {
            "enc_magic_nuke/MaxHP|90/NoAggro/MinMana|50",
        },
    },
    debuffs = {
        "Weaken/MinMana|90",
    },
}

return settings
