local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Staff of Eternal Eloquence|Mainhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    ["melee"] = "Staff of Eternal Eloquence|Mainhand", -- 1hb
}

settings.gems = {
    ["Euphoria"] = 1,
    ["Wake of Felicity"] = 2, -- XXX unused
    ["Guard of Druzzil"] = 3,
    ["True Name"] = 4,
    ["Ancient: Neurosis"] = 6,
    ["Mana Flare"] = 7,
    ["Rune of Rikkukin"] = 8,
    ["Hastening of Salik"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Form of Defense III (slot 6: immunity, slot 10: 81 ac)
    "Hanvar's Hoop",

    -- mana regen clicky:
    -- Reyfin's Random Musings (slot 8: 9 mana regen, slot 10: 6 hp regen)
    "Earring of Pain Deliverance",

    -- mana pool clicky:
    -- Maelin's Meditation (slot 4: 400 mana pool)
    --"Muramite Signet Orb",

    -- shield - does not stack with Focus / Virtue:
    -- L40 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)

    -- self rune - slot 3:
    -- L61 Arcane Rune (absorb 1500 dmg)
    -- L6x Eldritch Rune AA Rank 3 (id:3260, absorb 1500 dmg)
    -- L66 Ethereal Rune (absorb 1950 dmg)
    -- L6x Eldritch Rune AA Rank 3 (id:3260, absorb 1500 dmg)
    -- L66 Eldritch Rune AA Rank 4 (id:8109, absorb 1800 dmg)
    -- L67 Eldritch Rune AA Rank 5 (id:8110, absorb 2100 dmg)
    -- L68 Eldritch Rune AA Rank 6 (id:8111, absorb 2400 dmg)
    -- L69 Eldritch Rune AA Rank 7 (id:8112, absorb 2700 dmg)
    -- L70 Eldritch Rune AA Rank 8 (id:8113, absorb 3000 dmg, 10 min recast)
    "Eldritch Rune",

    -- targeted rune - slot 1:
    -- L40 Rune IV (absorb 305-394 dmg)
    -- L52 Rune V (absorb 620-700 dmg)
    -- L61 Rune of Zebuxoruk (absorb 850 dmg)
    -- L67 Rune of Salik (slot 1: absorb 1105 dmg)
    -- L69 Rune of Rikkukin (slot 1: absorb 1500 dmg, group)
    "Rune of Rikkukin/Reagent|Peridot", -- XXX Reagent

    -- epic 1.5: slot 5: absorb 1500 dmg. Oculus of Persuasion (Protection of the Eye)
    -- epic 2.0: slot 5: absorb 1800 dmg. Staff of Eternal Eloquence (Aegis of Abstraction)
    "Staff of Eternal Eloquence",

    "Voice of Clairvoyance/MinMana|30",

    "Guard of Druzzil/MinMana|80",
}

settings.group_buffs = {
    -- L26 Clarity (7-9 mana/tick)
    -- L42 Boon of the Clear Mind (6-9 mana/tick, group)
    -- L52 Clarity II (9-11 mana/tick, single)
    -- L56 Gift of Pure Thought (10-11 mana/tick, group)
    -- L60 Koadic's Endless Intellect (14 mana/tick, group)
    -- L63 Tranquility (16 mana/tick, group)
    -- L65 Voice of Quellious (18 mana/tick, group, cost 1200 mana)
    -- L68 Clairvoyance (20 mana/tick, cost 400 mana)
    -- L70 Voice of Clairvoyance (20 mana/tick, cost 1300 mana, group)
    ["manaregen"] = {
        "Boon of the Clear Mind/MinLevel|1",
        "Gift of Pure Thought/MinLevel|43",
        "Koadic's Endless Intellect/MinLevel|45",
        "Tranquility/MinLevel|46",
        "Voice of Quellious/MinLevel|47",
        "Voice of Clairvoyance/MinLevel|62",
    },

    -- L47 Swift Like the Wind (60% haste, 16 min) - L01-45
    -- L53 Aanya's Quickening (64% haste, 24 min, DOES NOT land on lv15. DOES LAND on L42)
    -- L58 Wondrous Rapidity (70% haste, 18.4 min)
    -- L62 Speed of Vallon (68% haste, 41 atk, 52 agi, 33 dex, 42 min)
    -- L65 Vallon's Quickening (68% haste, 41 atk, 52 agi, 33 dex, 42 min, group)
    -- L67 Speed of Salik (68% haste, 53 atk, 60 agi, 50 dex, 42 min + 20% melee crit chance, cost 437 mana)
    -- L67 Hastening of Salik (68% haste, 53 atk, 60 agi, 50 dex, 42 min, group + 20% melee crit chance, cost 1260 mana)
    ["haste"] = {
        "Swift Like the Wind/MinLevel|1",
        "Aanya's Quickening/MinLevel|41",
        "Wondrous Rapidity/MinLevel|44",
        "Speed of Vallon/MinLevel|46",
        "Vallon's Quickening/MinLevel|47",
        "Hastening of Salik/MinLevel|62",
    },

    -- L48 Group Resist Magic (53-55 mr, group)
    -- L62 Guard of Druzzil (75 mr, group)
    ["resist"] = {
        "Group Resist Magic/MinLevel|1",
        "Guard of Druzzil/MinLevel|46",
    },
}

