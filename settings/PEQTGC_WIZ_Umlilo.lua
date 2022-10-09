local settings = { }

settings.swap = {
    ["main"] = "Staff of Phenomenal Power|Mainhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Staff of Phenomenal Power|Mainhand", -- 1hb
}

settings.gems = {
    ["Chaos Flame"] = 1, -- fire nuke
    ["Ancient: Core Fire"] = 2, -- fire nuke
    ["Spark of Ice"] = 3, -- cold nuke
    ["Gelidin Comet"] = 4, -- cold nuke

    ["Ether Skin"] = 6,
    ["Iceflame of E`ci"] = 7,
    ["Circle of Thunder"] = 8, -- pbae
    ["Concussion"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Lxx Pyromancy AA Rank 3 (id:8408, 15% chance proc spell id:8164, -500 hate, -500 hp/tick, -50 fr)
    "Pyromancy/CheckFor|Mana Flare",

    "Earring of Dragonkin", -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)

    "Muramite Signet Orb", -- Maelin's Meditation (slot 4: 400 mana pool)

    "Ether Skin/MinMana|20/CheckFor|Rune of Rikkukin",

    --"Iceflame of E`ci/MinMana|20",  -- L63 Iceflame of E`ci (1-30% cold spell dmg for L60 nukes)

    -- familiars - improved stacks with bard song, druzzils does not:
    "Improved Familiar",
}


settings.healing = {
    ["life_support"] = {
        "Distillate of Divine Healing XI/HealPct|10",

        --"Glyph of Stored Life/HealPct|4", -- Expendable AA
    },
}

settings.assist = {
    ["nukes"] = {
        ["main"] = {
            "Concussion/PctAggro|98",
            "Mind Crash/PctAggro|99",
            "Scepter of Incantations/NoAggro", -- tacvi clicky
            "Chaos Flame/NoAggro/MinMana|5",
            "Ancient: Core Fire/GoM/NoAggro",
        },
        ["noks"] = {
            "Draught of Ro/NoAggro/Gem|1",
        },
        ["fastfire"] = {
            "Chaos Flame/NoAggro/MinMana|5",
            "Ancient: Core Fire/GoM/NoAggro",
            "Scepter of Incantations/NoAggro",
        },
        ["bigfire"] = {
            "Ancient: Core Fire/NoAggro/MinMana|5",
            "Scepter of Incantations",
        },
        ["fastcold"] = {
            "Spark of Ice/NoAggro/MinMana|5",
            "Gelidin Comet/GoM/NoAggro/MinMana|5",
        },
        ["bigcold"] = {
            "Gelidin Comet/NoAggro/MinMana|5",
        },
    },

    ["quickburns"] = { -- XXX impl
        "Ward of Destruction",
        "Call of Xuzl",

        "Silent Casting",

        -- oow T2 bp: Academic's Robe of the Arcanists (Academic's Intellect, -25% cast time for x, 5 min reuse)
        --"Academic's Robe of the Arcanists",

        -- epic 2.0: Staff of Phenomenal Power (-50% spell resist rate for group, -6% spell hate)
        "Staff of Phenomenal Power",
    },

    ["longburns"] = {
        "Frenzied Devastation",
        --"Mana Blaze",
    },

    ["fullburns"] = {},

    ["pbae"] = {
        "Circle of Thunder",
        "Winds of Gelid/Gem|4",
        "Circle of Fire/Gem|5",
        --"Fire Rune/Gem|8",
    },

    ["targetae"] = { -- XXX impl?
    },
}

settings.wizard = { -- XXX impl / rearrange
--[[
Auto-Harvest (On/Off)=On
;Harvest=Harvest/Gem|8/MaxMana|22
Harvest=Harvest of Druzzil/MaxMana|20
]]--
}

return settings
