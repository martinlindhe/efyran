local settings = { }

settings.swap = {} -- XXX impl

settings.gems = {
    -- XXX fill list

    ["Pious Remedy"] = 1,
    ["Pious Light"] = 2,
    ["Eleventh-Hour"] = 3,
    ["Word of Vivacity"] = 4,


    ["Reproval"] = 7,
    ["Catastrophe"] = 8, -- pbae



    ["Rallied Shield of Vie"] = 10,
    ["Aura of Resolve"] = 11,
    ["Kaerra's Mark"] = 12,


}


settings.self_buffs = {
    -- XXX do we have any clickies?

    -- self mana regen:
    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
    -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
    -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
    -- L70 Armor of the Pious (563 hp, 46 ac, 9 mana/tick)
    -- L75 Armor of the Sacred Rk. II (704 hp, 58 ac, 10 mana/tick)
    -- L80 Armor of the Solemn Rk. II (915 hp, 71 ac, 12 mana/tick)
    -- NOTE: does not stack with DRU Skin

    "Aura of Resolve/MinMana|40", -- spell haste

    "Rallied Shield of Vie/MinMana|70", -- absorb melee dmg

    "Kaerra's Mark/MinMana|75/CheckFor|Hand of Temerity", -- slot 3 hp

    "Order of the Resolute/MinMana|50/CheckFor|Hand of Temerity", -- ac
}

settings.group_buffs = {
    -- slot 3 hp buff - symbol line:
    -- L41 Symbol of Naltron (406-525 hp)
    -- L54 Symbol of Marzin (640-700 hp)
    -- L58 Naltron's Mark (525 hp, group)
    -- L60 Marzin's Mark (725 hp, group)
    -- L61 Symbol of Kazad (910 hp, cost 600 mana)
    -- L63 Kazad's Mark (910 hp, cost 1800 mana, group)
    -- L66 Symbol of Balikor (1137 hp, cost 780 mana)
    -- L70 Balikor's Mark (1137 hp, cost 2340 mana, group)
    -- L71 Symbol of Elushar (1364 hp, cost 936 mana)
    -- L75 Elushar's Mark Rk. II (1421 hp, cost 2925 mana, group)
    -- L76 Symbol of Kaerra Rk. II (1847 hp, cost 1190 mana)
    -- L80 Kaerra's Mark (1563 hp, cost 3130 mana)    XXX get Rk. II
    -- NOTE: stacks with DRU Skin and AC
    ["symbol"] = {
        "Symbol of Naltron/MinLevel|1", -- single
        "Symbol of Marzin/MinLevel|42", -- single
        "Naltron's Mark/MinLevel|44",
        "Kazad's Mark/MinLevel|46",
        "Balikor's Mark/MinLevel|62",
        "Elushar's Mark/MinLevel|71", -- XXX unsure of minlevel
        "Kaerra's Mark/MinLevel|76", -- XXX unsure of minlevel
    },

    ["absorb_melee"] = {
        -- absorb melee:
        -- L40 Guard of Vie (absorb 10% melee dmg to 700)
        -- L54 Protection of Vie (absorb 10% melee dmg to 1200)
        -- L62 Bulwark of Vie (absorb 10% melee dmg to 1600)
        -- L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
        -- L73 Aegis of Vie (absorb 10% of melee dmg to 2496, 36 min)
        -- L75 Rallied Aegis of Vie Rk. II (absorb 10% of melee dmg to 2600, 36 min, group)
        -- L78 Shield of Vie Rk. II (absorb 10% of melee dmg to 3380, 36 min)
        -- L80 Rallied Shield of Vie Rk. II (absorb 10% of melee dmg to 3380, 36 min, group)
        --"Guard of Vie/MinLevel|1", -- XXX get spell
        --"Protection of Vie/MinLevel|42",    -- XXX get spell
        "Bulwark of Vie/MinLevel|46",
        "Panoply of Vie/MinLevel|62",
        "Rallied Aegis of Vie/MinLevel|71", -- XXX unsure of minlevel
        "Rallied Shield of Vie/MinLevel|76", -- XXX unsure of minlevel
    },

    -- L61 Ward of Gallantry (slot 4: 54 ac)
    -- L66 Ward of Valiance (slot 4: 72 ac)
    -- L71 Ward of the Dauntless (slot 4: 86 ac)
    -- L76 Ward of the Resolute Rk. II (solt 4: 109 ac)
    -- L80 Order of the Resolute Rk. II (slot 4: 109 ac, group)
    -- NOTE: stacks with Symbol + DRU Skin + Focus
    ["ac"] = {
        "Ward of Gallantry/MinLevel|45/CheckFor|Hand of Virtue",
        "Ward of Valiance/MinLevel|62/CheckFor|Hand of Conviction",
        "Ward of the Dauntless/MinLevel|71/CheckFor|Hand of Tenacity", -- XXX unsure of minlevel
        "Order of the Resolute/MinLevel|76/CheckFor|Hand of Temerity", -- XXX unsure of minlevel
    },

    -- hp buff - aegolism line (slot 2 - does not stack with DRU skin):
    -- L01 Courage (20 hp, 4 ac, single)
    -- L40 Temperance (800 hp, 48 ac, single) - LANDS ON L01
    -- L45 Blessing of Temperance (800 hp, 48 ac, group) - LANDS ON L01
    -- L60 Aegolism (1150 hp, 60 ac, single)
    -- L60 Blessing of Aegolism (1150 hp, 60 ac, group)
    -- L62 Virtue (1405 hp, 72 ac, single)
    -- L65 Hand of Virtue (1405 hp, 72 ac, group) - LANDS ON L47
    -- L67 Conviction (1787 hp, 94 ac)
    -- L70 Hand of Conviction (1787 hp, 94 ac, group) - LANDS ON L62
    -- L72 Tenacity (2144 hp, 113 ac)
    -- L75 Hand of Tenacity Rk. II (2234 hp, 118 ac, group)
    -- L7x Temerity ??? XXX
    -- L80 Hand of Temerity (2457 hp, 126 ac, group)
    ["aegolism"] = {
        --"Blessing of Temperance/MinLevel|1",
        --"Blessing of Aegolism/MinLevel|45",
        --"Hand of Virtue/MinLevel|47",
        --"Hand of Conviction/MinLevel|62",
        --"Hand of Tenacity/MinLevel|71", -- XXX unsure of minlevel
        --"Hand of Temerity/MinLevel|76",-- XXX unsure of minlevel
    },

    -- spell haste:
    -- L15 Blessing of Piety (10% spell haste to L39, 40 min)
    -- L35 Blessing of Faith (10% spell haste to L61, 40 min)
    -- L62 Blessing of Reverence (10% spell haste to L65, 40 min)
    -- L64 Aura of Reverence (10% spell haste to L65, 40 min, group)
    -- L67 Blessing of Devotion (10% spell haste to L70, 40 min, 390 mana)
    -- L69 Aura of Devotion (10% spell haste to L70, 45 min, group, 1125 mana)
    -- L71 Blessing of Purpose (9% spell haste to L75, 40 min, 390 mana)
    -- L72 Aura of Purpose Rk. II (10% spell haste to L75, 45 min, group, 1125 mana)
    -- L76 Blessing of Resolve Rk. II (10% spell haste to L80, 40 min, 390 mana)
    -- L77 Aura of Resolve Rk. II (10% spell haste to L80, 45 min, group, 1125 mana)
    ["spellhaste"] = {
        "Blessing of Faith/MinLevel|1",
        "Aura of Devotion/MinLevel|62",
        "Aura of Purpose/MinLevel|71", -- XXX unsure of minlevel
        "Aura of Resolve/MinLevel|77", -- XXX unsure of minlevel
    },
}