settings.bot_buffs = {
    -- NOTE: Trams do mana regen
    ["Voice of Clairvoyance/MinMana|30"] = {
        "Stor", "Kamaxia", "Maynarrd", "Arriane", "Gerrald", "Helge", "Hankie", "Hybregee",
        "Drutten", "Lofty", "Samma", "Erland", 
    },

    ["Voice of Clairvoyance/MinMana|50"] = {
        "Blastar", "Fandinu", "Redito", "Brann", "Umlilo",
        "Myggan", "Agatha", "Besty", "Arctander",

        -- roof
        "Gimaxx", "Kesok", "Shimaclop",

        -- pl 2021
        "Negan", "Fatale", "Soya", "Sliten", "Tand", "Stampe", "Krille", "Bomben", "Eldballe", "Tunnan", "Kotten", "Skarven",

        "Gasoline", "Katan", "Fedt", "Sogaard", "Fisse", "Runar", "Katten", "Sogaard", "Tervet",
        "Saga", "Brinner", 
    },

    -- NOTE: Trams do group haste
    ["Hastening of Salik/MinMana|40"] = {
        "Bandy", "Manu", "Juancarlos", "Crusade", "Nullius",
        "Azoth", "Yelwen", "Laser", "Knuck",
        "Kniven", "Strupen", "Fosco", "Lotho", "Grimakin",
        "Arctander", "Besty", "Blod", "Urinfact", "Sweetlard",
        "Spela", "Chancer", "Gerwulf", "Garotta", "Alethea", "Sophee", "Moola", "Saberku", "Lynnmary",
        "Rupat", "Debre", "Kedel",
        "Nacken", "Ryggen", "Halsen", "Papp", "Kasta", "Bulf", "Endstand",
        "Hypert", "Crust", "Plin", "Pantless",
    },

    -- NOTE: Trams and Kasper both do GoD
    ["Guard of Druzzil/MinMana|40"] = {
        "Bandy", "Manu", "Crusade", "Nullius",
        "Stor", "Drutten", "Samma", "Spela",
        "Kamaxia", "Lofty", "Erland",
    },
}

settings.combat_buffs = { -- XXX impl
--[[
; L63 Night's Dark Terror (scarecrow, Lifetap Strike proc, 45 atk, 120 dex) - DOES not stack with Avatar
; L70 Mana Flare (timer 7, trigger Mana Flare Strike, dmg 700)
Combat Buff=Mana Flare/Arctander
Combat Buff=Mana Flare/Blastar
Combat Buff=Mana Flare/Brann
Combat Buff=Mana Flare/Fandinu
Combat Buff=Mana Flare/Redito
Combat Buff=Mana Flare/Myggan
]]--
}

settings.healing = { -- XXX implement
    ["life_support"] = { -- XXX implement
        "Self Stasis/HealPct|55/CheckFor|Resurrection Sickness",

        -- L70 Color Shock AA
        "Color Shock/HealPct|50/CheckFor|Resurrection Sickness",

        -- L65 Doppelganger AA
        "Doppelganger/HealPct|30/CheckFor|Resurrection Sickness",
        
        "Distillate of Divine Healing XI/HealPct|12/CheckFor|Resurrection Sickness",
        
        -- L6x Mind Over Matter AA Rank 1 (id:5906 - slot1: mana shield absorb damage up to 50%, 10 hits)
        -- L68 Mind Over Matter AA Rank 2 (id:5907 - slot1: mana shield absorb damage up to 50%, 20 hits)
        -- L69 Mind Over Matter AA Rank 3 (id:xxx , 30 hits)
        -- Rank 4 - 40 hits
        -- Rank 5 - 50 hits
        -- Rank 6 - 60 hits
        "Mind Over Matter/HealPct|30/CheckFor|Resurrection Sickness",
    }
}

