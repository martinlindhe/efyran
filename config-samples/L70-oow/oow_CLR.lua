local settings = { }

settings.debug = true -- enable debug logging for this peer

settings.swap = {
    main = "Bazu Claw Hammer|Mainhand/Aegis of Superior Divinity|Offhand",
    fishing = "Fishing Pole|Mainhand",
    melee = "Weighted Hammer of Conviction|Mainhand", -- 1hb
}

settings.gems = {
    ["Pious Remedy"] = 1,
    ["Pious Elixir"] = 2,
    ["Ancient: Pious Conscience"] = 3, -- nuke
    ["Ancient: Hallowed Light"] = 4,
    ["Puratus"] = 5, -- XXX also temp gem
    ["Word of Vivification"] = 6,
    ["Balikor's Mark"] = 7,
    ["Reviviscence"] = 8, --["Ward of Retribution"] = 8,
    ["Divine Intervention"] = 9,
}

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    --"Mantle of Corruption", -- Mantle of Corruption (Geomantra, mitigate 20% spell dmg of 500, decrease 2 mana/tick)

    "Aura of Devotion/MinMana|40",
    "Panoply of Vie/MinMana|70",
    "Balikor's Mark/MinMana|75/CheckFor|Hand of Conviction",
    "Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction",

    "Shimmering Bauble of Trickery/Shrink",
}

settings.healing = {
    life_support = {
        -- L70 Sanctuary AA (id:5912, removes you from combat), 1h12 min reuse
        "Sanctuary/HealPct|13",

        -- L69 Ward of Retribution (add defenstive proc: Ward of Retribution Parry)   DoN
        --"Ward of Retribution/HealPct|50/CheckFor|Ward of Retribution",

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

        "Pious Elixir/HealPct|70/CheckFor|Spiritual Serenity", -- HoT
    },

    tanks = {
        "Bandy",
        "Crusade",
    },

    -- fast heals:
    -- L58 Ethereal Light (1980-2000 hp, 3.8s cast, 490 mana)
    -- L63 Supernal Light (2730-2750 hp, 3.8s cast, 600 mana)
    -- L65 Holy Light (3275 hp, 3.8s cast, 650 mana)
    -- L65 Weighted Hammer of Conviction (tacvi class click) - Supernal Remedy (1.5s cast, 3m30s reuse)
    -- L68 Pious Light (3750-3770 hp, 3.8s cast, 740 mana)
    -- L70 Ancient: Hallowed Light (4150 hp, 3.8s cast, 775 mana)

    -- quick heals:
    -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
    -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
    -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
    -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
    -- L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
    -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
    -- L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
    -- L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)

    -- HoT:
    -- L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
    -- L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
    -- L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
    -- L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
    -- L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
    -- L67 Pious Elixir (slot 1: 1170 hp/tick, 0.4 min, 890 mana)

    tank_heal = {
        "Pious Elixir/HealPct|92/CheckFor|Spiritual Serenity", -- HoT
        "Pious Remedy/HealPct|88/MinMana|5",
        "Weighted Hammer of Conviction/HealPct|80", -- tacvi clicky
    },

    important = {
        "Manu",
        "Nullius",
        "Juancarlos",
    },
    important_heal = {
        "Pious Elixir/HealPct|70/CheckFor|Spiritual Serenity", -- HoT
        "Pious Remedy/HealPct|65/MinMana|30",
    },

    all_heal = {
        "Weighted Hammer of Conviction/HealPct|72/Not|raid",
        "Pious Remedy/HealPct|60/MinMana|70/Not|raid",
    },

    group_heal = { -- XXX impl
        -- group hot:
        -- L70 Elixir of Divinity (900 hp/tick, group, cost 1550 mana)
        -- XXX add celestial regen aa here?!
    },

    pet_heal = {}, -- XXX impl

    ["divine_arbitration"] = 60,    -- XXX impl. was [Cleric] Divine Arbitrsation pct in e3
    ["celestial_regeneration"] = 25, -- XXX impl. was [Cleric] Celestial Regeneration pct in e3

    -- yaulp:
    -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
    -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
    -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
    --yaulp = "Yaulp VII",    -- was e3 [Cleric].Yaulp Spell   XXX auto select yaulp spell
    auto_yaulp = false, -- was e3 [Cleric].Auto-Yaulp (On/Off)  XXX impl.
}

settings.assist = {
    nukes = {
        main = {
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
            "Ancient: Pious Conscience/NoAggro/Gem|7/MinMana|30/Not|raid",
        }
    },

    quickburns = {
        -- oow T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
        -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        "Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse (XXX disabled because of casting time)
        "Celestial Hammer/Not|raid",
    },

    pbae = {
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
        "Calamity/Gem|6/MinMana|10",
        "Catastrophe/Gem|7/MinMana|10",
    },
}

return settings
