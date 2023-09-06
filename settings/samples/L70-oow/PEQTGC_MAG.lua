local settings = { }

settings.debug = true

settings.swap = {
    main = "Focus of Primal Elements|Mainhand",

    fishing = "Fishing Pole|Mainhand",

    -- Focus of Primal Elements (1hb)
    melee = "Focus of Primal Elements|Mainhand",
}

settings.gems = {
    ["Burning Earth"] = 1,
    ["Ancient: Nova Strike"] = 2,
    ["Renewal of Jerikor"] = 3,
    ["Iceflame Guard"] = 4,
    ["Malosinia"] = 6,
    ["Fireskin"] = 7,
    ["Raging Servant"] = 8,
    --["Summon: Molten Orb"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    "Earring of Dragonkin", -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)
    "Xxeric's Matted-Fur Mask", -- Reyfin's Racing Thoughts (slot 4: 450 mana pool)

    -- L59 Elemental Form: Air Rank 1 AA (id:2789, see invis, +10 all resists)
    -- L59 Elemental Form: Air Rank 2 AA (id:2790, see invis, +15 all resists)
    -- L59 Elemental Form: Air Rank 3 AA (id:2791, see invis, +25 all resists)
    -- L59 Elemental Form: Earth Rank 1 AA (id:2792, +10 sta, +50 max hp)
    -- L59 Elemental Form: Earth Rank 2 AA (id:2793, +15 sta, +100 max hp)
    -- L59 Elemental Form: Earth Rank 3 AA (id:2794, +20 sta, +200 max hp)
    -- L59 Elemental Form: Water Rank 1 AA (id:2798, water breathing, 1 mana/tick)
    -- L59 Elemental Form: Water Rank 2 AA (id:2799, water breathing, 2 mana/tick)
    -- L59 Elemental Form: Water Rank 3 AA (id:2800, water breathing, 4 mana/tick)
    -- L59 Elemental Form: Fire Rank 1 AA (10 ds, 10 int, casting level +1)
    -- L59 Elemental Form: Fire Rank 2 AA (20 ds, 15 int, casting level +3)
    -- L59 Elemental Form: Fire Rank 3 AA (30 ds, 20 int, casting level +5)
    -- NOTE: cannot use with Heart of Flames AA
    --"Elemental Form: Fire",

    "Shimmering Bauble of Trickery/Shrink",
}

settings.combat_buffs = {
--[[
; ds:
; L68 Pyrilen Skin (420 ds - slot 12, 12 sec)
; L70 Ancient: Veil of Pyrilonus (500 ds - slot 12, 24 sec)
;;Combat Buff=Fireskin/Bandy/MinMana|10
;;Combat Buff=Fireskin/Manu/MinMana|10
;;Combat Buff=Fireskin/Nullius/MinMana|10
;;Combat Buff=Fireskin/Kamaxia/MinMana|10
;;Combat Buff=Fireskin/Maynarrd/MinMana|10
;;Combat Buff=Fireskin/Stor/MinMana|10
;;Combat Buff=Fireskin/Drutten/MinMana|10

; PL ds:
;;Bot Buff=Fireskin/Nullius/MinMana|10
;Combat Buff=Pyrilen Skin/Nullius/Gem|2/MinMana|10
]]--
}

settings.healing = {
    life_support = {
        "Shared Health/HealPct|60",
        "Distillate of Divine Healing XI/HealPct|10",
    }
}

