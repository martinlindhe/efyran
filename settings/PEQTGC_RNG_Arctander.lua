local settings = { }

settings.swap = { -- XXX impl
    --[[
    Main=Aurora, the Heartwood Blade|Mainhand/Notched Blade of Bloodletting|Offhand/Symbol of the Overlord|Ranged

    BFG=Breezeboot's Frigid Gnasher|Mainhand

    Ranged=Plaguebreeze|Ranged

    NoRiposte=Fishing Pole|Mainhand/Muramite Aggressor's Bulwark|Offhand

    Fishing=Fishing Pole|Mainhand
    ]]--
}

settings.buffs = {
    "Fuzzy Foothairs",

    -- atk buff:
    -- Furious Might (slot 5: 40 atk)
    "Veil of Intense Evolution",

    -- form of endurance:
    -- Form of Endurance III (slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    -- mana regen clicky:
    -- Aura of Taelosia (slot 8: 7 mana regen, slot 10: 7 hp regen)
    -- NOTE: jan 2021-out of buff slots and mana is low prio
    --"Pendant of Discord",

    -- ac + ds:
    -- L68 Briarcoat (49 ac, 8 ds)
    -- "Briarcoat/MinMana|70",

    --[[

    -- SLOT 1 PROC BUFFS:
    -- L64 Nature's Rebuke (add proc Nature's Rebuke Strike)
    -- L65 Symbol of the Planemasters (Pestilence Shock buff, potime)
    -- L65 Cry of Thunder (add proc Cry of Thunder Strike)
    -- L65 Sylvan Call (add proc Sylvan Call Strike)
    -- L66 Nature Veil (slot 1: add Defensive Proc: Nature's Veil Parry) - makes mob less hateful toward you
    -- L69 Nature's Denial (add proc Nature's Denial Strike)
    -- L70 Call of Lightning (slot 1: Add Proc Call of Lightning Strike)
    --"Nature Veil/MinMana|50",
    "Call of Lightning/Gem|9/MinMana|50",

    -- L65 Mask of the Stalker (slot 3: 3 mana regen)
    -- NOTE: skipping Mask of the Stalker because out of buff slots, june 2022
    --"Mask of the Stalker/MinMana|30",

    -- L62 Strength of Tunare (slot 1: 92 atk, 125 hp, group, cost 250 mana)
    -- L67 Strength of the Hunter (75 atk, 155 hp, group, cost 325 mana)
    -- NOTE: Tunare has more ATK
    "Strength of Tunare/Gem|8/MinMana|50",


    Group Buff=Strength of Tunare
    Bot Buff=Strength of Tunare/Besty/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Blod/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Urinfact/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Sweetlard/MinMana|50/CheckFor|Spiritual Vitality

    Bot Buff=Strength of Tunare/Azoth/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Yelwen/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Laser/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Knuck/MinMana|50/CheckFor|Spiritual Vitality

    Bot Buff=Strength of Tunare/Kniven/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Strupen/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Fosco/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Lotho/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Grimakin/MinMana|50/CheckFor|Spiritual Vitality

    Bot Buff=Strength of Tunare/Spela/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Garotta/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Gerwulf/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Chancer/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Sophee/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Alethea/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Moola/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Saberku/MinMana|50/CheckFor|Spiritual Vitality

    Bot Buff=Strength of Tunare/Rupat/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Debre/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Kedel/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Lynnmary/MinMana|50/CheckFor|Spiritual Vitality

    Bot Buff=Strength of Tunare/Kasta/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Bulf/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Halsen/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Nacken/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Ryggen/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Papp/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Hypert/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Crust/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Pantless/MinMana|50/CheckFor|Spiritual Vitality
    Bot Buff=Strength of Tunare/Plin/MinMana|50/CheckFor|Spiritual Vitality

    ; L64 Spirit of the Predator (70 atk slot 2)
    ; L69 Howl of the Predator (90 atk slot 2, double atk 3-20%)
    Self Buff=Howl of the Predator/MinMana|50

    Bot Buff=Howl of the Predator/Azoth/MinMana|50
    Bot Buff=Howl of the Predator/Yelwen/MinMana|50
    Bot Buff=Howl of the Predator/Laser/MinMana|50
    Bot Buff=Howl of the Predator/Knuck/MinMana|50

    Bot Buff=Howl of the Predator/Fosco/MinMana|50
    Bot Buff=Howl of the Predator/Lotho/MinMana|50
    Bot Buff=Howl of the Predator/Grimakin/MinMana|50
    Bot Buff=Howl of the Predator/Kniven/MinMana|50
    Bot Buff=Howl of the Predator/Strupen/MinMana|50

    Bot Buff=Howl of the Predator/Blod/MinMana|50
    Bot Buff=Howl of the Predator/Urinfact/MinMana|50
    Bot Buff=Howl of the Predator/Sweetlard/MinMana|50

    Bot Buff=Howl of the Predator/Besty/MinMana|50

    Bot Buff=Howl of the Predator/Spela/MinMana|50
    Bot Buff=Howl of the Predator/Garotta/MinMana|50
    Bot Buff=Howl of the Predator/Gerwulf/MinMana|50
    Bot Buff=Howl of the Predator/Sophee/MinMana|50
    Bot Buff=Howl of the Predator/Chancer/MinMana|50
    Bot Buff=Howl of the Predator/Alethea/MinMana|50
    Bot Buff=Howl of the Predator/Moola/MinMana|50
    Bot Buff=Howl of the Predator/Saberku/MinMana|50


    Bot Buff=Howl of the Predator/Debre/MinMana|50
    Bot Buff=Howl of the Predator/Kedel/MinMana|50
    Bot Buff=Howl of the Predator/Rupat/MinMana|50
    Bot Buff=Howl of the Predator/Lynnmary/MinMana|50

    Bot Buff=Howl of the Predator/Kasta/MinMana|50
    Bot Buff=Howl of the Predator/Bulf/MinMana|50
    Bot Buff=Howl of the Predator/Plin/MinMana|50
    Bot Buff=Howl of the Predator/Pantless/MinMana|50
    Bot Buff=Howl of the Predator/Crust/MinMana|50
    Bot Buff=Howl of the Predator/Hypert/MinMana|50
    Bot Buff=Howl of the Predator/Halsen/MinMana|50
    Bot Buff=Howl of the Predator/Nacken/MinMana|50
    Bot Buff=Howl of the Predator/Ryggen/MinMana|50
    Bot Buff=Howl of the Predator/Papp/MinMana|50


    ;Bot Buff=Howl of the Predator/Bandy/MinMana|50
    ;Bot Buff=Howl of the Predator/Manu/MinMana|50
    ;Bot Buff=Howl of the Predator/Juancarlos/MinMana|50
    ;Bot Buff=Howl of the Predator/Crusade/MinMana|50
    ;Bot Buff=Howl of the Predator/Nullius/MinMana|50


    ; ac + ds:
    ; L62 Call of the Rathe (10 ds, 34 ac)
    ; L67 Guard of the Earth (13 ds, 49 ac)
    ;;Bot Buff=Guard of the Earth/Bandy/MinMana|50
    ;;Bot Buff=Guard of the Earth/Manu/MinMana|50
    ;;Bot Buff=Guard of the Earth/Crusade/MinMana|50
    ;;Bot Buff=Guard of the Earth/Nullius/MinMana|50
    ]]--
}

