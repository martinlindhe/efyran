local SpellGroups = {}

SpellGroups.Lookup = {
    shm_focus = "SHM",
    shm_runspeed = "SHM",
    shm_haste = "SHM",
    shm_disease_resist = "SHM",
    shm_sta = "SHM",
    shm_str = "SHM",
    shm_agi = "SHM",
    shm_dex = "SHM",
    shm_cha = "SHM",

    clr_symbol = "CLR",
    clr_ac = "CLR",
    clr_aegolism = "CLR",
    clr_vie = "CLR",
    clr_spellhaste = "CLR",
    clr_magic_resist = "CLR",
    di = "CLR",

    dru_skin = "DRU",
    dru_fire_resist = "DRU",
    dru_cold_resist = "DRU",
    dru_corruption = "DRU",
    dru_regen = "DRU",
    dru_ds = "DRU",
    dru_str = "DRU",
    dru_skill_dmg_mod = "DRU",
    dru_runspeed = "DRU",
    dru_epic2 = "DRU",
    dru_oow_bp = "DRU",

    enc_manaregen = "ENC",
    enc_haste = "ENC",
    enc_magic_resist = "ENC",
    enc_cha = "ENC",
    enc_rune = "ENC",
    enc_group_rune = "ENC",
    enc_epic2 = "ENC",
    enc_oow_bp = "ENC",

    mag_group_ds = "MAG",
    mag_ds = "MAG",

    nec_levitate = "NEC",
    nec_group_levitate = "NEC",

    rng_hp = "RNG",
    rng_atk = "RNG",
    rng_ds = "RNG",
    rng_skin = "RNG",

    pal_hp = "PAL",
    pal_symbol = "PAL",

    bst_manaregen = "BST",
    bst_hp = "BST",
    bst_haste = "BST",
    bst_focus = "BST",
    bst_sta = "BST",
    bst_str = "BST",
    bst_dex = "BST",
}

