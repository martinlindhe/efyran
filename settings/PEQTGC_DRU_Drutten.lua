local settings = { }

settings.swap = {
    ["main"] = "Staff of Everliving Brambles|Mainhand/Shield of the Planar Assassin|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",

    ["melee"] = "Staff of Everliving Brambles|Mainhand", -- 1h blunt
}

settings.gems = {
    ["Ancient: Chlorobon"] = 1, -- heal
    ["Solstice Strike"] = 2, -- fire nuke
    ["Immolation of the Sun"] = 3, -- debuff+dot
    ["Wasp Swarm"] = 4, -- dot
    ["Blessing of Steeloak"] = 6,
    ["Hand of Ro"] = 7,
    ["Remove Greater Curse"] = 8,
    ["Skin of the Reptile"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    "Earring of Dragonkin", -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)

    "Xxeric's Matted-Fur Mask", -- Reyfin's Racing Thoughts (slot 4: 450 mana pool)

    -- self ds:
    -- L07 Thistlecoat (4-6 ac, 1 ds)
    -- Lxx Thorncoat (31 ac, 5 ds)
    -- L56 Bladecoat (37 ac, 6 ds)
    -- L64 Brackencoat (49 ac, 13 ds)
    -- L68 Nettlecoat (64 ac, 17 ds)
    --"Nettlecoat",

    -- self mana regen:
    -- L60 Mask of the Stalker (3 mana/tick)
    -- L65 Mask of the Forest (4 mana/tick)
    -- L70 Mask of the Wild (5 mana/tick)
    "Mask of the Wild/MinMana|10",

    -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
    "Blessing of Steeloak/MinMana|20",

    -- L51 Circle of Winter (45 fr) - dont stack with Seasons
    -- L52 Circle of Summer (45 cr) - stacks with Seasons
    -- L58 Circle of Seasons (55 fr, 55 cr)
    -- L64 Protection of Seasons (72 fr, 72 cr)
    "Protection of Seasons/MinMana|40",

    "Shimmering Bauble of Trickery/Shrink",
}

