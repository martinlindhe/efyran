local settings = { }

settings.debug = true

settings.swap = {
    main = "Staff of Everliving Brambles|Mainhand/Shield of the Planar Assassin|Offhand",
    fishing = "Fishing Pole|Mainhand",
    melee = "Staff of Everliving Brambles|Mainhand", -- 1h blunt
}

settings.gems = {
    ["Ancient: Chlorobon"] = 1, -- heal
    ["Solstice Strike"] = 2, -- fire nuke
    ["Immolation of the Sun"] = 3, -- debuff+dot
    ["Wasp Swarm"] = 4, -- dot

    ["Blessing of Steeloak"] = 6, -- hp buff
    ["Hand of Ro"] = 7, -- debuff
    ["Remove Greater Curse"] = 8, -- cure
    ["Skin of the Reptile"] = 9, -- defensive proc buff
}

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    "Mask of the Wild/MinMana|10", -- 5 mana/tick
    "Blessing of Steeloak/MinMana|20",  -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
    "Protection of Seasons/MinMana|40",

    "Shimmering Bauble of Trickery/Shrink",
}

settings.healing = {
    life_support = {
        -- L70 Convergence of Spirits I AA (1000 hp instant, 500 hp/tick, 60 ds, 54 ac) DoDH
        -- L70 Convergence of Spirits II AA (1500 hp instant, 750 hp/tick, 65 ds, 60 ac) DoDH
        -- L70 Convergence of Spirits III AA (2000 hp instant, 1000 hp/tick, 70 ds, 66 ac) DoDH
        --"Convergence of Spirits/CheckFor|Spirit of the Wood/HealPct|50/MinMobs|10",

        "Skin of the Reptile/HealPct|50/MinMobs|10",

        -- melee guard:
        -- L69 Oaken Guard (mitigate 75% melee dmg for 5000 + Oaken Guard Parry proc, 1s cast, timer 5, 15 min recast)
        --"Oaken Guard/HealPct|50/MinMobs|5", -- XXX need a gem for it

        "Distillate of Divine Healing XI/HealPct|10",
    },

    tanks = {
        "Bandy",
        "Crusade",
        --"Nullius",
        --"Manu",
    },

    -- fast heal:
    -- L29 Greater Healing (280-350 hp, cost 115 mana)
    -- L44 Healing Water (395-425 hp, cost 150 mana)
    -- L51 Superior Healing (500-600 hp, cost 185 mana)
    -- L55 Chloroblast (994-1044 hp, cost 331 mana)
    -- L58 Tunare's Renewal (2925 hp, cost 400 mana - 75% CH)
    -- L60 Nature's Touch (1491 hp, cost 457 mana)
    -- L63 Nature's Infusion (2030-2050 hp, cost 560 mana)
    -- L64 Karana's Renewal (4680 hp, cost 600 mana - 75% CH)
    -- L65 Sylvan Infusion (2441 hp, cost 607 mana, 3.75s cast)
    -- L65 Kelp-Covered Hammer (GoD class clicky)
    -- L68 Chlorotrope (2790-2810 hp, cost 691 mana, 3.75s cast)
    -- L70 Ancient: Chlorobon (3094 hp, cost 723 mana,3.75s cast)

    -- hot v2 - stacks with CLR/SHM/PAL HoT:
    -- L60 Nature's Recovery (slot 2: 30 hp/tick, 3.0 min, recast 90s, cost 250 mana)
    -- L63 Spirit of the Wood AA

    tank_heal = {
        "Ancient: Chlorobon/HealPct|60", -- fast heal
        "Kelp-Covered Hammer/HealPct|68", -- tacvi
    },

    important = {
        "Stor", "Helge", "Kamaxia", "Maynarrd",
    },

    important_heal = {
        "Kelp-Covered Hammer/HealPct|85", -- tacvi clicky
        "Ancient: Chlorobon/HealPct|70",
    },

    all_heal = {
        "Ancient: Chlorobon/HealPct|40/MinMana|30", -- fast heal
        "Kelp-Covered Hammer/HealPct|68/Not|raid",
    },


    group_heal = { -- XXX impl
        -- group heals:
        -- L70 Moonshadow (1500 hp, cost 1100 mana, 4.5s cast, 18s recast)
    },
}

