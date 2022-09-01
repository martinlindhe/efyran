local settings = { }

settings.swap = { -- XXX impl
    -- XXX to use: /bcaa //swap main
    ["main"] = "Kreljnok's Sword of Eternal Power|Mainhand/Shield of the Lightning Lord|Offhand/Plaguebreeze|Ranged",

    ["bfg"] = "Breezeboot's Frigid Gnasher|Mainhand",

    -- 215 range + 150 range Flight Arrow = 365
    ["ranged"] = "Plaguebreeze|Ranged",

    -- For raids where tanks should not riposte, like tacvi Pixtt Riel Tavas
    ["noriposte"] = "Aged Left Eye of Xygoz|Mainhand/Shield of the Lightning Lord|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    -- for mpg trial of weaponry (group):
    ["slashdmg"] = "Greatsword of Mortification|Mainhand",
    ["piercedmg"] = "Warspear of Vexation|Mainhand",
    ["bluntdmg"] = "Girplan Hammer of Carnage|Mainhand",
}

settings.self_buffs = {
    "Amulet of Necropotence",

    -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DON'T STACK WITH Form of Defense
    "Necklace of the Steadfast Spirit",

    -- Form of Endurance III (slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    -- Form of Defense III (slot 10: 81 ac) - Hanvar's Hoop (anguish)
    --"Hanvar's Hoop",

    -- god haste click:
    --"Kizrak's Gauntlets of Battle",

    -- Pestilence Shock proc buff (potime)
    --"Symbol of the Planemasters",

    -- Aura of Battle (2 hp/tick, 10 atk slot 3) - don't stack with Champion
    --"Fearsome Shield",

    -- Shield of Pain (10 ds slot 4)
    --"Puresteel Mantle",

    --"Shimmering Bauble of Trickery/Shrink",
}

settings.request_buffs = {
    -- XXX i list all buffs that I want

    -- should we ask for symbol / aegolism?
    "symbol/IfAvailable|DRU", -- CLR
    "ac/IfAvailable|DRU", -- CLR
    "skin/IfAvailable|DRU", -- DRU. XXX DRU need ini

    "aegolism/IfNotAvailable|DRU", -- CLR



    "focus/IfAvailable|SHM", -- shm

    -- XXX alternates, BST SV or RNG buff
    "brells/IfAvailable|PAL", -- XXX PAL need ini



    "enc_haste", -- enc


    -- resists
    "seasons/IfAvailable|DRU", -- DRU
    "magic_resist", -- enc
}

settings.combat_buffs = { -- XXX implement
    -- L68 Commanding Voice
    "Commanding Voice/Bandy/MinEnd|5",
}

settings.healing = {
    ["life_support"] = {
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
        --"Warlord's Tenacity/HealPct|6",

        -- Expendable AA
        --"Glyph of Stored Life/HealPct|4",
    }
}

settings.misc = {       -- XXX implement
    ["auto-loot"] = false, -- XXX false=default if unset
}

settings.assist = {
    ["type"] = "Melee", -- XXX "Ranged",  "Off"
    ["stick_point"] = "Front",
    --["melee_distance"] = 12,
    ["ranged_distance"] = 100,
    ["engage_percent"] = 98,  -- XXX implement!

    ["taunts"] = { -- XXX impl. used if set
        "Taunt",
        -- XXX add more + ae taunts
    },

    ["abilities"] = {
        "Knee Strike",
        "Bash",
        "Kick",
        --"Slam",
        --"Disarm",
    },

    ["quickburns"] = {}, -- XXX implememt !!!

    ["longburns"] = { -- XXX implememt !!!
        -- timer 3:
        -- L54 Mighty Strike Discipline (cause every attack to crit)
        -- L58 Fellstrike Discipline (increase melee damage)
        "Fellstrike Discipline",
    },
}

return settings
