local settings = { }

settings.gems = {
    ["Lifespike"] = 1,
    ["Clinging Darkness"] = 2,

    ["Vampiric Embrace"] = 6,
    ["Grim Aura"] = 7,
    ["Bone Walk"] = 8,
}

settings.self_buffs = {
    "Vampiric Embrace",

    "Grim Aura",
}

settings.healing = {
    ["life_support"] = {
        --"Distillate of Divine Healing XIII/HealPct|12",    -- XXX FIXME get heal pots
    }
}

settings.pet = {
    ["auto"] = false,

    -- L07 Leering Corpse
    -- L14 Bone Walk
    -- Lxxxxxxxxxxxxxxxxxxxxx
    ["spell"] = "Bone Walk/MinMana|80/Reagent|Bone Chips",

    ["heals"] = {
    },

    ["buffs"] = {
    },
}

settings.assist = {
    ["type"] = "Melee",
    ["stick_point"] = "Front",
    --["melee_distance"] = 12,
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = {
    },

    ["quickburns"] = {-- XXX implememt !!!

    },

    ["longburns"] = {-- XXX implememt !!!
    },
}

return settings
