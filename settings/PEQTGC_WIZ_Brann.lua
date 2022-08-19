local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Staff of Phenomenal Power|Mainhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Staff of Phenomenal Power|Mainhand", -- 1hb
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

    "Ether Skin/Gem|6/MinMana|20/CheckFor|Rune of Rikkukin",

    "Iceflame of E`ci/Gem|7/MinMana|20",

    "Improved Familiar",
}

settings.healing = { -- XXX implement
    ["life_support"] = { -- XXX implement
        "Distillate of Divine Healing XI/HealPct|10/CheckFor|Resurrection Sickness",

        -- Expendable AA
        --"Glyph of Stored Life/HealPct|4/CheckFor|Resurrection Sickness",
    },
}

settings.assist = {
    ["nukes"] = { -- XXX implement
        --[[
        Main=Ancient: Greater Concussion/Gem|9/PctAggro|98
        Main=Mind Crash/PctAggro|99

        ; fire nukes:
        ; L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana)
        ; L68 Firebane (1500 hp, resist adj -300, cost 456 mana)
        ; L70 Chaos Flame (random -1000 to 1000, resist adj -50, cost 275 mana)
        ; L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana)
        ; L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana)
        Main=Scepter of Incantations/NoAggro
        Main=Chaos Flame/NoAggro/Gem|1/MinMana|5
        Main=Ether Flame/GoM/NoAggro/Gem|3

        NoKS=Draught of Ro/NoAggro/Gem|1

        FastFire=Scepter of Incantations/NoAggro
        FastFire=Chaos Flame/NoAggro/Gem|1/MinMana|5
        FastFire=Ether Flame/GoM/NoAggro/Gem|3

        BigFire=Scepter of Incantations/NoAggro
        BigFire=Ether Flame/NoAggro/Gem|3/MinMana|5
        LureFire=

        ; cold nukes:
        ; L66 Icebane (1500 hp, resist adj -300, cost 456 mana)
        ; L68 Clinging Frost (1830 hp, resist adj -10, cost 350 mana + Clinging Frost Trigger DD)
        ; L69 Gelidin Comet (3385 hp, resist adj -10, cost 650 mana)
        ; L69 Spark of Ice (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        ; L69 Claw of Vox (1375 hp, resist adj -50, cost 208 mana, 5s cast)
        FastCold=Spark of Ice/NoAggro/Gem|2/MinMana|5
        FastCold=Gelidin Comet/GoM/NoAggro/Gem|4/MinMana|5
        BigCold=Gelidin Comet/NoAggro/Gem|4/MinMana|5
        LureCold=

        ; magic nukes:
        ; L10 Shock of Lightning (74-83 hp, cost 50 mana)
        ; L60 Elnerick's Electrical Rending (1796 hp, cost 421 mana)
        ; L61 Lure of Thunder (1090 hp, resist adj -300, cost 365 mana)
        ; L63 Draught of Thunder (980 hp, stun 1s/65, resist adj -50, cost 255 mana)
        ; L63 Draught of Lightning (980 hp, resist adj -50, cost 255 mana)
        ; L63 Agnarr's Thunder (2350 hp, cost 525 mana)
        ; L65 Shock of Magic (random dmg up to 2400 hp, cost 550 mana, resist adj -20)
        BigMagic=
        FastMagic=
        LureMagic=
        ]]--
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
        "Mana Blaze",
    },

    ["fullburns"] = {
        -- Expendable AA (increase dmg)
        "Glyph of Courage",
    }
}

settings.pbae = { -- XXX impl
    "Circle of Thunder/Gem|3",
    "Winds of Gelid/Gem|4",
    "Circle of Fire/Gem|5",
    --"Fire Rune/Gem|8",
}

settings.wizard = { -- XXX impl / rearrange
--[[
[Wizard]
Evac Spell=Exodus
Auto-Harvest (On/Off)=On
;Harvest=Harvest/Gem|8/MaxMana|22
Harvest=Harvest of Druzzil/MaxMana|20
]]--
}

return settings