settings.pet = {
    -- pet heals:
    -- Lxx Primal Remedy
    -- L59 Mend Companion AA (36 min reuse without Hastened Mending AA)
    -- L60 Transon's Elemental Renewal (849-873 hp, -20 dr pr curse, cost 237 mana)
    -- L64 Planar Renewal (1190-1200 hp, -24 dr pr curse, cost 290 mana)
    -- L69 Renewal of Jerikor (1635-1645 hp, -28 dr pr curse, cost 358 mana)
    heals = {
        "Renewal of Jerikor/HealPct|40",

        -- L6x Replenish Companion AA (36 min reuse)
        "Replenish Companion/HealPct|50", -- was [Magician].pet mend" in e3
    },

    buffs = {
        "Elemental Fury/MinMana|25", -- pet haste
        "Velocity/MinMana|90", -- pet run speed

        -- "aura":
        -- L55 Earthen Strength (5% melee dmg to nearby pets)
        -- L70 Rathe's Strength (slot 1: Persistent Effect: Rather's Strength Effect)
        "Rathe's Strength/MinMana|10/CheckFor|Rathe's Strength Effect",

        -- L70 Iceflame Guard (15 ds, Iceflame Strike proc, rate mod 150)
        "Iceflame Guard/MinMana|15",

        -- epic 1.5: hp  800, mana 10/tick, hp 20/tick, proc Elemental Conjunction Strike, defensive proc Elemental Conjunction Parry (Staff of Elemental Essence)
        -- epic 2.0: hp 1000, mana 12/tick, hp 24/tick, proc Primal Fusion Strike, defensive proc Primal Fusion Parry, 20 min (34 min with ext duration) (Focus of Primal Elements)
        "Focus of Primal Elements",

        "Algae Covered Stiletto/Shrink",
    },

    ["auto_weapons"] = false, -- XXX was e3 [Magician].Auto-Pet Weapons (On/Off). XXX IMPL

    ["summoned_pet_items"] = { -- for magicians. was e3 [Magician].Summoned Pet Item. XXX IMPL
        -- pet toys:
        -- L56 Muzzle of Mardu (FACE: 11% haste)
        -- L61 Belt of Magi`Kot (WAIST: 250 hp, 10 str, 10 sta, 10 agi, 10 dex)
        -- L61 Blade of Walnan (1HS: 50 hp, 10 dmg, 3 magic dmg, 20 delay + 220 magic proc)
        -- L62 Fist of Ixiblat (H2H: 50 hp, 10 dmg, 3 fire dmg, 20 delay + 220 fire proc)
        -- L63 Blade of The Kedge (1HS: 50 hp, 10 dmg, 3 cold dmg, 20 delay + 220 cold proc)
        -- L64 Girdle of Magi`Kot (WAIST: 500 hp, 15 str, 15 sta, 15 agi, 15 dex)
        -- L66 Summon Fireblade (1HS: 75 hp, 12 dmg, 5 fire, 20 delay + 220 fire proc)
        -- L67 Summon Staff of the North Wind (1HB: 75 hp, 12 dmg, 5 magic, 20 delay + 220 magic proc)
        -- L67 Summon Dagger of the Deep (1HP: 75 hp, 12 dmg, 5 cold, 12 backstab, 20 delay + 220 cold proc)
        -- L67 Summon Crystal Belt (WAIST: 650 hp, 20 str, 20 sta, 20 agi, 20 dex)
        -- Blazing Stone of Demise: Summoned: Burning Shank from ikky4 (1HP, 100 hp, 11 dmg, 4 fire, 11 backstab, 19 delay + 225 fire proc)
        -- NOTE: MAG Agatha does Summon Crystal Belt
        "Blazing Stone of Demise",
        "Blazing Stone of Demise",
    },

    ["taunt"] = false, -- XXX impl
    ["shrink"] = false, -- XXX impl . was e3 [Pets].Pet Auto-Shrink (On/Off)
    ["buff_in_combat"] = false, -- XXX impl. was e3 [Pets].Pet Buff Combat (On/Off)=Off
    --Pet Summon Combat (On/Off)=Off       -- XXX unimplemented e3 pet setting
}

