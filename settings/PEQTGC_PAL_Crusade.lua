local settings = { }

settings.swap = {
    main = "Blade of Forgotten Faith|Mainhand/Shield of the Lightning Lord|Offhand/Tome of New Beginnings|Ranged",
    bfg = "Breezeboot's Frigid Gnasher|Mainhand",
    noriposte = "Fishing Pole|Mainhand/Shield of the Lightning Lord|Offhand",
    ranged = "Plaguebreeze|Ranged",
    fishing = "Fishing Pole|Mainhand",
}

settings.gems = {
    ["Light of Piety"] = 1,     -- single heal
    ["Ancient: Force of Jeron"] = 2, -- stun 4s/73
    ["Force of Piety"] = 3, -- stun 4s/70
    ["Serene Command"] = 4, -- stun 10s/70

    ["Ward of Tunare"] = 6,
    ["Pious Fury"] = 7,
    ["Wave of Piety"] = 8,          -- group heal
    ["Brell's Brawny Bulwark"] = 9, -- hp buff
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- PAL/SHD mana regen clicky:
    -- Glyphed Greaves of Conflict ALL/ALL: Aura of Eternity (slot 8: 5 mana regen, slot 10: 5 hp regen)
    -- Pendant of Discord ALL/ALL: Aura of Taelosia (slot 8: 7 mana regen, slot 10: 7 hp regen)
    -- NOTE: NOT ENOUGH BUFF SLOTS
    --"Pendant of Discord",

    -- Form of Endurance III (slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    --Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense
    "Necklace of the Steadfast Spirit",

    -- proc self buffs:
    -- L26 Instrument of Nife (undead proc Condemnation of Nife)
    -- L45 Divine Might (proc Divine Might Effect)
    -- L62 Ward of Nife (UNDEAD: proc Ward of Nife Strike)
    -- L63 Pious Might (proc Pious Might Strike)
    -- L65 Holy Order (proc Holy Order Strike)
    -- L67 Silvered Fury (proc Silvered Fury Strike)
    -- L68 Pious Fury (slot 1: proc Pious Fury Strike)
    "Pious Fury/MinMana|30",

    -- L69 Silent Piety (10% chance to resist spells, 30 min)

    -- defensive proc:
    -- L70 Ward of Tunare (2 min, 25 atk, 60 str, 24 ac, defensive proc: Ward of Tunare Effect)
    -- NOTE: Ward of Tunare does not stack with Skin of the Reptile
    "Ward of Tunare/CheckBuff|Skin of the Reptile",

    "Brell's Brawny Bulwark/MinMana|20",
}

settings.healing = {
    life_support = {
        -- timer 4:
        -- L56 Guard of Piety (absorb 25% melee up to 2500 hp)
        -- L61 Guard of Humility (absorb 25% melee up to 6000 hp)
        -- L69 Guard of Righteousness (absorb 25% melee up to 10000 hp)
        "Guard of Righteousness/HealPct|40",

        -- timer 3:
        "Deflection Discipline/HealPct|37",

        -- timer 2:
        "Sanctification Discipline/HealPct|35",

        "Distillate of Divine Healing XI/HealPct|8",

        --"Lay on Hands/HealPct|10",

        -- OOW T1 bp: Oathbound Breastplate (proc Minor Pious Shield Effect, 0.2 min)
        -- OOW T1 bp: Dawnseeker's Chestpiece of the Defender (proc Minor Pious Shield Effect, 0.4 min)
        "Dawnseeker's Chestpiece of the Defender/HealPct|25",

        --"Glyph of Stored Life/HealPct|4", -- expendable
    },

    -- heals:
    -- L01 Salve (5-9 hp)
    -- L06 Minor Healing (12-20 hp)
    -- L12 Light Healing (47-65 hp)
    -- L27 Healing (135-175 hp)
    -- L36 Greater Healing (280-350 hp, cost 115 mana)
    -- L52 Light of Life (410 hp, cast time 1.5s, 7s recast, cost 215 mana)
    -- L57 Superior Healing (500-600 hp, cast time 3.5s, 1.5s recast, cost 185 mana)
    -- L61 Touch of Nife (1210-1250 hp, cast time 3.8s, 1.5s recast, cost 4556 mana)
    -- L65 Light of Order (1072 hp, cast time 1.0s, 5s recast, cost 428 mana)
    -- L68 Light of Piety (1234 hp, cast time 1.0s, 5s recast, cost 487 mana)
    -- AA  Lay on Hands Rank 14 (xxx hp, instant cast, 1h12 min reuse / 36 min cast with max aa @ peq-oow)

    -- hot:
    -- L44 Ethereal Cleansing (98-100 hp/tick, 30s recast, cost 150 mana)
    -- L59 Celestial Cleansing (175 hp/tick, 30s recast, cost 225 mana)
    -- L64 Supernal Cleansing (300 hp/tick, 30s recast, cost 360 mana)
    -- L69 Pious Cleansing (585 hp/tick, 30s recast, cost 668 mana)

    -- group heals:
    -- L39 Wave of Life (201-219 hp, cost 274 mana)
    -- L55 Wave of Healing (439-489 hp, cost 503 mana)
    -- L58 Healing Wave of Prexus (688-698 hp, cost 698 mana)
    -- L65 Wave of Marr (960 hp, cost 850 mana)
    -- L65 Wave of Trushar (1143 hp, cost 921 mana) - NOTE different timer
    -- L70 Wave of Piety (1316 hp, cost 1048 mana)
    -- L?? Hand of Piety AA Rank 1-XXX (24 min reuse with Hastened Piety Rank 3)

    tanks = {
        --"Bandy",
        "Manu",
    },

    tank_heal = {
        "Lay on Hands/HealPct|10",

        --"Light of Piety/HealPct|30/MinMana|5",
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
    important_heal = {"Light of Piety/HealPct|40/MinMana|15"},

    who_to_heal = "Tanks/Important", -- XXX impl
}

settings.assist = {
    type = "Melee",
    stick_point = "Front",
    engage_percent = 100,

    taunts = { -- XXX impl. used if set
        "Taunt",
        -- XXX add more + stun taunts

        -- magic stuns, no timer:
        -- L07 Cease (1s/55, 1.5s cast, 15 mana, 9s recast)
        -- L13 Desist (3s/55, 1.8s cast, 25 mana, 10s recast)
        -- L28 Stun (4s/55, 1.5s cast, 35 mana, 12s recast)
        -- L42 Holy Might (6s/55 2.0s cast, 60 mana, 18s recast, decrease hp by 26-60)
        -- L52 Force (6s/55 2.5s cast, 90 mana, 18s recast, decrease hp by 71-90)

        -- L59 Divine Stun Rank 1 AA (???s/68, 30s recast ??)
        -- L?? Divine Stun Rank 2 AA (???s/73, 8s recast)
        -- L73 Divine Stun Rank 3 AA (???s/78)

        -- magic stuns, timer 5:
        -- L53 Force of Akera (4s/61, 1s cast, 90 mana, 12s recast, -30 resist adj)
        -- L65 Ancient: Force of Chaos (4s/65, 1.0s cast, 80 mana, 12s recast)
        -- L70 Ancient: Force of Jeron (4s/73, 1.0s cast, 100 mana, 12s recast)

        -- magic stuns, timer 4:
        -- L62 Force of Akilae (4s/65, 1.0s cast, 65 mana, 12s recast)
        -- L66 Force of Piety (4s/70, 1.0s cast, 80 mana, 12s recast)

        -- magic stuns, timer 6:
        -- L64 Quellious' Word of Serenity (10s/65, 2.0s cast, 200 mana, 24s recast)
        -- L68 Serene Command (10s/70, 2.0s cast, 250 mana, 24s recast)

        "Divine Stun/MaxLevel|73", -- 8s recast    TODO IMPL MaxLevel filter
        "Ancient: Force of Jeron/MinMana|5/MaxLevel|73", --12s recast
        "Force of Piety/MinMana|5/MaxLevel|70", --12s recast
        "Serene Command/MinMana|5/MaxLevel|70", --24s recast
    },

    abilities = {
        "Bash",
        "Disarm",
    },

    longburns = {
        "Holyforge Discipline",
    }
}

--[[
[Paladin]
Auto-Yaulp (On/Off)=Off
; yaulp:
; L09 Yaulp (10 str, 6 ac, 24s)
; L38 Yaulp II (20 str, 9 ac, 24s)
; L56 Yaulp III (30 str, 12 ac, 24s)
; L60 Yaulp IV (17 atk, 40 str, 15 ac, 24s)
Yaulp Spell=Yaulp IV/Gem|7
]]

return settings
