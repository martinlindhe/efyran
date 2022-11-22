---@type PeerSettings
local settings = { }

settings.gems = {
    ["Blast of Cold"]   = 2,
    ["Minor Shielding"] = 8,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
    "Minor Shielding",
}

settings.assist = {
    nukes = {
        main = {
            "Blast of Cold/NoAggro",
        },
    },
}

return settings
