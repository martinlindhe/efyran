local settings = { }

settings.swap = {
}

settings.gems = {
    -- XXX fill list

    ["Pious Remedy"] = 1,
    ["Pious Light"] = 2,
    ["Eleventh-Hour"] = 3,
    ["Word of Vivacity"] = 4,

    -- 6 unused
    ["Reproval"] = 7,
    ["Catastrophe"] = 8, -- pbae
    -- 9 unused
    ["Rallied Shield of Vie"] = 10,
    ["Aura of Resolve"] = 11,
    ["Kaerra's Mark"] = 12,
}

settings.mount = "Mottled Worg Bridle"

settings.self_buffs = {
    -- XXX do we have any clickies?

    "Aura of Resolve/MinMana|40", -- spell haste
    "Rallied Shield of Vie/MinMana|70", -- absorb melee dmg
    "Kaerra's Mark/MinMana|75/CheckFor|Hand of Temerity", -- slot 3 hp
    "Order of the Resolute/MinMana|50/CheckFor|Hand of Temerity", -- ac
}

settings.healing = {
    ["life_support"] = {
        -- Divine Arbitration AA - balance group HP %, 3 min reuse
        "Divine Arbitration/HealPct|50/MinMobs|10",

        -- epic 1.5 - balance group HP %, 6 min reuse
        "Harmony of the Soul/HealPct|50/MinMobs|10",

        -- Celestial Regeneration AA - HoT, 15 min reuse
        "Celestial Regeneration/HealPct|50/MinMobs|10",

        -- L70 Sanctuary AA (id:5912, removes you from combat), 1h12 min reuse
        "Sanctuary/HealPct|13",

        --"Ward of Retribution/HealPct|50/CheckFor|Ward of Retribution", -- XXX buy spell

        "Distillate of Divine Healing XIII/HealPct|18",

        -- L65 Divine Avatar Rank 1 AA (decrease melee attack by 5%, increase HoT by 100/tick)
        "Divine Avatar/HealPct|20",

        -- defensive - stun attackers:
        -- L70 Divine Retribution I AA (id:5866, proc Divine Retribution Effect)
        --"Divine Retribution/HealPct|25", -- XXX fixme get aa

        "Eleventh-Hour/HealPct|35/MinMana|60", -- XXX is MinMana check done on life_support ?

        "Pious Remedy/HealPct|70/MinMana|5",
    },

    ["cures"] = { -- XXX impl
    },

    ["tanks"] = {
        "Ixtrem",
    },

    ["tank_heal"] = {
        -- fast heals:
        -- L58 Ethereal Light (1980-2000 hp, 3.75s cast, 490 mana)
        -- L63 Supernal Light (2730-2750 hp, 3.75s cast, 600 mana)
        -- L65 Holy Light (3275 hp, 3.75s cast, 650 mana)
        -- L65 Weighted Hammer of Conviction (tacvi class click) - Supernal Remedy (1.5s cast, 3m30s reuse)
        -- L68 Pious Light (3750-3770 hp, 3.75s cast, 740 mana)
        -- L70 Ancient: Hallowed Light (4150 hp, 3.75s cast, 775 mana)
        -- L73 Sacred Like Rk. II (4390-4410 hp, 3.75s cast, 823 mana)
        -- L78 Solemn Light Rk. II (5051-5071 hp, 3.75s cast, 878 mana)
        "Pious Light/HealPct|88/MinMana|5",
    },

    ["all_heal"] = {
        -- quick heals:
        -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
        -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
        -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
        -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
        -- L51 Remedy (463-483 hp, 1.75s cast, 167 mana)
        -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
        -- L61 Supernal Remedy (1450 hp, 1.75s cast, 400 mana)
        -- L66 Pious Remedy (1990 hp, 1.75s cast, 495 mana)
        -- L71 Sacred Remedy Rk. II (2365 hp, 1.75s cast, 549 mana)
        -- L76 Solemn Remedy Rk. II (2720 hp, 1.75s cast, 585 mana)
        "Pious Remedy/HealPct|60/MinMana|30",

        -- timer 11:
        -- L77 Eleventh-Hour Rk. II (4656 hp, 0.5s cast, 1171 mana. target must be below 35% hp)
        --"Eleventh-Hour/HealMaxPct|34/MinMana|30", -- XXX impl filter HealMaxPct
    },

    ["group_heal"] = { -- XXX impl
        -- group heals:
        -- L30 Word of Health (380-485 hp, cost 302 mana)
        -- L57 Word of Restoration (1788-1818 hp, cost 898 mana)
        -- L60 Word of Redemption (7500 hp, cost 1100 mana)
        -- L64 Word of Replenishment (2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana)
        -- L69 Word of Vivification (3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana)
        -- L80 Word of Vivacity (4250 hp, -21 dr, -21 pr, -14 curse, cost 1540 mana)    XXX get Rk. II

        -- group hot - slot 1:
        -- L70 Elixir of Divinity (900 hp/tick, cost 1550 mana)    XXX get spell
        -- L75 Elixir of Redemption Rk. II (1136 hp/tick, cost 1883 mana)
        -- L80 Elixir of Atonement (1203 hp/tick, cost 1859 mana)
        -- XXX add celestial regen aa here?!
    },

    ["who_to_heal"] = "Tanks/All", -- XXX impl

    ["hot"] = { -- XXX impl
        -- single hot - slot 1:
        -- L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
        -- L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
        -- L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
        -- L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
        -- L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
        -- L67 Pious Elixir (1170 hp/tick, 0.4 min, 890 mana)
        -- L72 Sacxred Eilixir (1424 hp/tick, 0.4 min, 1044 mana)
        -- L77 Solemn Elixir Rk. II (1695 hp/tick, 0.4 min, 1115 mana)
        "Solemn Elixir/HealPct|70/CheckFor|Spiritual Serenity",
    },

    -- ["who_to_hot"] = "Tanks", -- XXX impl

    ["divine_arbitration"] = 60,    -- XXX impl. was [Cleric] Divine Arbitrsation pct in e3
    ["celestial_regeneration"] = 25, -- XXX impl. was [Cleric] Celestial Regeneration pct in e3

    -- yaulp:
    -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
    -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
    -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
    -- L76 Yaulp IX Rk. II (116 atk, 22 mana/tick, 60% proc chance, 30% haste)
    ["yaulp"] = "Yaulp IX",    -- was e3 [Cleric].Yaulp Spell    XXX impl?  or hard code yaulp spell names?
    ["auto_yaulp"] = false, -- was e3 [Cleric].Auto-Yaulp (On/Off)  XXX impl.
}


settings.assist = {
    ["nukes"] = {
        ["main"] = {
            -- hammer pet
            -- L54 Unswerving Hammer of Faith (0.5 sec cast, 175 mana)
            -- L68 Unswerving Hammer of Retribution (0.5 sec cast, 175 mana)
            -- L79 Indomitable Hammer of Zeal (0.5 sec cast, 175 mana)
            "Indomitable Hammer of Zeal/NoPet", -- XXX NoPet filter. only cast if i have no pet

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
            -- L72 Reproval Rk. II (1967 hp, cost 562 mana)
            -- L77 Divine Censure Rk. II (~2500 dmg, cost 654 mana) - more dmg to undead/summoned
            "Reproval/NoAggro/MinMana|30",
        },
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
        -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        --"Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse
        "Celestial Hammer",
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
