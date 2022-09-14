local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Bazu Claw Hammer|Mainhand/Aegis of Superior Divinity|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Weighted Hammer of Conviction|Mainhand", -- 1hb
}

settings.gems = {
    ["Pious Remedy"] = 1,
    ["Pious Elixir"] = 2,
    ["Aura of Devotion"] = 3,
    ["Ancient: Hallowed Light"] = 4,
    ["Word of Vivification"] = 6,
    ["Balikor's Mark"] = 7,
    ["Ward of Retribution"] = 8,
    ["Divine Intervention"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- mana regen clicky:
    -- Reyfin's Random Musings (slot 8: 9 mana regen, slot 10: 6 hp regen)
    "Earring of Pain Deliverance",

    -- mana pool clicky:
    -- Reyfin's Racing Thoughts (slot 4: 450 mana pool, tacvi)
    -- NOTE: ran out of buff slots at 20-jan 2022
    --"Xxeric's Matted-Fur Mask",

    -- Eternal Ward (15 all resists, 45 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense
    "Lavender Cloak of Destruction",

    -- rune clicky:
    -- Mantle of Corruption (Geomantra, mitigate 20% spell dmg of 500, decrease 2 mana/tick)
    --"Mantle of Corruption",

    "Aura of Devotion/MinMana|40",

    -- absorb melee:
    -- L40 Guard of Vie (absorb 10% melee dmg to 700)
    -- L54 Protection of Vie (absorb 10% melee dmg to 1200)
    -- L62 Bulwark of Vie (absorb 10% melee dmg to 1600)
    -- L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
    "Panoply of Vie/MinMana|70",

    "Balikor's Mark/MinMana|75/CheckFor|Hand of Conviction",

    -- ac - slot 4:
    -- L61 Ward of Gallantry (54 ac)
    -- L66 Ward of Valiance (72 ac)
    -- NOTE: stacks with Symbol + DRU Skin + Focus
    "Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction",

    -- self mana regen:
    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
    -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
    -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
    -- L70 Armor of the Pious (563 hp, 46 ac, 9 mana/tick)
    -- NOTE: does not stack with DRU Skin
    --"Armor of the Pious/MinMana|90/CheckFor|Balikor's Mark",

    "Shimmering Bauble of Trickery/Shrink",
}

settings.healing = {
    ["life_support"] = {
        -- L70 Sanctuary AA (id:5912, removes you from combat), 1h12 min reuse
        "Sanctuary/HealPct|13",

        -- L69 Ward of Retribution (add defenstive proc: Ward of Retribution Parry)
        "Ward of Retribution/HealPct|50",

        "Distillate of Divine Healing XI/HealPct|12",

        -- L65 Divine Avatar Rank 1 AA (decrease melee attack by 5%, increase HoT by 100/tick)
        -- L65 Divine Avatar Rank 2 AA (decrease melee attack by 10%, increase HoT by 150/tick)
        -- L65 Divine Avatar Rank 3 AA (decrease melee attack by 10%, increase HoT by 200/tick)
        -- L70 Divine Avatar Rank 4 AA (decrease melee attack by 15%, increase HoT by 250/tick)
        -- L70 Divine Avatar Rank 5 AA (id:8157, decrease melee attack by 15%, increase HoT by 300/tick)
        -- L70 Divine Avatar Rank 6 AA (id:8158, decrease melee attack by 338%, increase HoT by 350/tick, 3.0 min, 36 min reuse)
        "Divine Avatar/HealPct|20",

        -- defensive - stun attackers:
        -- L70 Divine Retribution I AA (id:5866, proc Divine Retribution Effect)
        "Divine Retribution/HealPct|25",
    },

    ["cures"] = { -- XXX impl. was [Cures] in e3
        -- poison cures:
        -- L01 Cure Poison (-1 to -4 poison)
        -- L22 Counteract Poison (-8 posion)
        -- L48 Abolish Poison (-36 posion)
        -- L51 Pure Blood (-9 poison x4)
        -- L58 Antidote (-16 poison x4)
        -- L70 Puratus (cure all poisons from target + block next posion spell from affecting them)

        -- curse cures:
        -- L08 Remove Minor Curse (-2 curse)
        -- L23 Remove Lesser Curse (-4 curse)
        -- L38 Remove Curse (-4 curse x2)
        -- L54 Remove Greater Curse (-9 curse x5)

        -- disease cures:
        -- L04 Cure Disease (-1 to -4 disease)

        -- curing heals:
        -- L70 Desperate Renewal (4935 hp, -18 pr, -18 dr, -18 curse, cost 1375 mana)

        ["Remove Greater Curse"] = {
            --"Gravel Rain/Zone|potactics,poearthb",
            --"Solar Storm/Zone|poair", -- NOTE: makes tanks die if all clerics cure this
            "Curse of the Fiend/Zone|solrotower",
            "Feeblemind/Zone|thedeep",
        },

        ["Cure Disease"] = {
            "Rabies/Zone|chardok",
        },

        ["Antidote"] = {
            "Fulmination/Zone|Txevu",
        },

        ["Pure Blood"] = {
            "Chailak Venom/Zone|riftseekers",
        },

        -- AutoRadiant (On/Off)=On   XXX impl? you always want it on imo
        ["Radiant Cure"] = {
            -- PoP:
            --"Gravel Rain/MinSick|1/Zone|potactics,poearthb",

            -- GoD:
            "Fulmination/MinSick|1/Zone|txevu",
            "Kneeshatter/MinSick|1/Zone|qvic",
            "Skullpierce/MinSick|1/Zone|qvic",
            "Malo/MinSick|1",
            "Malicious Decay/MinSick|1",
            "Insidious Decay/MinSick|1",
            "Chaos Claws/MinSick|1",

            -- vxed,tipt:
            "Stonemite Acid/MinSick|1",
            "Tigir's Insects/MinSick|1",

            -- OOW:
            "Whipping Dust/MinSick|1/Zone|causeway",
            "Chaotica/MinSick|1/Zone|riftseekers,wallofslaughter",
            "Infected Bite/MinSick|1/Zone|riftseekers",
            "Kneeshatter/MinSick|1/Zone|provinggrounds",

            -- rss downstairs mez - XXX dont work
            --"Freezing Touch/Zone|riftseekers",

            --"Pyronic Lash/Zone|riftseekers",

            -- anguish:
            "Gaze of Anguish/MinSick|1/Zone|anguish",
            "Chains of Anguish/MinSick|1/Zone|anguish",
            "Feedback Dispersion/MinSick|1/Zone|anguish",
            "Wanton Destruction/MinSick|1/Zone|anguish,txevu",
        }
    },

    ["tanks"] = {
        "Bandy",
        "Nullius",
        --"Manu",
        --"Crusade",
        --"Juancarlos",
    },

    ["tank_heal"] = {
        -- fast heals:
        -- L58 Ethereal Light (1980-2000 hp, 3.8s cast, 490 mana)
        -- L63 Supernal Light (2730-2750 hp, 3.8s cast, 600 mana)
        -- L65 Holy Light (3275 hp, 3.8s cast, 650 mana)
        -- L65 Weighted Hammer of Conviction (tacvi class click) - Supernal Remedy (1.5s cast, 3m30s reuse)
        -- L68 Pious Light (3750-3770 hp, 3.8s cast, 740 mana)
        -- L70 Ancient: Hallowed Light (4150 hp, 3.8s cast, 775 mana)
        "Ancient: Hallowed Light/HealPct|88/MinMana|5",
    },

    ["important"] = {"Spela"},
    ["important_heal"] = {"Pious Remedy/HealPct|65/MinMana|30"},

    ["all_heal"] = {
        -- quick heals:
        -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
        -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
        -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
        -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
        -- L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
        -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
        -- L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
        -- L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)

        "Weighted Hammer of Conviction/HealPct|62", -- tacvi clicky
        "Pious Remedy/HealPct|60/MinMana|30",
    },

    ["group_heal"] = { -- XXX impl
        -- group heals:
        -- L30 Word of Health (380-485 hp, cost 302 mana)
        -- L57 Word of Restoration (1788-1818 hp, cost 898 mana)
        -- L60 Word of Redemption (7500 hp, cost 1100 mana)
        -- L64 Word of Replenishment (2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana)
        -- L69 Word of Vivification (3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana)

        -- group hot:
        -- L70 Elixir of Divinity (900 hp/tick, group, cost 1550 mana)
        -- XXX add celestial regen aa here?!
    },

    ["pet_heal"] = {}, -- XXX impl

    ["who_to_heal"] = "Tanks/All", -- XXX impl

    ["hot"] = { -- XXX impl
        -- L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
        -- L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
        -- L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
        -- L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
        -- L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
        -- L67 Pious Elixir (slot 1: 1170 hp/tick, 0.4 min, 890 mana)
        "Pious Elixir/HealPct|70/CheckFor|Spiritual Serenity",
    },

    -- ["who_to_hot"] = "Tanks", -- XXX impl

    ["divine_arbitration"] = 60,    -- XXX impl. was [Cleric] Divine Arbitrsation pct in e3
    ["celestial_regeneration"] = 25, -- XXX impl. was [Cleric] Celestial Regeneration pct in e3

    -- yaulp:
    -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
    -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
    -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
    ["yaulp"] = "Yaulp VII",    -- was e3 [Cleric].Yaulp Spell   XXX impl?  or hard code yaulp spell names?
    ["auto_yaulp"] = false, -- was e3 [Cleric].Auto-Yaulp (On/Off)  XXX impl.
}

settings.assist = {
    ["nukes"] = {
        ["main"] = {
            -- magic nukes:
            -- L44 Retribution (372-390 hp, cost 144 mana)
            -- L54 Reckoning (571 hp, cost 206 mana)
            -- L56 Judgment (842 hp, cost 274 mana)
            -- L62 Condemnation (1175 hp, cost 365 mana)
            -- L65 Order (1219 hp, cost 379 mana)
            -- L65 Ancient: Chaos Censure (1329 hp, cost 413 mana)
            -- L67 Reproach (1424-1524 hp, cost 430 mana)
            -- L69 Chromastrike (1200 hp, cost 375 mana, chromatic resist)
            -- L70 Ancient: Pious Conscience (1646 hp, cost 457 mana)
            -- "Reproach/NoAggro/Gem|7/MinMana|30",
        }
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
        -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        "Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse (XXX disabled because of casting time)
        --"Celestial Hammer",
    },

    ["pbae"] = {
        -- pbae magic nukes:
        -- L09 Word of Pain (24-29 hp, aerange 20, recast 9s, cost 47 mana)
        -- L19 Word of Shadow (52-58 hp, aerange 20, recast 9s, cost 85 mana)
        -- L26 Word of Spirit (91-104 hp, aerange 20, recast 9s, cost 133 mana)
        -- L34 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
        -- L39 Word of Souls (138-155 hp, aerange 20, recast 9s, cost 171 mana)
        -- L44 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
        -- L49 Word Divine (339 hp, aerange 20, recast 9s, cost 304 mana)
        -- L52 Upheaval (618-725 hp, aerange 35, recast 24s, cost 625 mana)
        -- L59 The Unspoken Word (605 hp, aerange 20, recast 120s, cost 427 mana)
        -- L64 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
        -- L69 Calamity (1105 hp, aerange 35, recast 24s, cost 812 mana - PUSHBACK 1.0)
        -- "Calamity/Gem|6/MinMana|10",
        -- "Catastrophe/Gem|7/MinMana|10",
    },
}

return settings
