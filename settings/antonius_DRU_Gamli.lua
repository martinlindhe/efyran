local settings = { }

settings.swap = {} -- XXX impl

settings.gems = {
    -- XXX
    ["Puravida Rk. II"] = 1,            -- fast heal 3.75s
    ["Adrenaline Surge Rk. III"] = 2,   -- quick heal 1.8s
    ["Solstice Strike"] = 3,
    ["Ancient: Glacier Frost"] = 4,

    ["Scales of the Reptile"] = 6,
    ["Legacy of Viridithorns"] = 7,
    ["Viridithorn Coat"] = 8,
    ["Direwood Guard"] = 9,
    ["Blessing of the Ironwood"] = 10,
    ["Tectonic Upheaval"] = 11,
    ["Second Life"] = 12,
}

settings.mount = "Glowing Black Drum"

settings.self_buffs = {
    --"Guise of the Deceiver", -- 6s cast. XXX get general AA 'Persistent Illusions (L75, 30 aa cost)
    --"Thick Ice Studded Collar", -- 3s cast,
    --"Ball of Golem Clay",
    "Amulet of Necropotence",

    -- Geomantra III
    --"Crimson Mask of Triumph",

    -- Form of Endurance V
    "Frost-Scarred Giant Hide Bracer/CheckFor|Shadow of Endurance",

    -- Symbol of Vitality (slot 3: increase max hp by 700)
    --"Orb of Duskmold", -- do not stack with CLR symbol

    "Earring of Pain Deliverance/CheckFor|Shadow of Knowledge",

    -- slot 3: block if spell is slot 3 and "All Resists" < 1050, slot 10: 50 fire resist
    "Fractured Werewolf Jawbone",

    "Bracelet of the Shadow Hive/Shrink",

    -- L73 Vididicoat Rk. II (SELF, slot 2: 80 ac, slot 3: 21 ds)
    -- L78 Viridithorn Coat (SELF, slot 2: 86 ac, slot 3: 23 ds)
    -- L78 Viridithorn Coat Rk. II (SELF, slot 2: 98 ac, slot 3: 26 ds)
    -- slot 3: 26 ds
    "Viridithorn Coat",

    -- slot 2: 8 ds
    "Coldain Hero's Insignia Ring",

    -- slot 1: 86 ds
    "Legacy of Viridithorns",

    -- slot XXX: big single hit ds
    "Wrath of the Wild",

    -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
    "Blessing of the Ironwood",

    -- L80 Mask of the Shadowcat (SELF, slot 2: 9 mana/tick)
    "Mask of the Shadowcat",

    -- L75 Second Life (SELF, increase divine save by 25%)
    -- L75 Second Life Rk. II (SELF, increase divine save by 29%)
    "Second Life",

    "Protection of Seasons",

    -- L68 Skin of the Reptile (melee proc heals when hit)
    -- L79 Scales of the Reptile Rk. II (melee proc that heals when hit)
    "Scales of the Reptile/MinMana|25",

    --"Forbear Corruption", -- not needed atm
}

