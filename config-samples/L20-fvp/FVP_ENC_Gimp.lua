---@type PeerSettings
local settings = { }

settings.debug = true

settings.meditate = 50

settings.gems = {
    ["Weaken"] = 1,
    ["enc_magic_nuke"] = 2,
    ["Enthrall"] = 3, -- better mez
    ["enc_slow"] = 4,

    ["enc_root"] = 6,
    ["Mesmerize"] = 7, -- low mez           --["enc_tash"] = 7
    ["enc_manaregen"] = 8,
}

settings.self_buffs = {
    "enc_manaregen",
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
