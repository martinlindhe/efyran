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

settings.group_buffs = {

    -- hp buff:
    -- L49 Protection of Nature (16 ac, 248-25 hp, 2 hp/tick, group)
    -- L59 Protection of the Cabbage (24 ac, 467-485 hp, 6 mana/tick)
    -- L60 Protection of the Glades (24 ac, 470-485 hp, 6 mana/tick, group)
    -- L63 Protection of the Nine (32 ac, 618 hp, 8 mana/tick, cost 725 mana)
    -- L65 Blessing of the Nine (32 ac, 618 hp, 8 mana/tick, cost 1700 mana, group)
    -- L68 Steeloak Skin (43 ac, 772 hp, 9 mana/tick, cost 906 mana)
    -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
    -- L72 Direwild Skin Rk. II (54 ac, 965 hp, 10 mana/tick, cost 1133 mana)
    -- L75 Blessing of the Direwild Rk. II (56 ac, 1004 hp, 10 mana/tick, cost 2873 mana, group)
    -- L77 Ironwood Skin Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 1382 mana)
    -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
    ["skin"] = {
        "Protection of Nature/MinLevel|1",
        "Protection of the Nine/MinLevel|46",
        "Blessing of the Nine/MinLevel|47",
        "Blessing of Steeloak/MinLevel|62",
        "Blessing of the Direwild/MinLevel|71",     -- XXX unsure of minlevel
        "Blessing of the Ironwood/MinLevel|76",     -- XXX unsure of minlevel
    },

    -- cold & fire resists:
    -- L20 Resist Fire (slot 1: 30-40 fr)
    -- L30 Resist Cold (slot 1: 39-40 cr)
    -- L51 Circle of Winter (slot 1: 45 fr) - don't stack with Protection of Seasons
    -- L52 Circle of Summer (slot 4: 45 cr) - stack with Protection of Seasons
    -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
    ["dru_resists"] = {-- XXX unused
        "Resist Fire/MinLevel|1",
        "Resist Cold/MinLevel|1",
        "Circle of Seasons/MinLevel|44",
        "Protection of Seasons/MinLevel|47",
    },

    -- corruption resists (CLR/DRU):
    -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
    ["corruption"] = { -- XXX unused
        "Resist Corruption/MinLevel|71",    -- XXX unsure of minlevel
        "Forbear Corruption/MinLevel|76",   -- XXX unsure of minlevel
    },

    ["regen"] = {
        -- L34 Regeneration (5-9 hp/tick)
        -- L39 Pack Regeneration (9 hp/tick)
        -- L42 Chloroplast (10-19 hp/tick)
        -- L45 Pack Chloroplast (13-19 hp/tick)
        -- L54 Regrowth (20-38 hp/tick, 18.4 min, cost 300 mana)
        -- L58 Regrowth of the Grove (32-38 hp/tick, 18.4 min, cost 600 mana, group)
        -- L61 Replenishment (40-58 hp/tick, 19.6 min, cost 275 mana)
        -- L63 Blessing of Replenishment (44-58 hp/tick, 19.6 min, cost 650 mana, group)
        -- L66 Oaken Vigor (60-70 hp/tick, 21 min, cost 343 mana)
        -- L69 Blessing of Oak (66-70 hp/tick, 21 min, cost 845 mana, group)
        -- L76 Spirit of the Stalwart Rk. II (105-144 hp/tick, 21 min, cost 523 mana)
        -- L79 Talisman of the Stalwart Rk. II (111-144 hp/tick, 21 min, cost 1238 mana)
        "Chloroplast/MinLevel|1",
        "Regrowth/MinLevel|42",
        "Replenishment/MinLevel|45",
        "Oaken Vigor/MinLevel|62",
        "Spirit of the Stalwart/MinLevel|76", -- XXX unsure of minlevel
    },

    ["ds"] = {
        -- L07 Shield of Thistles (4-6 ds, 15 min)
        -- L17 Shield of Barbs (7-9 ds, 15 min)
        -- L27 Shield of Brambles (10-12 ds, 15 min)
        -- L37 Shield of Spikes (14 ds, 15 min)
        -- L47 Shield of Thorns (24 ds, 15 min) - lands on LV1
        -- L49 Legacy of Spike (24 ds, 15 min, group) - lands on LV1
        -- L58 Shield of Blades (32 ds, 15 min)
        -- L59 Legacy of Thorn (32 ds, 15 min, group)
        -- L63 Shield of Bracken (40 ds, 15 min)
        -- L65 Legacy of Bracken (40 ds, 15 min, group)
        -- L67 Nettle Shield (55 ds, 15 min)
        -- L70 Legacy of Nettles (55 ds, 15 min, group)
        -- L72 Viridifloral Shield Rk. II (69 ds, 15 min)
        -- L75 Legacy of Viridiflora Rk. II (69 ds, 15 min, group)
        -- L77 Viridifloral Bulwark Rk. II (86 ds, 15 min)
        -- L80 Legacy of Viridithorns Rk. II (86 ds, 15 min, group)
        -- NOTE: MAGE DS IS STRONGER
        "Shield of Thorns/MinLevel|1",
        "Shield of Blades/MinLevel|44",
        "Shield of Bracken/MinLevel|46",
        "Nettle Shield/MinLevel|62", -- XXX unsure of minlevel
        "Viridifloral Shield/MinLevel|71",  -- XXX unsure of minlevel
        "Viridifloral Bulwark/MinLevel|76", -- XXX unsure of minlevel
    },

    ["str"] = {
        -- L07 Strength of Earth (8-15 str)
        -- L34 Strength of Stone (22-25 str)
        -- L44 Storm Strength (32-35 str)
        -- L55 Girdle of Karana (42 str)
        -- L62 Nature's Might (55 str)
        "Storm Strength/MinLevel|1",
        "Girdle of Karana/MinLevel|42",
        "Nature's Might/MinLevel|46",
    },

    -- L67 Lion's Strength (increase skills dmg mod by 5%, cost 165 mana)
    -- L71 Mammoth's Strength Rk. III (increase skills dmg mod by 8%, cost 215 mana)
    -- NOTE: SHM has group version of these spells
    ["skill_dmg_mod"] = {
        "Lion's Strength/MinLevel|62",
        "Mammoth's Strength/MinLevel|71", -- XXX minlevel
    },

    -- L09 Spirit of Wolf (48-55% speed, 36 min)
    -- L35 Pack Spirit (47-55% speed, 36 min, group)
    -- L54 Spirit of Eagle (57-70% speed, 1 hour)
    -- L62 Flight of Eagles (70% speed, 1 hour, group)
    ["runspeed"] = {
        "Pack Spirit/MinLevel|1",
        "Spirit of Eagle/MinLevel|42",
        "Flight of Eagles/MinLevel|46", 
    },
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

        -- L80 Distillate of Divine Healing XIII
        "Distillate of Divine Healing XIII/HealPct|18",

        -- XXX

        -- melee guard:
        -- L69 Oaken Guard (mitigate 75% melee dmg for 5000 + Oaken Guard Parry proc, 1s cast, timer 5, 15 min recast)
        -- L74 Direwood Guard Rk. II (mitigate 75% melee dmg for 6250 + Direwood Guard Parry proc, 1s cast, timer 5, 15 min recast)
        "Direwood Guard/HealPct|30",

        "Mask of the Ancients/HealPct|40", -- 1s cast Chlorotrope

        "Adrenaline Surge/HealPct|30/MinMana|50", -- 1.8s cast

        "Puravida/HealPct|70/MinMana|30", -- 3.75s cast
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