settings.healing = {
    ["automed"] = false, -- do not auto sit/stand/mount
    ["life_support"] = {
        -- L70 Convergence of Spirits I AA (1000 hp instant, 500 hp/tick, 60 ds, 54 ac)
        -- L70 Convergence of Spirits II AA (1500 hp instant, 750 hp/tick, 65 ds, 60 ac)
        -- L70 Convergence of Spirits III AA (2000 hp instant, 1000 hp/tick, 70 ds, 66 ac)
        "Convergence of Spirits/CheckFor|Spirit of the Wood/HealPct|90/MinMobs|10",

        -- L63 Spirit of the Wood 1 AA (xxx ds)
        "Spirit of the Wood/CheckFor|Convergence of Spirits/HealPct|90/MinMobs|10",
        
        -- melee guard:
        -- L69 Oaken Guard (mitigate 75% melee dmg for 5000 + Oaken Guard Parry proc, 1s cast, timer 5, 15 min recast)
        -- L74 Direwood Guard Rk. II (mitigate 75% melee dmg for 6250 + Direwood Guard Parry proc, 1s cast, timer 5, 15 min recast)
        "Direwood Guard/HealPct|50/MinMobs|5",

        -- XXX

        "Mask of the Ancients/HealPct|40", -- 1s cast Chlorotrope, 3 min 30 sec recast

        "Adrenaline Surge/HealPct|60/MinMana|50", -- 1.8s cast

        "Puravida/HealPct|70/MinMana|30", -- 3.75s cast
        
        -- L80 Distillate of Divine Healing XIII, 2 min recast
        "Distillate of Divine Healing XIII/HealPct|18",
    },

    ["rez"] = { -- XXX impl
        -- L59 Incarnate Anew (90% exp, 20s cast, 700 mana)
        -- Lxx Call of the Wild (0% rez, corpse can be properly rezzed later)
        --"Incarnate Anew",
        "Call of the Wild",
    },

    ["cures"] = { -- XXX impl. 
        ["Cure Disease"] = {
            "Rabies/Zone|chardok",
        },
    },

    ["tanks"] = {
        "Ixtrem", -- SHD
    },

    ["tank_heal"] = {
        "Mask of the Ancients/HealPct|85",

        "Puravida/HealPct|80/MinMana|5",
    },

    ["all_heal"] = {
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
        -- L70 Mask of the Ancients (DoN class clicky, Chlorotrope, 1s cast)
        -- L72 Pure Life Rk. III (3369-3399 hp, cost 794 mana, 3.75s cast)
        -- L77 Puravida Rk. II (4534-4564 hp, cost 790 mana, 3.75s cast)
        "Mask of the Ancients/HealPct|65",

        "Puravida/HealPct|60/MinMana|30",
    },

    ["important"] = {
        "Kirurgen",
    },

    ["important_heal"] = {
        -- quick heal:
        -- L75 Adrenaline Surge Rk. III (3681 hp, cost 1050 mana, cast time 1.8s, timer 2. 15s recast)
        "Mask of the Ancients/HealPct|60",

        "Adrenaline Surge/HealPct|30/MinMana|50",

        "Puravida/HealPct|70/MinMana|30",
    },

    ["group_heal"] = { -- XXX impl
        -- group heals:
        -- L70 Moonshadow (1500 hp, cost 1100 mana, 4.5s cast, 18s recast)
        -- L75 Lunarlight Rk. II (1754 hp, cost 1223 mana, 4.5s cast, 18s recast)
        -- L80 Crescentbloom (3825 hp, cost 1386 mana, 4.5s cast, 12s recast)

        -- pct group heals:
        -- L78 Survival of the Fittest Rk. II (1394-6968 hp based on HP %, 1s cast, 3 min recast)
    },

    ["hot"] = { -- XXX impl
        -- hot v2 - stacks with CLR/SHM/PAL HoT:
        -- L60 Nature's Recovery (slot 2: 30 hp/tick, 3.0 min, recast 90s, cost 250 mana)
        --"Nature's Recovery/HealPct|70/MinMana|20",
    },

    --["who_to_hot"] = "Tanks", -- XXX impl
}

settings.evac = {
    -- L18 Lesser Succor (10.5s cast, cost 150 mana)
    -- L57 Succor (9s cast, cost 100 mana)
    -- Lxx Exodus AA (instant cast, recast time 72 min)
    "Exodus",

    "Succor",
}

