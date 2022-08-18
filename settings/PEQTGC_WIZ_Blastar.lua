local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Staff of Phenomenal Power|Mainhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Staff of Phenomenal Power|Mainhand", -- 1hb
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Lxx Pyromancy AA Rank 3 (id:8408, 15% chance proc spell id:8164, -500 hate, -500 hp/tick, -50 fr)
    "Pyromancy/CheckFor|Mana Flare",

    -- mana regen clicky:
    -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)
    "Earring of Dragonkin",

    -- mana pool clicky:
    -- Reyfin's Racing Thoughts (slot 4: 450 mana pool, tacvi)
    -- NOTE: ran out of buff slots at 20-jan 2022
    --"Xxeric's Matted-Fur Mask",

    -- shield - does not stack with Virtue or Focus:
    -- LXX Major Shielding
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    --"Shield of Maelin/MinMana|80",

    -- self rune:
    -- L63 Force Shield (slot 1: absorb 750 dmg, 2 mana/tick)
    -- L68 Ether Skin (slot 1: absorb 975 dmg, 3 mana/tick)
    -- L70 Shield of Dreams (slot 1: absorb 451 dmg, slot 8: +10 resists, slot 9: 3 mana/tick)
    "Ether Skin/Gem|6/MinMana|20/CheckFor|Rune of Rikkukin",

    -- increase spell dmg:
    -- L63 Iceflame of E`ci (1-30% cold spell dmg for L60 nukes)
    "Iceflame of E`ci/MinMana|20",

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
        ; defensive - lower aggro:
        ; L37 Concussion (-400 hate, 2s cast)
        ; --- Maelin's Leggings of Lore (Concussion 2s cast) - pop ep legs
        ; L60 Ancient: Greater Concussion (-600 hate, 2s cast)
        ; Lxx Mind Crash AA Rank 1 (id:5943, -2500 hate)
        ; Lxx Mind Crash AA Rank 2 (id:5944, -5000 hate)
        ; Lxx Mind Crash AA Rank 3 (id:5945, -7500 hate)
        Main=Ancient: Greater Concussion/Gem|9/PctAggro|98
        Main=Mind Crash/PctAggro|99

        ; fire nukes:
        ; L04 Shock of Fire (14-20 hp, cost 10 mana)
        ; L15 Flame Shock (145-175 hp, cost 65 mana)
        ; L26 Inferno Shock (430-600 hp, cost 185 mana)
        ; L51 Draught of Fire (622 hp, cost 176 mana)
        ; L60 Sunstrike (1800 hp, resist adj -10, cost 450 mana)
        ; L62 Draught of Ro (980 hp, resist adj -50, cost 255 mana)
        ; L62 Lure of Ro (1090 hp, resist adj -300, cost 387 mana)
        ; L65 Strike of Solusek (2740 hp, resist adj -10, cost 640 mana)
        ; L65 White Fire (3015 hp, resist adj -10, cost 704 mana)
        ; L65 Ancient: Strike of Chaos (3288 hp, resist adj -10, cost 768 mana)


        ; tacvi class clicky:
        Main=Scepter of Incantations/NoAggro

        ; L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        ; L68 Firebane (1500 hp, resist adj -300, cost 456 mana, 4.5s cast)
        ; L70 Chaos Flame (random 1000 to 2000, resist adj -50, cost 275 mana, 3.0s cast)
        ; L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana, 8s cast)
        ; L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana, 8s cast)
        ; L70 Ancient: Core Fire (4070 hp, resist adj -10, cost 850 mana, 8s cast)
        Main=Chaos Flame/NoAggro/Gem|1/MinMana|5
        Main=Ancient: Core Fire/GoM/NoAggro/Gem|3

        NoKS=Draught of Ro/NoAggro/Gem|1

        FastFire=Chaos Flame/NoAggro/Gem|1/MinMana|5
        FastFire=Ancient: Core Fire/GoM/NoAggro/Gem|3
        FastFire=Scepter of Incantations/NoAggro

        BigFire=Ancient: Core Fire/NoAggro/Gem|3/MinMana|5
        BigFire=Scepter of Incantations

        LureFire=

        ; cold nukes:
        ; L01 Frost Bolt (9-14 hp, cost 6 mana)
        ; L01 Blast of Cold (11-18 hp, cost 8 mana)
        ; L08 Shock of Ice (46-58 hp, cost 23 mana)
        ; L49 Ice Comet (808 hp, resist adj -10, cost 203 mana)
        ; L57 Draught of Ice (793 hp, resist adj -10, cost 216 mana)
        ; L60 Ice Spear of Solist (1076 hp, resist adj -10, cost 221 mana)
        ; L61 Claw of Frost (1000 hp, resist adj -50, cost 167 mana)
        ; L64 Ice Meteor (2460 hp, resist adj -10, cost 520 mana)
        ; L64 Draught of E'ci (980 hp, resist adj -50, cost 255 mana)
        ; L65 Black Ice (1078 hp, resist adj -10, cost 280 mana)
        ; L66 Icebane (1500 hp, resist adj -300, cost 456 mana)
        ; L68 Clinging Frost (1830 hp, resist adj -10, cost 350 mana + Clinging Frost Trigger DD)
        ; L69 Gelidin Comet (3385 hp, resist adj -10, cost 650 mana)
        ; L69 Spark of Ice (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        ; L69 Claw of Vox (1375 hp, resist adj -50, cost 208 mana, 5s cast)
        ; L70 Ancient: Spear of Gelaqua (1976 hp, resist adj -10, cost 345 mana, 3.5s cast)
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
        ; L65 Shock of Magic (random dmg up to 2400 hp, resist adj -20, cost 550 mana)
        ; L67 Lightningbane (1500 hp, resist adj -300, cost 456 mana)
        ; L68 Spark of Lightning (1348 hp, resist adj -50, cost 319 mana)
        ; L68 Spark of Thunder (1348 hp, resist adj -50, cost 319 mana + 1s stun L70)
        ; L68 Thundaka (3233 hp, cost 656 mana)

        BigMagic=
        FastMagic=
        LureMagic=
        ]]--
    },

    ["targetae"] = {
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
        -- epic 1.5: Staff of Prismatic Power (-30% spell resist rate for group, -4% spell hate)
        -- epic 2.0: Staff of Phenomenal Power (-50% spell resist rate for group, -6% spell hate)
        "Staff of Phenomenal Power",

        "Silent Casting",
        "Ward of Destruction",
        "Call of Xuzl",

        -- oow T2 bp: Academic's Robe of the Arcanists (Academic's Intellect, -25% cast time for x, 5 min reuse)
        "Academic's Robe of the Arcanists",
    },

    ["longburns"] = {
        "Frenzied Devastation",

        -- L59 Mana Burn AA (3000 mana into nuke???)
        -- L65 Mana Blast AA (6000 mana into nuke???)
        -- L70 Mana Blaze AA (9000 mana into nuke???)
        "Mana Blaze",
    },

    ["fullburns"] = {
        -- Expendable AA (increase dmg)
        "Glyph of Courage",
    }
}

settings.pbae = { -- XXX impl
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
    "Circle of Thunder/Gem|3",
    "Winds of Gelid/Gem|4",
    "Circle of Fire/Gem|5",
    --"Fire Rune/Gem|8",
}

settings.wizard = { -- XXX impl / rearrange
--[[
[Wizard]
; L18 Lesser Evacuate (10.5s cast, cost 150 mana)
; L57 Evacuate (9s cast, cost 100 mana)
; Lxx Exodus AA (instant cast, recast time 72 min)
Evac Spell=Exodus

Auto-Harvest (On/Off)=On
;Harvest=Harvest/Gem|8/MaxMana|22
Harvest=Harvest of Druzzil/MaxMana|20
]]--
}

return settings