settings.bot_buffs = {} -- XXX

settings.healing = {
    ["life_support"] = {
        -- Celestial Regeneration AA - HoT, 15 min reuse
        "Celestial Regeneration/HealPct|90/MinMobs|10",

        -- Divine Arbitration AA - balance group HP %, 3 min reuse
        "Divine Arbitration/HealPct|50/MinMobs|10",

        -- epic 1.5 - balance group HP %, 6 min reuse
        "Harmony of the Soul/HealPct|50/MinMobs|10",

        -- L70 Sanctuary AA (id:5912, removes you from combat), 1h12 min reuse
        "Sanctuary/HealPct|13",

        --"Ward of Retribution/HealPct|50/Delay|3m", -- XXX buy spell

        "Distillate of Divine Healing XIII/HealPct|18",

        -- L65 Divine Avatar Rank 1 AA (decrease melee attack by 5%, increase HoT by 100/tick)
        "Divine Avatar/HealPct|20",

        -- defensive - stun attackers:
        -- L70 Divine Retribution I AA (id:5866, proc Divine Retribution Effect)
        --"Divine Retribution/HealPct|25", -- XXX fixme get aa

        "Eleventh-Hour/HealPct|35/MinMana|60", -- XXX is MinMana check done on life_support ?

        "Pious Remedy/HealPct|40/MinMana|5",
    },

    ["rez"] = { -- XXX impl? or just auto code the rez spells
        "Water Sprinkler of Nem Ankh",
        --"Blessing of Resurrection", -- XXX get AA
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

    ["pbae"] = {   -- XXX implement
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

settings.mount = "Mottled Worg Bridle"

return settings