settings.healing = { -- XXX implement
    ["life_support"] = { -- XXX implement
        "Weapon Shield Discipline/HealPct|30/CheckFor|Resurrection Sickness",
        "Distillate of Divine Healing XI/HealPct|10/CheckFor|Resurrection Sickness",
    },

    ["important"] = { -- XXX impl. prioritized list of toons to heal as "Important" group in who_to_heal
        "Stor",
        "Kamaxia",
        "Maynarrd",
        "Arriane",
        "Helge",
        "Gerrald",
        "Hankie",
        "Hybregee",
    },

    ["important_heal"] = { -- XXX impl. heal spell to heal these toons with
        -- L65 Sylvan Light (850 hp, 3s cast time, cost 370 mana)
        -- L67 Sylvan Water (1135-1165 hp, 3s cast time, cost 456 mana)
        "Sylvan Water/HealPct|45/Gem|1/MinMana|5",
    },

    ["who_to_heal"] = "Important", -- XXX impl. was "ImportantBots" in e3. accept both values
}

settings.assist = {
    ["type"] = "Melee", -- XXX "Ranged",  "Off"
    ["stick_point"] = "Behind",
    ["melee_distance"] = 12,
    ["ranged_distance"] = 80,
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = { -- XXX implememt !!!
        "Kick",
    },

    ["nukes"] = { -- XXX implement
        -- fire nukes - timer 1:
        -- L65 Sylvan Burn (673 hp, 0.5s cast, cost 242 mana)
        -- L69 Hearth Embers (842 hp, 0.5s cast, cost 275 mana, 30s recast)

        -- fire nukes - timer 4:
        -- L65 Ancient: Burning Chaos (734 hp, 0.5s cast, cost 264 mana)
        -- L70 Scorched Earth (1150 hp, 0.5s cast, cost 365 mana, 30s recast)

        --Main=Scorched Earth/noAggro/Gem|2/MinMana|60
        --FastFire=Scorched Earth/noAggro/Gem|2/MinMana|60
        --BigFire=Scorched Earth/noAggro/Gem|2/MinMana|60

        -- cold nukes - timer 2:
        -- L68 Frost Wind (956 hp, 0.5s cast, cost 369 mana, 30s recast)
        -- cold nukes - timer 3:
        -- L63 Frozen Wind (695 hp, 0.5s cast, cost 295 mana)
        -- L70 Ancient: North Wind (1032 hp, 0.5s cast, 30s recast, cost 392 mana)

        --FastCold=Ancient: North Wind/noAggro/Gem|3/MinMana|60
        --BigCold=Ancient: North Wind/noAggro/Gem|3/MinMana|60
    },

    ["dots"] = { -- XXX implement. was called "DoTs on assist" in e3
        -- magic dots:
        -- L67 Locust Swarm (magic -100 adj, 173-179 hp/tick, 1m, cost 406 mana)
        -- NOTE: RNG dot wont stack with DRU dot which is stronger ???
        --"Locust Swarm/Gem|3",

        -- Entrap AA
        "Entrap/MaxTries|2",
    },

    ["debuffs"] = {-- XXX impl
        -- snare:
        -- L69 Earthen Shackles (chromatic -50 adj, 3.0 min, 55-60% snare)
        --"Earthen Shackles/Gem|3",
    },

    ["debuffs_on_command"] = {  -- XXX impl
    },

    ["targetae"] = { -- XXX impl???
        "Hail of Arrows/MinMana|5",
    },

    ["quickburns"] = {-- XXX implememt !!!
        -- combat skill - timer 1:
        -- L55 Trueshot Discipline (XXX)
        -- L69 Warder's Wrath (33m45s reuse, increase accuracy and crit rate for 1m)
        "Warder's Wrath",

        -- epic 1.5: Heartwood Blade (critical melee chance 110%, accuracy 110%)
        -- epic 2.0: Aurora, the Heartwood Blade (critical melee chance 170%, accuracy 170%, 1 min duration, 5 min recast)
        "Aurora, the Heartwood Blade",

        -- L70 - 20 min reuse:
        "Outrider's Attack",

        -- L6x Guardian of the Forest Rank 1 (song id: 30741, 15m reuse, -30% with 3/? rank aa: 10m30s)
        "Guardian of the Forest",

        -- oow T1 bp: Sunrider's Vest (add self proc Minor Lightning Call Effect for 18s)
        -- oow T2 bp: xxx
        "Sunrider's Vest",

        -- quick burn some extra nukes, timer 1, 2 and 3
        "Ancient: North Wind/Gem|3",
        "Hearth Embers/Gem|4",
        "Frost Wind/Gem|7",
    },

    ["longburns"] = {-- XXX implememt !!!
        -- AA 15 min reuse (also MGB:ed, so disabled)
        --"Auspice of the Hunter",      -- XXX condition: only use if MGB AA is down and more than 15 min cooldown.
    },
}


return settings