SpellGroups.SHM = {
    shm_heal = {
        "Ancient: Wilslik's Mending",               -- L70 Ancient: Wilslik's Mending (2716 hp, cost 723 mana, 3.8s cast)
        "Yoppa's Mending",                          -- L68 Yoppa's Mending (2448-2468 hp, cost 691 mana, 3.8s cast)
        "Daluda's Mending",                         -- L65 Daluda's Mending (2144 hp, cost 607 mana, 3.8s cast)
        "Tnarg's Mending",                          -- L62 Tnarg's Mending (1770-1800 hp, cost 560 mana)
        "Chloroblast",                              -- L55 Chloroblast (994-1044 hp, cost 331 mana)
        "Superior Healing",                         -- L51 Superior Healing (500-600 hp, cost 185 mana)
        "Greater Healing",                          -- L29 Greater Healing (280-350 hp, cost 115 mana)
        "Healing",                                  -- L19 Healing (135-175 hp, cost 65 mana)
        "Light Healing",                            -- L09 Light Healing (47-65 hp, cost 28 mana)
        "Minor Healing",                            -- L01 Minor Healing (12-20 hp, cost 10 mana)
    },
    shm_focus = {
        "Wunshi's Focusing",                        -- L68: 680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 780 mana, OOW
        "Focus of Soul",                            -- L62: 544 hp, 75 str, 70 dex, cost 600 mana, PoP
        "Focus of Spirit",                          -- L60: 405-525 hp, 67 str, 60 dex, cost 500 mana, Velious
        "Harnessing of Spirit",                     -- L46: 243-251 hp, 67 str, 50 dex, cost 425 mana, Luclin
        "Talisman of Kragg",                        -- L55: 365-500 hp, Kunark
        "Talisman of Altuna",                       -- L40: 230-250 hp, Original
        "Talisman of Tnarg",                        -- L32: 132-150 hp, Original
    },
    shm_group_focus = {
        "Talisman of Wunshi",                       -- L70: 680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 2340 mana, OOW
        "Focus of the Seventh",                     -- L65: 544 hp, 75 str, 70 dex, cost 1800 mana, PoP
        "Khura's Focusing",                         -- L60: 430-550 hp, 67 str, 60 dex, cost 1250 mana, Luclin
    },
    shm_runspeed = {
        "Spirit of Bih`Li",                         -- L36 Spirit of Bih`Li (48-55% run speed, 15 atk, 36 min, group)
        "Spirit of Wolf",                           -- L09 Spirit of Wolf (48-55% speed, 36 min)
    },
    shm_haste = {
        "Swift Like the Wind",                      -- L63 Swift Like the Wind (60% haste, 16 min)
        "Celerity",                                 -- L56 Celerity (47-50% haste, 16 min)
        "Alacrity",                                 -- L42 Alacrity (32-40% haste, 11 min)
        "Quickness",                                -- L26 Quiuckness (27--30% haste, 11 min)
    },
    shm_group_haste = {
        "Talisman of Celerity",                     -- L64 Talisman of Celerity (60% haste, 36 min, group)
    },
    -- slot 2: cr, slot 3: mr, slot 4: pr, slot 5: fr
    shm_malo = {
        "Malos",                                    -- L65: -55 cr, -55 mr, -55 pr, -55 fr, unresistable, cost 400 mana
        "Malosinia",                                -- L63: -70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana
        "Malo",                                     -- L60: -45 cr, -45 mr, -45 pr, -45 fr, unresistable, cost 350 mana
        "Malosini",                                 -- L57: -60 cr, -60 mr, -60 fr, cost 200 mana, 8.2 min
        "Malosi",                                   -- L49: -60 cr, -60 mr, -60 fr, cost 175 mana, 5.8 min
        "Malaisement",                              -- L34: -40 cr, -40 mr, -40 fr, cost 100 mana
        "Malaise",                                  -- L19: -20 cr, -20 mr, -20 fr, cost 60 mana
    },
    -- NOTE: don't stack with Talisman of the Tribunal
    shm_poison_resist = {
        "Talisman of Shadoo",                       -- L53 Talisman of Shadoo (45 pr, group) Kunark
        "Resist Poison",                            -- L39 Resist Poison (40 pr)
        "Endure Poison",                            -- L14 Endure Poison (19-20 pr)
    },
    shm_disease_resist = {
        "Talisman of the Tribunal",                 -- L62: 65 dr, 65 pr, group, PoP
        "Talisman of Epuration",                    -- L58: 55 dr, 55 pr, group, Luclin
        "Talisman of Jasinth",                      -- L50: 45 dr, group, Kunark
        "Resist Disease",                           -- L34 40 dr
        "Endure Disease",                           -- L09: 19-20 dr
    },
    shm_poison_cure = {
        "Counteract Poison",                        -- L29: -8 poison counter
        "Cure Poison",                              -- L05: -1-4 poison counter
    },
    shm_disease_cure = {
        "Counteract Disease",                       -- L24: -8 disease counter
        "Cure Disease",                             -- L01: -1-4 disease counter
    },
    shm_magic_resist = {
        "Resist Magic",                             -- L44: 40 mr
        "Endure Magic",                             -- L19: 20 mr
    },
    shm_regen = {
        "Spirit of Perseverance",                   -- L66: 60 hp/tick, 21 min, cost 343 mana
        "Replenishment",                            -- L61: 40 hp/tick, 20.5 min, cost 275 mana
        "Regrowth",                                 -- L52: 20 hp/tick, 17.5 min, cost 300 mana
        "Chloroplast",                              -- L39: 10 hp/tick, 17.5 min, cost 200 mana
        "Regeneration",                             -- L23:  5 hp/tick, 17.5 min, cost 100 mana
    },
    shm_group_regen = {
        "Talisman of Perseverance",                 -- L69: 60 hp/tick, 20.5 min, cost 812 mana
        "Blessing of Replenishment",                -- L63: 40 hp/tick, 20.5 min, cost 650 mana
    },
    -- NOTE: weaker than clr_ac
    shm_ac = {
        "Ancestral Bulwark",                        -- L67: 46 ac
        "Ancestral Guard",                          -- L62: 36 ac
        "Shroud of the Spirits",                    -- L54: 26-30 ac
        "Guardian",                                 -- L42: 23-24 ac
        "Shifting Shield",                          -- L31: 16-18 ac
        "Protect",                                  -- L20: 11-13 ac
        "Turtle Skin",                              -- L11: 8-10 ac
        "Scale Skin",                               -- L03: 4-6 ac
    },
    shm_sta = {
        "Spirit of Fortitude",                      -- L68: 75 sta, 40 sta cap
        "Endurance of the Boar",                    -- L62: 60 sta
        "Riotous Health",                           -- L54: 50 sta
        "Stamina",                                  -- L43: 36-40 sta
        "Health",                                   -- L30: 27-31 sta
        "Spirit of Ox",                             -- L21: 19-23 sta
        "Spirit of Bear",                           -- L06: 11-15 sta
    },
    shm_group_sta = {
        "Talisman of Fortitude",                    -- L69: 78 sta, 40 sta cap
        "Talisman of the Boar",                     -- L63: 60-68 sta
        "Talisman of the Brute",                    -- L57: 50 sta
    },
    -- NOTE: dru_str is weaker
    -- blocked by shm_focus (67 str)
    shm_str = {
        "Strength of the Diaku",                    -- L63: 35 str, 28 dex
        "Maniacal Strength",                        -- L57: 68 str
        "Strength",                                 -- L46: 65-67 str - works on L01
        "Furious Strength",                         -- L39: 31-34 str
        "Raging Strength",                          -- L28: 23-26 str
        "Spirit Strength",                          -- L18: 16-18 str
        "Strengthen",                               -- L01: 5-10 str
    },
    shm_group_str = {
        "Talisman of the Diaku",                    -- L64: 45 str, 35 dex
        "Talisman of the Rhino",                    -- L58: 68 str
        "Tumultuous Strength",                      -- L35: 34 str
    },
    -- NOTE: same as dru_skill_dmg_mod
    shm_skill_dmg_mod = {
        "Spirit of Might",                          -- L67: 5% skill dmg mod, cost 175 mana
    },
    shm_group_skill_dmg_mod = {
        "Talisman of Might",                        -- L70: 5% skill dmg mod, group, cost 700 mana
    },
    shm_agi = {
        "Agility of the Wrulan",                    -- L61: 60 agi
        "Deliriously Nimble",                       -- L53: 52 agi
        "Agility",                                  -- L41: 41-45 agi
        "Nimble",                                   -- L31: 31-36 agi
        "Spirit of Cat",                            -- L18: 22-27 agi
        "Feet like Cat",                            -- L03: 12-18 agi
    },
    shm_group_agi = {
        "Talisman of the Wrulan",                   -- L62: 60 agi
        "Talisman of the Cat",                      -- L57: 52 agi, group
    },
    -- blocked by shm_focus
    shm_dex = {
        "Mortal Deftness",                          -- L58: 60 dex
        "Dexterity",                                -- L48: 49-50 dex
        "Deftness",                                 -- L39: 40 dex
        "Rising Dexterity",                         -- L25: 26-30 dex
        "Spirit of Monkey",                         -- L21: 19-20 dex
        "Dexterous Aura",                           -- L01: 5-10 dex
    },
    shm_group_dex = {
        "Talisman of the Raptor",                   -- L59 Talisman of the Raptor (60 dex, group)
    },
    shm_cha = {
        "Unfailing Reverence",                      -- L59: 55 cha
        "Charisma",                                 -- L47: 40 cha
        "Glamour",                                  -- L37: 28-32 cha
        "Alluring Aura",                            -- L28: 20-23 cha
        "Spirit of Snake",                          -- L10: 11-15 cha
    },
    shm_cha_group = {
        "Talisman of the Serpent",                  -- L58: 40 cha
    },
    shm_fire_nuke = {
        "Burst of Flame",                           -- L01 Burst of Flame
    },
    shm_cold_nuke = {
        "Ice Age",                                  -- L69 Ice Age (1273 hp, cost  413 mana)
        "Velium Strike",                            -- L64 Velium Strike (925 hp, cost 330 mana)
        "Ice Strike",                               -- L54 Ice Strike (511 hp, cost 198 mana)
        "Blizzard Blast",                           -- L44 Blizzard Blast (332-346 hp, cost 147 mana)
        "Winter's Roar",                            -- L33 Winter's Roar (236-246 hp, cost 116 mana)
        "Frost Strike",                             -- L23 Frost Strike (142-156 hp, cost 78 mana)
        "Spirit Strike",                            -- L14 Spirit Strike (72-78 hp, cost 44 mana)
        "Frost Rift",                               -- L05 Frost Rift
    },
    shm_poison_nuke = {
        "Yoppa's Spear of Venom",                   -- L66 Yoppa's Spear of Venom (1197 hp, cost 425 mana)
        "Spear of Torment",                         -- L61 Spear of Torment (870 hp, cost 340 mana)
        "Blast of Venom",                           -- L54 Blast of Venom (704 hp, cost 289 mana)
    },
    shm_slow = {
        "Balance of Discord",                       -- L69: MAGIC, resist adj -60, 75% slow, 1.5 min, 1.5s cast, 350 mana, OOW
        "Balance of the Nihil",                     -- L65: MAGIC: 75% slow, 1.5 min, 1.5s cast, 300 mana, GoD
        "Turgur's Insects",                         -- L51: MAGIC: 66-75% slow, 5.1 min, 3s cast, 250 mana, Kunark
        "Togor's Insects",                          -- L38: MAGIC: 48-70% slow, 2.6 min, 5s cast, 175 mana, Original
        "Tagar's Insects",                          -- L27: MAGIC: 33-50% slow, 2.6 min, 125 mana, Original
        "Walking Sleep",                            -- L13: MAGIC: 23-35% slow, 2.6 min, 60 mana, Original
        "Drowsy",                                   -- L05: MAGIC: 11-25% slow, 2.6 min, 20 mana, Original
    },
    shm_disease_slow = {
        "Hungry Plague",                            -- L70: DISEASE: resist adj -50, 40% slow, 1 min, 3s cast, 450 mana, DoDH
        "Cloud of Grummus",                         -- L61: DISEASE: 40% slow, 3.3 min, 6.4s cast, 400 mana, PoP
        "Plague of Insects",                        -- L54: DISEASE: 25% slow, 3.3 min, 6.4s cast, 250 mana, Luclin
    },
    shm_epic2 = {
        "Blessed Spiritstaff of the Heyokah",       -- epic 2.0: Prophet's Gift of the Ruchu: group buff: skill crit damage 110%, 65% melee crit, slot 12: 500 HoT, 1 min, 3 min reuse
        "Crafted Talisman of Fates",                -- epic 1.5:
    },
    shm_oow_bp = {
        "Ritualchanter's Tunic of the Ancestors",   -- oow t2 bp: reduce resist rate by 40% for 0.7 min, 5 min recast
        "Spiritkin Tunic",                          -- oow t1 bp: reduce resist rate by 40% for 0.5 min, 5 min recast
    },
}

SpellGroups.CLR = {
    -- group heals with cure component
    clr_group_heal = {
        "Word of Vivification",                     -- CLR/69: 3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana
        "Word of Replenishment",                    -- CLR/64: 2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana
        "Word of Redemption",                       -- CLR/60: 7500 hp, cost 1100 mana
        "Word of Restoration",                      -- CLR/57: 1788-1818 hp, cost 898 mana
        "Word of Health",                           -- CLR/30: 380-485 hp, cost 302 mana
    },
    clr_heal = {
        "Ancient: Hallowed Light",                  -- L70 Ancient: Hallowed Light (4150 hp, 3.8s cast, 775 mana)
        "Pious Light",                              -- L68 Pious Light (3750-3770 hp, 3.8s cast, 740 mana)
        "Holy Light",                               -- L65 Holy Light (3275 hp, 3.8s cast, 650 mana)
        "Supernal Light",                           -- L63 Supernal Light (2730-2750 hp, 3.8s cast, 600 mana)
        "Ethereal Light",                           -- L58 Ethereal Light (1980-2000 hp, 3.8s cast, 490 mana)
        "Divine Light",                             -- L53 Divine Light
        "Greater Healing",                          -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
        "Healing",                                  -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
        "Light Healing",                            -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
        "Minor Healing",                            -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
    },
    clr_remedy = {
        "Pious Remedy",                             -- L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)
        "Supernal Remedy",                          -- L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
        "Ethereal Remedy",                          -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
        "Remedy",                                   -- L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
    },
    clr_hot = {
        "Pious Elixir",                             -- L67 Pious Elixir (slot 1: 1170 hp/tick, 0.4 min, 890 mana)
        "Holy Elixir",                              -- L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
        "Supernal Elixir",                          -- L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
        "Ethereal Elixir",                          -- L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
        "Celestial Elixir",                         -- L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
        "Celestial Healing",                        -- L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
    },
    -- group hot, don't stack with Celestial Regeneration AA
    clr_group_hot = {
        "Elixir of Divinity",                       -- L70 Elixir of Divinity (900 hp/tick, group, cost 1550 mana)
    },
    clr_rez = {
        "Reviviscence",                             -- L56: 96% exp, 7s cast, 600 mana, Kunark
        "Resurrection",                             -- L47: 90% exp, 6s cast, 20s recast, 700 mana, Original
        "Restoration",                              -- L42: 75% exp, 6s cast, 20s recast, Luclin?
        "Resuscitate",                              -- L37: 60% exp, 6s cast, 20s recast, Original
        "Renewal",                                  -- L32: 50% exp, 6s cast, 20s recast, Luclin?
        "Revive",                                   -- L27: 35% exp, 6s cast, 20s recast, Original
        "Reparation",                               -- L22: 20% exp, 6s cast, 20s recast, Luclin?
        "Reconstitution",                           -- L18: 10% exp, 6s cast, 20s recast, Luclin?
        "Reanimation",                              -- L12:  0% exp, 6s cast, 20s recast, Luclin?
    },
    -- NOTE: stacks with dru_skin and clr_ac
    clr_symbol = {
        "Symbol of Kaerra",                         -- L76 Symbol of Kaerra Rk. II (1847 hp, cost 1190 mana)
        "Symbol of Elushar",                        -- L71 Symbol of Elushar (1364 hp, cost 936 mana)
        "Symbol of Balikor",                        -- L66 Symbol of Balikor (1137 hp, cost 780 mana)
        "Symbol of Kazad",                          -- L61 Symbol of Kazad (910 hp, cost 600 mana) PoP
        "Symbol of Marzin/Reagent|Peridot",         -- L54 Symbol of Marzin (640-700 hp)
        "Symbol of Naltron/Reagent|Peridot",        -- L41 Symbol of Naltron (406-525 hp)
        "Symbol of Pinzarn/Reagent|Jasper",         -- L34 Symbol of Pinzarn
        "Symbol of Ryltan/Reagent|Bloodstone",      -- L24 Symbol of Ryltan
        "Symbol of Transal/Reagent|Cat's Eye Agate",-- L14 Symbol of Transal (34-72 hp)
    },
    clr_group_symbol = {
        "Kaerra's Mark",                            -- L80 Kaerra's Mark (1563 hp, cost 3130 mana)
        "Elushar's Mark",                           -- L75 Elushar's Mark Rk. II (1421 hp, cost 2925 mana)
        "Balikor's Mark",                           -- L70 Balikor's Mark (1137 hp, cost 2340 mana)
        "Kazad's Mark",                             -- L63 Kazad's Mark (910 hp, cost 1800 mana) PoP
        "Marzin's Mark",                            -- L60 Marzin's Mark (725 hp)
        "Naltron's Mark",                           -- L58 Naltron's Mark (525 hp)
    },
    clr_di = {
        "Divine Intervention",                      -- L60 Divine Intervention (single)
    },
    -- NOTE: stacks with clr_symbol + dru_skin + shm_focus
    clr_ac = {
        "Order of the Resolute",                    -- L80 Order of the Resolute Rk. II (slot 4: 109 ac, group)
        "Ward of the Resolute",                     -- L76 Ward of the Resolute Rk. II (solt 4: 109 ac)
        "Ward of the Dauntless",                    -- L71 Ward of the Dauntless (slot 4: 86 ac)
        "Ward of Valiance",                         -- L66 Ward of Valiance (slot 4: 72 ac)
        "Ward of Gallantry",                        -- L61 Ward of Gallantry (slot 4: 54 ac)
        "Shield of Words",                          -- L49 Shield of Words (slot 4: 31 ac)
        "Armor of Faith",                           -- L39 Armor of Faith (slot 4: 24-25 ac)
        "Guard",                                    -- L29 Guard (slot 4: 18-19 ac)
        "Spirit Armor",                             -- L19 Spirit Armor (slot 4: 11-13 ac)
        "Holy Armor",                               -- L05 Holy Armor (slot 4: 6 ac)
    },
    -- NOTE: slot 2 - does not stack with dru_skin
    clr_aegolism     = {
        "Temerity",                                 -- L77: 2457 hp, 126  ac, SoF
        "Tenacity",                                 -- L72: (2144 hp, 113 ac)
        "Conviction",                               -- L67: (1787 hp, 94 ac)
        "Virtue",                                   -- L62: (1405 hp, 72 ac, single) PoP
        "Aegolism",                                 -- L60: (1150 hp, 60 ac, single) Velious
        "Temperance",                               -- L40: (800 hp, 48 ac, single) LoY - LANDS ON L01
        "Fortitu    de",                            -- L55: (320-360 hp, 17-18 ac, 2h24m duration) Kunark
        "Heroic Bond",                              -- L52: (360-400 hp, 18-19 ac, group) Kunark
        "Heroism",                                  -- L52: (360-400 hp, 18-19 ac, 1h12m duration) Kunark
        "Resolution",                               -- L44: (232-250 hp, 15-16 ac)
        "Valor",                                    -- L34: (168-200 hp, 12-13 ac)
        "Bravery",                                  -- L24: (114-140 hp, 9-10 ac)
        "Daring",                                   -- L19: (84-135 hp, 7-9 ac)
        "Center",                                   -- L09: (44-105 hp, 5-6 ac)
        "Courage",                                  -- L01: (20 hp, 4 ac, single)
    },
    clr_group_aegoism = {
        "Hand of Temerity",                         -- L80 Hand of Temerity (2457 hp, 126 ac, group)
        "Hand of Tenacity",                         -- L75 Hand of Tenacity Rk. II (2234 hp, 118 ac, group)
        "Hand of Conviction",                       -- L70 Hand of Conviction (1787 hp, 94 ac, group) - LANDS ON L62
        "Hand of Virtue",                           -- L65 Hand of Virtue (1405 hp, 72 ac, group) PoP - LANDS ON L47
        "Blessing of Aegolism",                     -- L60 Blessing of Aegolism (1150 hp, 60 ac, group) Luclin
        "Blessing of Temperance",                   -- L45 Blessing of Temperance (800 hp, 48 ac, group) LDoN - LANDS ON L01
    },
    clr_vie = {
        "Shield of Vie",                            -- L78: absorb 10% of melee dmg to 3380, 36 min
        "Aegis of Vie",                             -- L73: absorb 10% of melee dmg to 2496, 36 min
        "Panoply of Vie",                           -- L67: absorb 10% melee dmg to 2080, 36 min
        "Bulwark of Vie",                           -- L62: absorb 10% melee dmg to 1600
        "Protection of Vie",                        -- L54: absorb 10% melee dmg to 1200
        "Guard of Vie",                             -- L40: absorb 10% melee dmg to 700
        "Ward of Vie",                              -- L20: absorb 10% melee dmg to 460
    },
    clr_group_vie = {
        "Rallied Shield of Vie",                    -- L80: slot 1: absorb 10% of melee dmg to 3380, 36 min, group
        "Rallied Aegis of Vie",                     -- L75: absorb 10% of melee dmg to 2600, 36 min, group
    },
    clr_spellhaste = {
        "Blessing of Resolve",                      -- L76 Blessing of Resolve Rk. II (10% spell haste to L80, 40 min, 390 mana)
        "Blessing of Purpose",                      -- L71 Blessing of Purpose (9% spell haste to L75, 40 min, 390 mana)
        "Blessing of Devotion",                     -- L67 Blessing of Devotion (10% spell haste to L70, 40 min, 390 mana) OOW
        "Blessing of Reverence",                    -- L62 Blessing of Reverence (10% spell haste to L65, 40 min) PoP
        "Blessing of Faith",                        -- L35 Blessing of Faith (10% spell haste to L61, 40 min) PoP
        "Blessing of Piety",                        -- L15 Blessing of Piety (10% spell haste to L39, 40 min) PoP
    },
    clr_group_spellhaste = {
        "Aura of Resolve",                          -- L77 Aura of Resolve Rk. II (10% spell haste to L80, 45 min, group, 1125 mana)
        "Aura of Purpose",                          -- L72 Aura of Purpose Rk. II (10% spell haste to L75, 45 min, group, 1125 mana)
        "Aura of Devotion",                         -- L69 Aura of Devotion (10% spell haste to L70, 45 min, group, 1125 mana) OOW
        "Aura of Reverence",                        -- L64 Aura of Reverence (10% spell haste to L65, 40 min, group) LDoN
    },
    -- NOTE: does not stack with dru_skin
    clr_self_shield = {
        "Armor of the Solemn",                      -- L80 Armor of the Solemn Rk. II (915 hp, 71 ac, 12 mana/tick)
        "Armor of the Sacred",                      -- L75 Armor of the Sacred Rk. II (704 hp, 58 ac, 10 mana/tick)
        "Armor of the Pious",                       -- L70 Armor of the Pious (563 hp, 46 ac, 9 mana/tick)
        "Armor of the Zealot",                      -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
        "Blessed Armor of the Risen",               -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
        "Armor of the Faithful",                    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
        "Armor of Protection",                      -- L34 Armor of Protection (202-225 hp, 15 ac)
    },
    clr_yaulp = {
        "Yaulp VII",                                -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
        "Yaulp VI",                                 -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
        "Yaulp V",                                  -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
        "Yaulp IV",                                 -- L53 Yaulp IV () Kunark
        "Yaulp III",                                -- L44 Yaulp III () Original
        "Yaulp II",                                 -- L19 Yaulp II () Original
        "Yaulp",                                    -- L01 Yaulp () Original
    },
    clr_stun = {
        "Enforced Reverence",                       -- L58 Enforced Reverence
        "Sound of Force",                           -- L49 Sound of Force
        "Force",                                    -- L34 Force
        "Holy Might",                               -- L19 Holy Might
        "Stun",                                     -- L05 Stun
    },
    clr_nuke = {
        "Ancient: Pious Conscience",                -- L70: 1646 dd, cost 457 mana
        "Chromastrike",                             -- L69: 1200 dd, cost 375 mana, chromatic resist
        "Reproach",                                 -- L67: 1424-1524 dd, cost 430 mana
        "Ancient: Chaos Censure",                   -- L65: 1329 dd, cost 413 mana
        "Order",                                    -- L65: 1219 dd, cost 379 mana
        "Condemnation",                             -- L62: 1175 dd, cost 365 mana
        "Judgment",                                 -- L56: 842 dd, cost 274 mana
        "Reckoning",                                -- L54: 675 dd, cost 250 mana, Kunark
        "Retribution",                              -- L44: 372-390 dd, cost 240 mana, Original
        "Wrath",                                    -- L29: 192-218 dd, cost 145 mana
        "Smite",                                    -- L14: -74-83 dd, cost 70 mana
        "Furor",                                    -- L05: -16-19 dd, cost 20 mana
        "Strike",                                   -- L01: -6-8 dd, cost 12 mana
    },
    clr_pbae_nuke = {
        "Calamity",                                 -- L69 Calamity (1105 hp, aerange 35, recast 24s, cost 812 mana - PUSHBACK 1.0)
        "Catastrophe",                              -- L64 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
        "The Unspoken Word",                        -- L59 The Unspoken Word (605 hp, aerange 20, recast 120s, cost 427 mana)
        "Upheaval",                                 -- L52 Upheaval (618-725 hp, aerange 35, recast 24s, cost 625 mana)
        "Word Divine",                              -- L49 Word Divine (339 hp, aerange 20, recast 9s, cost 304 mana)
        "Earthquake",                               -- L44 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
        "Word of Souls",                            -- L39 Word of Souls (138-155 hp, aerange 20, recast 9s, cost 171 mana)
        "Tremor",                                   -- L34 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
        "Word of Spirit",                           -- L26 Word of Spirit (91-104 hp, aerange 20, recast 9s, cost 133 mana)
        "Word of Shadow",                           -- L19 Word of Shadow (52-58 hp, aerange 20, recast 9s, cost 85 mana)
        "Word of Pain",                             -- L09 Word of Pain (24-29 hp, aerange 20, recast 9s, cost 47 mana)
    },
    clr_magic_resist = {
        "Resist Magic",                             -- L44: 40 mr
        "Endure Magic",                             -- L19: 20 mr
    },
    clr_oow_bp = {
        "Faithbringer's Breastplate of Conviction", -- oow T2 bp: increase healing spell potency by 1-50% for 0.7 min
        "Sanctified Chestguard",                    -- oow T1 bp: increase healing spell potency by 1-50% for 0.5 min
    },
}

SpellGroups.DRU = {
    dru_group_heal = {
        "Moonshadow",                               -- L70: 1500 hp, cost 1100 mana, 4.5S cast, 18s recast
    },
    dru_heal = {
        "Ancient: Chlorobon",                       -- L70 Ancient: Chlorobon (3094 hp, cost 723 mana,3.75s cast)
        "Chlorotrope",                              -- L68 Chlorotrope (2790-2810 hp, cost 691 mana, 3.75s cast)
        "Sylvan Infusion",                          -- L65 Sylvan Infusion (2441 hp, cost 607 mana, 3.75s cast)
        "Nature's Infusion",                        -- L63 Nature's Infusion (2030-2050 hp, cost 560 mana)
        "Nature's Touch",                           -- L60 Nature's Touch (1491 hp, cost 457 mana)
        "Chloroblast",                              -- L55 Chloroblast (994-1044 hp, cost 331 mana)
        "Superior Healing",                         -- L51 Superior Healing (500-600 hp, cost 185 mana)
        "Healing Water",                            -- L44 Healing Water (395-425 hp, cost 150 mana)
        "Greater Healing",                          -- L29 Greater Healing (280-350 hp, cost 115 mana)
        "Healing",                                  -- L10 Healing
        "Light Healing",                            -- L09 Light Healing
        "Minor Healing",                            -- L01 Minor Healing
    },
    dru_complete_heal = {
        "Karana's Renewal",                         -- L64 Karana's Renewal (4680 hp, cost 600 mana - 75% CH)
        "Tunare's Renewal",                         -- L58 Tunare's Renewal (2925 hp, cost 400 mana - 75% CH)
    },
    dru_skin = {
        "Ironwood Skin",                            -- L77 Ironwood Skin Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 1382 mana)
        "Direwild Skin",                            -- L72 Direwild Skin Rk. II (54 ac, 965 hp, 10 mana/tick, cost 1133 mana)
        "Steeloak Skin",                            -- L68: 43 ac, 772 hp, 9 mana/tick, cost 906 mana
        "Protection of the Nine",                   -- L63: 32 ac, 618 hp, 8 mana/tick, cost 725 mana
        "Protection of the Cabbage",                -- L59: 24 ac, 467-485 hp, 6 mana/tick
        "Skin like Nature",                         -- L49 Skin like Nature
        "Skin like Diamond",                        -- L39 Skin like Diamond
        "Skin like Steel",                          -- L24 Skin like Steel
        "Skin like Rock",                           -- L14 Skin like Rock
        "Skin like Wood",                           -- L01 Skin like Wood
    },
    dru_group_skin = {
        "Blessing of the Ironwood",                 -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
        "Blessing of the Direwild",                 -- L75 Blessing of the Direwild Rk. II (56 ac, 1004 hp, 10 mana/tick, cost 2873 mana, group)
        "Blessing of Steeloak",                     -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
        "Blessing of the Nine",                     -- L65 Blessing of the Nine (32 ac, 618 hp, 8 mana/tick, cost 1700 mana, group)
        "Protection of the Glades",                 -- L60 Protection of the Glades (24 ac, 470-485 hp, 6 mana/tick, group)
        "Protection of Nature",                     -- L49 Protection of Nature (16 ac, 248-25 hp, 2 hp/tick, group)
    },
    dru_fire_resist = {
        "Protection of Seasons",                    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
        "Circle of Seasons",                        -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
        "Circle of Winter",                         -- L51 Circle of Winter (slot 1: 45 fr)
        "Resist Fire",                              -- L20 Resist Fire (slot 1: 30-40 fr)
        "Endure Fire",                              -- L01 Endure Fire (slot 1: 11-20 fr)
    },
    dru_cold_resist = {
        "Resist Cold",                              -- L30 Resist Cold (slot 1: 39-40 cr)
        "Endure Cold",                              -- L09 Endure Cold (slot 1: 11-20 cr)
    },
    dru_cold_resist2 = {
        "Circle of Summer",                         -- L52 Circle of Summer (slot 4: 45 cr) - stack with dru_fire_resist and dru_cold_resist
    },
    dru_poison_resist = {
        "Resist Poison",                            -- L44 Resist Poison (40 pr)
        "Endure Poison",                            -- L19 Endure Poison (19-20 pr)
    },
    dru_disease_resist = {
        "Resist Disease",                           -- L44 Resist Disease (40 dr)
        "Endure Disease",                           -- L19 Endure Disease (19-20 dr)
    },
    dru_magic_resist = {
        "Resist Magic",                             -- L49: 40 mr
        "Endure Magic",                             -- L34: 20
    },
    dru_corruption_resist = {
        "Forbear Corruption",                       -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
        "Resist Corruption",                        -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    },
    dru_poison_cure = {
        "Counteract Poison",                        -- L29 Counteract Poison (-8 poison counter)
        "Cure Poison",                              -- L05 Cure Poison (-1-4 poison counter)
    },
    dru_disease_cure = {
        "Counteract Disease",                       -- L29 Counteract Disease (-8 disease counter)
        "Cure Disease",                             -- L05 Cure Disease (-1-4 disease counter)
    },
    dru_regen = {
        "Spirit of the Stalwart",                   -- L76 Spirit of the Stalwart Rk. II (105-144 hp/tick, 21 min, cost 523 mana)
        "Oaken Vigor",                              -- L66 Oaken Vigor (60-70 hp/tick, 21 min, cost 343 mana)
        "Replenishment",                            -- L61 Replenishment (40-58 hp/tick, 19.6 min, cost 275 mana)
        "Regrowth",                                 -- L54 Regrowth (20-38 hp/tick, 18.4 min, cost 300 mana)
        "Chloroplast",                              -- L42 Chloroplast (10-19 hp/tick)
        "Regeneration",                             -- L34 Regeneration (5-9 hp/tick)
    },
    dru_group_regen = {
        "Talisman of the Stalwart",                 -- L79 Talisman of the Stalwart Rk. II (111-144 hp/tick, 21 min, cost 1238 mana)
        "Blessing of Oak",                          -- L69 Blessing of Oak (66-70 hp/tick, 21 min, cost 845 mana)
        "Blessing of Replenishment",                -- L63 Blessing of Replenishment (44-58 hp/tick, 19.6 min, cost 650 mana)
        "Regrowth of the Grove",                    -- L58 Regrowth of the Grove (32-38 hp/tick, 18.4 min, cost 600 mana)
        "Pack Chloroplast",                         -- L45 Pack Chloroplast (13-19 hp/tick)
        "Pack Regeneration",                        -- L39 Pack Regeneration (9 hp/tick)
    },
    -- NOTE: mag_ds is stronger
    dru_ds = {
        "Viridifloral Bulwark",                     -- L77 Viridifloral Bulwark Rk. II (86 ds, 15 min)
        "Viridifloral Shield",                      -- L72 Viridifloral Shield Rk. II (69 ds, 15 min)
        "Nettle Shield",                            -- L67: 55 ds, 15 min
        "Shield of Bracken",                        -- L63: 40 ds, 15 min
        "Shield of Blades",                         -- L58: 32 ds, 15 min
        "Shield of Thorns",                         -- L47: 24 ds, 15 min - lands on LV1
        "Shield of Spikes",                         -- L37: 14 ds, 15 mi
        "Shield of Brambles",                       -- L27: 10-12 ds, 15 min
        "Shield of Barbs",                          -- L17: 7-9 ds, 15 min
        "Shield of Thistles",                       -- L07: 4-6 ds, 15 min
    },
    dru_group_ds = {
        "Legacy of Viridithorns",                   -- L80 Legacy of Viridithorns Rk. II (86 ds, 15 min)
        "Legacy of Viridiflora",                    -- L75 Legacy of Viridiflora Rk. II (69 ds, 15 min)
        "Legacy of Nettles",                        -- L70: 55 ds, 15 min
        "Legacy of Bracken",                        -- L65: 40 ds, 15 min
        "Legacy of Thorn",                          -- L59: 32 ds, 15 min
        "Legacy of Spike",                          -- L49: 24 ds, 15 min - lands on LV1
    },
    -- NOTE: shm_str is stronger
    dru_str = {
        "Nature's Might",                           -- L62 Nature's Might (55 str) PoP
        "Girdle of Karana",                         -- L55 Girdle of Karana (42 str) Kunark
        "Storm Strength",                           -- L44 Storm Strength (32-35 str)
        "Strength of Stone",                        -- L34 Strength of Stone (22-25 str)
        "Strength of Earth",                        -- L07 Strength of Earth (8-15 str)
    },
    -- NOTE: shm_skill_dmg_mod is the same and shm_group_skill_dmg_mod exists
    dru_skill_dmg_mod = {
        "Mammoth's Strength",                       -- L71 Mammoth's Strength Rk. III (increase skills dmg mod by 8%, cost 215 mana)
        "Lion's Strength",                          -- L67 Lion's Strength (increase skills dmg mod by 5%, cost 165 mana)
    },
    dru_runspeed = {
        "Flight of Eagles",                         -- L62 Flight of Eagles (70% speed, 1 hour, group) PoP
        "Spirit of Eagle",                          -- L54 Spirit of Eagle (57-70% speed, 1 hour) Luclin
        "Pack Spirit",                              -- L35 Pack Spirit (47-55% speed, 36 min, group) Original
        "Spirit of Wolf",                           -- L10 Spirit of Wolf (48-55% speed, 36 min) Original
    },
    dru_self_ds = {
        "Viridithorn Coat",                         -- L78 Viridithorn Coat rk1: slot 2: 86 ac, slot 3: 23 ds, rk2: slot 2: 98 ac, slot 3: 26 ds
        "Vididicoat",                               -- L73 Vididicoat Rk. II (slot 2: 80 ac, slot 3: 21 ds)
        "Nettlecoat",                               -- L68 Nettlecoat (64 ac, 17 ds)
        "Brackencoat",                              -- L64 Brackencoat (49 ac, 13 ds)
        "Bladecoat",                                -- L56 Bladecoat (37 ac, 6 ds)
        "Thorncoat",                                -- L47 Thorncoat (31 ac, 5 ds)
        "Spikecoat",                                -- L37 Spikecoat (23-25 ac, 4 ds)
        "Bramblecoat",                              -- L27 Bramblecoat (16-18 ac, 3 ds)
        "Barbcoat",                                 -- L17 Barbcoat (10-12 ac, 2 ds)
        "Thistlecoat",                              -- L07 Thistlecoat (4-6 ac, 1 ds)
    },
    dru_self_mana = {
        "Mask of the Shadowcat",                    -- L80 Mask of the Shadowcat (slot 2: 9 mana/tick)
        "Mask of the Wild",                         -- L70 Mask of the Wild (5 mana/tick)
        "Mask of the Forest",                       -- L65 Mask of the Forest (4 mana/tick)
        "Mask of the Stalker",                      -- L60 Mask of the Stalker (3 mana/tick)
    },
    dru_snare = {
        -- Special L70 Hungry Vines (magic -100, snare 50%, 0.3 min, cast time 3s, cost 500 mana) + absorb 1600 melee dmg on group

        "Serpent Vines",                            -- L69 Serpent Vines (chromatic -50, snare 55-60%, 3.0 min, cast time 3s, cost 125 mana)
        "Mire Thorns",                              -- L61 Mire Thorns (chromatic -20, snare 55-60%, 3.0 min, cast time 3s, cost 75 mana)
        "Ensnare",                                  -- L29 Ensnare
        "Snare",                                    -- L01 Snare
    },
    dru_fire_nuke = {
        -- Special L70 Dawnstrike (2125 hp, cost 482 mana. chance to proc spell buff that adjust dmg of next nuke)

        "Solstice Strike",                          -- L69 Solstice Strike (2201 hp, cost 494 mana)
        "Sylvan Fire",                              -- L65 Sylvan Fire (1761 hp, cost 435 mana)
        "Summer's Flame",                           -- L64 Summer's Flame (1600 hp, cost 395 mana)
        "Ancient: Starfire of Ro",                  -- L60 Ancient: Starfire of Ro (1350 hp, cost 300 mana)
        "Wildfire",                                 -- L59 Wildfire (1294 hp, cost 335 mana)
        "Scoriae",                                  -- L54 Scoriae (986 hp, cost 264 mana)
        "Starfire",                                 -- L48 Starfire (634 hp, cost 186 mana)
        "Firestrike",                               -- L38 Firestrike (402-422 hp, cost 138 mana)
        "Combust",                                  -- L28 Combust (156-182 hp, cost 85 mana)
        "Ignite",                                   -- L08 Ignite (38-46 hp, cost 21 mana)
        "Burst of Fire",                            -- L03 Burst of Fire (11-14 hp, cost 7 mana)
        "Burst of Flame",                           -- L01 Burst of Flame (3-5 hp, cost 4 mana)
    },
    dru_cold_nuke = {
        "Ancient: Glacier Frost",                   -- L70 Ancient: Glacier Frost (2042 hp, cost 405 mana)
        "Glitterfrost",                             -- L70 Glitterfrost (1892 hp, cost 381 mana)
        "Ancient: Chaos Frost",                     -- L65 Ancient: Chaos Frost (1450 hp, cost 290 mana)
        "Winter's Frost",                           -- L65 Winter's Frost (1375 hp, cost 305 mana)
        "Moonfire",                                 -- L60 Moonfire (1132 hp, cost 263 mana)
        "Frost",                                    -- L55 Frost (837 hp, cost 202 mana)
        "Ice",                                      -- L47 Ice (511-538 hp, cost 142 mana)
    },
    -- stacks with CLR/SHM/PAL HoT
    dru_hot_v2 = {
        "Nature's Recovery",                        -- L60 Nature's Recovery (slot 2: 30 hp/tick, 3.0 min, recast 90s, cost 250 mana). Don't stack with Spirit of the Wood AA
    },
    dru_pbae_nuke = {
        "Earth Shiver",                             -- L66: 1105 magic dmg, aerange 35, recast 24s, cost 812 mana, OOW
        "Catastrophe",                              -- L61: 850 magic dmg, aerange 35, recast 24s, cost 650 mana, PoP
        "Upheaval",                                 -- L48: 618-725 magic dmg, aerange 35, recast 24, cost 625 mana, Kunark
        "Earthquake",                               -- L31: 214-246 magic dmg, aerange 30, recast 24s, cost 375 mana, Original
        "Tremor",                                   -- L21: 106-122 magic dmg, aerange 30, recast 10s, cost 200 mana, Original
    },
    dru_pbae_snare = {
        "Hungry Vines",                             -- L70 Hungry Vines (ae snare, aerange 50, recast 30s, cost 500 mana, duration 12s) OOW
    },
    dru_magic_dot = {
        "Wasp Swarm",                               -- L68 Wasp Swarm (resist -100, 283-289 hp/tick, 54s, cost 454 mana)
        "Swarming Death",                           -- L63 Swarming Death (resist -100, 216-225 hp/tick, cost 357 mana)
        "Winged Death",                             -- L53 Winged Death (resist -100) Kunark
        "Drifting Death",                           -- L40 Drifting Death (resist -100) Original
        "Drones of Doom",                           -- L32 Drones of Doom (resist -100) Original
        "Creeping Crud",                            -- L24 Creeping Crud (resist -100) Original
        "Stinging Swarm",                           -- L10 Stinging Swarm (resist -100) Original
    },
    dru_cold_debuff = {
        "Eci's Frosty Breath",                      -- L63 Eci's Frosty Breath (-55 cr, -24-30 ac, resist adj -200)
        "Glacier Breath",                           -- L67 Glacier Breath (-55 cr, -30-36 ac, resist adj -200)
    },
    dru_ac_dot = {
        "Immolation of the Sun",                    -- L67 Immolation of the Sun (-174-178 hp/tick, slot 10: -36 ac, slot 3: -40 fr, resist adj -50) OOW
        "Sylvan Embers",                            -- L65 Sylvan Embers (-132-142 hp/tick, slot 10: -30 ac, slot 3: -40 fr, resist adj -50, 1 min) GoD
        "Immolation of Ro",                         -- L62 Immolation of Ro (-145 hp/tick, slot 10: -27 ac, slot 3: -35 fr, resist adj -50) PoP
        "Flame Lick",                               -- L01 Flame Lick (-1-3 hp/tick, slot 10: -3 ac) Fire Beetle Eye
    },
    dru_fire_dot = {
        "Vengeance of the Sun",                     -- L69 Vengeance of the Sun (-408-412 hp/tick)
        "Vengeance of Tunare",                      -- L64 Vengeance of Tunare (-293-310 hp/tick)
        "Vengeance of Nature",                      -- L55 Vengeance of Nature (resist adj -30, -170-174 hp/tick)
        "Vengeance of the Wild",                    -- L49 Vengeance of the Wild (-124 hp/tick)
        "Immolate",                                 -- L29 Immolate (-24 hp/tick, -11-18 ac) Fire Beetle Eye
    },
    dru_fire_debuff = {
        "Hand of Ro",                               -- L61 Hand of Ro (slot 7: -72 fr, slot 10: -100 atk, slot 12: -15 ac, resist adj -200) PoP
        "Ro's Smoldering Disjunction",              -- L56 Ro's Smoldering Disjunction (-150 hp, slot 4: -58-80 atk, slot 6: -26-33 ac, slot 7: -64-71 fr) Luclin
    },
    dru_attack_debuff = {
        "Sun's Corona",                             -- L67 Sun's Corona (FIRE: slot 5: -90 atk, slot 6: -19 ac) OOW
        "Ro's Illumination",                        -- L62 Ro's Illumination (slot 5: -80 atk, slot 6: -15 ac) PoP
    },
    dru_epic2 = {
        "Staff of Everliving Brambles",             -- epic 2.0: increase spell damage by 50% for 0.5 min, 3 min recast
        "Staff of Living Brambles",                 -- epic 1.5: increase spell damage by XX% for 0.5 min, 6 min recast
    },
    dru_oow_bp = {
        "Everspring Jerkin of the Tangled Briars",  -- oow t2 chest: slot 1: reduce cast time by 25% for 0.7 min
        "Greenvale Jerkin",                         -- oow t1 chest: slot 1: reduce cast time by 25% for 0.5 min
    },
}

SpellGroups.ENC = {
    enc_manaregen = {
        "Seer's Cognizance",                        -- L78: 35 mana/tick, cost 610 mana
        "Seer's Intuition",                         -- L73: 24 mana/tick, cost 480 mana
        "Clairvoyance",                             -- L68: 20 mana/tick, cost 400 mana
        "Clarity II",                               -- L52: 9-11 mana/tick, cost 115 mana, Kunark
        "Clarity",                                  -- L26: 7-9 mana/tick, cost 75 mana, Original
        "Breeze",                                   -- L16: 2 mana/tick, cost 35 mana, Kunark
    },
    enc_group_manaregen = {
        "Voice of Cognizance",                      -- L80 Voice of Cognizance Rk. II (35 mana/tick, cost 1983 mana, group)
        "Voice of Intuition",                       -- L75 Voice of Intuition Rk. II (25 mana/tick, cost 1625 mana, group)
        "Voice of Clairvoyance",                    -- L70 Voice of Clairvoyance (20 mana/tick, cost 1300 mana, group), OOW
        "Voice of Quellious",                       -- L65 Voice of Quellious (18 mana/tick, group, cost 1200 mana), PoP
        --"Dusty Cap of the Will Breaker",          -- L65 Dusty Cap of the Will Breaker (LDoN raid). casts Voice of Quellious on L01 toons, TODO make use of
        "Tranquility",                              -- L63 Tranquility (16 mana/tick, group), PoP
        "Koadic's Endless Intellect",               -- L60 Koadic's Endless Intellect (14 mana/tick, group), Luclin
        "Gift of Pure Thought",                     -- L56 Gift of Pure Thought (10-11 mana/tick, group), Kunark
        "Boon of the Clear Mind",                   -- L42 Boon of the Clear Mind (6-9 mana/tick, group), Kunark
    },
    enc_mana_pool = {
        "Gift of Brilliance",                       -- L60: slot 1: 150 mana cap, slot 3: 2 mana/tick, Velious
        "Gift of Insight",                          -- L55: slot 1: 100 mana cap, slot 3: 1 mana/tick, Velious
    },
    enc_haste = {
        "Speed of Ellowind",                        -- L72 Speed of Ellowind   (68% haste, 64 atk, 72 agi, 60 dex, 42 min, 24% melee crit chance, %1 crit melee damage, cost 524 mana)
        "Speed of Salik",                           -- L67 Speed of Salik      (68% haste, 53 atk, 60 agi, 50 dex, 42 min 20% melee crit chance, cost 437 mana)
        "Speed of Vallon",                          -- L62 Speed of Vallon     (68% haste, 41 atk, 52 agi, 33 dex, 42 min)
        "Wonderous Rapidity",                       -- NOTE: original spelling, used on some classic servers like FVP
        "Wondrous Rapidity",                        -- L58 Wondrous Rapidity   (70% haste, 18.4 min)
        "Aanya's Quickening",                       -- L53 Aanya's Quickening  (64% haste, 24 min, DOES NOT land on lv15. DOES LAND on L42)
        "Swift Like the Wind",                      -- L47 Swift Like the Wind (60% haste, 16 min) - L01-45
        "Augmentation",                             -- L29: 22-28% haste, 27min
        "Alacrity",                                 -- L24 Alacrity (34-40% haste, 7 min)
        "Quickness",                                -- L16 Quickness (28-30% haste, 7 min)
    },
    enc_group_haste = {
        "Vallon's Quickening",                      -- L65 Vallon's Quickening (68% haste, 41 atk, 52 agi, 33 dex, 42 min, group)
        "Hastening of Salik",                       -- L67 Hastening of Salik  (68% haste, 53 atk, 60 agi, 50 dex, 42 min, 20% melee crit chance, cost 1260 mana, group)
        "Hastening of Ellowind",                    -- L75 Hastening of Ellowind Rk. II (68% haste, 66 atk, 75 agi, 63 dex, 42 min, 25% melee crit chance, 2% crit melee damage, cost 1575 mana, group)
    },
    enc_magic_resist = {
        "Guard of Druzzil",                         -- L62: 75 mr, group, PoP
        "Group Resist Magic",                       -- L49: 55 mr, group
        "Resist Magic",                             -- L39: 40 mr
        "Endure Magic",                             -- L20: 20 mr
    },
    enc_cha = {
        "Overwhelming Splendor",                    -- L56: 50 cha
        "Adorning Grace",                           -- L46: 40 cha
        "Radiant Visage",                           -- L31: 25-30 cha
        "Sympathetic Aura",                         -- L18: 15-18 cha
    },
    -- targeted rune - slot 1
    enc_rune = {
        "Rune of Erradien/Reagent|Peridot",         -- L76 Rune of Erradien (absorb rk1 5363 dmg, rk2 5631 dmg) SoF
        "Rune of Ellowind/Reagent|Peridot",         -- L71 Rune of Ellowind (absorb 2160 dmg) SerpentSpine
        "Rune of Salik/Reagent|Peridot",            -- L67 Rune of Salik (absorb 1105 dmg) OOW
        "Rune of Zebuxoruk/Reagent|Peridot",        -- L61 Rune of Zebuxoruk (absorb 850 dmg) PoP
        "Rune V/Reagent|Peridot",                   -- L52 Rune V (absorb 620-700 dmg) Kunark
        "Rune IV/Reagent|Peridot",                  -- L44 Rune IV (absorb 305-394 dmg, 90 min) Original
        "Rune III/Reagent|Jasper",                  -- L34 Rune III (absorb 168-230 dmg, 72 min) Original
        "Rune II/Reagent|Bloodstone",               -- L24 Rune II (absorb 71-118 dmg, 54 min) Original
        "Rune I/Reagent|Cat's Eye Agate",           -- L16 Rune I (absorb 27-55 dmg, 36 min) Original
    },
    enc_group_rune = {
        "Rune of the Deep",                         -- L79: slot 1: absorb 4118 dmg, slot 2: defensive proc Blurred Shadows Rk. II
        "Rune of Rikkukin",                         -- L69: slot 1: absorb 1500 dmg, group, DoN
    },

    -- self rune - slot 3. NOTE: don't stack with Eldritch Rune AA
    -- L65 Eldritch Rune AA Rank 1 (id:3258, absorb 500 dmg) PoP
    -- L65 Eldritch Rune AA Rank 2 (id:3259, absorb 1000 dmg) PoP
    -- L65 Eldritch Rune AA Rank 3 (id:3260, absorb 1500 dmg) PoP
    -- L66 Eldritch Rune AA Rank 4 (id:8109, absorb 1800 dmg)
    -- L67 Eldritch Rune AA Rank 5 (id:8110, absorb 2100 dmg)
    -- L68 Eldritch Rune AA Rank 6 (id:8111, absorb 2400 dmg)
    -- L69 Eldritch Rune AA Rank 7 (id:8112, absorb 2700 dmg)
    -- L70 Eldritch Rune AA Rank 8 (id:8113, absorb 3000 dmg, 10 min recast)
    enc_self_rune = {
        "Ethereal Rune",                            -- L66 Ethereal Rune (absorb 1950 dmg) OOW
        "Arcane Rune",                              -- L61 Arcane Rune (absorb 1500 dmg) PoP
    },

    -- NOTE: does not stack with clr_aegolism or shm_focus
    enc_self_shield = {
        "Mystic Shield",                            -- L66: 390 hp, 46 ac, 40 mr
        "Shield of Maelin",                         -- L64: 350 hp, 38-39 ac, 40 mr
        "Shield of the Arcane",                     -- L61: 298-300 hp, 34-36 ac, 30 mr
        "Shield of the Magi",                       -- L54: 232-250 hp, 29-31 ac, 22-24 mr
        "Arch Shielding",                           -- L43: 140-150 hp, 24-27 ac, 20 mr
        "Greater Shielding",                        -- L32: 91-100 hp, 20-22 ac, 16 mr
        "Major Shielding",                          -- L24: 68-75 hp, 16-18 ac, 14 mr
        "Shielding",                                -- L16: 45-50 hp, 11-13 ac, 11-12 mr
        "Lesser Shielding",                         -- L05: 17-30 hp, 5-9 ac, 6-10 mr
        "Minor Shielding",                          -- L01: 6-10 hp, 3-4 ac
    },
    enc_tash = {
        "Howl of Tashan",                           -- L61 Howl of Tashan (-48-50 mr, 13.6 min, cost 40 mana) PoP
        "Tashanian",                                -- L57 Tashanian (-37-43 mr, 12.4 min, 40 mana) Kunark
        "Tashania",                                 -- L44 Tashania (-31-33 mr, 30 mana) Original
        "Tashani",                                  -- L20 Tashani (-20-23 mr, 20 mana) Original
        "Tashan",                                   -- L04 Tashan (-9-13 mr, 10 mana) Original
    },
    enc_mez = {
        "Euphoria/MaxLevel|73",                     -- L69: 0.9 min/L73, resist adj -10, 70% memblur, 375 mana, OOW
        "Felicity/MaxLevel|70",                     -- L67: 0.9 min/L70, resist adj -10, 70% memblur, 340 mana, OOW
        "Bliss/MaxLevel|68",                        -- L64: 0.9 min/L68, resist adj -10, 80% memblur, 300 mana, PoP
        "Sleep/MaxLevel|65",                        -- L63: 0.9 min/L65, resist adj -10, 75% memblur, 275 mana, PoP
        "Apathy/MaxLevel|62",                       -- L61: 0.9 min/L62, reisst adj -10, 70% memblur, 225 mana, PoP
        "Glamour of Kintaz/MaxLevel|57",            -- L54: 0.9 min/L57, resist adj -10, 70% memblur, 125 mana, 1.5s recast, Kunark
        "Dazzle/MaxLevel|55",                       -- L49: 1.6 min/L55, 1% memblur, 125 mana, 5s recast, Original
        "Entrance/MaxLevel|55",                     -- L34: 1.2 min/L55, 1% memblur, 85 mana, 3.75s recast, Original
        "Enthrall/MaxLevel|55",                     -- L16: 0.8 min/L55, 1% memblur, 50 mana, 2.5s recasat, Original
        "Mesmerize/MaxLevel|55",                    -- L04: 0.4 min/L55, 1% memblur, 20 mana, 2.25s recast, Original
    },
    enc_unresistable_mez = {
        "Rapture/MaxLevel|61",                      -- L59: 0.7 min/L61, resist adj -1000, 80% memblur, 250 mana, 24s recast, Kunark
    },
    enc_ae_mez = {
        "Wake of Felicity/MaxLevel|70",             -- L69: 0.9 min/L70, 25 aerange, 6 sec recast
        "Bliss of the Nihil/MaxLevel|68",           -- L65: 0.6 min/L68, aerange 25, cost 850 mana, 6 sec recast, GoD
        "Word of Morell/MaxLevel|65",               -- L62: 0.3 min/L65, aerange 30, cost 300 mana, PoP
        "Fascination/MaxLevel|55",                  -- L52: 36 sec/L55, 35 aerange resist adj -10, 1% memblur, cost 200 mana, Kunark
        "Mesmerization/MaxLevel|55",                -- L16: 0.4 min/L55, aerange 30, 1% memblur, cost 70 mana, Original
    },
    enc_slow = {
        "Desolate Deeds",                           -- L69: MAGIC 70% slow, resist adj -30, 1.5 min, cost 300 mana, OOW
        "Dreary Deeds",                             -- L65: MAGIC 70% slow, resist adj -10, 1.5 min, cost 270 mana, GoD
        "Forlorn Deeds",                            -- L57: MAGIC 67-70% slow, 2.9 min, 225 mana, Kunark
        "Shiftless Deeds",                          -- L44: MAGIC 49-65% slow, 2.7 min, 200 mana, Original
        "Tepid Deeds",                              -- L24: MAGIC 32-50% slow, 2.7 min, 100 mana, Original
        "Languid Pace",                             -- L12: MAGIC 18-30% slow, 2.7 min, 50 mana, Original
    },
    enc_disempower = {
        "Synapsis Spasm",                           -- L66 Synapsis Spasm (-100 dex, -100 agi, -100 str, -39 ac, cost 225 mana) OOW
        "Cripple",                                  -- L53 Cripple (-58-105 dex, -68-115 agi, -68-115 str, -30-45 ac, cost 225 mana) Kunark
        "Incapacitate",                             -- L40 Incapacitate (-45-55 agi, -45-55 str, -21-24 ac, cost 150 mana) Original
        "Listless Power",                           -- L25 Listless Power (-22-35 agi, -22-35 str, -10-18 ac, cost 90 mana) Original
        "Disempower",                               -- L16 Disempower (-9-12 sta, -13-15 str, -6-9 ac) Original
        "Enfeeblement",                             -- L04 Enfeeblement (-18-20 str, -3 ac, cost 20 mana) Original
    },
    enc_unresistable_charm = {
        "Ancient: Voice of Muram/MaxLevel|70",      -- L70 Ancient: Voice of Muram (-1000 magic, charm/L70, 0.8 min, 5m recast)
        "Dictate/MaxLevel|58",                      -- L60 Dictate (-1000 magic, charm/L58, 0.8 min, 5m recast)
        "Ordinance/MaxLevel|52",                    -- L48 Ordinance (-1000 magic, charm/L52, 0.8 min, 5m recast)
    },
    enc_charm = {
        "True Name/MaxLevel|69",                    -- L70 True Name (magic, charm/L69, 7.5 min). 5s cast time, 1.5s recast
        "Compel/MaxLevel|67",                       -- L68 Compel (magic, charm/L67, 7.5 min). 5s cast time, 1.5s recast
        "Command of Druzzil/MaxLevel|64",           -- L64 Command of Druzzil (magic, charm/L64, 7.5 min). 5s cast time, 1.5s recast
        "Beckon/MaxLevel|57",                       -- L62 Beckon (magic, charm/L57, 7.5 min)
        "Boltran's Agacerie/MaxLevel|53",           -- L53 Boltran's Agacerie (-10 magic, charm/L53, 7.5 min)
        "Allure/MaxLevel|51",                       -- L46 Allure (magic, charm/L51, 20.5 min)
        "Cajoling Whispers/MaxLevel|46",            -- L37 Cajoling Whispers (magic, charm/L46, 20.5 min)
        "Beguile/MaxLevel|37",                      -- L23 Beguile (magic, charm/L37, 20.5 min)
        "Charm/MaxLevel|25",                        -- L11 Charm (magic, charm/L25, 20.5 min)
    },

    enc_magic_nuke = {
        "Ancient: Neurosis",                        -- L70 Ancient: Neurosis (1634 hp, cost 398 mana)
        "Psychosis",                                -- L68 Psychosis (1513 hp, cost 375 mana)
        "Ancient: Chaos Madness",                   -- L65 Ancient: Chaos Madness (1320 hp, cost 360 mana)
        "Madness of Ikkibi",                        -- L65 Madness of Ikkibi (1210 hp, cost 330 mana)
        "Insanity",                                 -- L64 Insanity (1100 hp, cost 300 mana)
        "Dementing Visions",                        -- L58 Dementing Visions (836 hp, 239 mana)
        "Dementia",                                 -- L54 Dementia (571 hp, 1s stun, 169 mana)
        "Discordant Mind",                          -- L43 Discordant Mind (387 hp, 1s stun, 126 mana)
        "Anarchy",                                  -- L32 Anarchy (264-275 hp, 1s stun, 99 mana)
        "Chaos Flux",                               -- L21 Chaos Flux (152-175 hp, 1s stun, 67 mana)
        "Sanity Warp",                              -- L16 Sanity Warp (81-87 hp, 1s stun, 38 mana)
        "Chaotic Feedback",                         -- L07 Chaotic Feedback (28-32 hp, 1s stun, 16 mana)
    },
    enc_chromatic_nuke = {
        "Colored Chaos",                            -- L69 Colored Chaos (CHROMATIC, 1600 hp, cost 425 mana)
    },
    enc_ae_stun = {
        "Color Snap",                               -- L69: timer 3, 6s stun/L70, aerange 30, recast 12s
        "Color Cloud",                              -- L63: timer 3, 8s stun/L65, aerange 30, recast 12s   XXX best for pop stuns then!?
        "Color Slant",                              -- L52: 8s stun/L55?, -100 mana, aerange 35, recast 12s
        "Color Skew",                               -- L43: 8s stun/L55?, aerange 30, recast 12s
        "Color Shift",                              -- L20: 6s stun/L55?, aerange 25, recast 12s
        "Color Flux",                               -- L03: 4s stun/L55?, aerange 20, recast 12s
    },
    enc_root = {
        "Fetter",                                   -- L58: root for 3 min, Kunark
        "Paralyzing Earth",                         -- L49: root for 3 min
        "Immobilize",                               -- L39: root for 1 min
        "Enstill",                                  -- L29: root for 1.6 min
        "Root",                                     -- L08: root for 0.8 min
    },
    enc_epic2 = {
        "Staff of Eternal Eloquence",               -- epic 2.0: slot 5: Aegis of Abstraction,  absorb 1800 dmg
        "Oculus of Persuasion",                     -- epic 1.5: slot 5: Protection of the Eye, absorb 1500 dmg
    },
    enc_oow_bp = {
        "Mindreaver's Vest of Coercion",            -- oow t2 bp: Bedazzling Aura, 42 sec, -1% spell resist rate, 5 min reuse
        "Charmweaver's Robe",                       -- oow t1 bp: Bedazzling Eyes, 30 sec, -1% spell resist rate, 5 min reuse
    }
}

SpellGroups.MAG = {
    mag_ds = {
        "Fireskin",                                 -- L66: 62 ds - slot 1, 45 fr, 15 min
        "Flameshield of Ro",                        -- L61: 48 ds, 45 fr, 15 min
        "Cadeau of Flame",                          -- L56: 35 ds, 33 fr, 15 min
        "Shield of Lava",                           -- L45: 25 ds, 25 fr, 15 min - L1-45
        "Barrier of Combustion",                    -- L38: 18-20 ds, 22 fr, 15 min
        "Inferno Shield",                           -- L28: 13-15 ds, 20 fr, 15 min
        "Shield of Flame",                          -- L19: 7-9 ds, 15 fr, 15 min
        "Shield of Fire",                           -- L07: 4-6 ds, 10 fr, 1.5 min
    },
    mag_group_ds = {
        "Circle of Fireskin",                       -- L70: 62 ds, 45 fr, 15 min, group, OOW
        "Maelstrom of Ro",                          -- L63: 48 ds, 45 fr, 15 min, group, PoP
        "Boon of Immolation",                       -- L53: 25 ds, 25 fr, 15 min, group, Kunark
    },
    mag_big_ds = {
        "Ancient: Veil of Pyrilonus",               -- L70: 500 ds - slot 12, 24 sec
        "Pyrilen Skin",                             -- L68: 420 ds - slot 12, 12 sec
    },
    -- NOTE: does not stack with clr_aegolism or shm_focus
    mag_self_shield = {
        "Elemental Aura",                           -- L66: 390 hp, 46 ac, 40 mr
        "Shield of Maelin",                         -- L64: 350 hp, 38-39 ac, 40 mr
        "Shield of the Arcane",                     -- L61: 298-300 hp, 34-36 ac, 30 mr
        "Shield of the Magi",                       -- L54: 232-250 hp, 29-31 ac, 22-24 mr
        "Arch Shielding",                           -- L43: 140-150 hp, 24-27 ac, 20 mr
        "Greater Shielding",                        -- L32: 91-100 hp, 20-22 ac, 16 mr
        "Major Shielding",                          -- L24: 68-75 hp, 16-18 ac, 14 mr
        "Shielding",                                -- L16: 45-50 hp, 11-13 ac, 11-12 mr
        "Lesser Shielding",                         -- L05: 17-30 hp, 5-9 ac, 6-10 mr
        "Minor Shielding",                          -- L01: 6-10 hp, 3-4 ac
    },
    -- NOTE: does not stack with druid resists
    mag_self_resist = {
        "Elemental Barrier",                        -- L61 Elemental Barrier (60 cr, 60 fr)
        "Elemental Cloak",                          -- L54 Elemental Cloak (45 cr, 45 fr)
        "Elemental Armor",                          -- L41 Elemental Armor (30 cr, 30 fr)
        "Elemental Shield",                         -- L19 Elemental Shield (14-15 cr, 14-15 fr)
    },
    mag_pet_haste = {
        "Elemental Fury",                           -- L69 Elemental Fury (85% haste, 29 ac, 52 atk, 5% skill dmg mod)
        "Burnout V",                                -- L62 Burnout V (80 str, 85% haste, 22 ac, 40 atk)
        "Ancient: Burnout Blaze",                   -- L60 Ancient: Burnout Blaze (80 str, 80% haste, 22 ac, 50 atk)
        "Burnout IV",                               -- L55 Burnout IV (60 str, 21-85% haste, 16 ac)
        "Elemental Empathy",                        -- L52 Elemental Empathy (60 str, 21-80% haste, 18 ac)
        "Burnout III",                              -- L47 Burnout III (50 str, 16-75% haste, 13 ac)
        "Burnout II",                               -- L29 Burnout II (39-45 str, 15-50% haste, 9 ac)
        "Burnout",                                  -- L11 Burnout (15 str, 12-15% haste, 7 ac)
    },
    mag_pet_runspeed = {
        "Velocity",                                 -- L58 Velocity (59-80% movement, 36 min)
        "Expedience",                               -- L27 Expedience (20% movement, 12 min)
    },
    -- water pets (rogue)
    mag_water_pet = {
        "Child of Water",             -- L67 (pet ROG/65) - Malachite
        "Servant of Marr",            -- L62 (pet ROG/60) - no reagent
        "Greater Vocaration: Water",  -- L60
        "Vocarate: Water",            -- L54
        "Greater Conjuration: Water", -- L49
        "Conjuration: Water",         -- L41
        "Lesser Conjuration: Water",  -- L36
        "Minor Conjuration: Water",   -- L31
        "Greater Summoning: Water",   -- L26
        "Summoning: Water",           -- L22
        "Lesser Summoning: Water",    -- L18
        "Minor Summoning: Water",     -- L14
        "Elemental: Water",           -- L10
        "Elementaling: Water",        -- L06
        "Elementalkin: Water",        -- L02
    },
    mag_fire_nuke = {
        "Ancient: Nova Strike",                     -- L70 Ancient: Nova Strike (2377 hp, 6.3s cast, cost 525 mana)
        "Star Strike",                              -- L70 Star Strike (2201 hp, 6.4s cast, cost 494 mana)
        "Spear of Ro",                              -- L70 Spear of Ro (3119 hp, 7s cast, cost 684 mana)
        "Fickle Fire",                              -- L69 Fickle Fire (2475 hp, 6.4s cast, cost 519 mana) + chance to increase dmg
        "Burning Earth",                            -- L69 Burning Earth (1348 hp, 3s cast, cost 337 mana)
        "Bolt of Jerikor",                          -- L66 Bolt of Jerikor (2889 hp, cost 644 mana)
        "Ancient: Chaos Vortex",                    -- L65 Ancient: Chaos Vortex (1920 hp, cost 474 mana)
        "Sun Vortex",                               -- L65 Sun Vortex (1600 hp, cost 395 mana)
        "Burning Sand",                             -- L62 Burning Sand (980 hp, cost 270 mana)
        "Firebolt of Tallon",                       -- L61 Firebolt of Tallon (2100 hp, cost 515 mana)
        "Shock of Fiery Blades",                    -- L60 Shock of Fiery Blades (1294 hp, cost 335 mana)
        "Seeking Flame of Seukor",                  -- L59 Seeking Flame of Seukor
        "Scars of Sigil",                           -- L54 Scars of Sigil
        "Char",                                     -- L52 Char
        "Lava Bolt",                                -- L49 Lava Bolt
        "Cinder Bolt",                              -- L34 Cinder Bolt
        "Blaze",                                    -- L34 Blaze
        "Bolt of Flame",                            -- L20 Bolt of Flame (105 mana, 146-156 dd)
        "Shock of Flame",                           -- L16 Shock of Flame (70 mana, 91-96 dd)
        "Flame Bolt",                               -- L08 Flame Bolt
        "Burn",                                     -- L04 Burn
        "Burst of Flame",                           -- L01 Burst of Flame
    },
    mag_malo = {
        "Malosinia",                                -- L63: -70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana
        "Mala",                                     -- L60: -35 cr, -35 mr, -35 pr, -35 fr, unresistable, cost 350 mana
        "Malosi",                                   -- L51: -58-60 cr, -58-60 mr, -58-60 pr, -58-60 fr, cost 175 mana
        "Malaisement",                              -- L44: -36-40 cr, -36-40 mr, -36-40 pr, -36-40 fr, cost 100 mana
        "Malaise",                                  -- L22: -15-20 cr, -15-20 mr, -15-20 pr, -15-20 fr, cost 60 mana
    },
    mag_pet_heal = {
        "Renewal of Jerikor",                       -- L69 Renewal of Jerikor (1635-1645 hp, -28 dr pr curse, cost 358 mana)
        "Planar Renewal",                           -- L64 Planar Renewal (1190-1200 hp, -24 dr pr curse, cost 290 mana)
        "Transon's Elemental Renewal",              -- L60 Transon's Elemental Renewal (849-873 hp, -20 dr pr curse, cost 237 mana)
        "Primal Remedy",                            -- L44: HoT, 120hp/tick
        "Renew Summoning",                          -- L20 Renew Summoning (140-200 hp)
        "Renew Elements",                           -- L08 Renew Elements (33-50 hp)
    },
    mag_pet_aa_heal = {
        "Mend Companion",                           -- L59 Mend Companion Rank 1 AA (36 min reuse without Hastened Mending AA) Luclin
                                                    -- L63 Mend Companion Rank 2 AA, PoP
        "Replenish Companion",                      -- L67 Replenish Companion Rank 1 AA (36 min reuse), OOW
                                                    -- L68 Replenish Companion Rank 2 AA, OOW
                                                    -- L69 Replenish Companion Rank 3 AA, OOW
    },
    mag_pbae_nuke = {
        "Wind of the Desert",                       -- L60 Wind of the Desert (1050 hp, aerange 25, recast 12s, cost 780 mana)
        "Scintillation",                            -- L51 Scintillation (597-608 hp, aerange 25, recast 6.5s, cost 361 mana)
        "Flame Arc",                                -- L39 Flame Arc (171-181 hp, aerange 20, recast 7s , cost 199 mana)
        "Flame Flux",                               -- L22 Flame Flux (89-96 hp, aerange 20, recast 6s, cost 123 mana)
        "Fire Flux",                                -- L01 Fire Flux (8-12 hp, aerange 20, recast 6s , cost 23 mana)
    },
    -- pet delay is fixed, so list is ordered by damage
    mag_pet_weapon = {
        --"Dagger of Symbols/Summon|Summoned: Dagger of Symbols", -- L39: 5/20 1hp
        "Sword of Runes/Summon|Summoned: Sword of Runes",       -- L29: 7/27 1hs, proc Ward Summoned
        "Spear of Warding/Summon|Summoned: Spear of Warding",   -- L20: 6/27 1hp, 5 fr, 5 cr
        "Summon Fang/Summon|Summoned: Snake Fang",              -- L12: 5/26 1hp
        "Summon Dagger/Summon|Summoned: Dagger",                -- L01: 3/21 1hp
    },
    mag_pet_gear = {
        "Muzzle of Mardu/Summon|Summoned: Muzzle of Mardu",     -- L56: 11% haste
    },
    mag_summoned_clickies = {
        "Modulating Rod/Summon|Summoned: Modulating Rod",       -- L44: 150 mana, -225 hp, 5 min recast (1 charge)
        "Summon Ring of Flight/Summon|Summoned: Ring of Flight",-- L39: levitate (2 charges)
        "Staff of Symbols/Summon|Summoned: Staff of Symbols",   -- L34: 10/34 2hb, click See Invisible (4 charges)
        "Staff of Runes/Summon|Summoned: Staff of Runes",       -- L24: 9/36 2hb, click Cancel Magic (1 charge)
        "Staff of Warding/Summon|Summoned: Staff of Warding",   -- L16: 8/38 2hb, click Gaze (5 charges)
        "Staff of Tracing/Summon|Summoned: Staff of Tracing",   -- L08: 7/40 2hb, click Flare (2 charges)
    },
    mag_epic2 = {
        "Focus of Primal Elements",                 -- epic 2.0: hp 1000, mana 12/tick, hp 24/tick, proc Primal Fusion Strike, defensive proc Primal Fusion Parry, 20 min (34 min with ext duration)
        "Staff of Elemental Essence",               -- epic 1.5: hp  800, mana 10/tick, hp 20/tick, proc Elemental Conjunction Strike, defensive proc Elemental Conjunction Parry
    },
    mag_oow_bp = {
        "Glyphwielder's Tunic of the Summoner",     -- oow t2 bp: pet buff, +50% skill dmg mod, -15% skill dmg taken for 0.5 min
        "Runemaster's Robe",                        -- oow t1 bp: pet buff, +50% skill dmg mod, -15% skill dmg taken for 0.3 min
    },
}

SpellGroups.NEC = {
    nec_levitate = {
        "Dead Man Floating",                        -- L41: 61-70 pr, water breathing, see invis, levitate
    },
    nec_group_levitate = {
        "Dead Men Floating",                        -- L45: 65-70 pr, water breathing, see invis, levitate, group
    },
    -- NOTE: nec_lich dont stack with enc_manaregen
    nec_lich = {
        "Spectralside",                             -- L79 Spectralside (87 mana/tick, cost 76 hp/tick, mottled skeleton)
        "Otherside",                                -- L74 Otherside Rk. II (81 mana/tick, cost 81 hp/tick, mottled skeleton)
        "Grave Pact",                               -- L70 Grave Pact (72 mana/tick, cost 60 hp/tick, skeleton, por expansion)
        "Dark Possession",                          -- L70 Dark Possession (65 mana/tick, cost 57 hp/tick, skeleton, oow expansion)
        "Ancient: Seduction of Chaos",              -- L65 Ancient: Seduction of Chaos (60 mana/tick, cost 50 hp/tick, skeleton)
        "Seduction of Saryrn",                      -- L64 Seduction of Saryrn (50 mana/tick, cost 42 hp/tick, skeleton)
        "Arch Lich",                                -- L60 Arch Lich (35 mana/tick, cost 36 hp/tick, wraith)
        "Demi Lich",                                -- L56 Demi Lich (31 mana/tick, cost 32 hp/tick)
        "Lich",                                     -- L48 Lich (20 mana/tick, cost 22 hp/tick)
        "Call of Bones",                            -- L31 Call of Bones (8 mana/tick, cost 11 hp/tick)
        "Dark Pact",                                -- L06 Dark Pact (2 mana/tick, cost 3 hp/tick)
    },
    -- NOTE: does not stack with ENC rune
    nec_self_rune = {
        "Shadowskin",                               -- L78 Shadowskin Rk. II (slot 1: absorb 1585 dmg, 4 mana/tick)
        "Wraithskin",                               -- L73 Wraithskin Rk. II (slot 1: absorb 1219 dmg, 4 mana/tick)
        "Dull Pain",                                -- L69: absorb 975 dmg, 3 mana/tick
        "Force Shield",                             -- L63: absorb 750 dmg, 2 mana/tick
        "Manaskin/Reagent|Peridot",                 -- L52: absorb 521-600 dmg, 1 mana/tick
        "Steelskin/Reagent|Jasper",                 -- L32: absorb 168-230 dmg
        "Leatherskin/Reagent|Bloodstone",           -- L22: absorb 71-118 dmg
        "Shieldskin/Reagent|Cat's Eye Agate",       -- L14: absorb 27-55 dmg
    },
    nec_pet_haste = {
        "Sigil of the Aberrant",                    -- L77 Sigil of the Aberrant Rk. II (10% skills dmg mod, 122 str, 70% haste, 36 ac)
        "Sigil of the Unnatural",                   -- L72 Sigil of the Unnatural (6% skills dmg mod, 96 str, 70% haste, 28 ac)
        "Glyph of Darkness",                        -- L67 Glyph of Darkness (5% skills dmg mod, 84 str, 70% haste, 23 ac)
        "Rune of Death",                            -- L62 Rune of Death (65 str, 70% haste, 18 ac)
        "Augmentation of Death",                    -- L55 Augmentation of Death (52-55 str, 65% haste, 14-15 ac)
        "Augment Death",                            -- L35 Augment Death (37-45 str, 45-55% haste, 9-12 ac
        "Intensify Death",                          -- L23 Intensify Death (25-33 str, 21-30% haste, 6-8 ac)
    },
    nec_pet_heal = {
        "Chilling Renewal",                         -- L73 Chilling Renewal (2420-2440 hp, -34 dr, -34 pr, -34 curse, -8 corruption, cost 504 mana)
        "Dark Salve",                               -- L69 Dark Salve (1635-1645 hp, -28 dr, -28 pr, -28 curse, cost 358 mana)
        "Touch of Death",                           -- L64 Touch of Death (1190-1200 hp, -24 dr, -24 pr, -24 curse, cost 290 mana)
        "Renew Bones",                              -- L26 Renew Bones (121-175 hp)
        "Mend Bones",                               -- L07 Mend Bones (22-32 hp)
    },
    -- NOTE: does not stack with clr_aegolism or shm_focus
    nec_self_shield = {
        "Shadow Guard",                             -- L66: 390 hp, 46 ac, 40 mr
        "Shield of Maelin",                         -- L64: 350 hp, 38-39 ac, 40 mr
        "Shield of the Arcane",                     -- L61: 298-300 hp, 34-36 ac, 30 mr
        "Shield of the Magi",                       -- L54: 232-250 hp, 29-31 ac, 22-24 mr
        "Arch Shielding",                           -- L41: 140-150 hp, 24-27 ac, 20 mr
        "Greater Shielding",                        -- L32: 91-100 hp, 20-22 ac, 16 mr
        "Major Shielding",                          -- L24: 68-75 hp, 16-18 ac, 14 mr
        "Shielding",                                -- L16: 45-50 hp, 11-13 ac, 11-12 mr
        "Lesser Shielding",                         -- L05: 17-30 hp, 5-9 ac, 6-10 mr
        "Minor Shielding",                          -- L01: 6-10 hp, 3-4 ac
    },
    nec_snare_dot = {
        "Desecrating Darkness",                     -- L68 Desecrating Darkness (resist adj -20, 96 hp/tick, 75% snare, 2.0 min, cost 248 mana)
        "Embracing Darkness",                       -- L63 Embracing Darkness (resist adj -20, 68-70 hp/tick, 75% snare, 2.0 min, cost 200 mana)
        "Devouring Darkness",                       -- L59 Devouring Darkness (123 hp/tick, 69-75% snare, 1.3 min, cost 400 mana)
        "Cascading Darkness",                       -- L47 Cascading Darkness (72 hp/tick, 60% snare, 1.6 min, cost 300 mana)
        "Dooming Darkness",                         -- L27 Dooming Darkness (20 hp/tick, 48-59% snare, 1.5 min, cost 120 mana)
        "Engulfing Darkness",                       -- L11 Engulfing Darkness (11 hp/tick, 40% snare, 1.0 min, cost 60 mana)
        "Clinging Darkness",                        -- L04 Clinging Darkness (8 hp/tick, 24-30% snare, 0.8 min, cost 20 mana)
    },
    nec_poison_dot = {
        "Chaos Venom",                              -- L70 Chaos Venom (473 hp/tick, POISON, resist adj -50, cost 566 mana)
        "Corath Venom",                             -- L69 Corath Venom (611 hp/tick, POISON,  resist adj -50, cost 655 mana)
        "Blood of Thule",                           -- L65 Blood of Thule (350-360 hp/tick, resist adj -50, poison)
        "Chilling Embrace",                         -- L36 Chilling Embrace (100-114 hp/tick, poison)
        "Venom of the Snake",                       -- L34 Venom of the Snake (x)
        "Poison Bolt",                              -- L04 Poison Bolt (10 hp/tick, poison)
    },
    nec_disease_dot = {
        "Grip of Mori",                             -- L67 Grip of Mori (194-197 hp/tick, -63-65 str, -35-36 ac, cost 325 mana)
        "Chaos Plague",                             -- L66 Chaos Plague (247-250 hp/tick, resist adj -50, disease)
        "Dark Plague",                              -- L61 Dark Plague (182-190 hp/tick, resist adj -50, disease, cost 340 mana)
        "Asystole",                                 -- L40 Asystole (x)
        "Scrounge",                                 -- L35 Scrounge (x)
        "Heart Flutter",                            -- L13 Heart Flutter (18-22 hp/tick, -13-20 str, -7-9 ac)
        "Disease Cloud",                            -- L01 Disease Cloud (x)
    },
    nec_magic_dot = {
        "Ancient: Curse of Mori",                   -- L70 Ancient: Curse of Mori (639 hp/tick, resist adj -30, magic, cost 625 mana)
        "Dark Nightmare",                           -- L67 Dark Nightmare (591 hp/tick, resist adj -30, magic, cost 585 mana)
        "Horror",                                   -- L63 Horror (432-450 hp/tick, resist adj -30, magic, cost 450 mana)
        "Splurt",                                   -- L51 Splurt (x)
        "Dark Soul",                                -- L39 Dark Soul (x)
    },
    nec_fire_dot = {
        "Dread Pyre",                               -- L70 Dread Pyre (956 hp/tick, resist adj -100, cost 1093 mana)
        "Pyre of Mori",                             -- L69 Pyre of Mori (419 hp/tick, resist adj -100, cost 560 mana)
        "Night Fire",                               -- L65 Night Fire (335 hp/tick, resist adj -100)
        "Pyrocruor",                                -- L58 Pyrocruor (156-166 hp/tick)
        "Ignite Blood",                             -- L47 Ignite Blood (X)
        "Boil Blood",                               -- L28 Boil Blood (67 hp/tick)
        "Heat Blood",                               -- L10 Heat Blood (28-43 hp/tick)
    },
    -- duration tap (heal + DoT)
    nec_heal_dot = {
        "Fang of Death",                            -- L68 Fang of Death (370 hp/tick, MAGIC, resist adj -200, cost 750 mana)
        "Night's Beckon",                           -- L65 Night's Beckon (220 hp/tick, MAGIC resist adj -200, cost 605 mana)
        "Night Stalker",                            -- L65 Night Stalker (122 hp/tick, DISEASE, resist adj -200, cost 950 mana)
        "Saryrn's Kiss",                            -- L62 Saryrn's Kiss (191-200 hp/tick, MAGIC, resist adj -200, magic, cost 550 mana)
        "Auspice",                                  -- L45 Auspice (30 hp/tick, DISEASE, resist adj -200)
        "Vampiric Curse",                           -- L29 Vampiric Curse (21 hp/tick, MAGIC, resist adj -200)
        "Leech",                                    -- L09 Leech (8 hp/tick, MAGIC, resist adj -200)
    },
    nec_poison_nuke = {
        "Call for Blood",                           -- L68 Call for Blood (1770 dmg, cost 568 mana) DoDH - adjusts dot dmg randomly, better than Ancient: Touch of Orshilak
        "Ancient: Touch of Orshilak",               -- L70 Ancient: Touch of Orshilak (-200 resist check, 1300 dmg, cost 598) OOW
        "Acikin",                                   -- L66 Acikin (1823 hp, cost 556 mana) OOW
        "Neurotoxin",                               -- L61 Neurotoxin (1325 hp, cost 445 mana) PoP
        "Ancient: Lifebane",                        -- L60 Ancient: Lifebane (1050 dmg)
        "Torbas' Venom Blast",                      -- L54 Torbas' Venom Blast (688 dmg, cost 251 mana)
        "Torbas' Acid Blast",                       -- L32 Torbas' Acid Blast (314-332 dmg)
        "Shock of Poison",                          -- L21 Shock of Poison (171-210 dmg)
    },
    nec_pbae_nuke = {
        "Word of Souls",                            -- L36 Word of Souls (MAGIC, 138-155 hp, aerange 20, recast 9s, cost 171 mana)
        "Word of Spirit",                           -- L27 Word of Spirit (MAGIC, 91-104 hp, aerange 20, recast 9s, cost 133 mana)
        "Word of Shadow",                           -- L20 Word of Shadow (MAGIC, 52-58 hp, aerange 20, recast 9s, cost 85 mana)
    },
    nec_scent_debuff = {
        "Scent of Midnight",                        -- L68 Scent of Midnight (-55 dr, -55 pr, disease, resist adj -200)
        "Scent of Terris",                          -- L52 Scent of Terris (-33-36 fr, -33-36 pr, -33-36 dr, poison)
        "Scent of Darkness",                        -- L37 Scent of Darkness (-23-27 fr, -23-27 pr, -23-27 dr)
        "Scent of Dusk",                            -- L10 Scent of Dusk (-6-9 fr, -6-9 pr, -6-9 dr)
    },
    nec_lifetap = {
        "Ancient: Touch of Orshilak",               -- L70 Ancient: Touch of Orshilak (1300 hp, cost 598 mana)
        "Soulspike",                                -- L67 Soulspike (1204 hp, cost 563 mana)
        "Touch of Night",                           -- L59 Touch of Night (708 hp, cost 382 mana)
        "Deflux",                                   -- L54 Deflux (535 hp, cost 299 mana)
        "Drain Spirit",                             -- L39 Drain Spirit (314 hp, cost 213 mana)
        "Spirit Tap",                               -- L26 Spirit Tap (202-210 hp, cost 152 mana)
        "Siphon Life",                              -- L20 Siphon Life (140-150 hp, cost 115 mana)
        "Lifedraw",                                 -- L12 Lifedraw (102-105 hp, cost 86 mana)
        "Lifespike",                                -- L03 Lifespike (8-12 hp, cost 13 mana)
        "Lifetap",                                  -- L01 Lifetap (4-6 hp, cost 8 mana)
    },
    nec_manadump = {
        "Sedulous Subversion",                      -- L56 Sedulous Subversion (150 mana, cost 400 mana, 8s recast)
        "Covetous Subversion",                      -- L43 Covetous Subversion (100 mana, cost 300 mana, 8s recast)
        "Rapacious Subvention",                     -- L21 Rapacious Subvention (60 mana, cost 200 mana)
    },
    nec_epic2 = {
        "Deathwhisper",                             -- epic 2.0: Guardian of Blood, swarm pet
        "Soulwhisper",                              -- epic 1.5: Servant of Blood, swarm pet
    },
    new_oow_bp = {
        "Blightbringer's Tunic of the Grave",       -- oow tier 2 bp: increase dot crit by 40% for 0.6 min, 5 min recast
        "Deathcaller's Robe",                       -- oow tier 1 bp: increase dot crit by 40% for 0.3 min, 5 min recast
    },
}

SpellGroups.WIZ = {
    -- NOTE: does not stack with clr_aegolism or shm_focus
    wiz_self_shield = {
        "Ether Shield",                             -- L66 Ether Shield (390 hp, 46 ac, 40 mr)
        "Shield of Maelin",                         -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
        "Shield of the Arcane",                     -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
        "Shield of the Magi",                       -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
        "Arch Shielding",                           -- L44 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
        "Greater Shielding",                        -- L33 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
        "Major Shielding",                          -- L23 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
        "Shielding",                                -- L15 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
        "Lesser Shielding",                         -- L06 Lesser Shielding (17-30 hp, 5-9 ac, 6-10 mr)
        "Minor Shielding",                          -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    },
    wiz_self_rune = {
        "Shield of Dreams",                         -- L70: slot 1: absorb 451 dmg, slot 8: +10 resists, slot 9: 3 mana/tick
        "Ether Skin",                               -- L68: slot 1: absorb 975 dmg, 3 mana/tick
        "Force Shield",                             -- L63: slot 1: absorb 750 dmg, 2 mana/tick
    },
    wiz_fire_nuke = {
        "Ancient: Core Fire",                       -- L70 Ancient: Core Fire (4070 hp, resist adj -10, cost 850 mana, 8s cast)
        "Corona Flare",                             -- L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana, 8s cast)
        "Ether Flame",                              -- L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana, 8s cast)
        "Chaos Flame",                              -- L70 Chaos Flame (random 1000 to 2000, resist adj -50, cost 275 mana, 3.0s cast)
        "Firebane",                                 -- L68 Firebane (1500 hp, resist adj -300, cost 456 mana, 4.5s cast)
        "Spark of Fire",                            -- L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana, 3s cast)
        "Ancient: Strike of Chaos",                 -- L65 Ancient: Strike of Chaos (3288 hp, resist adj -10, cost 768 mana)
        "White Fire",                               -- L65 White Fire (3015 hp, resist adj -10, cost 704 mana)
        "Strike of Solusek",                        -- L65 Strike of Solusek (2740 hp, resist adj -10, cost 640 mana)
        "Lure of Ro",                               -- L62 Lure of Ro (1090 hp, resist adj -300, cost 387 mana)
        "Draught of Ro",                            -- L62 Draught of Ro (980 hp, resist adj -50, cost 255 mana)
        "Sunstrike",                                -- L60 Sunstrike (1615 hp, resist adj -10, cost 450 mana)
        "Draught of Fire",                          -- L51 Draught of Fire (643-688 hp, cost 215 mana)
        "Supernova",                                -- L49 Supernova (854 hp, cost 875 mana)
        "Conflagration",                            -- L44 Conflagration (606-625 hp, cost 250 mana)
        "Inferno Shock",                            -- L29 Inferno Shock (237-250 hp, cost 135 mana)
        "Flame Shock",                              -- L16 Flame Shock (102-110 hp, cost 75 mana)
        "Fire Bolt",                                -- L08 Fire Bolt (45-51 hp, cost 40 mana)
        "Shock of Fire",                            -- L04 Shock of Fire (13-16 hp, cost 15 mana)
    },

    -- L01 Frost Bolt (9-14 hp, cost 6 mana)
    -- L01 Blast of Cold (11-18 hp, cost 8 mana), called "Shock of Frost" on fvp
    -- L08 Shock of Ice (46-58 hp, cost 23 mana)
    -- L49 Ice Comet (808 hp, resist adj -10, cost 203 mana)
    -- L57 Draught of Ice (793 hp, resist adj -10, cost 216 mana)
    -- L60 Ice Spear of Solist (1076 hp, resist adj -10, cost 221 mana)
    -- L61 Claw of Frost (1000 hp, resist adj -50, cost 167 mana)
    -- L64 Ice Meteor (2460 hp, resist adj -10, cost 520 mana)
    -- L64 Draught of E'ci (980 hp, resist adj -50, cost 255 mana)
    -- L65 Black Ice (1078 hp, resist adj -10, cost 280 mana)
    -- L66 Icebane (1500 hp, resist adj -300, cost 456 mana)
    -- L68 Clinging Frost (1830 hp, resist adj -10, cost 350 mana + Clinging Frost Trigger DD)
    -- L69 Gelidin Comet (3385 hp, resist adj -10, cost 650 mana)
    -- L69 Spark of Ice (1348 hp, resist adj -50, cost 319 mana, 3s cast)
    -- L69 Claw of Vox (1375 hp, resist adj -50, cost 208 mana, 5s cast)
    -- L70 Ancient: Spear of Gelaqua (1976 hp, resist adj -10, cost 345 mana, 3.5s cast)
    wiz_cold_nuke = {
        -- XXX
    },

    -- L10 Shock of Lightning (74-83 hp, cost 50 mana)
    -- L60 Elnerick's Electrical Rending (1796 hp, cost 421 mana)
    -- L61 Lure of Thunder (1090 hp, resist adj -300, cost 365 mana)
    -- L63 Draught of Thunder (980 hp, stun 1s/65, resist adj -50, cost 255 mana)
    -- L63 Draught of Lightning (980 hp, resist adj -50, cost 255 mana)
    -- L63 Agnarr's Thunder (2350 hp, cost 525 mana)
    -- L65 Shock of Magic (random dmg up to 2400 hp, resist adj -20, cost 550 mana)
    -- L67 Lightningbane (1500 hp, resist adj -300, cost 456 mana)
    -- L68 Spark of Lightning (1348 hp, resist adj -50, cost 319 mana)
    -- L68 Spark of Thunder (1348 hp, resist adj -50, cost 319 mana + 1s stun L70)
    -- L68 Thundaka (3233 hp, cost 656 mana)
    wiz_magic_nuke = {
        -- XXX
    },

    -- L12 Firestorm (41 hp, FIRE, adj -10, aerange 25, recast 12s, cost 34 mana)
    -- L24 Column of Lightning (128-136 hp, FIRE, aerange 15, recast 6s, cost 130 mana)
    -- L26 Energy Storm (238 hp, MAGIC, adj -10, aerange 25, recast 12s, cost 148 mana)
    -- L28 Shock Spiral of Al'Kabor (111-118 hp, MAGIC, aerange 35, recast 9s, cost 200 mana)
    -- L31 Circle of Force (193-216 hp, FIRE, adj -10, aerange 15, recast 6s, cost 175 mana)
    -- L32 Lava Storm (401 hp, FIRE, adj -10, aerange 25, recast 12s, cost 234 mana)
    -- L61 Tears of Ro (1106 hp, FIRE, adj -10, aerange 25, recast 10s, cost 492 mana)
    -- L64 Tears of Arlyxir (645 hp, FIRE, adj -300, aerange 25, recast 12s, cost 420 mana)
    -- L66 Tears of the Sun (1168 hp, FIRE, adj -10, aerange 25, recast 10s, cost 529 mana)
    -- L69 Meteor Storm (886 hp, FIRE, adj -300, aerange 25, recast 12s, cost 523 mana)
    wiz_target_ae = {
        -- XXX
    },

    -- L01 Numbing Cold (14 hp, ICE, aerange 25, recast 12s, cost 6 mana)
    -- L05 Fingers of Fire (19-28 hp, FIRE, aerange 25, recast 6s, cost 47 mana)
    -- L14 Project Lightning (55-62 hp, MAGIC, aerange 25, recast 6s, cost 85 mana)
    -- L30 Thunderclap (210-232 hp, MAGIC, aerange 20, recast 12s, cost 175 mana)
    -- L45 Supernova (854 hp, FIRE, aerange 35, recast 12s, cost 875 mana)
    -- L53 Jyll's Static Pulse (495-510 hp, MAGIC, aerange 25, recast 6s, cost 285 mana)
    -- L56 Jyll's Zephyr of Ice (594 hp, ICE, adj -10, aerange 25, recast 6s, cost 313 mana)
    -- L59 Jyll's Wave of Heat (638-648 hp, FIRE, adj -10, aerange 25, recast 6s, cost 342 mana)
    -- L60 Winds of Gelid (1260 hp, ICE, adj -10, aerange 35, recast 12s, cost 875 mana)
    -- L67 Circle of Fire (845 hp, FIRE, adj -10, aerange 35, recast 6s, cost 430 mana)
    -- L70 Circle of Thunder (1450 hp, MAGIC; adj -10, aerange 35, recast 12s, cost 990 mana)
    wiz_pbae_nuke = {
        -- xxx
    },
    wiz_epic2 = {
        "Staff of Phenomenal Power",                -- epic 2.0: -50% spell resist rate for group, -6% spell hate
        "Staff of Prismatic Power",                 -- epic 1.5: -30% spell resist rate for group, -4% spell hate
    },
    wiz_oow_bp = {
        "Academic's Robe of the Arcanists",         -- oow t2 bp: Academic's Intellect, -25% cast time for 0.7 min, 5 min reuse
        "Spelldeviser's Cloth Robe",                -- oow t1 bp: Academic's Foresight, -25% cast time for 0.5 min, 5 min reuse
    },
}

SpellGroups.RNG = {
    rng_heal = {
        "Sylvan Water",                             -- L67: 1135-1165 hp, 3s cast time, cost 456 mana)
        "Sylvan Light",                             -- L65: 850 hp, 3s cast time, cost 370 mana)
        "Chloroblast",                              -- L62: 994-1044 hp, cost 331 mana)
        "Greater Healing",                          -- L44: 280-350 hp, cost 115 mana)
        "Healing",                                  -- L32:
        "Light Healing",                            -- L20:
        "Minor Healing",                            -- L08:
        "Salve",                                    -- L01:
    },
    rng_hp = {
        --"Strength of the Hunter",                 -- L67: 75 atk, 155 hp, group, cost 325 mana, OOW, Strength of Tunare has more ATK !!!
        "Strength of Tunare",                       -- L62: slot 1: 92 atk, slot 4: 125 hp, group, cost 250 mana, PoP
        "Strength of Nature",                       -- L51: 25 atk, 75 hp, single, cost 125 mana, Velious
    },
    rng_atk = {
        "Howl of the Predator",                     -- L69: slot 2: 90 atk, slot 9: double atk 3-20%, group, OOW
        "Spirit of the Predator",                   -- L64: slot 2: 70 atk, group, PoP
        "Call of the Predator",                     -- L60: slot 2: 40 atk, group, Velious
        "Mark of the Predator",                     -- L56: slot 2: 20 atk, group, Luclin
    },
    rng_ds = {
        "Guard of the Earth",                       -- L67: slot 2: 13 ds, slot 3: 49 ac
        "Call of the Rathe",                        -- L62: slot 2: 10 ds, slot 3: 34 ac
        "Call of Earth",                            -- L50: slot 2: 4 ds, slot 3: 24-25 ac
        "Riftwind's Protection",                    -- L29: slot 2: 2 ds, slot 3: 11-12 ac
    },
    rng_skin = {
        "Onyx Skin",                                -- L70: 33 ac, 540 hp, 6 hp/tick
        "Natureskin",                               -- L65: 18-19 ac, 391-520 hp, 4 hp/tick
        "Skin like Nature",                         -- L59: Velious
        "Skin like Diamond",                        -- L54: Original
        "Skin like Steel",                          -- L38: Original
        "Skin like Rock",                           -- L21: Original
        "Skin like Wood",                           -- L07: Original
    },
    rng_self_ds = {
        "Briarcoat",                                -- L68: slot 2: 49 ac, slot 3: 8 ds
        "Bladecoat",                                -- L63: slot 2: 37 ac, slot 3: 6 ds
        "Thorncoat",                                -- L60:
        "Spikecoat",                                -- L42:
        "Bramblecoat",                              -- L34:
        "Barbcoat",                                 -- L30:
        "Thistlecoat",                              -- L13:
    },
    rng_self_ds_atk = {
        "Ward of the Hunter",                       -- L70: slot 1: 45 ds, slot 2: 170 atk, slot 3: 49 ac, slot 4: 165 hp, slot 9: 3% double attack
        "Protection of the Wild",                   -- L65: slot 1: 34 ds, slot 2: 130 atk, slot 3: 34 ac, slot 4: 125 hp
    },
    rng_self_mana = {
        "Mask of the Stalker",                      -- L65: slot 3: 3 mana regen
    },
    rng_snare = {
        "Ensnare",                                  -- L51
        "Snare",                                    -- L09
    },
    -- Timer 1
    rng_fire_nuke = {
        "Hearth Embers",                            -- L69: 842 hp, 0.5s cast, cost 275 mana, 30s recast, OOW
        "Sylvan Burn",                              -- L65, 673 hp, 0.5s cast, cost 242 mana, GoD
        "Brushfire",                                -- L64, PoP
        "Calefaction",                              -- L59 .. xxx spelling
        "Firestrike",                               -- L52, Kunark
        "Call of Flame",                            -- L49, Original
        "Burning Arrow",                            -- L39, PoP
        "Flaming Arrow",                            -- L29, PoP
        "Ignite",                                   -- L22, Original
        "Burst of Fire",                            -- L15, Original
    },
    -- Timer 4
    rng_fire_nuke4 = {
        "Scorched Earth",                           -- L70: 1150 hp, 0.5s cast, cost 365 mana, 30s recast, PoR
        "Ancient: Burning Chaos",                   -- L65: 734 hp, 0.5s cast, cost 264 mana, GoD
    },
    -- Timer 3
    rng_cold_nuke = {
        "Frozen Wind",                              -- L63: 695 hp, 0.5s cast, cost 295 mana, PoP
        "Ancient: North Wind",                      -- L70: 1032 hp, 0.5s cast, 30s recast, cost 392 mana, OOW
    },
    -- Timer 2
    rng_cold_nuke2 = {
        "Frost Wind",                               -- L68: 956 hp, 0.5s cast, cost 369 mana, 30s recast, OOW
    },
    rng_epic2 = {
        "Aurora, the Heartwood Blade",              -- epic 2.0: critical melee chance 170%, accuracy 170%, 1 min duration, 5 min recast
        "Heartwood Blade",                          -- epic 1.5: critical melee chance 110%, accuracy 110%
    },
    rng_oow_bp = {
        "Bladewhisper Chain Vest of Journeys",      -- oow T2 bp: slot 3: Add Proc: Major Lightning Call Effect for 0.5 min
        "Sunrider's Vest",                          -- oow T1 bp: slot 3: Add Proc: Minor Lightning Call Effect for 0.3 min
    },
}

SpellGroups.PAL = {
    pal_heal = {
        "Light of Piety",                           -- L68 Light of Piety (1234 hp, cast time 1.0s, 5s recast, cost 487 mana)
        "Light of Order",                           -- L65 Light of Order (1072 hp, cast time 1.0s, 5s recast, cost 428 mana)
        "Touch of Nife",                            -- L61 Touch of Nife (1210-1250 hp, cast time 3.8s, 1.5s recast, cost 4556 mana)
        "Superior Healing",                         -- L57 Superior Healing (500-600 hp, cast time 3.5s, 1.5s recast, cost 185 mana)
        "Light of Life",                            -- L52 Light of Life (410 hp, cast time 1.5s, 7s recast, cost 215 mana)
        "Greater Healing",                          -- L36 Greater Healing (280-350 hp, cost 115 mana)
        "Healing",                                  -- L27 Healing (135-175 hp)
        "Light Healing",                            -- L12 Light Healing (47-65 hp)
        "Minor Healing",                            -- L06 Minor Healing (12-20 hp)
        "Salve",                                    -- L01 Salve (5-9 hp)
    },
    pal_group_heal = {
        "Wave of Piety",                            -- L70: 1316 hp, cost 1048 mana
        "Wave of Trushar",                          -- L65: 1143 hp, cost 921 mana
        "Wave of Marr",                             -- L65: 960 hp, cost 850 mana
        "Healing Wave of Prexus",                   -- L58: 688-698 hp, cost 698 mana
        "Wave of Healing",                          -- L55: 439-489 hp, cost 503 mana
        "Wave of Life",                             -- L39: 201-219 hp, cost 274 mana
    },
    pal_hot = {
        "Pious Cleansing",                          -- L69 Pious Cleansing (585 hp/tick, 30s recast, cost 668 mana)
        "Supernal Cleansing",                       -- L64 Supernal Cleansing (300 hp/tick, 30s recast, cost 360 mana)
        "Celestial Cleansing",                      -- L59 Celestial Cleansing (175 hp/tick, 30s recast, cost 225 mana)
        "Ethereal Cleansing",                       -- L44 Ethereal Cleansing (98-100 hp/tick, 30s recast, cost 150 mana)
    },
    pal_rez = {
        "Resurrection",                             -- L59: 90% exp, 6s cast, 20s recast, 700 mana
        "Restoration",                              -- L55: 75% exp, 6s cast, 20s recast
        "Renewal",                                  -- L49: 50% exp, 6s cast, 20s recast
        "Revive",                                   -- L39: 35% exp, 6s cast, 20s recast
        "Reparation",                               -- L31: 20% exp, 6s cast, 20s recast
        "Reconstitution",                           -- L30: 10% exp, 6s cast, 20s recast
        "Reanimation",                              -- L22:  0% exp, 6s cast, 20s recast
    },
    pal_hp = {
        "Brell's Brawny Bulwark",                   -- L70 Brell's Brawny Bulwark (412 hp, group) OOW
        "Brell's Stalwart Shield",                  -- L65 Brell's Stalwart Shield (330 hp, group) PoP
        "Brell's Mountainous Barrier",              -- L60 Brell's Mountainous Barrier (225 hp, group) Luclin
        "Brell's Steadfast Aegis",                  -- L49 Brell's Steadfast Aegis (145 hp, group) PoP
        "Divine Vigor",                             -- L35 Divine Vigor (100 hp) Luclin
    },
    pal_symbol = {
        "Symbol of Jeron",                          -- L67 Symbol of Jeron
        "Symbol of Marzin",                         -- L63 Symbol of Marzin
        "Symbol of Pinzarn",                        -- L46 Symbol of Pinzarn
        "Symbol of Ryltan",                         -- L33 Symbol of Ryltan
        "Symbol of Transal",                        -- L24 Symbol of Transal
    },
    pal_group_symbol = {
        "Jeron's Mark",                             -- L68 Jeron's Mark (group)
    },
    pal_self_shield = {
        "Armor of the Champion",                    -- L69 Armor of the Champion (slot 2: 39 ac, slot 3: 437 hp, slot 4: 4 mana/tick)
        "Aura of the Crusader",                     -- L64 Aura of the Crusader (slot 2: 30 ac, slot 3: 342-350 hp, slot 4: 3 mana/tick)
    },
    pal_proc_buff = {
        "Pious Fury",                               -- L68 Pious Fury (slot 1: proc Pious Fury Strike)
        "Silvered Fury",                            -- L67 Silvered Fury (proc Silvered Fury Strike)
        "Holy Order",                               -- L65 Holy Order (proc Holy Order Strike)
        "Pious Might",                              -- L63 Pious Might (proc Pious Might Strike)
        "Ward of Nife",                             -- L62 Ward of Nife (UNDEAD: proc Ward of Nife Strike)
        "Divine Might",                             -- L45 Divine Might (proc Divine Might Effect)
        "Instrument of Nife",                       -- L26 Instrument of Nife (UNDEAD: proc Condemnation of Nife)
    },
    pal_yaulp = {
        "Yaulp IV",                                 -- L60 Yaulp IV
        "Yaulp III",                                -- L56 Yaulp III
        "Yaulp II",                                 -- L39 Yaulp II
        "Yaulp"                                     -- L09 Yaulp
    },
    pal_oow_bp = {
        "Dawnseeker's Chestpiece of the Defender",  -- oow t2 bp: proc Minor Pious Shield Effect, 0.4 min
        "Oathbound Breastplate",                    -- oow t1 bp: proc Minor Pious Shield Effect, 0.2 min
    },
}

SpellGroups.SHD = {
    shd_combat_innate = {
        "Decrepit Skin",                            -- L70: slot 1: proc Decrepit Skin Parry, 4 min duration, absorb dmg
        "Shroud of Discord",                        -- L67: proc: Shroud of Discord Strike, 60 min duration, lifetap proc
        "Scream of Death",                          -- L37: proc: Scream of Death Strike
        "Vampiric Embrace",                         -- L22: proc: Vampiric Embrace
    },
    -- NOTE: does not stack with enc_manaregen
    shd_lich = {
        "Pact of Decay",                            -- L69 Pact of Decay (illusion: skeleton?, 17 mana/tick, -25 hp/tick)
        "Pact of Hate",                             -- L64 Pact of Hate (illusion: skeleton?, 15 mana/tick, -22 hp/tick)
        "Deathly Temptation",                       -- L58 Deathly Temptation (illusion: skeleton?, 6 mana/tick, -11 hp/tick)
    },
    shd_self_shield = {
        "Cloak of Discord",                         -- L70 Cloak of Discord (slot 3: 49 ac, slot 6: 13 ds, slot 10: 350 hp)
        "Cloak of Luclin",                          -- L65 Cloak of Luclin (slot 3: 34 ac, slot 6: 10 ds, slot 10: 280 hp)
        "Cloak of the Akheva",                      -- L60 Cloak of the Akheva (slot 3: 13 ac, slot 6: 5 ds, slot 10: 150 hp)
    },
    shd_epic2 = {
        "Innoruuk's Dark Blessing",                 -- epic 2.0: 40% accuracy for group, 50% melee lifetap. 5 min reuse
        "Innoruuk's Voice",                         -- epic 1.5: 30% accuracy for group, 35% melee lifetap. 10 min reuse
    },
    shd_oow_bp = {
        "Duskbringer's Plate Chestguard of the Hateful",-- oow t2 bp: Lifetap from Weapon Damage (15) for 4 ticks, 5 min reuse
        "Heartstiller's Mail Chestguard",               -- oow t1 bp: Lifetap from Weapon Damage (15) for 2 ticks, 5 min reuse
    },
}

SpellGroups.BST = {
    bst_manaregen = {
        "Spiritual Ascendance",                     -- L69 Spiritual Ascendance (10 hp + 10 mana/tick, group, cost 900 mana)
        "Spiritual Dominion",                       -- L64 Spiritual Dominion (9 hp + 9 mana/tick, group)
        "Spiritual Purity",                         -- L59 Spiritual Purity (7 hp + 7 mana/tick, group)
        "Spiritual Radiance",                       -- L52 Spiritual Radiance (5 hp + 5 mana/tick, group)
        "Spiritual Light",                          -- L41 Spiritual Light (3 hp + 3 mana/tick, group)
    },
    -- hp type 2 - Slot 4: Increase max HP
    -- NOTE: RNG buff has more atk
    bst_hp = {
        "Spiritual Vitality",                       -- L67 Spiritual Vitality (52 atk, 280 hp, group)
        "Spiritual Vigor",                          -- L62 Spiritual Vigor (40 atk, 225 hp, group)
        "Spiritual Strength",                       -- L60 Spiritual Strength (25 atk, 150 hp)
        "Spiritual Brawn",                          -- L42 Spiritual Brawn (10 atk, 75 hp)
    },
    bst_haste = {
        "Celerity",                                 -- L63 Celerity (47-50% haste, 16 min)
        "Alacrity",                                 -- L60 Alacrity (32-40% haste, 11 min)
    },
    -- NOTE: shm_focus is stronger
    bst_focus = {
        "Focus of Alladnu",                         -- L67 Focus of Alladnu (513 hp)
        "Talisman of Kragg",                        -- L62 Talisman of Kragg (365-500 hp)
        "Talisman of Altuna",                       -- L58 Talisman of Altuna (230-250 hp)
        "Talisman of Tnarg",                        -- L53 Talisman of Tnarg (132-150 hp)
    },
    bst_sta = {
        "Stamina",                                  -- L57 Stamina (36-40 sta)
        "Health",                                   -- L52 Health (27-31 sta)
        "Spirit of Ox",                             -- L37 Spirit of Ox (19-23 sta)
        "Spirit of Bear",                           -- L17 Spirit of Bear (11-15 sta)
    },
    bst_str = {
        "Furious Strength",                         -- L54 Furious Strength (31-34 str)
        "Raging Strength",                          -- L41 Raging Strength (23-26 str)
        "Spirit Strength",                          -- L28 Spirit Strength (16-18 str)
        "Strengthen",                               -- L14 Strengthen (5-10 str)
    },
    -- do not stack with shm_focus
    bst_dex = {
        "Dexterity",                                -- L57 Dexterity (49-50 dex)
        "Deftness",                                 -- L53 Deftness (40 dex)
        "Spirit of Monkey",                         -- L38 Spirit of Monkey (19-20 dex)
    },
    bst_ferocity = {
        "Ferocity of Irionu",                       -- L70 Ferocity of Irionu (52 sta, 187 atk, 65 all resists, 6.5 min, 2 min recast)
        "Ferocity",                                 -- L65 Ferocity (40 sta, 150 atk, 65 all resists, 6.5 min)
        "Growl of the Leopard",                     -- L61 Growl of the Leopard (15% skill damage mod, 80 hp/tick, max hp 850, 1 min, cost 500 mana)
        "Frenzy",                                   -- L47 Frenzy (6-10 ac, 18-25 agi, 19-28 str, 25 dex, 10 min)
    },
    bst_pet_haste = {
       "Growl of the Beast",                        -- L68 Growl of the Beast (85% haste, 90 atk, 78 ac, 5% skill dmg mod, duration 1h)
       "Arag's Celerity",                           -- L64 Arag's Celerity (115 str, 85% haste, 75 atk, 71 ac)
       "Sha's Ferocity",                            -- L59 Sha's Ferocity (99-100 str, 84-85% haste, 60 atk, 60 ac)
       "Omakin's Alacrity",                         -- L55 Omakin's Alacrity (60 str, 65-70% haste, 40 atk, 30 ac)
       "Bond of the Wild",                          -- L52 Bond of the Wild (51-55 str, 60% haste, 25 atk, 13-15 ac)
       "Yekan's Quickening",                        -- L37 Yekan's Quickening (43-45 str, 60% haste, 20 atk, 11-12 ac)
    },
    bst_pet_proc = {
        "Spirit of Oroshar",                        -- L70 Spirit of Oroshar (FIRE: Spirit of Oroshar Strike, rate mod 150, 75 dex)
        "Spirit of Irionu",                         -- L68 Spirit of Irionu (COLD: Spirit of Irionu Strike, rate mod 150, 75 dex)
        "Spirit of Rellic",                         -- L63 Spirit of Rellic (COLD: Spirit of Rellic Strike, rate mod 150)
        "Spirit of Flame",                          -- L56 Spirit of Flame (FIRE: Spirit of Flame Strike, rate mod 150)
        "Spirit of Snow",                           -- L54 Spirit of Snow (Spirit of Snow Strike, rate mod 150)
        "Spirit of the Storm",                      -- L53 Spirit of the Storm (Spirit of Storm Strike, rate mod 150)
        "Spirit of Wind",                           -- L51 Spirit of Wind (Spirit of Wind Strike proc, rate mod 150)
        "Spirit of Vermin",                         -- L46 Spirit of Vermin (Spirit of Vermin Strike proc)
        "Spirit of the Scorpion",                   -- L38 Spirit of the Scorpion (Spirit of Scorpion Strike proc)
        "Spirit of Inferno",                        -- L28 Spirit of Inferno (Spirit of Inferno Strike proc)
        "Spirit of Lightning",                      -- L13 Spirit of Lightning (Spirit of Lightning Strike proc)
    },
    bst_pet_heal = {
        "Healing of Mikkily",                       -- L66 Healing of Mikkily (2810 hp, decrease dr 28, pr 28, cr 28, cost 610 mana)
        "Healing of Sorsha",                        -- L61 Healing of Sorsha (2018-2050 hp, decrease dr 24, pr 24, cr 24, cost 495 mana)
        "Sha's Restoration",                        -- L55 Sha's Restoration (1426-1461 hp, decrease dr 20, pr 20, cr 20, cost 404 mana)
        "Aid of Khurenz",                           -- L52 Aid of Khurenz (1044 hp, decrease dr 16, pr 16, cr 16, cost 293 mana)
        "Vigor of Zehkes",                          -- L49 Vigor of Zehkes (671 hp, decrease dr 10, pr 10, cr 10, cost 206 mana)
        "Yekan's Recovery",                         -- L36 Yekan's Recovery
        "Herikol's Soothing",                       -- L27 Herikol's Soothing (274-298 hp, decrease dr 10, pr 10, cr 10)
        "Keshuval's Rejuvenation",                  -- L15 Keshuval's Rejuvenation
        "Sharik's Replenishing",                    -- L09 Sharik's Replenishing
    },
    bst_ice_nuke = {
        "Ancient: Savage Ice",                      -- L70 Ancient: Savage Ice (1034 hp, cost 329 mana, 30s recast)
        "Glacier Spear",                            -- L69 Glacier Spear (958 hp, cost 310 mana)
        "Ancient: Frozen Chaos",                    -- L65 Ancient: Frozen Chaos (836 hp, cost 298 mana)
        "Trushar's Frost",                          -- L65 Trushar's Frost (742 hp, cost 274 mana)
        "Frost Spear",                              -- L63 Frost Spear (600 hp, cost 235 mana)
        "Blizzard Blast",                           -- L59 Blizzard Blast (332-346 hp, cost 147 mana)
        "Ice Shard",                                -- L54 Ice Shard (404 hp, cost 156 mana)
        "Frost Shard",                              -- L47 Frost Shard (281 hp, cost 119 mana)
        "Ice Spear",                                -- L33 Ice Spear (207 hp, cost 97 mana)
        "Spirit Strike",                            -- L26 Spirit Strike (72-78 hp, cost 44 mana)
        "Blast of Frost",                           -- L12 Blast of Frost (71 hp, cost 40 mana)
    },
    bst_slow = {
        "Sha's Legacy",                             -- L70 Sha's Legacy (MAGIC -30 adj, 65% slow, 1m30s duration)
        "Sha's Revenge",                            -- L65 Sha's Revenge (MAGIC, 65% slow, 3m30s duration)
    },
    bst_heal = {
        "Muada's Mending",                          -- L67 Muada's Mending (1176-1206 hp, cost 376 mana, 3s cast time)
        "Trushar's Mending",                        -- L65 Trushar's Mending (1048 hp, cost 330 mana)
        "Chloroblast",                              -- L62 Chloroblast (994-1044 hp, cost 331 mana)
        "Greater Healing",                          -- L57 Greater Healing (280-350 hp, cost 115 mana)
        "Healing",                                  -- L36 Healing (135-175 hp, cost 65 mana)
        "Light Healing",                            -- L20 Light Healing (47-65 hp, cost 28 mana)
        "Minor Healing",                            -- L06 Minor Healing (12-20 hp, cost 10 mana)
        "Salve",                                    -- L01 Salve (5-9 hp, cost 8 mana), GoD
    },
    bst_posion_dot = {
        "Turepta Blood",                            -- L65 Turepta Blood (168/tick, poison, cost 377 mana)
        "Scorpion Venom",                           -- L61 Scorpion Venom (162-170/tick, poison, cost 350 mana)
        "Venom of the Snake",                       -- L52 Venom of the Snake (104-114 hp/tick, poison, cost 172 mana)
        "Envenomed Breath",                         -- L35 Envenomed Breath (59-71/tick, poison, cost 181 mana)
        "Tainted Breath",                           -- L19 Tainted Breath (14-19/tick, poison)
    },
    bst_disease_dot = {
        "Plague",                                   -- L65 Plague (74-79 hp/tick, disease, cost 172 mana)
        "Sicken",                                   -- L14 Sicken (3-5/tick, disease)
    },
    bst_epic2 = {
        "Spiritcaller Totem of the Feral",          -- epic 2.0: pet buff, double attack 8%, evasion 12%, hp 1000, proc Wild Spirit Strike
        "Savage Lord's Totem",                      -- epic 1.5: pet buff, double attack 5%, evasion 10%, hp 800, proc Savage Blessing Strike
    },
    bst_oow_bp = {
        "Savagesoul Jerkin of the Wilds",           -- oow T2 bp: Savage Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 30s
        "Beast Tamer's Jerkin",                     -- oow T1 bp: Wild Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 18s
    }
}

SpellGroups.BRD = {
    brd_runspeed = {
        "Selo's Accelerating Chorus",               -- L49: PERCUSSION, 64-65% speed, 2.5 min, Luclin
        "Selo's Accelerando",                       -- L05: PERCUSSION, 20-65% speed, 0.3 min, Original
    },
    brd_travel = {
        "Selo's Song of Travel",                    -- L51: 65% speed, invis, levi, 0.3 min, Kunark
    },
    brd_invis = {
        "Shauri's Sonorous Clouding",               -- L19: invis
    },
    brd_levitate = {
        "Agilmente's Aria of Eagles",               -- L31: levitate
    },
    brd_pbae_debuff = {
        "Zuriki's Song of Shenanigans",             -- L67 Zuriki's Song of Shenanigans (stringed, dd+haste debuff 45%) OOW
        "Melody of Mischief",                       -- L62 Melody of Mischief (stringed, dd+haste debuff 45%) PoP
        "Selo's Chords of Cessation",               -- L48 Selo's Chords of Cessation (stringed, dd+haste debuff 30%) Original
        "Denon's Disruptive Discord",               -- L18 Denon's Disruptive Discord (brass, dd+ac debuff) Original
        "Chords of Dissonance",                     -- L02 Chords of Dissonance (stringed, dd if target not moving) Original
    },
    brd_ae_fear = {
        "Angstlich's Wail of Panic",                -- L67: ae range 25, fear to L65
        "Angstlich's Echo of Terror",               -- L62: ae range 25, fear to L60
        "Song of Midnight",                         -- L56: ae range 35, fear to L52, sow mobs
        "Angstlich's Appalling Screech",            -- L26: ae range 25, fear to L52
    },
    brd_da = {
        "Kazumi's Note of Preservation",            -- L60 Kazumi's Note of Preservation
    },
    brd_mez = {
        "Song of Twilight",                         -- L53 Song of Twilight, Kunark
        "Crission's Pixie Strike"                   -- L28 Crission's Pixie Strike, Original
    },
    brd_ae_mez  = {
        "Kelin's Lucid Lullaby"                     -- L15 Kelin's Lucid Lullaby
    },
    -- HP regen songs
    brd_hp_regen = {
        "Hymn of Restoration",                      -- L06: 2-12 hp/tick, aerange 30, Original
    },
    -- Mana regen songs
    brd_mana_regen = {
        "Cassindra's Chorus of Clarity",            -- L32: 5-7 mana/tick, Original
        "Cassindra's Chant of Clarity",             -- L20: 2 mana/tick, Velious
    },
    -- HP + mana regen songs
    brd_hp_mana_regen = {
        "Chorus of Life",                           -- L69: OOW
        "Cantata of Life",                          -- L67: OOW
        "Chorus of Marr",                           -- L64: PoP
        "Wind of Marr",                             -- L62: PoP
        "Ancient: Lcea's Lament",                   -- L60: Velious
        "Chorus of Replenishment",                  -- L58: Luclin
        "Cantata of Replenishment",                 -- L55: Original
        "Cantana of Soothing",                      -- L34: 4 hp/tick, 5 mana/tick, Velious
    },
    brd_haste = {
        "Jonthan's Inspiration",                    -- L58: singing, 61-63% haste, 17-18 str, 15-16 atk, Kunark
        "Vilia's Chorus of Celerity",               -- L54: singing, 45% haste, Kunark
        "Verses of Victory",                        -- L50: singing, 30% haste, 30 agi, 30 str, 15 ac, Original
        "Jonthan's Provocation",                    -- L45: singing, 48-50% haste, 13-19 str, 13-19 atk, Original
        "Vilia's Verses of Celerity",               -- L36: singing, 20% haste, 23-40 agi, 5-10 ac, Original
        "Anthem de Arms",                           -- L10: singing, 10% haste, 10-35 str, Original
        "Jonthan's Whistling Warsong",              -- L07: singing, 16-25% haste, 2-10 ac, 8-32 str (self only), Original
    },
    brd_brass_haste = {
        "McVaxius' Rousing Rondo",                  -- L57: brass, 21-22% haste, 20-21 str, 21-22 atk, 8 ds, Kunark
        "McVaxius' Berserker Crescendo",            -- L42: brass, 18-25% haste, 15-24 str, 6-10 ac, Origina
    },
    brd_ac = {
        "Chant of Battle",                          -- L01: 1-6 ac, 5-20 str, 5-20 dex
    },
    brd_nuke = {
        "Brusco's Bombastic Bellow",                -- L55: 222 dmg, stun, Kunark
        "Brusco's Boastful Bellow",                 -- L12: 7-31 dmg, pushback, 30s recast
    },
    brd_slow = {
        --"Angstlich's Assonance",                    -- L60: brass, 31% slow, 25 hp/tick dot, Kunark
        "Selo's Consonant Chain",                   -- L23: singing, 16-40% slow, 53-60% snare, Original
    },
    brd_eb = {
        "Tarew's Aquatic Ayre",                     -- L16: water breathing
    },
    brd_epic2 = {
        "Blade of Vesagran",                        -- epic 2.0: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140%
        "Prismatic Dragon Blade",                   -- epic 1.5: spell crit  8%, slot 10: dot crit  8%, slot 12: accuracy 130%
    },
    brd_oow_bp = {
        "Farseeker's Plate Chestguard of Harmony",  -- oow T2 bp: increase double attack by 100% for 24s, 5 min reuse
        "Traveler's Mail Chestguard",               -- oow T1 bp: increase double attack by  30% for 12s, 5 min reuse
    },
}

SpellGroups.WAR = {
    war_epic2 = {
        "Kreljnok's Sword of Eternal Power",        -- epic 2.0: group 800 hp
        "Champion's Sword of Eternal Power",        -- epic 1.5: group 600 hp
    },
    war_oow_bp = {
        "Gladiator's Plate Chestguard of War",      -- oow T2 bp: reduce damage taken for 24s
        "Armsmaster's Breastplate",                 -- oow T1 bp: reduce damage taken for 12s
    },
}

SpellGroups.ROG = {
    rog_epic2 = {
        "Nightshade, Blade of Entropy",             -- epic 2.0: 45% triple backstab, Deceiver's Blight Strike proc
        "Fatestealer",                              -- epic 1.5: 35% triple backstab, Assassin's Taint Strike proc
    },
    rog_oow_bp = {
        "Whispering Tunic of Shadows",              -- oow T2 bp: increase all melee taken by 20% for 24s, 5 min reuse
        "Darkraider's Vest",                        -- oow T1 bp: increase 1hb dmg   taken by 20% for 12s, 5 min reuse
    },
}

SpellGroups.BER = {
    ber_epic2 = {
        "Vengeful Taelosian Blood Axe",             -- epic 2.0: +100 str and cap, +300% melee crit chance, 100 hot heal
        "Raging Taelosian Alloy Axe",               -- epic 1.5:  +75 str and cap, +200% melee crit chance, 75 hot heal
    },
    ber_oow_bp = {
        "Wrathbringer's Chain Chestguard of the Vindicator",-- oow T2 bp: increase melee chance to hit by 40% for 24s
        "Ragebound Chain Chestguard",                       -- oow T1 bp: increase melee chance to hit by 40% for 12s
    }
}

SpellGroups.MNK = {
    mnk_epic2 = {
        "Transcended Fistwraps of Immortality",     -- epic 2.0: 25% max hp, +10000 hp, add proc Peace of the Disciple Strike, 0.5 min, 3 min recast
        "Fistwraps of Celestial Discipline",        -- epic 1.5: 15% max hp, +10000 hp, add proc Peace of the Order Strike, 0.5 min, 6 min recast
    },
    mnk_oow_bp = {
        "Fiercehand Shroud of the Focused",         -- oow bp t2: cancel beneficial buffs
        "Stillmind Tunic",                          -- oow bp t1: cancel beneficial buffs
    },
}

SpellGroups.Default = {}

-- REQUEST DEFAULTS BY CLASS
SpellGroups.Default.WAR = {
    -- should we ask for symbol / aegolism?   XXX try this out.
    --"clr_symbol/Class|DRU,CLR",         -- CLR
    --"clr_ac/Class|DRU,CLR",             -- CLR
    --"dru_skin/Class|DRU,CLR",           -- DRU
    --"clr_aegolism/Class|CLR/NotClass|DRU",  -- CLR

    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.SHD = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.PAL = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.BRD = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",            -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "rng_atk/Class|RNG",
    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.CLR = {
    -- XXX should do self buff + aego ?
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.DRU = {
    "clr_symbol/Class|CLR",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "clr_spellhaste/Class|CLR",
    "clr_vie/Class|CLR",

    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.SHM = {
    "clr_symbol/Class|CLR",
    "dru_skin/Class|DRU",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "clr_spellhaste/Class|CLR",
    "clr_vie/Class|CLR",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
}

SpellGroups.Default.ENC = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "clr_spellhaste/Class|CLR",
    "bst_manaregen/Class|BST",
    "clr_vie/Class|CLR",

    "dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.WIZ = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "clr_spellhaste/Class|CLR",
    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",
    "clr_vie/Class|CLR",

    "dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

SpellGroups.Default.MAG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "clr_spellhaste/Class|CLR",
    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",
    --"clr_vie/Class|CLR",

    "dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

SpellGroups.Default.NEC = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG",

    "clr_spellhaste/Class|CLR",
    "bst_manaregen/Class|BST",
    --"clr_vie/Class|CLR",

    "dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

SpellGroups.Default.RNG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "clr_spellhaste/Class|CLR",
    "enc_manaregen/Class|ENC",
    --"bst_manaregen/Class|BST",   -- XXX out of buff slots, sep 2022

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.BST = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",                 -- 1st

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "clr_spellhaste/Class|CLR",
    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.ROG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.MNK = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    --"shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

SpellGroups.Default.BER = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}


return SpellGroups