settings.assist = {
    -- fire nukes:
    -- L01 Burst of Flame (3-5 hp, cost 4 mana)
    -- L03 Burst of Fire (11-14 hp, cost 7 mana)
    -- L08 Ignite (38-46 hp, cost 21 mana)
    -- L28 Combust (156-182 hp, cost 85 mana)
    -- L38 Firestrike (402-422 hp, cost 138 mana)
    -- L48 Starfire (634 hp, cost 186 mana)
    -- L54 Scoriae (986 hp, cost 264 mana)
    -- L59 Wildfire (1294 hp, cost 335 mana)
    -- L60 Ancient: Starfire of Ro (1350 hp, cost 300 mana)
    -- L64 Summer's Flame (1600 hp, cost 395 mana)
    -- L65 Sylvan Fire (1761 hp, cost 435 mana)
    -- L69 Solstice Strike (2201 hp, cost 494 mana)
    -- L70 Dawnstrike (2125 hp, cost 482 mana. chance to proc spell buff that adjust dmg of next nuke)

    -- cold nukes:
    -- L47 Ice (511-538 hp, cost 142 mana)
    -- L55 Frost (837 hp, cost 202 mana)
    -- L60 Moonfire (1132 hp, cost 263 mana)
    -- L65 Winter's Frost (1375 hp, cost 305 mana)
    -- L65 Ancient: Chaos Frost (1450 hp, cost 290 mana)
    -- L70 Glitterfrost (1892 hp, cost 381 mana)
    -- L70 Ancient: Glacier Frost (2042 hp, cost 405 mana)
    nukes = {
        main = {
            "Solstice Strike/NoAggro/MinMana|50",
        },
        -- fastfire == main
        -- bigfire == main

        fastcold = {
            "Ancient: Glacier Frost/Gem|2/NoAggro/MinMana|30",
        },
        bigcold = {
            "Ancient: Glacier Frost/Gem|2/NoAggro/MinMana|30",
        }
    },


    dots = {
        -- fire dot + debuff:
        -- L67 Immolation of the Sun (-174-178 hp/tick, slot 3: -40 fr, slot 10: -36 ac, resist adj -50)
        "Immolation of the Sun/MaxTries|2",

        -- magic dots:
        -- Lxx Winged Death
        -- L63 Swarming Death (MAGIC: resist adj -100, 216-225 hp/tick, cost 357 mana)
        -- L68 Wasp Swarm (MAGIC: resist adj -100, 283-289 hp/tick, 54s, cost 454 mana)
        "Wasp Swarm/Not|raid",

        -- fire dots:
        -- L64 Vengeance of Tunare (FIRE: resist adj -30, 293-310 hp/tick, cost 345 mana)
        -- L69 Vengeance of the Sun (FIRE: resist adj -30, 408-412 hp/tick, 30s, cost 454 mana)
        --"Vengeance of the Sun/Gem|4",
    },

    debuffs_on_command = { -- XXX impl
        -- snares:
        -- Lxx Ensnare
        -- L61 Mire Thorns (chromatic -20, snare 55-60%, 3.0 min, cast time 3s, cost 75 mana)
        -- L64 Entrap AA (magic -0, snare 41-56%, 14 min, 5 sec recast)
        -- L69 Serpent Vines (chromatic -50, snare 55-60%, 3.0 min, cast time 3s, cost 125 mana)
        -- L70 Hungry Vines (magic -100, snare 50%, 0.3 min, cast time 3s, cost 500 mana) + absorb 1600 melee dmg on group

        -- fire debuffs:
        -- L56 Ro's Smoldering Disjunction (-150 hp, -58-80 atk, -26-33 ac, -64-71 fr)
        -- L61 Hand of Ro (slot 7: -72 fr, slot 10: -100 atk, slot 12: -15 ac, resist adj -200)
        -- L62 Ro's Illumination (-80 atk, -15 ac)
        -- L67 Sun's Corona (slot 5: -90 atk, slot 6: -19 ac)

        -- cold debuffs:
        -- L63 Eci's Frosty Breath (-55 cr, -24-30 ac, resist adj -200)
        -- L67 Glacier Breath (-55 cr, -30-36 ac, resist adj -200)

        -- fire dot + debuff:
        -- L62 Immolation of Ro (-145 hp/tick, -35 fr, -27 ac, resist adj -50)
        -- L65 Sylvan Emnbers (-132-142 hp/tick, slot 3: -40 fr, slot 10: -30 ac, resist adj -50, 1 min)
        -- L67 Immolation of the Sun (-174-178 hp/tick, slot 3: -40 fr, slot 10: -36 ac, resist adj -50)

        -- 1: -200 fire resist adj (slot 7: -72 fr, slot 10: -100 atk, slot 12: -15 ac)
        "Hand of Ro/MaxTries|2",

        -- 2: -50 fire resist adj (slot 3: -40 fr, slot 10: -36 ac)
        "Immolation of the Sun/MaxTries|2",
        -- 3: 0 fire resist adj (slot 5: -90 atk, slot 6: -19 ac)
        "Sun's Corona/Gem|4/MaxTries|2",

        -- 4: -200 cold resist adj (-55 cr, -30-36 ac)
        "Glacier Breath/Gem|6/MaxTries|2",
    },

    quickburns = {
        -- epic 1.5: Staff of Living Brambles
        -- epic 2.0: Staff of Everliving Brambles
        "Staff of Everliving Brambles",

        -- L70 Nature's Guardian I, DoDH
        -- L70 Nature's Guardian II, DoDH
        -- L70 Nature's Guardian III, DoDH
        --"Nature's Guardian",

        --"Silent Casting",

        -- oow t1 chest: XXX
        -- oow t2 chest: Everspring Jerkin of the Tangled Briars (reduce cast time by 25% for 0.7 min)
        "Everspring Jerkin of the Tangled Briars",

        -- L65 Nature's Boon Rank 1 AA (ae heal ward)
        "Nature's Boon",
    },

    longburns = {
        -- L65 Nature's Boon Rank 1 AA (ae heal ward)
        "Nature's Boon",
    },

    -- magic:
    -- L21 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
    -- L31 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
    -- L48 Upheaval (618-725 hp, aerange 35, recast 24, cost 625 mana)
    -- L61 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
    -- L66 Earth Shiver (1105 hp, aerange 35, recast 24s, cost 812 mana)
    -- L70 Hungry Vines (ae snare, aerange 50, recast 30s, cost 500 mana, duration 12s) (OOW)
    pbae = {
        "Earth Shiver/Gem|6/MinMana|10",
        "Catastrophe/Gem|7/MinMana|10",
        "Upheaval/Gem|8/MinMana|10",
    },
}

return settings
