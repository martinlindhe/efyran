local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Bazu Claw Hammer|Mainhand/Aegis of Superior Divinity|Offhand",
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

    "Earring of Dragonkin", -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)
    "Xxeric's Matted-Fur Mask",     -- Reyfin's Racing Thoughts (slot 4: 450 mana pool)

    "Aura of Devotion/MinMana|40",

    -- L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
    "Panoply of Vie/MinMana|70",

    "Balikor's Mark/MinMana|75/CheckFor|Hand of Conviction",

    -- ac - slot 4:
    -- L66 Ward of Valiance (72 ac)
    -- NOTE: stacks with Symbol + DRU Skin + Focus
    "Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction",
}

settings.healing = {
    ["life_support"] = {
        -- L70 Sanctuary AA (id:5912, removes you from combat), 1h12 min reuse
        --"Sanctuary/HealPct|13",

        -- L69 Ward of Retribution (add defenstive proc: Ward of Retribution Parry)
        "Ward of Retribution/HealPct|50/CheckFor|Ward of Retribution",

        "Distillate of Divine Healing XI/HealPct|12",

        "Divine Avatar/HealPct|20",

        "Divine Retribution/HealPct|25",
    },

    ["tanks"] = {
        "Bandy",
        "Nullius",
        "Manu",
        "Crusade",
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
        "Ancient: Hallowed Light/HealPct|80/MinMana|5",
    },

    ["important"] = {"Spela"},
    ["important_heal"] = {"Pious Remedy/HealPct|65/MinMana|30"},

    ["all_heal"] = {
        "Weighted Hammer of Conviction/HealPct|40", -- tacvi clicky
        "Pious Remedy/HealPct|25/MinMana|30",
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

    ["divine_arbitration"] = 60,    -- XXX impl. was [Cleric] Divine Arbitrsation pct in e3
    ["celestial_regeneration"] = 25, -- XXX impl. was [Cleric] Celestial Regeneration pct in e3

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
        -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        "Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse (XXX disabled because of casting time)
        "Celestial Hammer",
    },

    ["pbae"] = {
        -- magic pbae:
        -- "Calamity/Gem|6/MinMana|10",
        -- "Catastrophe/Gem|7/MinMana|10",
    },
}

return settings