settings.healing = {
    ["life_support"] = {
        -- L70 Convergence of Spirits I AA (1000 hp instant, 500 hp/tick, 60 ds, 54 ac)
        -- L70 Convergence of Spirits II AA (1500 hp instant, 750 hp/tick, 65 ds, 60 ac)
        -- L70 Convergence of Spirits III AA (2000 hp instant, 1000 hp/tick, 70 ds, 66 ac)
        "Convergence of Spirits/CheckFor|Spirit of the Wood/HealPct|50/MinMobs|10",

        "Skin of the Reptile/HealPct|50/MinMobs|10",

        -- melee guard:
        -- L69 Oaken Guard (mitigate 75% melee dmg for 5000 + Oaken Guard Parry proc, 1s cast, timer 5, 15 min recast)
        --"Oaken Guard/HealPct|50/MinMobs|5", -- XXX need a gem for it

        "Distillate of Divine Healing XI/HealPct|10",
    },

    ["cures"] = { -- XXX impl.
--[[
Cure=Remove Greater Curse/Bandy/CheckFor|Clinging Apathy
Cure=Pure Blood/Bandy/CheckFor|Plague of Hulcror
Cure=Pure Blood/Bandy/CheckFor|Kneeshatter

; Keldovan the Harrier - decrease healing effectiveness by 80%
Cure=Remove Greater Curse/Bandy/CheckFor|Packmaster's Curse/Zone|anguish
Cure=Remove Greater Curse/Manu/CheckFor|Packmaster's Curse/Zone|anguish
Cure=Remove Greater Curse/Crusade/CheckFor|Packmaster's Curse/Zone|anguish
Cure=Remove Greater Curse/Nullius/CheckFor|Packmaster's Curse/Zone|anguish
Cure=Remove Greater Curse/Juancarlos/CheckFor|Packmaster's Curse/Zone|anguish

; mpg raid endurance
Cure=Remove Greater Curse/Nullius/CheckFor|Complex Gravity/Zone|chambersb

; Warden Hanvar - mana dot
Cure=Remove Greater Curse/Stor/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Kamaxia/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Maynarrd/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Gerrald/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Arriane/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Helge/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Hankie/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Samma/CheckFor|Feedback Dispersion/Zone|anguish
Cure=Remove Greater Curse/Erland/CheckFor|Feedback Dispersion/Zone|anguish

; Overlord Mata Muram - increase spell cast time by 100%, 0.5 min
Cure=Remove Greater Curse/Stor/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Kamaxia/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Maynarrd/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Gerrald/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Arriane/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Helge/CheckFor|Relinquish Spirit/Zone|anguish
Cure=Remove Greater Curse/Hankie/CheckFor|Relinquish Spirit/Zone|anguish

; Overlord Mata Muram - silence on CH bots
Cure=Remove Greater Curse/Arriane/CheckFor|Void of Suppression/Zone|anguish
Cure=Remove Greater Curse/Gerrald/CheckFor|Void of Suppression/Zone|anguish
Cure=Remove Greater Curse/Hankie/CheckFor|Void of Suppression/Zone|anguish
Cure=Remove Greater Curse/Hybregee/CheckFor|Void of Suppression/Zone|anguish


; cursecaller root
CureAll=Remove Greater Curse/CheckFor|Debilitating Curse of Noqufiel/Zone|inktuta

CureAll=Pure Blood/CheckFor|Plague of Hulcror/Zone|wallofslaughter
CureAll=Remove Greater Curse/CheckFor|Gravel Rain/Zone|potactics,poearthb
CureAll=Remove Greater Curse/CheckFor|Solar Storm/Zone|poair
CureAll=Remove Greater Curse/CheckFor|Curse of the Fiend/Zone|solrotower
CureAll=Remove Greater Curse/CheckFor|Deathly Chants
CureAll=Remove Greater Curse/CheckFor|Storm Comet/Zone|poair
CureAll=Remove Greater Curse/CheckFor|Curse of Rhag`Zadune/Zone|ssratemple
CureAll=Remove Greater Curse/CheckFor|Wanton Destruction/Zone|anguish,txevu

; Overlord Mata Muram, -25% accuracy, -100 casting level, 1.0 min
CureAll=Remove Greater Curse/CheckFor|Torment of Body/Zone|anguish

CureAll=Pure Blood/CheckFor|Chailak Venom/Zone|riftseekers

AutoRadiant (On/Off)=On
RadiantCure=Fulmination/MinSick|1/Zone|txevu
RadiantCure=Skullpierce/MinSick|1/Zone|qvic
RadiantCure=Chaotica/MinSick|1/Zone|riftseekers
RadiantCure=Pyronic Lash/MinSick|1/Zone|riftseekers
RadiantCure=Whipping Dust/MinSick|1/Zone|causeway

RadiantCure=Gaze of Anguish/MinSick|1/Zone|anguish
RadiantCure=Chains of Anguish/MinSick|1/Zone|anguish
RadiantCure=Feedback Dispersion/MinSick|1/Zone|anguish
RadiantCure=Wanton Destruction/MinSick|1/Zone|anguish,txevu
]]--
    },

    ["tanks"] = {
        --"Bandy",
        "Nullius",
        --"Manu",
        "Crusade",
    },

    ["tank_heal"] = {
        "Ancient: Chlorobon/HealPct|35/MinMana|5",
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
        "Ancient: Chlorobon/HealPct|60/MinMana|20",
    },

    ["important"] = {
        "Stor",
        "Kamaxia",
        "Maynarrd",
        "Arriane",
        "Helge",
        "Gerrald",
        "Hankie",
        "Hybregee",

        "Drutten",
        "Lofty",
        "Gimaxx",
        "Samma",
        "Erland",
        "Kesok",
    },

    ["important_heal"] = {
        "Kelp-Covered Hammer/HealPct|85", -- tacvi clicky

        "Ancient: Chlorobon/HealPct|75/MinMana|5",
    },

    ["group_heal"] = { -- XXX impl
        -- group heals:
        -- L70 Moonshadow (1500 hp, cost 1100 mana, 4.5s cast, 18s recast)
    },

    ["hot"] = { -- XXX impl
        -- hot v2 - stacks with CLR/SHM/PAL HoT:
        -- L60 Nature's Recovery (slot 2: 30 hp/tick, 3.0 min, recast 90s, cost 250 mana)
        -- L63 Spirit of the Wood AA
        --"Nature's Recovery/HealPct|70/MinMana|20",
    },

    --["who_to_hot"] = "Tanks", -- XXX impl
}

settings.evac = {
    "Exodus", -- Lxx Exodus AA (instant cast, recast time 72 min)
    "Succor", -- L57 Succor (9s cast, cost 100 mana)
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
            "Solstice Strike/NoAggro/MinMana|30",
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
            "Ancient: Glacier Frost/Gem|2/NoAggro/MinMana|30",
        },
    },


    ["dots"] = { -- XXX  impl [DoTs on Assist]
        -- fire dot + debuff:
        -- L67 Immolation of the Sun (-174-178 hp/tick, slot 3: -40 fr, slot 10: -36 ac, resist adj -50)
        "Immolation of the Sun/MaxTries|2",

        -- magic dots:
        -- Lxx Winged Death
        -- L63 Swarming Death (MAGIC: resist adj -100, 216-225 hp/tick, cost 357 mana)
        -- L68 Wasp Swarm (MAGIC: resist adj -100, 283-289 hp/tick, 54s, cost 454 mana)
        "Wasp Swarm",

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
        "Hand of Ro/MaxTries|2",

        -- 2: -50 fire resist adj (slot 3: -40 fr, slot 10: -36 ac)
        "Immolation of the Sun/MaxTries|2",
        -- 3: 0 fire resist adj (slot 5: -90 atk, slot 6: -19 ac)
        "Sun's Corona/Gem|4/MaxTries|2",

        -- 4: -200 cold resist adj (-55 cr, -30-36 ac)
        "Glacier Breath/Gem|6/MaxTries|2",
    },

    ["quickburns"] = {
        -- epic 1.5: Staff of Living Brambles
        -- epic 2.0: Staff of Everliving Brambles
        "Staff of Everliving Brambles",

        "Nature's Guardian",

        --"Silent Casting",

        -- oow t1 chest: XXX
        -- oow t2 chest: Everspring Jerkin of the Tangled Briars (reduce cast time by 25% for 0.7 min)
        "Everspring Jerkin of the Tangled Briars",

        -- L65 Nature's Boon Rank 1 AA (ae heal ward)
        "Nature's Boon",
    },

    ["longburns"] = {
        -- L65 Nature's Boon Rank 1 AA (ae heal ward)
        "Nature's Boon",
    },

    ["pbae"] = {
        -- magic:
        -- L21 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
        -- L31 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
        -- L48 Upheaval (618-725 hp, aerange 35, recast 24, cost 625 mana)
        -- L61 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
        -- L66 Earth Shiver (1105 hp, aerange 35, recast 24s, cost 812 mana)
        -- L70 Hungry Vines (ae snare, aerange 50, recast 30s, cost 500 mana, duration 12s)
        --"Earth Shiver/Gem|6/MinMana|10",
        --"Catastrophe/Gem|8/MinMana|10",
        --"Upheaval/Gem|7/MinMana|10",
    }
}

return settings
