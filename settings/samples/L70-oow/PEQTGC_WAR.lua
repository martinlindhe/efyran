local settings = { }

settings.debug = true

settings.swap = { -- XXX impl
    main     = "Kreljnok's Sword of Eternal Power|Mainhand/Shield of the Lightning Lord|Offhand/Plaguebreeze|Ranged",
    ranged   = "Plaguebreeze|Ranged", -- 215 range + 150 range Flight Arrow = 365

    -- for raids where tanks should not riposte, like tacvi Pixtt Riel Tavas
    noriposte = "Aged Left Eye of Xygoz|Mainhand/Shield of the Lightning Lord|Offhand",

    bfg       = "Breezeboot's Frigid Gnasher|Mainhand",
    fishing   = "Fishing Pole|Mainhand",

    -- for mpg trial of weaponry (group)
    slashdmg  = "Greatsword of Mortification|Mainhand",
    piercedmg = "Warspear of Vexation|Mainhand",
    bluntdmg  = "Girplan Hammer of Carnage|Mainhand",
}

settings.illusions = { -- TODO implement
    default       = "skeleton", -- XXX either item name, or name of another key
    skeleton      = "Amulet of Necropotence", -- 0s
    halfling      = "Fuzzy Foothairs", -- 0s
    imp           = "Imp Wings", -- 0s, levitate, +15 fire resist
    air_elemental = "Second Breath", --0s, levitate
    human         = "Circlet of Disguise", -- 7s
    darkelf       = "Guise of the Deceiver", -- 6s
}

settings.self_buffs = {
    "Amulet of Necropotence", -- XXX remove, use settings.illusions

    "Necklace of the Steadfast Spirit", -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DON'T STACK WITH Form of Defense
    "Ring of the Beast", -- Form of Endurance III (slot 5: 270 hp)
    --"Hanvar's Hoop", -- Form of Defense III (slot 10: 81 ac)

    --"Kizrak's Gauntlets of Battle/CheckFor|Hastening of Salik", -- slot 3: 30% haste

    --"Symbol of the Planemasters", -- Pestilence Shock proc buff (potime)

    --"Fearsome Shield", -- Aura of Battle (2 hp/tick, 10 atk slot 3) - don't stack with Champion

    --"Puresteel Mantle", -- Shield of Pain (10 ds slot 4)

    --"Shimmering Bauble of Trickery/Shrink",
}

settings.preferred_buffers = { "Stor", "Samma", "Drutten", "Trams", "Myggan", "Absint", "Arctander", "Besty", "Crusade" } -- XXX TODO impl. when asking for buffs, prefer these bots as they have stronger buffs etc

settings.combat_buffs = { -- XXX implement
    -- L68 Commanding Voice
    "Commanding Voice/Bandy/MinEnd|5",
}

settings.healing = {
    life_support = {
        -- epic 2.0 Kreljnok's Sword of Eternal Power (group 800 hp)
        --"Kreljnok's Sword of Eternal Power/HealPct|50",

        -- timer 1:
        -- L52 Evasive
        -- L55 Defensive
        -- L65 Stonewall
        "Stonewall Discipline/HealPct|30",

        -- timer 2:
        -- L56 Furious (riposte every incoming attack, 12s, 40 min reuse)
        -- L59 Fortitude (increase chance of evading attacks, 12s, 40 min reuse)
        "Furious Discipline/HealPct|28",

        -- oow T1 bp: Armsmaster's Breastplate - reduce damage taken for 12s
        -- oow T2 bp: Gladiator's Plate Chestguard of War - reduce damage taken for 24s
        "Gladiator's Plate Chestguard of War/HealPct|20",

        "Distillate of Divine Healing XI/HealPct|8",

        -- Warlord's Tenacity (1h reuse, reduce with AA Hastened Defiance, 10% per rank)
        -- L6x Warlord's Tenacity Rank 1 AA (id: 4926, inc max hp by 1000, heal by 1134, dot 134/tick, 1.1 min)
        -- L65 Warlord's Tenacity Rank 2 AA (id: ???)
        -- L65 Warlord's Tenacity Rank 3 AA (id: 4927, inc max hp by 1500, heal by 1700, dot 200/tick, 1.1 min)
        -- L6x Warlord's Tenacity Rank 4 AA (id: 5936, inc max hp by 3000, heal by 3410, dot 410/tick, 1.1 min)
        -- L68 Warlord's Tenacity Rank 5 AA (id: 5937, inc max hp by 4000, heal by 4545, dot 545/tick, 1.1 min)
        -- L70 Warlord's Tenacity Rank 6 AA (id: 5938, inc max hp by 5000, heal by 5680, dot 680/tick, 1.1 min)
        "Warlord's Tenacity/HealPct|6",

        "Glyph of Stored Life/HealPct|5|Zone|anguish", -- Expendable AA
    }
}

settings.misc = {       -- XXX implement
    ["auto-loot"] = false, -- XXX false=default if unset
}

settings.assist = {
    type = "Melee",
    stick_point = "Front",
    --melee_distance = 12,
    ranged_distance = 100,
    engage_percent = 98,

    taunts = { -- XXX impl. used if set
        "Taunt",
        -- XXX add more + ae taunts
    },

    abilities = {
        --"Knee Strike", -- SoD
        "Bash",
        "Kick",
        --"Disarm",
    },

    quickburns = {},

    longburns = {
        -- timer 3:
        -- L54 Mighty Strike Discipline (cause every attack to crit)
        -- L58 Fellstrike Discipline (increase melee damage)
        "Fellstrike Discipline",
    },
}

return settings
