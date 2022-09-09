local settings = { }

settings.swap = { -- XXX impl
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
    ["Ancient: Greater Concussion"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- mana regen clicky:
    -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)
    "Earring of Dragonkin",

    -- mana pool clicky:
    -- Maelin's Meditation (slot 4: 400 mana pool)
    "Muramite Signet Orb",

    "Pyromancy/CheckFor|Mana Flare",

    "Ether Skin/MinMana|20/CheckFor|Rune of Rikkukin",

    "Iceflame of E`ci/MinMana|20",

    "Improved Familiar",
}

settings.healing = {
    ["life_support"] = {
        "Distillate of Divine Healing XI/HealPct|10",

        -- Expendable AA
        --"Glyph of Stored Life/HealPct|4",
    },
}

settings.assist = {
    ["nukes"] = { -- XXX implement
        ["main"] = {
            "Ancient: Greater Concussion/PctAggro|98",
            "Mind Crash/PctAggro|99",

            -- fire nukes:
            -- L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana)
            -- L68 Firebane (1500 hp, resist adj -300, cost 456 mana)
            -- L70 Chaos Flame (random -1000 to 1000, resist adj -50, cost 275 mana)
            -- L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana)
            -- L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana)
            "Scepter of Incantations/NoAggro",
            "Chaos Flame/NoAggro/MinMana|5",
            "Ether Flame/GoM/NoAggro",
        },
        ["noks"] = {
            "Draught of Ro/NoAggro/Gem|1",
        },

        ["fastfire"] = {
            "Scepter of Incantations/NoAggro",
            "Chaos Flame/NoAggro/MinMana|5",
            "Ether Flame/GoM/NoAggro",
        },

        ["bigfire"] = {
            "Scepter of Incantations/NoAggro",
            "Ether Flame/NoAggro/MinMana|5",
        },

        -- cold nukes:
        -- L66 Icebane (1500 hp, resist adj -300, cost 456 mana)
        -- L68 Clinging Frost (1830 hp, resist adj -10, cost 350 mana + Clinging Frost Trigger DD)
        -- L69 Gelidin Comet (3385 hp, resist adj -10, cost 650 mana)
        -- L69 Spark of Ice (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        -- L69 Claw of Vox (1375 hp, resist adj -50, cost 208 mana, 5s cast)
        ["fastcold"] = {
            "Spark of Ice/NoAggro/MinMana|5",
            "Gelidin Comet/GoM/NoAggro/MinMana|5",
        },
        ["bigcold"] = {
            "Gelidin Comet/NoAggro/MinMana|5",
        },
    },

    ["targetae"] = { -- XXX impl
        -- L12 Firestorm (41 hp, FIRE, adj -10, aerange 25, recast 12s, cost 34 mana)
        -- L24 Column of Lightning (128-136 hp, FIRE, aerange 15, recast 6s, cost 130 mana)
        -- L26 Energy Storm (238 hp, MAGIC, adj -10, aerange 25, recast 12s, cost 148 mana)
        -- L28 Shock Spiral of Al'Kabor (111-118 hp, MAGIC, aerange 35, recast 9s, cost 200 mana)
        -- L31 Circle of Force (193-216 hp, FIRE, adj -10, aerange 15, recast 6s, cost 175 mana)
        -- L32 Lava Storm (401 hp, FIRE, adj -10, aerange 25, recast 12s, cost 234 mana)
        -- L61 Tears of Ro (1106 hp, FIRE, adj -10, aerange 25, recast 10s, cost 492 mana)
        -- L64 Tears of Arlyxir (645 hp, FIRE, adj -300, aerange 25, recast 12s, cost 420 mana)
        -- L66 Tears of the Sun (1168 hp, FIRE, adj -10, aerange 25, recast 10s, cost 529 mana)
        -- L69 Meteor Storm (886 hp, FIRE, adj -300, aerange 25, recast 12s, cost 523 mana)
    },

    ["quickburns"] = {
        "Staff of Phenomenal Power",

        "Silent Casting",
        "Call of Xuzl",

        -- oow T2 bp: Academic's Robe of the Arcanists (Academic's Intellect, -25% cast time for x, 5 min reuse)
        --"Academic's Robe of the Arcanists",
    },

    ["longburns"] = {
        "Frenzied Devastation",
        "Ward of Destruction",
        --"Mana Blaze",
    },

    ["fullburns"] = {
        -- Expendable AA (increase dmg)
        "Glyph of Courage",
    },

    ["pbae"] = {
        "Circle of Thunder",
        "Winds of Gelid/Gem|4",
        "Circle of Fire/Gem|5",
        --"Fire Rune/Gem|8",
    },
}

settings.evac = {
    "Exodus",
    "Evacuate",
}

settings.wizard = { -- XXX impl / rearrange
--[[
[Wizard]
Auto-Harvest (On/Off)=On
;Harvest=Harvest/Gem|8/MaxMana|22
Harvest=Harvest of Druzzil/MaxMana|20
]]--
}

return settings