settings.pet = {
    ["auto"] = false,

    -- Lxx Kintaz's Animation
    -- L55 Zumaik's Animation
    -- L62 Aeldorb's Animation
    -- L66 Salik's Animation
    ["spell"] = "Salik's Animation/MinMana|20/Reagent|Tiny Dagger",

    ["heals"] = {},
    ["buffs"] = {
        "Hastening of Salik/MinMana|50",
    },
}

settings.assist = {
    ["nukes"] = { -- XXX implement
        -- lower aggro:
        -- L61 Boggle (decrease hate by 500)
        --"Boggle/PctAggro|99/Gem|2", -- XXX PctAggro

        -- chromatic nukes:
        -- L69 Colored Chaos (CHROMATIC, 1600 hp, cost 425 mana)

        -- magic nukes:
        -- L07 Chaotic Feedback (28-32 hp, 1s stun, 16 mana)
        -- L16 Sanity Warp (81-87 hp, 1s stun, 38 mana)
        -- L21 Chaos Flux (152-175 hp, 1s stun, 67 mana)
        -- L32 Anarchy (264-275 hp, 1s stun, 99 mana)
        -- L43 Discordant Mind (387 hp, 1s stun, 126 mana)
        -- L54 Dementia (571 hp, 1s stun, 169 mana)
        -- L58 Dementing Visions (836 hp, 239 mana)
        -- L64 Insanity (1100 hp, cost 300 mana)
        -- L65 Madness of Ikkibi (1210 hp, cost 330 mana)
        -- L65 Ancient: Chaos Madness (1320 hp, cost 360 mana)
        -- L68 Psychosis (1513 hp, cost 375 mana)
        -- L70 Ancient: Neurosis (1634 hp, cost 398 mana)
        "Ancient: Neurosis/NoAggro/MinMana|30"
    },

    ["debuffs"] = { -- XXX impl
        -- slow:
        -- L09 Languid Pace (17-30% slow, 2.7 min, 50 mana)
        -- L23 Tepid Deeds (31-50% slow, 2.7 min, 100 mana)
        -- L41 Shiftless Deeds (46-65% slow, 2.7 min, 200 mana)
        -- L57 Forlorn Deeds (67-70% slow, 2.9 min, 225 mana)
        -- L65 Dreary Deeds (MAGIC: 70% slow, resist adj -10, 1.5 min, cost 270 mana)
        -- L69 Desolate Deeds (MAGIC: 70% slow, resist adj -30, 1.5 min, cost 300 mana)
        -- NOTE - Erland is main slower!
        --"Desolate Deeds/MaxTries|2/Gem|2",
    },

    ["debuffs_on_command"] = { -- XXX impl
        -- disempower:
        -- L04 Enfeeblement (-18-20 str, -3 ac, cost 20 mana)
        -- L16 Disempower (-9-12 sta, -13-15 str, -6-9 ac)
        -- L25 Listless Power (-22-35 agi, -22-35 str, -10-18 ac, cost 90 mana)
        -- L40 Incapacitate (-45-55 agi, -45-55 str, -21-24 ac, cost 150 mana)
        -- L53 Cripple (-58-105 dex, -68-115 agi, -68-115 str, -30-45 ac, cost 225 mana)
        -- L66 Synapsis Spasm (-100 dex, -100 agi, -100 str, -39 ac, cost 225 mana)
        "Synapsis Spasm/MaxTries|2/Gem|2",

        -- tash:
        -- L57 Tashanian (-37-43 mr, 12.4 min, cost 40 mana)
        -- L61 Howl of Tashan (-48-50 mr, 13.6 min, cost 40 mana)
        "Howl of Tashan/MaxTries|2",
    },

    ["quickburns"] = {-- XXX implememt !!!
        -- oow T1 bp: 30 sec, -1% spell resist rate, 5 min reuse. Charmweaver's Robe (Bedazzling Eyes)
        -- oow T2 bp: 42 sec, -1% spell resist rate, 5 min reuse. Mindreaver's Vest of Coercion (Bedazzling Aura)
        "Mindreaver's Vest of Coercion",
    },
}

settings.pbae = { -- XXX impl
    -- ae stun:
    -- L03 Color Flux (4s stun/L55?, aerange 20, recast 12s)
    -- L20 Color Shift (6s stun/L55?, aerange 25, recast 12s)
    -- L43 Color Skew (8s stun/L55?, aerange 30, recast 12s)
    -- L52 Color Slant (8s stun/L55?, -100 mana, aerange 35, recast 12s)
    -- L63 Color Cloud (timer 3, 8s stun/L65, aerange 30, recast 12s)   XXX best for pop stuns then!?
    -- L69 Color Snap (timer 3, 6s stun/L70, aerange 30, recast 12s)

    -- Stun/L65
    --"Color Cloud/Gem|2/MinMana|5",

    -- Stun/L70
    "Color Snap/Gem|1/MinMana|5",
}

