local settings = { }

settings.debug = true

settings.swap = {
    main = "Aurora, the Heartwood Blade|Mainhand/Notched Blade of Bloodletting|Offhand/Symbol of the Overlord|Ranged",
    bfg = "Breezeboot's Frigid Gnasher|Mainhand",
    ranged = "Plaguebreeze|Ranged",
    noriposte = "Fishing Pole|Mainhand/Muramite Aggressor's Bulwark|Offhand",
    fishing = "Fishing Pole|Mainhand",
}

settings.gems = {
    ["Sylvan Water"] = 1,
    ["Scorched Earth"] = 2,
    ["Ancient: North Wind"] = 3,
    ["Hearth Embers"] = 4,
    ["Howl of the Predator"] = 6,
    ["Frost Wind"] = 7,
    ["Strength of Tunare"] = 8,
    ["Call of Lightning"] = 9,
}

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    -- "Briarcoat/MinMana|70", -- 49 ac, 8 ds

    -- SLOT 1 PROC BUFFS:
    -- L64 Nature's Rebuke (add proc Nature's Rebuke Strike)
    -- L65 Symbol of the Planemasters (Pestilence Shock buff, potime)
    -- L65 Cry of Thunder (add proc Cry of Thunder Strike)
    -- L65 Sylvan Call (add proc Sylvan Call Strike)
    -- L66 Nature Veil (slot 1: add Defensive Proc: Nature's Veil Parry) - makes mob less hateful toward you
    -- L69 Nature's Denial (add proc Nature's Denial Strike)
    -- L70 Call of Lightning (slot 1: Add Proc Call of Lightning Strike)
    --"Nature Veil/MinMana|50",
    "Call of Lightning/MinMana|50",

    -- NOTE: skipping Mask of the Stalker because out of buff slots, june 2022
    --"Mask of the Stalker/MinMana|30", -- slot 3: 3 mana regen

    -- L62 Strength of Tunare (slot 1: 92 atk, 125 hp, group, cost 250 mana)
    -- L67 Strength of the Hunter (75 atk, 155 hp, group, cost 325 mana)
    -- NOTE: Tunare has more ATK
    "Strength of Tunare/MinMana|50",

    "Howl of the Predator/MinMana|50", -- 90 atk slot 2, double atk 3-20%
}

settings.healing = {
    life_support = {
        "Weapon Shield Discipline/HealPct|30",
        "Distillate of Divine Healing XI/HealPct|10",
    },

    important = {
        "Stor",
        "Kamaxia",
        "Maynarrd",
        "Arriane",
        "Helge",
        "Gerrald",
        "Hankie",
        "Hybregee",
    },

    important_heal = {
        -- L65 Sylvan Light (850 hp, 3s cast time, cost 370 mana)
        -- L67 Sylvan Water (1135-1165 hp, 3s cast time, cost 456 mana)
        "Sylvan Water/HealPct|45/MinMana|5",
    },
}

settings.assist = {
    type = "Melee",
    ranged_distance = 80,
    engage_at = 98,  -- XXX implement!

    abilities = {
        "Kick",
    },

    nukes = {
        -- fire nukes - timer 1:
        -- L65 Sylvan Burn (673 hp, 0.5s cast, cost 242 mana)
        -- L69 Hearth Embers (842 hp, 0.5s cast, cost 275 mana, 30s recast)

        -- fire nukes - timer 4:
        -- L65 Ancient: Burning Chaos (734 hp, 0.5s cast, cost 264 mana)
        -- L70 Scorched Earth (1150 hp, 0.5s cast, cost 365 mana, 30s recast)

        main = {
            "Scorched Earth/NoAggro/MinMana|60",
        },

        fastfire = {
            "Scorched Earth/NoAggro/MinMana|60",
        },

        bigfire = {
            "Scorched Earth/NoAggro/MinMana|60"
        },

        -- cold nukes - timer 2:
        -- L68 Frost Wind (956 hp, 0.5s cast, cost 369 mana, 30s recast)
        -- cold nukes - timer 3:
        -- L63 Frozen Wind (695 hp, 0.5s cast, cost 295 mana)
        -- L70 Ancient: North Wind (1032 hp, 0.5s cast, 30s recast, cost 392 mana)
        fastcold = {
            "Ancient: North Wind/NoAggro/MinMana|60",
        },

        bigcold = {
            "Ancient: North Wind/NoAggro/MinMana|60",
        },
    },

    dots = {
        -- magic dots:
        -- L67 Locust Swarm (magic -100 adj, 173-179 hp/tick, 1m, cost 406 mana)
        -- NOTE: RNG dot wont stack with DRU dot which is stronger ???
        --"Locust Swarm/Gem|3",

        -- Entrap AA
        "Entrap/MaxTries|2/Not|raid",
    },

    debuffs = {
        -- snare:
        -- L69 Earthen Shackles (chromatic -50 adj, 3.0 min, 55-60% snare)
        --"Earthen Shackles/Gem|3",
    },

    debuffs_on_command = {
    },

    targetae = { -- XXX impl???
        "Hail of Arrows/MinMana|5",
    },

    quickburns = {
        -- combat skill - timer 1:
        -- L55 Trueshot Discipline (XXX)
        -- L69 Warder's Wrath (33m45s reuse, increase accuracy and crit rate for 1m)
        "Warder's Wrath",

        -- oow T1 bp: Sunrider's Vest (slot 3: Add Proc: Minor Lightning Call Effect for 0.3 min)
        -- oow T2 bp: Bladewhisper Chain Vest of Journeys (slot 3: Add Proc: Major Lightning Call Effect for 0.5 min)
        "Bladewhisper Chain Vest of Journeys",

        -- epic 1.5: Heartwood Blade (critical melee chance 110%, accuracy 110%)
        -- epic 2.0: Aurora, the Heartwood Blade (critical melee chance 170%, accuracy 170%, 1 min duration, 5 min recast)
        "Aurora, the Heartwood Blade",

        --"Outrider's Attack",         -- L70 - 20 min reuse (SoD)

        -- L6x Guardian of the Forest Rank 1 (song id: 30741, 15m reuse, -30% with 3/? rank aa: 10m30s)
        "Guardian of the Forest",

        -- quick burn some extra nukes, timer 1, 2 and 3
        "Ancient: North Wind",
        "Hearth Embers",
        "Frost Wind",
    },

    longburns = {
        -- AA 15 min reuse (also MGB:ed, so disabled)
        --"Auspice of the Hunter",      -- XXX condition: only use if MGB AA is down and more than 15 min cooldown.
    },
}

return settings
