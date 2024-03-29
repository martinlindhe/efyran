local settings = { }

settings.debug = true

settings.swap = { -- XXX impl
    main = "Staff of Phenomenal Power|Mainhand",
    fishing = "Fishing Pole|Mainhand",
    melee = "Staff of Phenomenal Power|Mainhand", -- 1hb
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

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    --"Pyromancy/CheckFor|Mana Flare",     -- (DODH) L70 Pyromancy AA Rank 3 (id:8408, 15% chance proc spell id:8164, -500 hate, -500 hp/tick, -50 fr)

    "Ether Skin/MinMana|20/CheckFor|Rune of Rikkukin",

    --"Iceflame of E`ci/MinMana|20", -- L63 Iceflame of E`ci (1-30% cold spell dmg for L60 nukes)

    -- familiars - improved stacks with bard song, druzzils does not:
    -- Lxx Minor Familiar (10 all resists, casting level 2)
    -- L45 Lesser Familiar (15 all resists, casting level 2, 1 mana/tick)
    -- L54 Familiar (20 all resists, casting level 4, max mana 75, 2 mana/tick)
    -- L60 Greater Familiar (25 all resists, casting level 8, max mana 150, 4 mana/tick)
    -- L59 Improved Familiar Rank 1 AA (25 all resists, casting level 9, max mana 200, crit chance, 6 mana/tick)
    -- L6x Improved Familiar Rank 2 AA (id:3264, 30 all resists, casting level 9, max mana 300, crit chance, 8 mana/tick)
    -- L70 Improved Familiar Rank 3 AA (id:5949, 30 all resists, casting level 9, max mana 500, crit chance, 10 mana/tick)
    -- L65 Ro's Flaming Familiar Rank 1 AA (id:4833, 1-20% fire spell dmg, max mana 300)
    -- L70 Ro's Flaming Familiar Rank 2 AA (id:5950, 1-25% fire spell dmg, max mana 350, 45 fire resist, 2 mana/tick)
    -- L65 E'chi's Icy Familiar Rank 1 AA (id:4834, 1-20% cold spell dmg, max mana 300)
    -- L68 E'chi's Icy Familiar Rank 2 AA (id:5951, 1-25% cold spell dmg, max mana 350, 45 cold resist, 2 mana/tick)
    -- L65 Druzzil's Mystical Familiar Rank 1 AA (id:4835, 1-20% magic spell dmg, max mana 300)
    -- L67 Druzzil's Mystical Familiar Rank 2 AA (id:5952, 1-25% magic spell dmg, max mana 350, 45 magic resist, 2 mana/tick)
    "Improved Familiar",
}


settings.healing = {
    life_support = {
        "Distillate of Divine Healing XI/HealPct|10",
        --"Glyph of Stored Life/HealPct|4", -- Expendable AA

        "Harvest of Druzzil/MaxMana|50",
    },
}

settings.assist = {
    nukes = {
        main = {
            -- defensive - lower aggro:
            -- L37 Concussion (-400 hate, 2s cast)
            --- Maelin's Leggings of Lore (Concussion 2s cast) - pop ep legs
            -- L60 Ancient: Greater Concussion (-600 hate, 2s cast)
            -- Lxx Mind Crash AA Rank 1 (id:5943, -2500 hate)
            -- Lxx Mind Crash AA Rank 2 (id:5944, -5000 hate)
            -- Lxx Mind Crash AA Rank 3 (id:5945, -7500 hate)
            "Ancient: Greater Concussion/PctAggro|90",
            "Mind Crash/PctAggro|99",

            -- fire nukes:
            -- L04 Shock of Fire (14-20 hp, cost 10 mana)
            -- L15 Flame Shock (145-175 hp, cost 65 mana)
            -- L26 Inferno Shock (430-600 hp, cost 185 mana)
            -- L51 Draught of Fire (622 hp, cost 176 mana)
            -- L60 Sunstrike (1800 hp, resist adj -10, cost 450 mana)
            -- L62 Draught of Ro (980 hp, resist adj -50, cost 255 mana)
            -- L62 Lure of Ro (1090 hp, resist adj -300, cost 387 mana)
            -- L65 Strike of Solusek (2740 hp, resist adj -10, cost 640 mana)
            -- L65 White Fire (3015 hp, resist adj -10, cost 704 mana)
            -- L65 Ancient: Strike of Chaos (3288 hp, resist adj -10, cost 768 mana)

            -- tacvi class clicky:
            "Scepter of Incantations/NoAggro",

            -- L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana, 3s cast)
            -- L68 Firebane (1500 hp, resist adj -300, cost 456 mana, 4.5s cast)
            -- L70 Chaos Flame (random 1000 to 2000, resist adj -50, cost 275 mana, 3.0s cast)
            -- L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana, 8s cast)
            -- L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana, 8s cast)
            -- L70 Ancient: Core Fire (4070 hp, resist adj -10, cost 850 mana, 8s cast)
            "Chaos Flame/NoAggro/MinMana|5/Delay|6",
            "Ancient: Core Fire/GoM/NoAggro",
        },

        noks = {
            "Draught of Ro/NoAggro/Gem|1",
        },

        -- fastfire == main
        bigfire = {
            "Ancient: Greater Concussion/PctAggro|90",
            "Mind Crash/PctAggro|99",

            "Scepter of Incantations",
            "Ancient: Core Fire/NoAggro/MinMana|5/Delay|6",
        },

        -- cold nukes:
        -- L01 Frost Bolt (9-14 hp, cost 6 mana)
        -- L01 Blast of Cold (11-18 hp, cost 8 mana)
        -- L08 Shock of Ice (46-58 hp, cost 23 mana)
        -- L49 Ice Comet (808 hp, resist adj -10, cost 203 mana)
        -- L57 Draught of Ice (793 hp, resist adj -10, cost 216 mana)
        -- L60 Ice Spear of Solist (1076 hp, resist adj -10, cost 221 mana)
        -- L61 Claw of Frost (1000 hp, resist adj -50, cost 167 mana)
        -- L64 Ice Meteor (2460 hp, resist adj -10, cost 520 mana)
        -- L64 Draught of E'ci (980 hp, resist adj -50, cost 255 mana)
        -- L65 Black Ice (1078 hp, resist adj -10, cost 280 mana)
        -- L66 Icebane (1500 hp, resist adj -300, cost 456 mana)
        -- L68 Clinging Frost (1830 hp, resist adj -10, cost 350 mana + Clinging Frost Trigger DD)
        -- L69 Gelidin Comet (3385 hp, resist adj -10, cost 650 mana)
        -- L69 Spark of Ice (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        -- L69 Claw of Vox (1375 hp, resist adj -50, cost 208 mana, 5s cast)
        -- L70 Ancient: Spear of Gelaqua (1976 hp, resist adj -10, cost 345 mana, 3.5s cast)
        fastcold = {
            "Spark of Ice/NoAggro/MinMana|5",
            "Gelidin Comet/GoM/NoAggro/Gem|4/MinMana|5/Delay|6",
        },
        bigcold = {
            "Gelidin Comet/NoAggro/Gem|4/MinMana|5/Delay|6",
        },

        -- magic nukes:
        -- L10 Shock of Lightning (74-83 hp, cost 50 mana)
        -- L60 Elnerick's Electrical Rending (1796 hp, cost 421 mana)
        -- L61 Lure of Thunder (1090 hp, resist adj -300, cost 365 mana)
        -- L63 Draught of Thunder (980 hp, stun 1s/65, resist adj -50, cost 255 mana)
        -- L63 Draught of Lightning (980 hp, resist adj -50, cost 255 mana)
        -- L63 Agnarr's Thunder (2350 hp, cost 525 mana)
        -- L65 Shock of Magic (random dmg up to 2400 hp, resist adj -20, cost 550 mana)
        -- L67 Lightningbane (1500 hp, resist adj -300, cost 456 mana)
        -- L68 Spark of Lightning (1348 hp, resist adj -50, cost 319 mana)
        -- L68 Spark of Thunder (1348 hp, resist adj -50, cost 319 mana + 1s stun L70)
        -- L68 Thundaka (3233 hp, cost 656 mana)
    },

    quickburns = {
        "Ward of Destruction",
        "Call of Xuzl",

        -- "Silent Casting",  -- DODH

        -- oow T2 bp: Academic's Robe of the Arcanists (Academic's Intellect, -25% cast time for 0.7 min, 5 min reuse)
        "Academic's Robe of the Arcanists",

        -- epic 1.5: Staff of Prismatic Power (-30% spell resist rate for group, -4% spell hate)
        -- epic 2.0: Staff of Phenomenal Power (-50% spell resist rate for group, -6% spell hate)
        "Staff of Phenomenal Power",
    },

    longburns = {
        "Frenzied Devastation",

        -- L59 Mana Burn AA (3000 mana into nuke???)
        -- L65 Mana Blast AA (6000 mana into nuke???)
        -- L70 Mana Blaze AA (9000 mana into nuke???)
        --"Mana Blaze",
    },

    fullburns = {
        -- Expendable AA (increase dmg)
        "Glyph of Courage",
    },

    pbae = {
        -- L01 Numbing Cold (14 hp, ICE, aerange 25, recast 12s, cost 6 mana)
        -- L05 Fingers of Fire (19-28 hp, FIRE, aerange 25, recast 6s, cost 47 mana)
        -- L14 Project Lightning (55-62 hp, MAGIC, aerange 25, recast 6s, cost 85 mana)
        -- L30 Thunderclap (210-232 hp, MAGIC, aerange 20, recast 12s, cost 175 mana)
        -- L45 Supernova (854 hp, FIRE, aerange 35, recast 12s, cost 875 mana)
        -- L53 Jyll's Static Pulse (495-510 hp, MAGIC, aerange 25, recast 6s, cost 285 mana)
        -- L56 Jyll's Zephyr of Ice (594 hp, ICE, adj -10, aerange 25, recast 6s, cost 313 mana)
        -- L59 Jyll's Wave of Heat (638-648 hp, FIRE, adj -10, aerange 25, recast 6s, cost 342 mana)
        -- L60 Winds of Gelid (1260 hp, ICE, adj -10, aerange 35, recast 12s, cost 875 mana)
        -- L67 Circle of Fire (845 hp, FIRE, adj -10, aerange 35, recast 6s, cost 430 mana)
        -- L70 Circle of Thunder (1450 hp, MAGIC; adj -10, aerange 35, recast 12s, cost 990 mana)
        "Circle of Thunder",
        "Winds of Gelid/Gem|4",
        "Circle of Fire/Gem|5",
        --"Fire Rune/Gem|8",
    },

    targetae = { -- XXX impl?
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
}

return settings
