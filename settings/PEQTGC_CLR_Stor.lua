local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Bazu Claw Hammer|Mainhand/Aegis of Superior Divinity|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Weighted Hammer of Conviction|Mainhand", -- 1hb
}

settings.gems = { -- XXX implement. default spell gem mapping. makes "main" spellset obsolete and allows for auto scribe in the right slots
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

    -- self mana regen:
    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
    -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
    -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
    -- L70 Armor of the Pioous (563 hp, 46 ac, 9 mana/tick)
    -- NOTE: does not stack with DRU Skin
    --"Armor of the Zealot/MinMana|90/CheckFor|Kazad's Mark",

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
    -- NOTE: stacks with DRU Skin and AC
    ["symbol"] = {
        "Symbol of Naltron/MinLevel|1", -- single
        "Symbol of Marzin/MinLevel|42", -- single
        "Naltron's Mark/MinLevel|44",
        "Kazad's Mark/MinLevel|46",
        "Balikor's Mark/MinLevel|62",
    },

    -- L61 Ward of Gallantry (slot 4: 54 ac)
    -- L66 Ward of Valiance (slot 4: 72 ac)
    -- NOTE: stacks with Symbol + DRU Skin + Focus
    ["ac"] = {
        "Ward of Gallantry/MinLevel|45/CheckFor|Hand of Virtue",
        "Ward of Valiance/MinLevel|62/CheckFor|Hand of Conviction",
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
    ["aegolism"] = {
        --"Blessing of Temperance/MinLevel|1",
        --"Blessing of Aegolism/MinLevel|45",
        --"Hand of Virtue/MinLevel|47",
        --"Hand of Conviction/MinLevel|62",
    },

    -- spell haste:
    -- L15 Blessing of Piety (10% spell haste to L39, 40 min)
    -- L35 Blessing of Faith (10% spell haste to L61, 40 min)
    -- L62 Blessing of Reverence (10% spell haste to L65, 40 min)
    -- L64 Aura of Reverence (10% spell haste to L65, 40 min, group)
    -- L67 Blessing of Devotion (10% spell haste to L70, 40 min, 390 mana)
    -- L69 Aura of Devotion (10% spell haste to L70, 45 min, group, 1125 mana)
    ["spellhaste"] = {
        "Blessing of Faith/MinLevel|1", -- 10% spell haste to L61
        "Aura of Devotion/MinLevel|62", -- 10% spell haste to L70
    },
}

settings.bot_buffs = {
    -- NOTE: Stor does team18, Helge does the rest
    ["Aura of Devotion/MinMana|50"] = {
        "Blastar", "Myggan", "Absint", "Trams", "Redito", "Samma", "Fandinu",
    },

    -- NOTE: Stor does team18, Helge does the rest
    ["Panoply of Vie/MinMana|80"] = {
        "Blastar", "Myggan", "Absint", "Trams", "Redito", "Samma", "Fandinu",
    },

    ["Ward of Valiance/MinMana|70/CheckFor|Hand of Conviction"] = {
        "Bandy", "Manu", "Nullius", "Crusade", "Juancarlos",
    },

    -- NOTE: Stor does team18, Kamaxia does the rest
    ["Balikor's Mark/MinMana|50"] = {
        -- team18
        "Bandy", "Crusade", "Spela", "Azoth", "Blastar", "Myggan", "Absint", "Trams", "Gerwulf", "Redito", 
        "Kniven", "Samma", "Besty", "Grimakin", "Chancer", "Fandinu", "Drutten",

        -- pl 2021
        "Endstand", "Nacken", "Halsen", "Ryggen", "Katten", "Tervet", 
        "Gasoline", "Saga", "Brinner", "Katan", "Kasta", "Bulf", "Papp",
        "Pantless", "Crust", "Plin", "Hypert",
    },
}

settings.healing = { -- XXX implement

    ["life_support"] = { -- XXX implement
        "Ward of Retribution/HealPct|50/Delay|3m/CheckFor|Resurrection Sickness",

        "Distillate of Divine Healing XI/HealPct|18/CheckFor|Resurrection Sickness",

        -- L65 Divine Avatar Rank 1 AA (decrease melee attack by 5%, increase HoT by 100/tick)
        -- L65 Divine Avatar Rank 2 AA (decrease melee attack by 10%, increase HoT by 150/tick)
        -- L65 Divine Avatar Rank 3 AA (decrease melee attack by 10%, increase HoT by 200/tick)
        -- L70 Divine Avatar Rank 4 AA (decrease melee attack by 15%, increase HoT by 250/tick)
        -- L70 Divine Avatar Rank 5 AA (id:8157, decrease melee attack by 15%, increase HoT by 300/tick)
        -- L70 Divine Avatar Rank 6 AA (id:8158, decrease melee attack by 338%, increase HoT by 350/tick, 3.0 min, 36 min reuse)
        "Divine Avatar/HealPct|20/CheckFor|Resurrection Sickness",

        -- L70 Sanctuary AA (id:5912, removes you from combat)
        "Sanctuary/HealPct|13/CheckFor|Resurrection Sickness",

        -- defensive - stun attackers:
        -- L70 Divine Retribution I (id:5866, proc Divine Retribution Effect)
        "Divine Retribution/HealPct|25/CheckFor|Resurrection Sickness",
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

        -- MPG Efficiency with stronger toons. the zone debuff fools mq that 100% HP is like 75%:
        --"Pious Remedy/HealPct|70/MinMana|5",

        -- CH for mpg Efficency. the zone debuff fools mq that 100% HP is like 75%:   TODO verify how it is on mqnext
        -- "Complete Heal/HealPct|70/Gem|2",

        -- CH for mpg Ingenuity:
        --"Complete Heal/HealPct|80/Gem|2",
    },

    --["important"] = {"Spela"}, -- XXX impl. prioritized list of toons to heal as "Important" group in who_to_heal
    --["important_heal"] = { "Pious Remedy/HealPct|60/MinMana|30"}, -- XXX impl. heal spell to heal these toons with

    ["all_heal"] = {-- XXX impl
        -- quick heals:
        -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
        -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
        -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
        -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
        -- L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
        -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
        -- L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
        -- L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)
        "Pious Remedy/HealPct|60/MinMana|30",

        -- tacvi clicky
        "Weighted Hammer of Conviction/HealPct|95",
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
    ["yaulp"] = "Yaulp VII",    -- was e3 [Cleric].Yaulp Spell    XXX impl. 
    ["auto_yaulp"] = false, -- was e3 [Cleric].Auto-Yaulp (On/Off)  XXX impl. 
}

settings.assist = {
    ["nukes"] = { -- XXX implement
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
        --"Reproach/NoAggro/Gem|7/MinMana|30",
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
        -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        "Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse (XXX disabled because of casting time)
        --"Celestial Hammer",
    },
}

settings.pbae = {   -- XXX implement
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
}

return settings