settings.assist = {
    nukes = {
        -- fire nukes:
        -- L33 Cinder Bolt (499-510 hp, cost 165 mana)
        -- Lxx
        -- L54 Scars of Sigil (622 hp, cost 186 mana)
        -- L59 Seeking Flame of Seukor (1607 hp, cost 413 mana)
        -- L60 Shock of Fiery Blades (1294 hp, cost 335 mana)
        -- L61 Firebolt of Tallon (2100 hp, cost 515 mana)
        -- L62 Burning Sand (980 hp, cost 270 mana)
        -- L65 Sun Vortex (1600 hp, cost 395 mana)
        -- L65 Ancient: Chaos Vortex (1920 hp, cost 474 mana)
        -- L66 Bolt of Jerikor (2889 hp, cost 644 mana)
        -- L69 Burning Earth (1348 hp, 3s cast, cost 337 mana)
        -- L69 Fickle Fire (2475 hp, 6.4s cast, cost 519 mana) + chance to increase dmg
        -- L70 Spear of Ro (3119 hp, 7s cast, cost 684 mana)
        -- L70 Star Strike (2201 hp, 6.4s cast, cost 494 mana)
        -- L70 Ancient: Nova Strike (2377 hp, 6.3s cast, cost 525 mana)

        -- L70 Raging Servant (1650 mana, swarm pet)
        main = {
            "Raging Servant/GoM",

            -- L69 Summon: Molten Orb (10 charge 700 hp fire nuke, -10 fire adj, instant cast, 12s recast)
            --"Molten Orb/NoAggro/Summon|Summon: Molten Orb", -- DoN

            "Burning Earth/NoAggro/MinMana|10",
            "Ancient: Nova Strike/GoM/NoAggro",

            -- tacvi clicky:
            "Dagger of Evil Summons/NoAggro",
        },
        noks = {
            "Sun Vortex/NoAggro/Gem|1",
        },
        --fastfire == main
        --bigfire == main
        fastcold = {
            "Raging Servant/GoM",

            -- magic nukes:
            -- L65 Rock of Taelosia (1623 hp, 6.3s cast, cost 379 mana)
            -- L68 Blade Strike (2029 hp, 6.3s cast, cost 431 mana)
            "Blade Strike/NoAggro/Gem|1",
        },
    },

    debuffs = {
        -- malos:
        -- L22 Malaise (-15-20 cr, -15-20 mr, -15-20 pr, -15-20 fr, cost 60 mana)
        -- L44 Malaisement (-36-40 cr, -36-40 mr, -36-40 pr, -36-40 fr, cost 100 mana)
        -- L51 Malosi (-58-60 cr, -58-60 mr, -58-60 pr, -58-60 fr, cost 175 mana)
        -- L60 Mala (-35 cr, -35 mr, -35 pr, -35 fr, unresistable, cost 350 mana)
        -- L63 Malosinia (-70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana)
        -- NOTE: Erland does Malos, Myggan does Malosinia
        --"Malosinia/MaxTries|2/MinMana|10", -- XXX MaxTries
    },

    debuffs_on_command = {  -- XXX impl
        "Malosinia/MaxTries|3/MinMana|10",
    },

    quickburns = {
        -- "Silent Casting",  -- DODH
        "Frenzied Burnout",
        "Host of the Elements",
        "Servant of Ro",

        -- L67 Heart of Ice (id:5916, mitigate spell dmg by 50% until 5000 for 1.5 min)
        -- L68 Heart of Vapor (id:5913, decrease spell hate by 50%)
        -- L69 Heart of Stone (id:xxx)
        -- L70 Heart of Flames (id:5915, increase fire dd dmg by 1-50% for 1.5 min, 22 min reuse)
        -- NOTE: if using this burn, cannot also use Elemental Form
        "Heart of Flames",

        -- oow t1 bp: Runemaster's Robe (pet buff: +50% skill dmg mod, -15% skill dmg taken for 0.3 min)
        -- oow t2 bp: Glyphwielder's Tunic of the Summoner (pet buff: +50% skill dmg mod, -15% skill dmg taken for 0.5 min)
        "Glyphwielder's Tunic of the Summoner",
    },

    pbae = {
        -- L01 Fire Flux (8-12 hp, aerange 20, recast 6s , cost 23 mana) - for PL
        -- L22 Flame Flux (89-96 hp, aerange 20, recast 6s, cost 123 mana)
        -- L39 Flame Arc (171-181 hp, aerange 20, recast 7s , cost 199 mana)
        -- L51 Scintillation (597-608 hp, aerange 25, recast 6.5s, cost 361 mana)
        -- L60 Wind of the Desert (1050 hp, aerange 25, recast 12s, cost 780 mana)
        "Wind of the Desert/Gem|7/MinMana|10",
        "Scintillation/Gem|6/MinMana|10",
    },
}

return settings