settings.enchanter = { -- XXX impl / rearrange settings
    ["gather_mana_pct"] = 30, -- XXX impl. was GatherMana Pct in e3
    ["auto_mez"] = false, -- XXX impl + impl toggle /mezon, /mezoff

    -- XXX impl: will allow enc to chain rune tanks during fight etc (when /buffoff)
    --[[
    RuneTarget=
    RuneSpell=
    AutoRune (On/Off)=Off
    ]]--

    ["mez"] = { -- XXX impl, use if auto_mez is true
        -- ae mez:
        -- L16 Mesmerization (0.4 min/L55, cost 70 mana)
        -- L52 Fascination (36 sec/L55, cost 200 mana)
        -- L62 Word of Morell (0.3 min/L65, aerange 30, cost 300 mana)
        -- L65 Bliss of the Nihil (0.6 min/L68, aerange 25, cost 850 mana)
        
        -- Hammer of Delusions (tacvi class click with Euphoria)
        "Hammer of Delusions",

        -- single mez:
        -- L02 Mesmerize         (0.4 min/L55, 41% memblur, 20 mana)
        -- L13 Enthrall          (0.8 min/L55, 41% memblur, 50 mana)
        -- L30 Entrance          (1.2 min/L55, 45% memblur, 85 mana)
        -- L47 Dazzle            (1.6 min/L55, 41% memblur, 125 mana)
        -- L54 Glamour of Kintaz (0.9 min/L57, resist adj -10, 70% memblur, 125 mana)
        -- L59 Rapture           (0.7 min/L61, resist adj -1000, 80% memblur, 250 mana)
        -- L61 Apathy            (0.9 min/L62, reisst adj -10, 70% memblur, 225 mana)
        -- L63 Sleep             (0.9 min/L65, resist adj -10, 75% memblur, 275 mana)
        -- L64 Bliss             (0.9 min/L68, resist adj -10, 80% memblur, 300 mana)
        -- L67 Felicity          (0.9 min/L70, resist adj -10, 70% memblur, 340 mana)
        -- L69 Euphoria          (0.9 min/L73, resist adj -10, 70% memblur, 375 mana)
        "Euphoria/MinMana|10",

        -- L68 Stasis   I AA (1.0 min/L73, resist adj -1000, 80% memblur, 36 min reuse)
        -- L69 Stasis  II AA (2.0 min/L73, resist adj -1000, 80% memblur, 36 min reuse)
        -- L70 Stasis III AA (3.0 min/L73, resist adj -1000, 80% memblur, 36 min reuse)
        "Stasis",
    },

    ["charm"] = { -- XXX impl
        -- unresistable charms:
        -- L48 Ordinance (-1000 magic, charm/L52, 0.8 min, 5m recast)
        -- L60 Dictate (-1000 magic, charm/L58, 0.8 min, 5m recast)
        -- L70 Ancient: Voice of Muram (-1000 magic, charm/L70, 0.8 min, 5m recast)
        --- Edict of Command Rank 1 AA (id:8196, magic -1000, charm/70, 2 min set duration)
        --- Edict of Command Rank 2 AA (id:8197, magic -1000, charm/70, 4 min set duration)
        --- Edict of Command Rank 3 AA (id:8198, magic -1000, charm/70, 6 min set duration)
        "Edict of Command",

        -- charms:
        -- L11 Charm (magic, charm/L25, 20.5 min)
        -- L23 Beguile (magic, charm/L37, 20.5 min)
        -- L37 Cajoling Whispers (magic, charm/L46, 20.5 min)
        -- L46 Allure (magic, charm/L51, 20.5 min)
        -- L53 Boltran's Agacerie (-10 magic, charm/L53, 7.5 min)
        -- L62 Beckon (magic, charm/L57, 7.5 min)
        -- L64 Command of Druzzil (magic, charm/L64, 7.5 min). 5s cast time, 1.5s recast
        -- L68 Compel (magic, charm/L67, 7.5 min). 5s cast time, 1.5s recast
        -- L70 True Name (magic, charm/L69, 7.5 min). 5s cast time, 1.5s recast
        -- L70 Ancient: Voice of Muram (magic -1000, charm/70, 0.8 min set duration). 5s cast time, 300s recast
        "True Name",
    },
}


return settings