settings.assist = {
    ["nukes"] = { -- XXX implement
        ["main"] = {
            -- fire nukes:
            -- L28 Combust (156-182 hp, cost 85 mana)
            -- L38 Firestrike (402-422 hp, cost 138 mana)
            -- L48 Starfire (634 hp, cost 186 mana)
            -- L54 Scoriae (986 hp, cost 264 mana)
            -- L59 Wildfire (1294 hp, cost 335 mana)
            -- L64 Summer's Flame (1600 hp, cost 395 mana)
            -- L65 Sylvan Fire (1761 hp, cost 435 mana)
            -- L69 Solstice Strike (2201 hp, cost 494 mana)
            -- L74 Equinox Burn Rk. III (2972 hp, cost 632 mana)
            -- L78 Solarsilver (2815 hp, cost 593, chance to proc a dmg buff???)
            -- L79 Equinox Brand Rk. II (3577 hp, cost 707 mana)
            "Solstice Strike/NoAggro/MinMana|30",

            -- pct fire nukes:
            -- L77 Reaping Inferno Rk. II (3018 hp, cost 596 mana, max hp 35%, trigger on KS: Inferno Harvest)
            "Reaping Inferno/MaxHP|30", -- XXX impl MaxHP filter

            -- taunt fire+cold nuke:
            -- L73 Winter's Flame Rk. III (427 hate, -1000 prismatic resist, trigger Winter's Flame Burn III + Winter's Flame Frostbite III)
        },
        ["fastfire"] = {
            "Solstice Strike/NoAggro/MinMana|30",
        },

        ["fastcold"] = {
            -- cold nukes:
            -- L47 Ice (511-538 hp, cost 142 mana)
            -- L55 Frost (837 hp, cost 202 mana)
            -- L60 Moonfire (1132 hp, cost 263 mana)
            -- L65 Winter's Frost (1375 hp, cost 305 mana)
            -- L65 Ancient: Chaos Frost (1450 hp, cost 290 mana)
            -- L70 Glitterfrost (1892 hp, cost 381 mana)
            -- L70 Ancient: Glacier Frost (2042 hp, cost 405 mana)
            -- L75 Rime Crystals Rk. III (2554 hp, cost 488 mana)
            -- L80 Hoar Crystals Rk. II (3074 hp, cost 546 mana)
            "Ancient: Glacier Frost/NoAggro/MinMana|30",
        },
    },


    ["dots"] = { -- XXX  impl [DoTs on Assist]
        -- fire dot + debuff:
        -- L67 Immolation of the Sun (-174-178 hp/tick, slot 3: -40 fr, slot 10: -36 ac, resist adj -50)
        "Immolation of the Sun/Gem|3/MaxTries|2",

        -- magic dots:
        -- Lxx Winged Death
        -- L63 Swarming Death (MAGIC: resist adj -100, 216-225 hp/tick, cost 357 mana)
        -- L68 Wasp Swarm (MAGIC: resist adj -100, 283-289 hp/tick, 54s, cost 454 mana)
        "Wasp Swarm/Gem|4",

        -- fire dots:
        -- L64 Vengeance of Tunare (FIRE: resist adj -30, 293-310 hp/tick, cost 345 mana)
        -- L69 Vengeance of the Sun (FIRE: resist adj -30, 408-412 hp/tick, 30s, cost 454 mana)
        --"Vengeance of the Sun/Gem|4",
    },

    ["debuffs_on_command"] = { -- XXX impl
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
        "Hand of Ro/Gem|7/MaxTries|2",

        -- 2: -50 fire resist adj (slot 3: -40 fr, slot 10: -36 ac)
        "Immolation of the Sun/Gem|3/MaxTries|2",
        -- 3: 0 fire resist adj (slot 5: -90 atk, slot 6: -19 ac)
        "Sun's Corona/Gem|4/MaxTries|2",

        -- 4: -200 cold resist adj (-55 cr, -30-36 ac)
        "Glacier Breath/Gem|6/MaxTries|2",
    },

    ["quickburns"] = {
        -- oow t2 chest: Everspring Jerkin of the Tangled Briars (reduce cast time by 25% for 0.7 min)
        --"Everspring Jerkin of the Tangled Briars",

        "Nature's Guardian",

        -- epic 1.5: Staff of Living Brambles
        -- epic 2.0: Staff of Everliving Brambles
        "Staff of Everliving Brambles",

        --"Silent Casting",
    },

    ["longburns"] = {
        -- L65 Nature's Boon Rank 1 AA (ae heal ward)
        "Nature's Boon",
    },

    ["pbae"] = { -- XXX impl
        -- magic:
        -- L21 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
        -- L31 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
        -- L48 Upheaval (618-725 hp, aerange 35, recast 24, cost 625 mana)
        -- L61 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
        -- L66 Earth Shiver (1105 hp, aerange 35, recast 24s, cost 812 mana)
        -- L70 Hungry Vines (ae snare, aerange 50, recast 30s, cost 500 mana, duration 12s)
        "Earth Shiver/Gem|6/MinMana|10",
        "Catastrophe/Gem|8/MinMana|10",
        "Upheaval/Gem|7/MinMana|10",
    }
}

return settings
