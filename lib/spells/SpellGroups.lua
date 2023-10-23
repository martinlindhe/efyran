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
    -- fast heals:
    -- L01 Minor Healing (12-20 hp, cost 10 mana)
    -- L09 Light Healing (47-65 hp, cost 28 mana)
    -- L19 Healing (135-175 hp, cost 65 mana)
    -- L29 Greater Healing (280-350 hp, cost 115 mana)
    -- L51 Superior Healing (500-600 hp, cost 185 mana)
    -- L55 Chloroblast (994-1044 hp, cost 331 mana)
    -- L62 Tnarg's Mending (1770-1800 hp, cost 560 mana)
    -- L65 Daluda's Mending (2144 hp, cost 607 mana, 3.8s cast)
    -- L68 Yoppa's Mending (2448-2468 hp, cost 691 mana, 3.8s cast)
    -- L70 Ancient: Wilslik's Mending (2716 hp, cost 723 mana, 3.8s cast)
    shm_heal = {
        "Ancient: Wilslik's Mending",
        "Yoppa's Mending",
        "Daluda's Mending",
        "Tnarg's Mending",
        "Chloroblast",
        "Superior Healing",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
    },

    -- focus - HP Slot 1: Increase Max HP + stats
    -- L32 Talisman of Tnarg (132-150 hp)
    -- L40 Talisman of Altuna (230-250 hp)
    -- L55 Talisman of Kragg (365-500 hp)
    -- L46 Harnessing of Spirit (243-251 hp, 67 str, 50 dex, cost 425 mana) Luclin
    -- L60 Focus of Spirit (405-525 hp, 67 str, 60 dex, cost 500 mana) Velious
    -- L60 Khura's Focusing (430-550 hp, 67 str, 60 dex, cost 1250 mana, group) Luclin
    -- L62 Focus of Soul (544 hp, 75 str, 70 dex, cost XXX mana)
    -- L65 Focus of the Seventh (544 hp, 75 str, 70 dex, cost 1800 mana, group)
    -- L68 Wunshi's Focusing (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 780 mana)
    -- L70 Talisman of Wunshi (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 2340 mana)
    shm_focus = {
        "Talisman of Wunshi",
        "Focus of the Seventh",
        "Khura's Focusing",
        "Harnessing of Spirit",
        "Talisman of Kragg",
        "Talisman of Altuna",
        "Talisman of Tnarg",
    },

    -- L09 Spirit of Wolf (48-55% speed, 36 min)
    -- L36 Spirit of Bih`Li (48-55% run speed, 15 atk, 36 min, group)
    shm_runspeed = {
        "Spirit of Bih`Li/CheckFor|Flight of Eagles",
        "Spirit of Wolf",
    },

    -- L26 Quiuckness (27--30% haste, 11 min)
    -- L42 Alacrity (32-40% haste, 11 min)
    -- L56 Celerity (47-50% haste, 16 min)
    -- L63 Swift Like the Wind (60% haste, 16 min)
    -- L64 Talisman of Celerity (60% haste, 36 min, group)
    shm_haste = {
        "Talisman of Celerity",
        "Swift Like the Wind",
        "Celerity",
        "Alacrity",
        "Quickness",
    },

    -- malos (slot 2: cr, slot 3: mr, slot 4: pr, slot 5: fr):
    -- L19 Malaise (-20 cr, -20 mr, -20 fr, cost 60 mana)
    -- L34 Malaisement (-40 cr, -40 mr, -40 fr, cost 100 mana)
    -- L49 Malosi (-60 cr, -60 mr, -60 fr, cost 175 mana, 5.8 min)
    -- L57 Malosini (-60 cr, -60 mr, -60 fr, cost 200 mana, 8.2 min)
    -- L60 Malo (-45 cr, -45 mr, -45 pr, -45 fr, unresistable, cost 350 mana)
    -- L63 Malosinia (-70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana)
    -- L65 Malos (-55 cr, -55 mr, -55 pr, -55 fr, unresistable, cost 400 mana)
    shm_malo = {
        "Malos",
        "Malosinia",
        "Malo",
        "Malosini",
        "Malosi",
        "Malaisement",
        "Malaise",
    },

    -- L09 Endure Disease (19-20 dr)
    -- L34 Resist Disease (40 dr)
    -- L50 Talisman of Jasinth (45 dr, group) Kunark
    -- L58 Talisman of Epuration (55 dr, 55 pr, group) Luclin
    -- L62 Talisman of the Tribunal (65 dr, 65 pr, group) PoP
    shm_disease_resist = {
        "Talisman of the Tribunal",
        "Talisman of Epuration",
        "Talisman of Jasinth",
        "Resist Disease",
        "Endure Disease",
    },

    -- NOTE: shm_poison_resist don't stack with Talisman of the Tribunal
    -- L14 Endure Poison (19-20 pr)
    -- L39 Resist Poison (40 pr)
    -- L53 Talisman of Shadoo (45 pr, group) Kunark
    shm_poison_resist = {
        "Talisman of Shadoo",
        "Resist Poison",
        "Endure Poison",
    },

    -- L23 Regeneration (5 hp/tick, 17.5 min, cost 100 mana)
    -- L39 Chloroplast (10 hp/tick, 17.5 min, cost 200 mana)
    -- L52 Regrowth (20 hp/tick, 17.5 min, cost 300 mana)
    -- L61 Replenishment (40 hp/tick, 20.5 min, cost 275 mana)
    -- L63 Blessing of Replenishment (40 hp/tick, 20.5 min, cost 650 mana, group)
    -- L66 Spirit of Perseverance (60 hp/tick, 21 min, cost 343 mana)
    -- L69 Talisman of Perseverance (60 hp/tick, 20.5 min, cost 812 mana, group)
    shm_regen = {
        "Spirit of Perseverance",
        "Replenishment",
        "Regrowth",
        "Chloroplast",
    },

    -- AC (slot 4, weaker than clr_ac)
    -- L03 Scale Skin (4-6 ac)
    -- L11 Turtle Skin (8-10 ac)
    -- L20 Protect (11-13 ac)
    -- L31 Shifting Shield (16-18 ac)
    -- L42 Guardian (23-24 ac)
    -- L54 Shroud of the Spirits (26-30 ac)
    -- L62 Ancestral Guard (36 ac)
    -- L67 Ancestral Bulwark (46 ac)
    shm_ac = {
        "Ancestral Bulwark",
        "Ancestral Guard",
        "Shroud of the Spirits",
        "Guardian",
    },

    -- STA - affects HP
    -- L06 Spirit of Bear (11-15 sta)
    -- L21 Spirit of Ox (19-23 sta)
    -- L30 Health (27-31 sta)
    -- L43 Stamina (36-40 sta)
    -- L54 Riotous Health (50 sta)
    -- L57 Talisman of the Brute (50 sta, group)
    -- L62 Endurance of the Boar (60 sta)
    -- L63 Talisman of the Boar (60-68 sta, group)
    -- L68 Spirit of Fortitude (75 sta, 40 sta cap)
    -- L69 Talisman of Fortitude (78 sta, 40 sta cap, group)
    shm_sta = {
        "Talisman of Fortitude",
        "Talisman of the Boar",
        "Talisman of the Brute",
        "Stamina",
    },

    -- STR - affects ATK & carry limit
    -- L01 Strengthen (5-10 str)
    -- L18 Spirit Strength (16-18 str)
    -- L28 Raging Strength (23-26 str)
    -- L35 Tumultuous Strength (34 str, group)
    -- L39 Furious Strength (31-34 str)
    -- L46 Strength (65-67 str) - works on L01
    -- L57 Maniacal Strength (68 str) - blocked by Khura's Focusing (67 str)
    -- L58 Talisman of the Rhino (68 str, group)
    -- L63 Strength of the Diaku (35 str, 28 dex)
    -- L64 Talisman of the Diaku (45 str, 35 dex, group)
    -- L67 Spirit of Might (5% skill dmg mod, cost 175 mana) - same as DRU Lion's Strength
    -- L70 Talisman of Might (5% skill dmg mod, group, cost 700 mana)
    -- NOTE: DRU has a weaker line of buffs
    shm_str = {
        "Talisman of Might",
        "Talisman of the Diaku",
        "Talisman of the Rhino",
        "Maniacal Strength",
        "Strength",
    },

    -- AGI - affects AC
    -- L03 Feet like Cat (12-18 agi)
    -- L18 Spirit of Cat (22-27 agi)
    -- L31 Nimble (31-36 agi)
    -- L41 Agility (41-45 agi)
    -- L53 Deliriously Nimble (52 agi)
    -- L57 Talisman of the Cat (52 agi, group)
    -- L61 Agility of the Wrulan (60 agi)
    -- L62 Talisman of the Wrulan (60 agi, group)
    shm_agi = {
        "Talisman of the Wrulan",
        "Talisman of the Cat",
        "Deliriously Nimble",
        "Agility",
    },

    -- DEX - affects bard song missed notes, procs & crits
    -- L01 Dexterous Aura (5-10 dex)
    -- L21 Spirit of Monkey (19-20 dex)
    -- L25 Rising Dexterity (26-30 dex)
    -- L39 Deftness (40 dex)
    -- L48 Dexterity (49-50 dex) - blocked by Khura's Focusing (60 dex)
    -- L58 Mortal Deftness (60 dex)
    -- L59 Talisman of the Raptor (60 dex, group)
    shm_dex = {
        "Talisman of the Raptor",
        "Dexterity",
    },

    -- CHA - affects sale prices and DI success rate
    -- L10 Spirit of Snake (11-15 cha)
    -- L28 Alluring Aura (20-23 cha)
    -- L37 Glamour (28-32 cha)
    -- L47 Charisma (40 cha)
    -- L58 Talisman of the Serpent (40 cha, group)
    -- L59 Unfailing Reverence (55 cha)
    shm_cha = {
        "Unfailing Reverence",
        "Charisma",
    },

    -- L01 Burst of Flame
    shm_fire_nuke = {
        "Burst of Flame",
    },

    -- L05 Frost Rift
    -- L14 Spirit Strike (72-78 hp, cost 44 mana)
    -- L23 Frost Strike (142-156 hp, cost 78 mana)
    -- L33 Winter's Roar (236-246 hp, cost 116 mana)
    -- L44 Blizzard Blast (332-346 hp, cost 147 mana)
    -- L54 Ice Strike (511 hp, cost 198 mana)
    -- L64 Velium Strike (925 hp, cost 330 mana)
    -- L69 Ice Age (1273 hp, cost  413 mana)
    shm_cold_nuke = {
        "Ice Age",
        "Velium Strike",
        "Ice Strike",
        "Blizzard Blast",
        "Winter's Roar",
        "Frost Strike",
        "Spirit Strike",
        "Frost Rift",
    },

    -- L54 Blast of Venom (704 hp, cost 289 mana)
    -- L61 Spear of Torment (870 hp, cost 340 mana)
    -- L66 Yoppa's Spear of Venom (1197 hp, cost 425 mana)
    shm_poison_nuke = {
        "Yoppa's Spear of Venom",
        "Spear of Torment",
        "Blast of Venom",
    },

    -- epic 1.5: Crafted Talisman of Fates
    -- epic 2.0: Blessed Spiritstaff of the Heyokah (Prophet's Gift of the Ruchu: group buff: skill crit damage 110%, 65% melee crit, slot 12: 500 HoT, 1 min, 3 min reuse)
    shm_epic2 = {
        "Blessed Spiritstaff of the Heyokah",
        "Crafted Talisman of Fates",
    },

    -- oow t1 bp: Spiritkin Tunic (reduce resist rate by 40% for 0.5 min, 5 min recast)
    -- oow t2 bp: Ritualchanter's Tunic of the Ancestors (reduce resist rate by 40% for 0.7 min, 5 min recast)
    shm_oow_bp = {
        "Ritualchanter's Tunic of the Ancestors",
        "Spiritkin Tunic",
    },
}

SpellGroups.CLR = {

    clr_group_heal = {
        -- CLR - cast group heals with cure component
        "Word of Vivification",     -- CLR/69: 3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana
        "Word of Replenishment",    -- CLR/64: 2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana
        "Word of Redemption",       -- CLR/60: 7500 hp, cost 1100 mana
        "Word of Restoration",      -- CLR/57: 1788-1818 hp, cost 898 mana
        "Word of Health",           -- CLR/30: 380-485 hp, cost 302 mana
    },

    -- fast heals:
    -- L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
    -- L04 Light Healing (47-65 hp, 2s cast, 28 mana)
    -- L10 Healing (135-175 hp, 2.5s cast, 65 mana)
    -- L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
    -- L53 Divine Light
    -- L58 Ethereal Light (1980-2000 hp, 3.8s cast, 490 mana)
    -- L63 Supernal Light (2730-2750 hp, 3.8s cast, 600 mana)
    -- L65 Holy Light (3275 hp, 3.8s cast, 650 mana)
    -- L68 Pious Light (3750-3770 hp, 3.8s cast, 740 mana)
    -- L70 Ancient: Hallowed Light (4150 hp, 3.8s cast, 775 mana)
    clr_heal = {
        "Ancient: Hallowed Light",
        "Pious Light",
        "Holy Light",
        "Supernal Light",
        "Ethereal Light",
        "Divine Light",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
    },

    -- L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
    -- L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
    -- L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
    -- L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)
    clr_remedy = {
        "Pious Remedy",
        "Supernal Remedy",
        "Ethereal Remedy",
        "Remedy",
    },

    -- HoT:
    -- L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
    -- L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
    -- L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
    -- L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
    -- L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
    -- L67 Pious Elixir (slot 1: 1170 hp/tick, 0.4 min, 890 mana)
    clr_hot = {
        "Pious Elixir",
        "Holy Elixir",
        "Supernal Elixir",
        "Ethereal Elixir",
        "Celestial Elixir",
        "Celestial Healing",
    },

    -- group hot:
    -- L70 Elixir of Divinity (900 hp/tick, group, cost 1550 mana)
    -- XXX add celestial regen aa here?!
    clr_group_hot = {

    },

    -- slot 3 hp buff - symbol line:
    -- L14 Symbol of Transal (34-72 hp, single)
    -- L24 Symbol of Ryltan
    -- L34 Symbol of Pinzarn
    -- L41 Symbol of Naltron (406-525 hp, single)
    -- L54 Symbol of Marzin (640-700 hp, single)
    -- L61 Symbol of Kazad (910 hp, cost 600 mana) PoP
    -- L66 Symbol of Balikor (1137 hp, cost 780 mana)
    -- L71 Symbol of Elushar (1364 hp, cost 936 mana)
    -- L76 Symbol of Kaerra Rk. II (1847 hp, cost 1190 mana)
    -- NOTE: stacks with dru_skin and clr_ac
    clr_symbol = {
        "Symbol of Kaerra",
        "Symbol of Elushar",
        "Symbol of Balikor",
        "Symbol of Kazad",
        "Symbol of Marzin/Reagent|Peridot",
        "Symbol of Naltron/Reagent|Peridot",
        "Symbol of Pinzarn/Reagent|Jasper",
        "Symbol of Ryltan/Reagent|Bloodstone",
        "Symbol of Transal/Reagent|Cat's Eye Agate",
    },

    -- L58 Naltron's Mark (525 hp, group)
    -- L60 Marzin's Mark (725 hp, group)
    -- L63 Kazad's Mark (910 hp, cost 1800 mana, group) PoP
    -- L70 Balikor's Mark (1137 hp, cost 2340 mana, group)
    -- L75 Elushar's Mark Rk. II (1421 hp, cost 2925 mana, group)
    -- L80 Kaerra's Mark (1563 hp, cost 3130 mana, group)
    clr_group_symbol = {
        "Kaerra's Mark",
        "Elushar's Mark",
        "Balikor's Mark",
        "Kazad's Mark",
        "Marzin's Mark",
        "Naltron's Mark",
    },

    -- slot 1: Death Save:
    -- L60 Divine Intervention (single)
    di = {
        "Divine Intervention",
    },

    -- L05 Holy Armor (slot 4: 6 ac)
    -- L19 Spirit Armor (slot 4: 11-13 ac)
    -- L29 Guard (slot 4: 18-19 ac)
    -- L39 Armor of Faith (slot 4: 24-25 ac)
    -- L49 Shield of Words (slot 4: 31 ac)
    -- L61 Ward of Gallantry (slot 4: 54 ac)
    -- L66 Ward of Valiance (slot 4: 72 ac)
    -- L71 Ward of the Dauntless (slot 4: 86 ac)
    -- L76 Ward of the Resolute Rk. II (solt 4: 109 ac)
    -- L80 Order of the Resolute Rk. II (slot 4: 109 ac, group)
    -- NOTE: stacks with clr_symbol + dru_skin + shm_focus
    clr_ac = {
        "Order of the Resolute",
        "Ward of the Dauntless",
        "Ward of Valiance",
        "Ward of Gallantry",
        "Shield of Words",
        "Armor of Faith",
        "Guard",
        "Spirit Armor",
        "Holy Armor",
    },

    -- hp buff - aegolism line (slot 2 - does not stack with dru_skin):
    -- L01 Courage (20 hp, 4 ac, single)
    -- L09 Center (44-105 hp, 5-6 ac)
    -- L19 Daring (84-135 hp, 7-9 ac)
    -- L24 Bravery (114-140 hp, 9-10 ac)
    -- L34 Valor (168-200 hp, 12-13 ac)
    -- L40 Temperance (800 hp, 48 ac, single) LoY - LANDS ON L01
    -- L44 Resolution (232-250 hp, 15-16 ac)
    -- L52 Heroism (360-400 hp, 18-19 ac, 1h12m duration) Kunark
    -- L52 Heroic Bond (360-400 hp, 18-19 ac, group) Kunark
    -- L55 Fortitude (320-360 hp, 17-18 ac, 2h24m duration) Kunark
    -- L60 Aegolism (1150 hp, 60 ac, single) Velious
    -- L62 Virtue (1405 hp, 72 ac, single) PoP
    -- L67 Conviction (1787 hp, 94 ac)
    -- L72 Tenacity (2144 hp, 113 ac)
    -- L7x Temerity ??? XXX
    clr_aegolism = {
        "Temerity",
        "Tenacity",
        "Conviction",
        "Virtue",
        "Aegolism",
        "Temperance",
        "Fortitude",
        "Heroic Bond",
        "Heroism",
        "Resolution",
        "Valor",
        "Bravery",
        "Daring",
        "Center",
        "Courage",
    },

    -- L45 Blessing of Temperance (800 hp, 48 ac, group) LDoN - LANDS ON L01
    -- L60 Blessing of Aegolism (1150 hp, 60 ac, group) Luclin
    -- L65 Hand of Virtue (1405 hp, 72 ac, group) PoP - LANDS ON L47
    -- L70 Hand of Conviction (1787 hp, 94 ac, group) - LANDS ON L62
    -- L75 Hand of Tenacity Rk. II (2234 hp, 118 ac, group)
    -- L80 Hand of Temerity (2457 hp, 126 ac, group)
    clr_group_aegoism = {
        "Hand of Temerity",
        "Hand of Tenacity",
        "Hand of Conviction",
        "Hand of Virtue",
        "Blessing of Aegolism",
        "Blessing of Temperance",
    },

    -- absorb melee:
    -- L20 Ward of Vie (absorb 10% melee dmg to 460)
    -- L40 Guard of Vie (absorb 10% melee dmg to 700)
    -- L54 Protection of Vie (absorb 10% melee dmg to 1200)
    -- L62 Bulwark of Vie (absorb 10% melee dmg to 1600)
    -- L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
    -- L73 Aegis of Vie (absorb 10% of melee dmg to 2496, 36 min)
    -- L75 Rallied Aegis of Vie Rk. II (absorb 10% of melee dmg to 2600, 36 min, group)
    -- L78 Shield of Vie Rk. II (absorb 10% of melee dmg to 3380, 36 min)
    -- L80 Rallied Shield of Vie Rk. II (slot 1: absorb 10% of melee dmg to 3380, 36 min, group)
    clr_vie = {
        "Rallied Shield of Vie",
        "Rallied Aegis of Vie",
        "Panoply of Vie",
        "Bulwark of Vie",
        "Protection of Vie",
        "Guard of Vie",
    },

    -- L15 Blessing of Piety (10% spell haste to L39, 40 min) PoP
    -- L35 Blessing of Faith (10% spell haste to L61, 40 min) PoP
    -- L62 Blessing of Reverence (10% spell haste to L65, 40 min) PoP
    -- L67 Blessing of Devotion (10% spell haste to L70, 40 min, 390 mana) OOW
    -- L71 Blessing of Purpose (9% spell haste to L75, 40 min, 390 mana)
    -- L76 Blessing of Resolve Rk. II (10% spell haste to L80, 40 min, 390 mana)
    clr_spellhaste = {
        "Blessing of Resolve",
        "Blessing of Purpose",
        "Blessing of Devotion",
        "Blessing of Reverence",
        "Blessing of Faith",
        "Blessing of Piety",
    },

    -- L64 Aura of Reverence (10% spell haste to L65, 40 min, group) LDoN
    -- L69 Aura of Devotion (10% spell haste to L70, 45 min, group, 1125 mana) OOW
    -- L72 Aura of Purpose Rk. II (10% spell haste to L75, 45 min, group, 1125 mana)
    -- L77 Aura of Resolve Rk. II (10% spell haste to L80, 45 min, group, 1125 mana)
    clr_group_spellhaste = {
        "Aura of Resolve",
        "Aura of Purpose",
        "Aura of Devotion",
        "Aura of Reverence",
    },

    -- self mana regen:
    -- L34 Armor of Protection (202-225 hp, 15 ac)
    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
    -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
    -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
    -- L70 Armor of the Pious (563 hp, 46 ac, 9 mana/tick)
    -- L75 Armor of the Sacred Rk. II (704 hp, 58 ac, 10 mana/tick)
    -- L80 Armor of the Solemn Rk. II (915 hp, 71 ac, 12 mana/tick)
    -- NOTE: does not stack with DRU Skin
    clr_self_shield = {
        "Armor of the Solemn",
        "Armor of the Sacred",
        "Armor of the Pious",
        "Armor of the Zealot",
        "Blessed Armor of the Risen",
        "Armor of the Faithful",
        "Armor of Protection",
    },

    -- L01 Yaulp () Original
    -- L19 Yaulp II () Original
    -- L44 Yaulp III () Original
    -- L53 Yaulp IV () Kunark
    -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
    -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
    -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
    clr_yaulp = {
        "Yaulp VII",
        "Yaulp VI",
        "Yaulp V",
        "Yaulp IV",
        "Yaulp III",
        "Yaulp II",
        "Yaulp",
    },

    -- L05 Stun
    -- L19 Holy Might
    -- L34 Force
    -- L49 Sound of Force
    -- L58 Enforced Reverence
    clr_stun = {
        "Enforced Reverence",
        "Sound of Force",
        "Force",
        "Holy Might",
        "Stun",
    },

    -- L01 Strike (-6-8 hp, cost 12 mana)
    -- L05 Furor (-16-19 hp, cost 20 mana)
    -- L14 Smite (-74-83 hp, cost 70 mana)
    -- L29 Wrath (-192-218 hp, cost 145 mana)
    -- L44 Retribution (372-390 hp, cost 240 mana) Original
    -- L54 Reckoning (675 hp, cost 250 mana) Kunark
    -- L56 Judgment (842 hp, cost 274 mana)
    -- L62 Condemnation (1175 hp, cost 365 mana)
    -- L65 Order (1219 hp, cost 379 mana)
    -- L65 Ancient: Chaos Censure (1329 hp, cost 413 mana)
    -- L67 Reproach (1424-1524 hp, cost 430 mana)
    -- L69 Chromastrike (1200 hp, cost 375 mana, chromatic resist)
    -- L70 Ancient: Pious Conscience (1646 hp, cost 457 mana)
    clr_magic_nuke = {
        "Ancient: Pious Conscience",
        "Chromastrike",
        "Reproach",
        "Ancient: Chaos Censure",
        "Order",
        "Condemnation",
        "Judgment",
        "Reckoning",
        "Retribution",
        "Wrath",
        "Smite",
        "Furor",
        "Strike",
    },

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
    clr_pbae_nuke = {
        "Calamity",
        "Catastrophe",
        "The Unspoken Word",
        "Upheaval",
        "Word Divine",
        "Earthquake",
        "Word of Souls",
        "Tremor",
        "Word of Spirit",
        "Word of Shadow",
        "Word of Pain",
    },

    -- oow T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
    -- oow T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
    clr_oow_bp = {
        "Faithbringer's Breastplate of Conviction",
        "Sanctified Chestguard",
    },
}

SpellGroups.DRU = {
    dru_group_heal = { -- TODO make use of
        "Moonshadow",               -- DRU/70: 1500 hp, cost 1100 mana, 4.5S cast, 18s recast
    },

    -- L01 Minor Healing
    -- L09 Light Healing
    -- L10 Healing
    -- L29 Greater Healing (280-350 hp, cost 115 mana)
    -- L44 Healing Water (395-425 hp, cost 150 mana)
    -- L51 Superior Healing (500-600 hp, cost 185 mana)
    -- L55 Chloroblast (994-1044 hp, cost 331 mana)
    -- L58 Tunare's Renewal (2925 hp, cost 400 mana - 75% CH)
    -- L60 Nature's Touch (1491 hp, cost 457 mana)
    -- L63 Nature's Infusion (2030-2050 hp, cost 560 mana)
    -- L64 Karana's Renewal (4680 hp, cost 600 mana - 75% CH)
    -- L65 Sylvan Infusion (2441 hp, cost 607 mana, 3.75s cast)
    -- L68 Chlorotrope (2790-2810 hp, cost 691 mana, 3.75s cast)
    -- L70 Ancient: Chlorobon (3094 hp, cost 723 mana,3.75s cast)
    dru_heal = {
        "Ancient: Chlorobon",
        "Chlorotrope",
        "Sylvan Infusion",
        "Karana's Renewal",
        "Nature's Infusion",
        "Nature's Touch",
        "Tunare's Renewal",
        "Chloroblast",
        "Superior Healing",
        "Healing Water",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
    },

    -- hp buff:
    -- L01 Skin like Wood
    -- L14 Skin like Rock
    -- L24 Skin like Steel
    -- L39 Skin like Diamond
    -- L49 Skin like Nature
    -- L49 Protection of Nature (16 ac, 248-25 hp, 2 hp/tick, group)
    -- L59 Protection of the Cabbage (24 ac, 467-485 hp, 6 mana/tick)
    -- L60 Protection of the Glades (24 ac, 470-485 hp, 6 mana/tick, group)
    -- L63 Protection of the Nine (32 ac, 618 hp, 8 mana/tick, cost 725 mana)
    -- L65 Blessing of the Nine (32 ac, 618 hp, 8 mana/tick, cost 1700 mana, group)
    -- L68 Steeloak Skin (43 ac, 772 hp, 9 mana/tick, cost 906 mana)
    -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
    -- L72 Direwild Skin Rk. II (54 ac, 965 hp, 10 mana/tick, cost 1133 mana)
    -- L75 Blessing of the Direwild Rk. II (56 ac, 1004 hp, 10 mana/tick, cost 2873 mana, group)
    -- L77 Ironwood Skin Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 1382 mana)
    -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
    dru_skin = {
        "Blessing of the Ironwood",
        "Blessing of the Direwild",
        "Blessing of Steeloak",
        "Blessing of the Nine",
        "Protection of the Nine",
        "Protection of Nature",
        "Skin like Nature",
        "Skin like Diamond",
        "Skin like Steel",
        "Skin like Rock",
        "Skin like Wood",
    },

    -- fire resists:
    -- L01 Endure Fire (slot 1: 11-20 fr)
    -- L20 Resist Fire (slot 1: 30-40 fr)
    -- L51 Circle of Winter (slot 1: 45 fr)
    -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
    dru_fire_resist = {
        "Protection of Seasons",
        "Circle of Seasons",
        "Circle of Winter",
        "Resist Fire",
        "Endure Fire",
    },

    -- L09 Endure Cold (slot 1: 11-20 cr)
    -- L30 Resist Cold (slot 1: 39-40 cr)
    dru_cold_resist = {
        "Resist Cold",
        "Endure Cold",
    },

    -- L52 Circle of Summer (slot 4: 45 cr) - stack with dru_fire_resist and dru_cold_resist
    dru_cold_resist2 = {
        "Circle of Summer",
    },

    -- corruption resists (CLR/DRU):
    -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
    dru_corruption = {
        "Forbear Corruption",
        "Resist Corruption",
    },

    -- L34 Regeneration (5-9 hp/tick)
    -- L39 Pack Regeneration (9 hp/tick)
    -- L42 Chloroplast (10-19 hp/tick)
    -- L45 Pack Chloroplast (13-19 hp/tick)
    -- L54 Regrowth (20-38 hp/tick, 18.4 min, cost 300 mana)
    -- L58 Regrowth of the Grove (32-38 hp/tick, 18.4 min, cost 600 mana, group)
    -- L61 Replenishment (40-58 hp/tick, 19.6 min, cost 275 mana)
    -- L63 Blessing of Replenishment (44-58 hp/tick, 19.6 min, cost 650 mana, group)
    -- L66 Oaken Vigor (60-70 hp/tick, 21 min, cost 343 mana)
    -- L69 Blessing of Oak (66-70 hp/tick, 21 min, cost 845 mana, group)
    -- L76 Spirit of the Stalwart Rk. II (105-144 hp/tick, 21 min, cost 523 mana)
    -- L79 Talisman of the Stalwart Rk. II (111-144 hp/tick, 21 min, cost 1238 mana)
    dru_regen = {
        "Spirit of the Stalwart",
        "Oaken Vigor",
        "Replenishment",
        "Regrowth",
        "Chloroplast",
    },

    -- L07 Shield of Thistles (4-6 ds, 15 min)
    -- L17 Shield of Barbs (7-9 ds, 15 min)
    -- L27 Shield of Brambles (10-12 ds, 15 min)
    -- L37 Shield of Spikes (14 ds, 15 min)
    -- L47 Shield of Thorns (24 ds, 15 min) - lands on LV1
    -- L49 Legacy of Spike (24 ds, 15 min, group) - lands on LV1
    -- L58 Shield of Blades (32 ds, 15 min)
    -- L59 Legacy of Thorn (32 ds, 15 min, group)
    -- L63 Shield of Bracken (40 ds, 15 min)
    -- L65 Legacy of Bracken (40 ds, 15 min, group)
    -- L67 Nettle Shield (55 ds, 15 min)
    -- L70 Legacy of Nettles (55 ds, 15 min, group)
    -- L72 Viridifloral Shield Rk. II (69 ds, 15 min)
    -- L75 Legacy of Viridiflora Rk. II (69 ds, 15 min, group)
    -- L77 Viridifloral Bulwark Rk. II (86 ds, 15 min)
    -- L80 Legacy of Viridithorns Rk. II (86 ds, 15 min, group)
    -- NOTE: MAGE DS IS STRONGER
    dru_ds = {
        "Viridifloral Bulwark",
        "Viridifloral Shield",
        "Nettle Shield",
        "Shield of Bracken",
        "Shield of Blades",
        "Shield of Thorns",
    },

    dru_group_ds = {
        "Legacy of Viridithorns",
        "Legacy of Viridiflora",
        "Legacy of Nettles",
        "Legacy of Bracken",
        "Legacy of Thorn",
        "Legacy of Spike",
    },

    -- L07 Strength of Earth (8-15 str)
    -- L34 Strength of Stone (22-25 str)
    -- L44 Storm Strength (32-35 str)
    -- L55 Girdle of Karana (42 str) Kunark
    -- L62 Nature's Might (55 str) PoP
    -- NOTE: Shaman has STR buffs too
    dru_str = {
        "Nature's Might",
        "Girdle of Karana",
        "Storm Strength",
        "Strength of Stone",
        "Strength of Earth",
    },

    -- L67 Lion's Strength (increase skills dmg mod by 5%, cost 165 mana)
    -- L71 Mammoth's Strength Rk. III (increase skills dmg mod by 8%, cost 215 mana)
    -- NOTE: SHM has group version of these spells
    dru_skill_dmg_mod = {
        "Mammoth's Strength",
        "Lion's Strength",
    },

    -- L10 Spirit of Wolf (48-55% speed, 36 min) Original
    -- L35 Pack Spirit (47-55% speed, 36 min, group) Original
    -- L54 Spirit of Eagle (57-70% speed, 1 hour) Luclin
    -- L62 Flight of Eagles (70% speed, 1 hour, group) PoP
    dru_runspeed = {
        "Flight of Eagles",
        "Spirit of Eagle",
        "Pack Spirit",
        "Spirit of Wolf",
    },

    -- L07 Thistlecoat (4-6 ac, 1 ds)
    -- L17 Barbcoat (10-12 ac, 2 ds)
    -- L27 Bramblecoat (16-18 ac, 3 ds)
    -- L37 Spikecoat (23-25 ac, 4 ds)
    -- L47 Thorncoat (31 ac, 5 ds)
    -- L56 Bladecoat (37 ac, 6 ds)
    -- L64 Brackencoat (49 ac, 13 ds)
    -- L68 Nettlecoat (64 ac, 17 ds)
    -- L73 Vididicoat Rk. II (SELF, slot 2: 80 ac, slot 3: 21 ds)
    -- L78 Viridithorn Coat (SELF, slot 2: 86 ac, slot 3: 23 ds)
    -- L78 Viridithorn Coat Rk. II (SELF, slot 2: 98 ac, slot 3: 26 ds)
    dru_self_ds = {
        "Viridithorn Coat",
        "Vididicoat",
        "Nettlecoat",
        "Brackencoat",
        "Bladecoat",
        "Thorncoat",
        "Spikecoat",
        "Bramblecoat",
        "Barbcoat",
        "Thistlecoat",
    },

    -- L60 Mask of the Stalker (3 mana/tick)
    -- L65 Mask of the Forest (4 mana/tick)
    -- L70 Mask of the Wild (5 mana/tick)
    -- L80 Mask of the Shadowcat (SELF, slot 2: 9 mana/tick)
    dru_self_mana = {
        "Mask of the Shadowcat",
        "Mask of the Wild",
        "Mask of the Forest",
        "Mask of the Stalker",
    },

    -- L01 Snare
    -- L29 Ensanre
    dru_snare = {
        "Ensnare",
        "Snare",
    },


    -- fire nuke special:
    -- L70 Dawnstrike (2125 hp, cost 482 mana. chance to proc spell buff that adjust dmg of next nuke)

    -- fire nukes:
    -- L01 Burst of Flame (3-5 hp, cost 4 mana)
    -- L03 Burst of Fire (11-14 hp, cost 7 mana)
    -- L08 Ignite (38-46 hp, cost 21 mana)
    -- L28 Combust (156-182 hp, cost 85 mana)
    -- L38 Firestrike (402-422 hp, cost 138 mana)
    -- L48 Starfire (634 hp, cost 186 mana)
    -- L54 Scoriae (986 hp, cost 264 mana)
    -- L59 Wildfire (1294 hp, cost 335 mana)
    -- L60 Ancient: Starfire of Ro (1350 hp, cost 300 mana)
    -- L64 Summer's Flame (1600 hp, cost 395 mana)
    -- L65 Sylvan Fire (1761 hp, cost 435 mana)
    -- L69 Solstice Strike (2201 hp, cost 494 mana)
    dru_fire_nuke = {
        "Solstice Strike",
        "Sylvan Fire",
        "Summer's Flame",
        "Ancient: Starfire of Ro",
        "Wildfire",
        "Scoriae",
        "Starfire",
        "Firestrike",
        "Combust",
        "Ignite",
        "Burst of Fire",
        "Burst of Flame",
    },

    -- cold nukes:
    -- L47 Ice (511-538 hp, cost 142 mana)
    -- L55 Frost (837 hp, cost 202 mana)
    -- L60 Moonfire (1132 hp, cost 263 mana)
    -- L65 Winter's Frost (1375 hp, cost 305 mana)
    -- L65 Ancient: Chaos Frost (1450 hp, cost 290 mana)
    -- L70 Glitterfrost (1892 hp, cost 381 mana)
    -- L70 Ancient: Glacier Frost (2042 hp, cost 405 mana)
    dru_cold_nuke = {
        "Ancient: Glacier Frost",
        "Glitterfrost",
        "Ancient: Chaos Frost",
        "Winter's Frost",
        "Moonfire",
        "Frost",
        "Ice",
    },

    -- hot v2 - stacks with CLR/SHM/PAL HoT:
    -- L60 Nature's Recovery (slot 2: 30 hp/tick, 3.0 min, recast 90s, cost 250 mana)
    -- L63 Spirit of the Wood AA
    dru_hot_v2 = {
        "Nature's Recovery",
    },

    -- magic pbae nukes:
    -- L21 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana) Original
    -- L31 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana) Original
    -- L48 Upheaval (618-725 hp, aerange 35, recast 24, cost 625 mana) Kunark
    -- L61 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana) PoP
    -- L66 Earth Shiver (1105 hp, aerange 35, recast 24s, cost 812 mana) OOW
    dru_pbae_nuke = {
        "Earth Shiver",
        "Catastrophe",
        "Upheaval",
        "Earthquake",
        "Tremor",
    },

    -- L70 Hungry Vines (ae snare, aerange 50, recast 30s, cost 500 mana, duration 12s) OOW
    dru_pbae_snare = {
        "Hungry Vines",
    },

    -- L10 Stinging Swarm (resist -100) Original
    -- L24 Creeping Crud (resist -100) Original
    -- L32 Drones of Doom (resist -100) Original
    -- L40 Drifting Death (resist -100) Original
    -- L53 Winged Death (resist -100) Kunark
    -- L63 Swarming Death (resist -100, 216-225 hp/tick, cost 357 mana)
    -- L68 Wasp Swarm (resist -100, 283-289 hp/tick, 54s, cost 454 mana)
    dru_magic_dot = {
        "Wasp Swarm",
        "Swarming Death",
        "Winged Death",
        "Drifting Death",
        "Drones of Doom",
        "Creeping Crud",
        "Stinging Swarm",
    },

    -- L63 Eci's Frosty Breath (-55 cr, -24-30 ac, resist adj -200)
    -- L67 Glacier Breath (-55 cr, -30-36 ac, resist adj -200)
    dru_cold_debuff = {
        "Eci's Frosty Breath",
        "Glacier Breath",
    },

    -- fire dot + ac debuff:
    -- L01 Flame Lick (-1-3 hp/tick, slot 10: -3 ac) Fire Beetle Eye
    -- L62 Immolation of Ro (-145 hp/tick, -35 fr, slot 10: -27 ac, resist adj -50) PoP
    -- L65 Sylvan Embers (-132-142 hp/tick, slot 3: -40 fr, slot 10: -30 ac, resist adj -50, 1 min) GoD
    -- L67 Immolation of the Sun (-174-178 hp/tick, slot 3: -40 fr, slot 10: -36 ac, resist adj -50) OOW
    dru_ac_dot = {
        "Immolation of the Sun",
        "Sylvan Embers",
        "Immolation of Ro",
        "Flame Lick",
    },

    -- L29 Immolate (-24 hp/tick, -11-18 ac) Fire Beetle Eye
    -- L49 Vengeance of the Wild (-124 hp/tick)
    -- L55 Vengeance of Nature (resist adj -30, -170-174 hp/tick)
    -- L64 Vengeance of Tunare (-293-310 hp/tick)
    -- L69 Vengeance of the Sun (-408-412 hp/tick)
    dru_fire_dot = {
        "Vengeance of the Sun",
        "Vengeance of Tunare",
        "Vengeance of Nature",
        "Vengeance of the Wild",
        "Immolate",
    },

    -- fire debuffs (slot 7):
    -- L56 Ro's Smoldering Disjunction (-150 hp, slot 4: -58-80 atk, slot 6: -26-33 ac, slot 7: -64-71 fr) Luclin
    -- L61 Hand of Ro (slot 7: -72 fr, slot 10: -100 atk, slot 12: -15 ac, resist adj -200) PoP
    dru_fire_debuff = {
        "Hand of Ro",
        "Ro's Smoldering Disjunction",
    },

    -- L62 Ro's Illumination (slot 5: -80 atk, slot 6: -15 ac) PoP
    -- L67 Sun's Corona (FIRE: slot 5: -90 atk, slot 6: -19 ac) OOW
    dru_attack_debuff = {
        "Sun's Corona",
        "Ro's Illumination",
    },

    -- epic 1.5: Staff of Living Brambles
    -- epic 2.0: Staff of Everliving Brambles (3 min recast, increase spell damage by 50% for 0.5 min)
    dru_epic2 = {
        "Staff of Everliving Brambles",
        "Staff of Living Brambles",
    },

    -- oow t1 chest: Greenvale Jerkin (slot 1: reduce cast time by 25% for 0.5 min)
    -- oow t2 chest: Everspring Jerkin of the Tangled Briars (slot 1: reduce cast time by 25% for 0.7 min)
    dru_oow_bp = {
        "Everspring Jerkin of the Tangled Briars",
        "Greenvale Jerkin",
    },
}

SpellGroups.ENC = {
    -- L26 Clarity (7-9 mana/tick)
    -- L42 Boon of the Clear Mind (6-9 mana/tick, group)
    -- L52 Clarity II (9-11 mana/tick, single)
    -- L56 Gift of Pure Thought (10-11 mana/tick, group)
    -- L60 Koadic's Endless Intellect (14 mana/tick, group)
    -- L63 Tranquility (16 mana/tick, group)
    -- L65 Voice of Quellious (18 mana/tick, group, cost 1200 mana)
    -- L65 Dusty Cap of the Will Breaker (LDoN raid). casts "Voice of Quellious" on L01 toons
    -- L68 Clairvoyance (20 mana/tick, cost 400 mana)
    -- L70 Voice of Clairvoyance (20 mana/tick, cost 1300 mana, group)
    -- L73 Seer's Intuition (24 mana/tick, cost 480 mana)
    -- L75 Voice of Intuition Rk. II (25 mana/tick, cost 1625 mana, group)
    -- L78 Seer's Cognizance Rk. II (35 mana/tick, cost 610 mana)
    -- L80 Voice of Cognizance Rk. II (35 mana/tick, cost 1983 mana, group)
    enc_manaregen = {
        "Voice of Cognizance",
        "Voice of Intuition",
        "Voice of Clairvoyance",
        --"Dusty Cap of the Will Breaker", -- TODO make use of this clicky. make sure its picked above other spells if available. need HaveItem and NotHaveItem filters !!!
        "Voice of Quellious",
        "Tranquility",
        "Koadic's Endless Intellect",
        "Gift of Pure Thought",
        "Boon of the Clear Mind",
    },

    -- L16 Quickness (single, 28-30% haste, 5.8 min)
    -- L24 Alacrity (single, 34-40% haste, 5.8 min)
    -- L47 Swift Like the Wind (60% haste, 16 min) - L01-45
    -- L53 Aanya's Quickening  (64% haste, 24 min, DOES NOT land on lv15. DOES LAND on L42)
    -- L58 Wondrous Rapidity   (70% haste, 18.4 min)
    -- L62 Speed of Vallon     (68% haste, 41 atk, 52 agi, 33 dex, 42 min)
    -- L65 Vallon's Quickening (68% haste, 41 atk, 52 agi, 33 dex, 42 min, group)
    -- L67 Speed of Salik      (68% haste, 53 atk, 60 agi, 50 dex, 42 min 20% melee crit chance, cost 437 mana)
    -- L67 Hastening of Salik  (68% haste, 53 atk, 60 agi, 50 dex, 42 min, 20% melee crit chance, cost 1260 mana, group)
    -- L72 Speed of Ellowind   (68% haste, 64 atk, 72 agi, 60 dex, 42 min, 24% melee crit chance, %1 crit melee damage, cost 524 mana)
    -- L75 Hastening of Ellowind Rk. II (68% haste, 66 atk, 75 agi, 63 dex, 42 min, 25% melee crit chance, 2% crit melee damage, cost 1575 mana, group)
    enc_haste = {
        "Hastening of Ellowind",
        "Hastening of Salik",
        "Vallon's Quickening",
        "Speed of Vallon",
        "Wonderous Rapidity", -- NOTE: original spelling, used on some classic servers like FVP
        "Wondrous Rapidity",
        "Aanya's Quickening",
        "Swift Like the Wind",
        "Alacrity",
        "Quickness",
    },

    -- L20 Endure Magic (20 mr)
    -- L39 Resist Magic (40 mr)
    -- L49 Group Resist Magic (55 mr, group)
    -- L62 Guard of Druzzil (75 mr, group) PoP
    enc_magic_resist = {
        "Guard of Druzzil",
        "Group Resist Magic",
        "Resist Magic",
        "Endure Magic",
    },

    -- L18 Sympathetic Aura (15-18 cha)
    -- L31 Radiant Visage (25-30 cha)
    -- L46 Adorning Grace (40 cha)
    -- L56 Overwhelming Splendor (50 cha)
    enc_cha = {
        "Overwhelming Splendor",
        "Adorning Grace",
        "Radiant Visage",
        "Sympathetic Aura",
    },

    -- targeted rune - slot 1:
    -- L16 Rune I (absorb 27-55 dmg, 36 min) Original
    -- L24 Rune II (absorb 71-118 dmg, 54 min) Original
    -- L34 Rune III (absorb 168-230 dmg, 72 min) Original
    -- L44 Rune IV (absorb 305-394 dmg, 90 min) Original
    -- L52 Rune V (absorb 620-700 dmg) Kunark
    -- L61 Rune of Zebuxoruk (absorb 850 dmg) PoP
    -- L67 Rune of Salik (absorb 1105 dmg) OOW
    -- L71 Rune of Ellowind (absorb 2160 dmg) SerpentSpine
    -- L76 Rune of Erradien (absorb rk1 5363 dmg, rk2 5631 dmg) SoF
    enc_rune = {
        "Rune of Erradien/Reagent|Peridot",
        "Rune of Ellowind/Reagent|Peridot",
        "Rune of Salik/Reagent|Peridot",
        "Rune of Zebuxoruk/Reagent|Peridot",
        "Rune V/Reagent|Peridot",
        "Rune IV/Reagent|Peridot",
        "Rune III/Reagent|Jasper",
        "Rune II/Reagent|Bloodstone",
        "Rune I/Reagent|Cat's Eye Agate",
    },

    -- slot 1:
    -- L69 Rune of Rikkukin (absorb 1500 dmg, group) DoN
    -- L79 Rune of the Deep Rk. II (absorb 4118 dmg, slot 2: defensive proc Blurred Shadows Rk. II)
    enc_group_rune = {
        "Rune of the Deep",
        "Rune of Rikkukin", -- DoN progression reward
    },

    -- self rune - slot 3:
    -- L61 Arcane Rune (absorb 1500 dmg) PoP
    -- L65 Eldritch Rune AA Rank 1 (id:3258, absorb 500 dmg) PoP
    -- L65 Eldritch Rune AA Rank 2 (id:3259, absorb 1000 dmg) PoP
    -- L65 Eldritch Rune AA Rank 3 (id:3260, absorb 1500 dmg) PoP
    -- L66 Ethereal Rune (absorb 1950 dmg) OOW
    -- L66 Eldritch Rune AA Rank 4 (id:8109, absorb 1800 dmg)
    -- L67 Eldritch Rune AA Rank 5 (id:8110, absorb 2100 dmg)
    -- L68 Eldritch Rune AA Rank 6 (id:8111, absorb 2400 dmg)
    -- L69 Eldritch Rune AA Rank 7 (id:8112, absorb 2700 dmg)
    -- L70 Eldritch Rune AA Rank 8 (id:8113, absorb 3000 dmg, 10 min recast)
    enc_self_rune = {
        "Eldritch Rune",
        "Ethereal Rune",
        "Arcane Rune",
    },

    -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    -- L06 Lesser Shielding (17-30 hp, 5-9 ac, 6-10 mr)
    -- L16 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
    -- L23 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
    -- L31 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
    -- L40 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    -- L66 Mystic Shield (390 hp, 46 ac, 40 mr)
    -- NOTE: does not stack with Virtue or Focus
    enc_self_shield = {
        "Mystic Shield",
        "Shield of Maelin",
        "Shield of the Arcane",
        "Shield of the Magi",
        "Arch Shielding",
        "Greater Shielding",
        "Major Shielding",
        "Shielding",
        "Lesser Shielding",
        "Minor Shielding",
    },

    -- L04 Tashan (-9-13 mr, 10 mana) Original
    -- L20 Tashani (-20-23 mr, 20 mana) Original
    -- L44 Tashania (-31-33 mr, 30 mana) Original
    -- L57 Tashanian (-37-43 mr, 12.4 min, 40 mana) Kunark
    -- L61 Howl of Tashan (-48-50 mr, 13.6 min, cost 40 mana) PoP
    enc_tash = {
        "Howl of Tashan",
        "Tashanian",
        "Tashania",
        "Tashani",
        "Tashan",
    },

    -- L04 Mesmerize         (0.4 min/L55, 1% memblur, 20 mana, 2.25s recast) Original
    -- L16 Enthrall          (0.8 min/L55, 1% memblur, 50 mana, 2.5s recasat) Original
    -- L34 Entrance          (1.2 min/L55, 1% memblur, 85 mana, 3.75s recast) Original
    -- L49 Dazzle            (1.6 min/L55, 1% memblur, 125 mana, 5s recast) Original
    -- L54 Glamour of Kintaz (0.9 min/L57, resist adj -10, 70% memblur, 125 mana, 1.5s recast) Kunark
    -- L59 Rapture           (0.7 min/L61, resist adj -1000, 80% memblur, 250 mana, 24s recast) Kunark
    -- L61 Apathy            (0.9 min/L62, reisst adj -10, 70% memblur, 225 mana) PoP
    -- L63 Sleep             (0.9 min/L65, resist adj -10, 75% memblur, 275 mana) PoP
    -- L64 Bliss             (0.9 min/L68, resist adj -10, 80% memblur, 300 mana) PoP
    -- L67 Felicity          (0.9 min/L70, resist adj -10, 70% memblur, 340 mana) OOW
    -- L69 Euphoria          (0.9 min/L73, resist adj -10, 70% memblur, 375 mana) OOW
    enc_mez = {
        "Euphoria/MaxLevel|73",
        "Felicity/MaxLevel|70",
        "Bliss/MaxLevel|68",
        "Sleep/MaxLevel|65",
        "Apathy/MaxLevel|62",
        "Rapture/MaxLevel|61",
        "Glamour of Kintaz/MaxLevel|57",
        "Dazzle/MaxLevel|55",
        "Entrance/MaxLevel|55",
        "Enthrall/MaxLevel|55",
        "Mesmerize/MaxLevel|55",
    },

    -- L16 Mesmerization (0.4 min/L55, aerange 30, 1% memblur, cost 70 mana) Original
    -- L52 Fascination (36 sec/L55, 35 aerange resist adj -10, 1% memblur, cost 200 mana) Kunark
    -- L62 Word of Morell (0.3 min/L65, aerange 30, cost 300 mana) PoP
    -- L65 Bliss of the Nihil (0.6 min/L68, aerange 25, cost 850 mana, 6 sec recast) GoD
    -- L69 Wake of Felicity (0.9 min/L70, 25 aerange, 6 sec recast)
    enc_ae_mez = {
        "Wake of Felicity/MaxLevel|70",
        "Bliss of the Nihil/MaxLevel|68",
        "Word of Morell/MaxLevel|65",
        "Fascination/MaxLevel|55",
        "Mesmerization/MaxLevel|55",
    },

    -- L12 Languid Pace (MAGIC: 18-30% slow, 2.7 min, 50 mana) Original
    -- L24 Tepid Deeds (MAGIC: 32-50% slow, 2.7 min, 100 mana) Original
    -- L44 Shiftless Deeds (MAGIC: 49-65% slow, 2.7 min, 200 mana) Original
    -- L57 Forlorn Deeds (MAGIC: 67-70% slow, 2.9 min, 225 mana) Kunark
    -- L65 Dreary Deeds (MAGIC: 70% slow, resist adj -10, 1.5 min, cost 270 mana) GoD
    -- L69 Desolate Deeds (MAGIC: 70% slow, resist adj -30, 1.5 min, cost 300 mana) OOW
    enc_slow = {
        "Desolate Deeds",
        "Dreary Deeds",
        "Forlorn Deeds",
        "Shiftless Deeds",
        "Tepid Deeds",
        "Languid Pace",
    },

    -- L04 Enfeeblement (-18-20 str, -3 ac, cost 20 mana) Original
    -- L16 Disempower (-9-12 sta, -13-15 str, -6-9 ac) Original
    -- L25 Listless Power (-22-35 agi, -22-35 str, -10-18 ac, cost 90 mana) Original
    -- L40 Incapacitate (-45-55 agi, -45-55 str, -21-24 ac, cost 150 mana) Original
    -- L53 Cripple (-58-105 dex, -68-115 agi, -68-115 str, -30-45 ac, cost 225 mana) Kunark
    -- L66 Synapsis Spasm (-100 dex, -100 agi, -100 str, -39 ac, cost 225 mana) OOW
    enc_disempower = {
        "Synapsis Spasm",
        "Cripple",
        "Incapacitate",
        "Listless Power",
        "Disempower",
        "Enfeeblement",
    },

    -- L48 Ordinance (-1000 magic, charm/L52, 0.8 min, 5m recast)
    -- L60 Dictate (-1000 magic, charm/L58, 0.8 min, 5m recast)
    -- L70 Ancient: Voice of Muram (-1000 magic, charm/L70, 0.8 min, 5m recast)
    enc_unresistable_charm = {
        "Ancient: Voice of Muram/MaxLevel|70",
        "Dictate/MaxLevel|58",
        "Ordinance/MaxLevel|52",
    },

    -- L11 Charm (magic, charm/L25, 20.5 min)
    -- L23 Beguile (magic, charm/L37, 20.5 min)
    -- L37 Cajoling Whispers (magic, charm/L46, 20.5 min)
    -- L46 Allure (magic, charm/L51, 20.5 min)
    -- L53 Boltran's Agacerie (-10 magic, charm/L53, 7.5 min)
    -- L62 Beckon (magic, charm/L57, 7.5 min)
    -- L64 Command of Druzzil (magic, charm/L64, 7.5 min). 5s cast time, 1.5s recast
    -- L68 Compel (magic, charm/L67, 7.5 min). 5s cast time, 1.5s recast
    -- L70 True Name (magic, charm/L69, 7.5 min). 5s cast time, 1.5s recast
    enc_charm = {
        "True Name/MaxLevel|69",
        "Compel/MaxLevel|67",
        "Command of Druzzil/MaxLevel|64",
        "Beckon/MaxLevel|57",
        "Boltran's Agacerie/MaxLevel|53",
        "Allure/MaxLevel|51",
        "Cajoling Whispers/MaxLevel|46",
        "Beguile/MaxLevel|37",
        "Charm/MaxLevel|25",
    },

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
    enc_magic_nuke = {
        "Ancient: Neurosis",
        "Psychosis",
        "Ancient: Chaos Madness",
        "Madness of Ikkibi",
        "Insanity",
        "Dementing Visions",
        "Dementia",
        "Discordant Mind",
        "Anarchy",
        "Chaos Flux",
        "Sanity Warp",
        "Chaotic Feedback",
    },

    -- L69 Colored Chaos (CHROMATIC, 1600 hp, cost 425 mana)
    enc_chromatic_nuke = {
        "Colored Chaos",
    },

    -- L03 Color Flux (4s stun/L55?, aerange 20, recast 12s)
    -- L20 Color Shift (6s stun/L55?, aerange 25, recast 12s)
    -- L43 Color Skew (8s stun/L55?, aerange 30, recast 12s)
    -- L52 Color Slant (8s stun/L55?, -100 mana, aerange 35, recast 12s)
    -- L63 Color Cloud (timer 3, 8s stun/L65, aerange 30, recast 12s)   XXX best for pop stuns then!?
    -- L69 Color Snap (timer 3, 6s stun/L70, aerange 30, recast 12s)
    enc_ae_stun = {
        "Color Snap",
        "Color Cloud",
        "Color Slant",
        "Color Skew",
        "Color Shift",
        "Color Flux",
    },

    -- epic 1.5: slot 5: absorb 1500 dmg. Oculus of Persuasion (Protection of the Eye)
    -- epic 2.0: slot 5: absorb 1800 dmg. Staff of Eternal Eloquence (Aegis of Abstraction)
    enc_epic2 = {
        "Staff of Eternal Eloquence",
        "Oculus of Persuasion",
    },

    -- oow T1 bp: 30 sec, -1% spell resist rate, 5 min reuse. Charmweaver's Robe (Bedazzling Eyes)
    -- oow T2 bp: 42 sec, -1% spell resist rate, 5 min reuse. Mindreaver's Vest of Coercion (Bedazzling Aura)
    enc_oow_bp = {
        "Mindreaver's Vest of Coercion",
        "Charmweaver's Robe",
    }
}

SpellGroups.MAG = {
    -- L07 Shield of Fire (4-6 ds, 10 fr, 1.5 min, single)
    -- L19 Shield of Flame (7-9 ds, 15 fr, 15 min, single)
    -- L28 Inferno Shield (13-15 ds, 20 fr, 15 min, single)
    -- L38 Barrier of Combustion (18-20 ds, 22 fr, 15 min, single)
    -- L45 Shield of Lava (25 ds, 25 fr, 15 min, single) - L1-45
    -- L56 Cadeau of Flame (35 ds, 33 fr, 15 min, single)
    -- L61 Flameshield of Ro (48 ds, 45 fr, 15 min, single)
    -- L66 Fireskin (62 ds - slot 1, 45 fr, 15 min, single)
    mag_ds = {
        "Fireskin",
        "Flameshield of Ro",
        "Cadeau of Flame",
        "Shield of Lava",
        "Barrier of Combustion",
        "Inferno Shield",
        "Shield of Flame",
        "Shield of Fire",
    },

    -- L53 Boon of Immolation (25 ds, 25 fr, 15 min, group)
    -- L63 Maelstrom of Ro (48 ds, 45 fr, 15 min, group)
    -- L70 Circle of Fireskin (62 ds, 45 fr, 15 min, group)
    mag_group_ds = {
        "Circle of Fireskin",
        "Maelstrom of Ro",
        "Boon of Immolation",
        "Shield of Lava", -- single
    },

    -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    -- L05 Lesser Shielding (17-30 hp, 5-9 ac, 6-10 mr)
    -- L16 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
    -- L24 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
    -- L32 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
    -- L43 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    -- L66 Elemental Aura (390 hp, 46 ac, 40 mr)
    -- NOTE: does not stack with Virtue or Focus
    mag_self_shield = {
        "Elemental Aura", -- CheckFor|Elemental Empathy R.
        "Shield of Maelin",
        "Shield of the Arcane",
        "Shield of the Magi",
        "Arch Shielding",
        "Greater Shielding",
        "Major Shielding",
        "Shielding",
        "Lesser Shielding",
        "Minor Shielding",
    },

    -- L19 Elemental Shield (14-15 cr, 14-15 fr)
    -- L41 Elemental Armor (30 cr, 30 fr)
    -- L54 Elemental Cloak (45 cr, 45 fr)
    -- L61 Elemental Barrier (60 cr, 60 fr)
    -- NOTE: does not stack with druid resists
    mag_self_resist = {
        "Elemental Barrier",
        "Elemental Cloak",
        "Elemental Armor",
        "Elemental Shield",
    },

    -- L11 Burnout (15 str, 12-15% haste, 7 ac)
    -- L29 Burnout II (39-45 str, 29-35% haste, 9 ac)
    -- L47 Burnout III (50 str, 60% haste, 13 ac)
    -- LXX Elemental Empathy (x)
    -- L55 Burnout IV (60 str, 65% haste, 16 ac)
    -- L60 Ancient: Burnout Blaze (80 str, 80% haste, 22 ac, 50 atk)
    -- L62 Burnout V (80 str, 85% haste, 22 ac, 40 atk)
    -- L69 Elemental Fury (85% haste, 29 ac, 52 atk, 5% skill dmg mod)
    mag_pet_haste = {
        "Elemental Fury",
        "Burnout V",
        "Ancient: Burnout Blaze",
        "Burnout IV",
        "Elemental Empathy", -- XXX AA ?
        "Burnout III",
        "Burnout II",
        "Burnout",
    },

    -- L27 Expedience (20% movement, 12 min)
    -- L58 Velocity (59-80% movement, 36 min)
    mag_pet_runspeed = {
        "Velocity",
        "Expedience",
    },

    -- single target DD fire nukes
    -- L01 Burst of Flame
    -- L04 Burn
    -- L08 Flame Bolt
    -- L16 Shock of Flame (70 mana, 91-96 dd)
    -- L20 Bolt of Flame (105 mana, 146-156 dd)
    -- L34 Blaze
    -- L34 Cinder Bolt
    -- L49 Lava Bolt
    -- L52 Char
    -- L54 Scars of Sigil
    -- L59 Seeking Flame of Seukor
    -- L60 Shock of Fiery Blades (1294 hp, cost 335 mana)
    -- L61 Firebolt of Tallon (2100 hp, cost 515 mana)
    -- L62 Burning Sand (980 hp, cost 270 mana)
    -- L65 Sun Vortex (1600 hp, cost 395 mana)
    -- L65 Ancient: Chaos Vortex (1920 hp, cost 474 mana)
    -- L66 Bolt of Jerikor (2889 hp, cost 644 mana)
    -- L69 Burning Earth (1348 hp, 3s cast, cost 337 mana)
    -- L69 Fickle Fire (2475 hp, 6.4s cast, cost 519 mana) + chance to increase dmg
    -- L70 Spear of Ro (3119 hp, 7s cast, cost 684 mana)
    -- L70 Star Strike (2201 hp, 6.4s cast, cost 494 mana)
    -- L70 Ancient: Nova Strike (2377 hp, 6.3s cast, cost 525 mana)
    mag_fire_nuke = {
        "Ancient: Nova Strike",
        "Star Strike",
        "Spear of Ro",
        "Fickle Fire",
        "Burning Earth",
        "Bolt of Jerikor",
        "Ancient: Chaos Vortex",
        "Sun Vortex",
        "Burning Sand",
        "Firebolt of Tallon",
        "Shock of Fiery Blades",
        "Seeking Flame of Seukor",
        "Scars of Sigil",
        "Char",
        "Lava Bolt",
        "Cinder Bolt",
        "Blaze",
        "Bolt of Flame",
        "Shock of Flame",
        "Flame Bolt",
        "Burn",
        "Burst of Flame",
    },

    -- L22 Malaise (-15-20 cr, -15-20 mr, -15-20 pr, -15-20 fr, cost 60 mana)
    -- L44 Malaisement (-36-40 cr, -36-40 mr, -36-40 pr, -36-40 fr, cost 100 mana)
    -- L51 Malosi (-58-60 cr, -58-60 mr, -58-60 pr, -58-60 fr, cost 175 mana)
    -- L60 Mala (-35 cr, -35 mr, -35 pr, -35 fr, unresistable, cost 350 mana)
    -- L63 Malosinia (-70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana)
    mag_malo = {
        "Malosinia",
        "Mala",
        "Malosi",
        "Malaisement",
        "Malaise",
    },

    -- L08 Renew Elements
    -- L20 Renew Summoning
    -- Lxx Primal Remedy
    -- L59 Mend Companion AA (36 min reuse without Hastened Mending AA)
    -- L60 Transon's Elemental Renewal (849-873 hp, -20 dr pr curse, cost 237 mana)
    -- L64 Planar Renewal (1190-1200 hp, -24 dr pr curse, cost 290 mana)
    -- L69 Renewal of Jerikor (1635-1645 hp, -28 dr pr curse, cost 358 mana)
    mag_pet_heal = {
        "Renewal of Jerikor",
        "Planar Renewal",
        "Transon's Elemental Renewal",
        "Renew Summoning",
        "Renew Elements",
    },

    -- L01 Fire Flux (8-12 hp, aerange 20, recast 6s , cost 23 mana) - for PL
    -- L22 Flame Flux (89-96 hp, aerange 20, recast 6s, cost 123 mana)
    -- L39 Flame Arc (171-181 hp, aerange 20, recast 7s , cost 199 mana)
    -- L51 Scintillation (597-608 hp, aerange 25, recast 6.5s, cost 361 mana)
    -- L60 Wind of the Desert (1050 hp, aerange 25, recast 12s, cost 780 mana)
    mag_pbae_nuke = {
        "Wind of the Desert",
        "Scintillation",
        "Flame Arc",
        "Flame Flux",
        "Fire Flux",
    },

    -- epic 1.5: hp  800, mana 10/tick, hp 20/tick, proc Elemental Conjunction Strike, defensive proc Elemental Conjunction Parry (Staff of Elemental Essence)
    -- epic 2.0: hp 1000, mana 12/tick, hp 24/tick, proc Primal Fusion Strike, defensive proc Primal Fusion Parry, 20 min (34 min with ext duration) (Focus of Primal Elements)
    mag_epic2 = {
        "Focus of Primal Elements",
        "Staff of Elemental Essence",
    },

    -- oow t1 bp: Runemaster's Robe (pet buff: +50% skill dmg mod, -15% skill dmg taken for 0.3 min)
    -- oow t2 bp: Glyphwielder's Tunic of the Summoner (pet buff: +50% skill dmg mod, -15% skill dmg taken for 0.5 min)
    mag_oow_bp = {
        "Glyphwielder's Tunic of the Summoner",
        "Runemaster's Robe",
    },
}

SpellGroups.NEC = {
    -- L41 Dead Man Floating (61-70 pr, water breathing, see invis, levitate)
    nec_levitate = {
        "Dead Man Floating",
    },

    -- L45 Dead Men Floating (65-70 pr, water breathing, see invis, levitate, group)
    nec_group_levitate = {
        "Dead Men Floating",
    },

    -- lich (dont stack with clarity line):
    -- L06 Dark Pact (2 mana/tick, cost 3 hp/tick)
    -- L31 Call of Bones (8 mana/tick, cost 11 hp/tick)
    -- L48 Lich (20 mana/tick, cost 22 hp/tick)
    -- L56 Demi Lich (31 mana/tick, cost 32 hp/tick)
    -- L60 Arch Lich (35 mana/tick, cost 36 hp/tick, wraith)
    -- L64 Seduction of Saryrn (50 mana/tick, cost 42 hp/tick, skeleton)
    -- L65 Ancient: Seduction of Chaos (60 mana/tick, cost 50 hp/tick, skeleton)
    -- L70 Dark Possession (65 mana/tick, cost 57 hp/tick, skeleton, oow expansion)
    -- L70 Grave Pact (72 mana/tick, cost 60 hp/tick, skeleton, por expansion)
    -- L74 Otherside Rk. II (81 mana/tick, cost 81 hp/tick, mottled skeleton)
    -- L79 Spectralside (87 mana/tick, cost 76 hp/tick, mottled skeleton)
    nec_lich = {
        "Spectralside",
        "Otherside",
        "Grave Pact",
        "Dark Possession",
        "Ancient: Seduction of Chaos",
        "Seduction of Saryrn",
        "Arch Lich",
        "Demi Lich",
        "Lich",
        "Call of Bones",
        "Dark Pact",
    },

    -- L14 Shieldskin (absorb 27-55 dmg, reagent Cat's Eye Agate)
    -- L22 Leatherskin (absorb 71-118 dmg, reagent Bloodstone)
    -- L32 Steelskin (absorb 168-230 dmg, reagent Jasper)
    -- L52 Manaskin (absorb 521-600 dmg, 1 mana/tick, reagent Peridot)
    -- L63 Force Shield (absorb 750 dmg, 2 mana/tick)
    -- L69 Dull Pain (absorb 975 dmg, 3 mana/tick)
    -- L73 Wraithskin Rk. II (slot 1: absorb 1219 dmg, 4 mana/tick)
    -- L78 Shadowskin Rk. II (slot 1: absorb 1585 dmg, 4 mana/tick)
    -- NOTE: does not stack with ENC rune
    nec_self_rune = {
        "Shadowskin",
        "Wraithskin",
        "Dull Pain",
        "Force Shield",
        "Manaskin",
        "Steelskin",
        "Leatherskin",
        "Shieldskin",
    },

    -- L23 Intensify Death (25-33 str, 21-30% haste, 6-8 ac)
    -- L35 Augment Death (37-45 str, 45-55% haste, 9-12 ac
    -- L55 Augmentation of Death (52-55 str, 65% haste, 14-15 ac)
    -- L62 Rune of Death (65 str, 70% haste, 18 ac)
    -- L67 Glyph of Darkness (5% skills dmg mod, 84 str, 70% haste, 23 ac)
    -- L72 Sigil of the Unnatural (6% skills dmg mod, 96 str, 70% haste, 28 ac)
    -- L77 Sigil of the Aberrant Rk. II (10% skills dmg mod, 122 str, 70% haste, 36 ac)
    nec_pet_haste = {
        "Sigil of the Aberrant",
        "Sigil of the Unnatural",
        "Glyph of Darkness",
        "Rune of Death",
        "Augmentation of Death",
        "Augment Death",
        "Intensify Death",
    },

    -- L07 Mend Bones (22-32 hp)
    -- L26 Renew Bones (121-175 hp)
    -- L64 Touch of Death (1190-1200 hp, -24 dr, -24 pr, -24 curse, cost 290 mana)
    -- L69 Dark Salve (1635-1645 hp, -28 dr, -28 pr, -28 curse, cost 358 mana)
    -- L73 Chilling Renewal (2420-2440 hp, -34 dr, -34 pr, -34 curse, -8 corruption, cost 504 mana)
    nec_pet_heal = {
        "Chilling Renewal",
        "Dark Salve",
        "Touch of Death",
        "Renew Bones",
        "Mend Bones",
    },

    -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    -- L16 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
    -- L24 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
    -- L33 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
    -- L41 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    -- L66 Shadow Guard (390 hp, 46 ac, 40 mr)
    -- NOTE: does not stack with Virtue or Focus
    nec_self_shield = {
        "Shadow Guard",
        "Shield of Maelin",
        "Shield of the Arcane",
        "Shield of the Magi",
        "Arch Shielding",
        "Greater Shielding",
        "Major Shielding",
        "Shielding",
        "Lesser Shielding",
        "Minor Shielding",
    },

    -- L04 Clinging Darkness (8 hp/tick, 24-30% snare, 0.8 min, cost 20 mana)
    -- L11 Engulfing Darkness (11 hp/tick, 40% snare, 1.0 min, cost 60 mana)
    -- L27 Dooming Darkness (20 hp/tick, 48-59% snare, 1.5 min, cost 120 mana)
    -- L47 Cascading Darkness (72 hp/tick, 60% snare, 1.6 min, cost 300 mana)
    -- L59 Devouring Darkness (123 hp/tick, 69-75% snare, 1.3 min, cost 400 mana)
    -- L63 Embracing Darkness (resist adj -20, 68-70 hp/tick, 75% snare, 2.0 min, cost 200 mana)
    -- L68 Desecrating Darkness (resist adj -20, 96 hp/tick, 75% snare, 2.0 min, cost 248 mana)
    nec_snare_dot = {
        "Desecrating Darkness",
        "Embracing Darkness",
        "Devouring Darkness",
        "Cascading Darkness",
        "Dooming Darkness",
        "Engulfing Darkness",
        "Clinging Darkness",
    },

    -- L04 Poison Bolt (10 hp/tick, poison)
    -- L34 Venom of the Snake (x)
    -- L36 Chilling Embrace (100-114 hp/tick, poison)
    -- L65 Blood of Thule (350-360 hp/tick, resist adj -50, poison)
    -- L69 Corath Venom (611 hp/tick, POISON,  resist adj -50, cost 655 mana)
    -- L70 Chaos Venom (473 hp/tick, POISON, resist adj -50, cost 566 mana)
    nec_poison_dot = {
        "Chaos Venom",
        "Corath Venom",
        "Blood of Thule",
        "Chilling Embrace",
        "Venom of the Snake",
        "Poison Bolt",
    },

    -- L01 Disease Cloud (x)
    -- L13 Heart Flutter (18-22 hp/tick, -13-20 str, -7-9 ac)
    -- L35 Scrounge (x)
    -- L40 Asystole (x)
    -- L61 Dark Plague (182-190 hp/tick, resist adj -50, disease, cost 340 mana)
    -- L66 Chaos Plague (247-250 hp/tick, resist adj -50, disease)
    -- L67 Grip of Mori (194-197 hp/tick, -63-65 str, -35-36 ac, cost 325 mana)
    nec_disease_dot = {
        "Grip of Mori",
        "Chaos Plague",
        "Dark Plague",
        "Asystole",
        "Scrounge",
        "Heart Flutter",
        "Disease Cloud",
    },

    -- magic dots:
    -- L39 Dark Soul (x)
    -- L51 Splurt (x)
    -- L63 Horror (432-450 hp/tick, resist adj -30, magic, cost 450 mana)
    -- L67 Dark Nightmare (591 hp/tick, resist adj -30, magic, cost 585 mana)
    -- L70 Ancient: Curse of Mori (639 hp/tick, resist adj -30, magic, cost 625 mana)
    nec_magic_dot = {
        "Ancient: Curse of Mori",
        "Dark Nightmare",
        "Horror",
        "Splurt",
        "Dark Soul",
    },

    -- L10 Heat Blood (28-43 hp/tick)
    -- L28 Boil Blood (67 hp/tick)
    -- L47 Ignite Blood (X)
    -- L58 Pyrocruor (156-166 hp/tick)
    -- L65 Night Fire (335 hp/tick, resist adj -100)
    -- L69 Pyre of Mori (419 hp/tick, resist adj -100, cost 560 mana)
    -- L70 Dread Pyre (956 hp/tick, resist adj -100, cost 1093 mana)
    nec_fire_dot = {
        "Dread Pyre",
        "Pyre of Mori",
        "Night Fire",
        "Pyrocruor",
        "Ignite Blood",
        "Boil Blood",
        "Heat Blood",
    },

    -- duration taps (dot + heal):
    -- L09 Leech (8 hp/tick, MAGIC, resist adj -200)
    -- L29 Vampiric Curse (21 hp/tick, MAGIC, resist adj -200)
    -- L45 Auspice (30 hp/tick, DISEASE, resist adj -200)
    -- L62 Saryrn's Kiss (191-200 hp/tick, MAGIC, resist adj -200, magic, cost 550 mana)
    -- L65 Night Stalker (122 hp/tick, DISEASE, resist adj -200, cost 950 mana)
    -- L65 Night's Beckon (220 hp/tick, MAGIC resist adj -200, cost 605 mana)
    -- L68 Fang of Death (370 hp/tick, MAGIC, resist adj -200, cost 750 mana)
    nec_heal_dot = {
        "Fang of Death",
        "Night's Beckon",
        "Night Stalker",
        "Saryrn's Kiss",
        "Auspice",
        "Vampiric Curse",
        "Leech",
    },

    -- poison nukes:
    -- L21 Shock of Poison (171-210 dmg)
    -- L32 Torbas' Acid Blast (314-332 dmg)
    -- L54 Torbas' Venom Blast (688 dmg, cost 251 mana)
    -- L60 Ancient: Lifebane (1050 dmg)
    -- L61 Neurotoxin (1325 hp, cost 445 mana) PoP
    -- L66 Acikin (1823 hp, cost 556 mana) OOW
    -- L68 Call for Blood (1770 dmg, cost 568 mana) DoDH - adjusts dot dmg randomly
    -- L70 Ancient: Touch of Orshilak (-200 resist check, 1300 dmg, cost 598) OOW
    nec_poison_nuke = {
        "Call for Blood", -- better than Ancient: Touch of Orshilak
        "Ancient: Touch of Orshilak",
        "Acikin",
        "Neurotoxin",
        "Ancient: Lifebane",
        "Torbas' Venom Blast",
        "Shock of Poison",
    },

    -- L20 Word of Shadow (MAGIC, 52-58 hp, aerange 20, recast 9s, cost 85 mana)
    -- L27 Word of Spirit (MAGIC, 91-104 hp, aerange 20, recast 9s, cost 133 mana)
    -- L36 Word of Souls (MAGIC, 138-155 hp, aerange 20, recast 9s, cost 171 mana)
    nec_pbae_nuke = {
        "Word of Souls",
        "Word of Spirit",
        "Word of Shadow",
    },

    -- L10 Scent of Dusk (-6-9 fr, -6-9 pr, -6-9 dr)
    -- L37 Scent of Darkness (-23-27 fr, -23-27 pr, -23-27 dr)
    -- L52 Scent of Terris (-33-36 fr, -33-36 pr, -33-36 dr, poison)
    -- L68 Scent of Midnight (-55 dr, -55 pr, disease, resist adj -200)
    nec_scent_debuff = {
        "Scent of Midnight",
        "Scent of Terris",
        "Scent of Darkness",
        "Scent of Dusk",
    },

    -- L01 Lifetap (4-6 hp, cost 8 mana)
    -- L03 Lifespike (8-12 hp, cost 13 mana)
    -- L12 Lifedraw (102-105 hp, cost 86 mana)
    -- L20 Siphon Life (140-150 hp, cost 115 mana)
    -- L26 Spirit Tap (202-210 hp, cost 152 mana)
    -- L39 Drain Spirit (314 hp, cost 213 mana)
    -- L54 Deflux (535 hp, cost 299 mana)
    -- L59 Touch of Night (708 hp, cost 382 mana)
    -- L67 Soulspike (1204 hp, cost 563 mana)
    -- L70 Ancient: Touch of Orshilak (1300 hp, cost 598 mana)
    nec_lifetap = {
        "Ancient: Touch of Orshilak",
        "Soulspike",
        "Touch of Night",
        "Deflux",
        "Drain Spirit",
        "Spirit Tap",
        "Siphon Life",
        "Lifedraw",
        "Lifespike",
        "Lifetap",
    },

    -- L21 Rapacious Subvention (60 mana, cost 200 mana)
    -- L43 Covetous Subversion (100 mana, cost 300 mana, 8s recast)
    -- L56 Sedulous Subversion (150 mana, cost 400 mana, 8s recast)
    nec_manadump = {
        "Sedulous Subversion",
        "Covetous Subversion",
        "Rapacious Subvention",
    },

    -- epic 1.5: Soulwhisper (Servant of Blood, swarm pet)
    -- epic 2.0: Deathwhisper (Guardian of Blood, swarm pet)
    nec_epic2 = {
        "Deathwhisper",
        "Soulwhisper",
    },

    -- oow tier 1 bp: Deathcaller's Robe (increase dot dmg)
    -- oow tier 2 bp: Blightbringer's Tunic of the Grave
    new_oow_bp = {
        "Blightbringer's Tunic of the Grave",
        "Deathcaller's Robe",
    },
}

SpellGroups.WIZ = {
    -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    -- L06 Lesser Shielding (17-30 hp, 5-9 ac, 6-10 mr)
    -- L15 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
    -- L23 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
    -- L33 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
    -- L44 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    -- L66 Ether Shield (390 hp, 46 ac, 40 mr)
    -- NOTE: does not stack with Virtue or Focus
    wiz_self_shield = {
        "Ether Shield",
        "Shield of Maelin",
        "Shield of the Arcane",
        "Shield of the Magi",
        "Arch Shielding",
        "Greater Shielding",
        "Major Shielding",
        "Shielding",
        "Lesser Shielding",
        "Minor Shielding",
    },

    -- L63 Force Shield (slot 1: absorb 750 dmg, 2 mana/tick)
    -- L68 Ether Skin (slot 1: absorb 975 dmg, 3 mana/tick)
    -- L70 Shield of Dreams (slot 1: absorb 451 dmg, slot 8: +10 resists, slot 9: 3 mana/tick)
    wiz_self_rune = {
        "Shield of Dreams",
        "Ether Skin",
        "Force Shield",
    },

    -- L04 Shock of Fire (13-16 hp, cost 15 mana)
    -- L08 Fire Bolt (45-51 hp, cost 40 mana)
    -- L16 Flame Shock (102-110 hp, cost 75 mana)
    -- L29 Inferno Shock (237-250 hp, cost 135 mana)
    -- L44 Conflagration (606-625 hp, cost 250 mana)
    -- L49 Supernova (854 hp, cost 875 mana)
    -- L51 Draught of Fire (643-688 hp, cost 215 mana)
    -- L60 Sunstrike (1615 hp, resist adj -10, cost 450 mana)
    -- L62 Draught of Ro (980 hp, resist adj -50, cost 255 mana)
    -- L62 Lure of Ro (1090 hp, resist adj -300, cost 387 mana)
    -- L65 Strike of Solusek (2740 hp, resist adj -10, cost 640 mana)
    -- L65 White Fire (3015 hp, resist adj -10, cost 704 mana)
    -- L65 Ancient: Strike of Chaos (3288 hp, resist adj -10, cost 768 mana)
    -- L66 Spark of Fire (1348 hp, resist adj -50, cost 319 mana, 3s cast)
    -- L68 Firebane (1500 hp, resist adj -300, cost 456 mana, 4.5s cast)
    -- L70 Chaos Flame (random 1000 to 2000, resist adj -50, cost 275 mana, 3.0s cast)
    -- L70 Ether Flame (5848 hp, resist adj -50, cost 1550 mana, 8s cast)
    -- L70 Corona Flare (3770 hp, resist adj -10, cost 800 mana, 8s cast)
    -- L70 Ancient: Core Fire (4070 hp, resist adj -10, cost 850 mana, 8s cast)
    wiz_fire_nuke = {
        "Ancient: Core Fire",
        "Corona Flare",
        "Ether Flame",
        "Chaos Flame",
        "Firebane",
        "Spark of Fire",
        "Ancient: Strike of Chaos",
        "White Fire",
        "Strike of Solusek",
        "Lure of Ro",
        "Draught of Ro",
        "Sunstrike",
        "Draught of Fire",
        "Supernova",
        "Conflagration",
        "Inferno Shock",
        "Flame Shock",
        "Fire Bolt",
        "Shock of Fire",
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

    -- epic 1.5: Staff of Prismatic Power (-30% spell resist rate for group, -4% spell hate)
    -- epic 2.0: Staff of Phenomenal Power (-50% spell resist rate for group, -6% spell hate)
    wiz_epic2 = {
        "Staff of Phenomenal Power",
        "Staff of Prismatic Power",
    },

    -- oow T1 bp: Spelldeviser's Cloth Robe (Academic's Foresight, -25% cast time for 0.5 min, 5 min reuse)
    -- oow T2 bp: Academic's Robe of the Arcanists (Academic's Intellect, -25% cast time for 0.7 min, 5 min reuse)
    wiz_oow_bp = {
        "Academic's Robe of the Arcanists",
        "Spelldeviser's Cloth Robe",
    },
}

SpellGroups.RNG = {

    -- L01 Salve (live)
    -- L08 Minor Healing
    -- L20 Light Healing
    -- L32 Healing
    -- L44 Greater Healing (280-350 hp, cost 115 mana)
    -- L62 Chloroblast (994-1044 hp, cost 331 mana)
    -- L65 Sylvan Light (850 hp, 3s cast time, cost 370 mana)
    -- L67 Sylvan Water (1135-1165 hp, 3s cast time, cost 456 mana)
    rng_heal = {
        "Sylvan Water",
        "Sylvan Light",
        "Chloroblast",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
        "Salve",
    },

    -- hp type 2 - Slot 4: Increase max HP
    -- L51 Strength of Nature (25 atk, 75 hp, single, cost 125 mana) Velious
    -- L62 Strength of Tunare (slot 1: 92 atk, slot 4: 125 hp, group, cost 250 mana)
    -- L67 Strength of the Hunter (75 atk, 155 hp, group, cost 325 mana) NOTE: Tunare has more ATK
    rng_hp = {
        -- "Strength of the Hunter",
        "Strength of Tunare",
        "Strength of Nature",
    },

    -- L56 Mark of the Predator (slot 2: 20 atk, group)
    -- L60 Call of the Predator (slot 2: 40 atk, group)
    -- L64 Spirit of the Predator (slot 2: 70 atk, group)
    -- L69 Howl of the Predator (slot 2: 90 atk, slot 9: double atk 3-20%, group)
    rng_atk = {
        "Howl of the Predator",
        "Spirit of the Predator",
        "Call of the Predator",
        "Mark of the Predator",
    },

    -- L29 Riftwind's Protection (slot 2: 2 ds, slot 3: 11-12 ac)
    -- L50 Call of Earth (slot 2: 4 ds, slot 3: 24-25 ac)
    -- L62 Call of the Rathe (slot 2: 10 ds, slot 3: 34 ac)
    -- L67 Guard of the Earth (slot 2: 13 ds, slot 3: 49 ac)
    rng_ds = {
        "Guard of the Earth",
        "Call of the Rathe",
        "Call of Earth",
    },

    -- L07 Skin like Wood
    -- L21 Skin like Rock
    -- L38 Skin like Steel
    -- L54 Skin like Diamond
    -- L59 Skin like Nature (Velious)
    -- L65 Natureskin (18-19 ac, 391-520 hp, 4 hp/tick)
    -- L70 Onyx Skin (33 ac, 540 hp, 6 hp/tick)
    rng_skin = {
        "Onyx Skin",
        "Natureskin",
        "Skin like Nature",
        "Skin like Diamond",
        "Skin like Steel",
        "Skin like Rock",
        "Skin like Wood",
    },

    -- L13 Thistlecoat
    -- L30 Barbcoat
    -- L34 Bramblecoat
    -- L42 Spikecoat
    -- L60 Thorncoat
    -- L63 Bladecoat (slot 2: 37 ac, slot 3: 6 ds)
    -- L68 Briarcoat (slot 2: 49 ac, slot 3: 8 ds)
    rng_self_ds = {
        "Briarcoat",
        "Bladecoat",
        "Thorncoat",
        "Spikecoat",
        "Bramblecoat",
        "Barbcoat",
        "Thistlecoat",
    },

    -- L65 Protection of the Wild (slot 1: 34 ds, slot 2: 130 atk, slot 3: 34 ac, slot 4: 125 hp)
    -- L70 Ward of the Hunter     (slot 1: 45 ds, slot 2: 170 atk, slot 3: 49 ac, slot 4: 165 hp, slot 9: 3% double attack)
    rng_self_ds_atk = {
        "Ward of the Hunter",
        "Protection of the Wild",
    },

    -- L65 Mask of the Stalker (slot 3: 3 mana regen)
    rng_self_mana = {
        "Mask of the Stalker",
    },

    -- L09 Snare
    -- L51 Ensanre
    rng_snare = {
        "Ensnare",
        "Snare",
    },

    -- epic 1.5: Heartwood Blade (critical melee chance 110%, accuracy 110%)
    -- epic 2.0: Aurora, the Heartwood Blade (critical melee chance 170%, accuracy 170%, 1 min duration, 5 min recast)
    rng_epic2 = {
        "Aurora, the Heartwood Blade",
        "Heartwood Blade",
    },

    -- oow T1 bp: Sunrider's Vest (slot 3: Add Proc: Minor Lightning Call Effect for 0.3 min)
    -- oow T2 bp: Bladewhisper Chain Vest of Journeys (slot 3: Add Proc: Major Lightning Call Effect for 0.5 min)
    rng_oow_bp = {
        "Bladewhisper Chain Vest of Journeys",
        "Sunrider's Vest",
    },
}

SpellGroups.PAL = {

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
    pal_heal = {
        "Light of Piety",
        "Light of Order",
        "Touch of Nife",
        "Superior Healing",
        "Light of Life",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
        "Salve",
    },

    pal_group_heal = { -- TODO make use of
        "Wave of Piety",            -- PAL/70: 1316 hp, cost 1048 mana
        "Wave of Trushar",          -- PAL/65: 1143 hp, cost 921 mana
        "Wave of Marr",             -- PAL/65: 960 hp, cost 850 mana
        "Healing Wave of Prexus",   -- PAL/58: 688-698 hp, cost 698 mana
        "Wave of Healing",          -- PAL/55: 439-489 hp, cost 503 mana
        "Wave of Life",             -- PAL/39: 201-219 hp, cost 274 mana
    },

    -- L44 Ethereal Cleansing (98-100 hp/tick, 30s recast, cost 150 mana)
    -- L59 Celestial Cleansing (175 hp/tick, 30s recast, cost 225 mana)
    -- L64 Supernal Cleansing (300 hp/tick, 30s recast, cost 360 mana)
    -- L69 Pious Cleansing (585 hp/tick, 30s recast, cost 668 mana)
    pal_hot = {
        "Pious Cleansing",
        "Supernal Cleansing",
        "Celestial Cleansing",
        "Ethereal Cleansing",
    },

    -- hp type 2 buff:
    -- L35 Divine Vigor (100 hp) Luclin
    -- L49 Brell's Steadfast Aegis (145 hp, group) PoP
    -- L60 Brell's Mountainous Barrier (225 hp, group) Luclin
    -- L65 Brell's Stalwart Shield (330 hp, group) PoP
    -- L70 Brell's Brawny Bulwark (412 hp, group) OOW
    pal_hp = {
        "Brell's Brawny Bulwark",
        "Brell's Stalwart Shield",
        "Brell's Mountainous Barrier",
        "Brell's Steadfast Aegis",
    },

    -- L24 Symbol of Transal
    -- L33 Symbol of Ryltan
    -- L46 Symbol of Pinzarn
    -- L63 Symbol of Marzin
    -- L67 Symbol of Jeron
    -- L68 Jeron's Mark (group)
    pal_symbol = {
        "Jeron's Mark",
        "Symbol of Jeron",
        "Symbol of Marzin",
        "Symbol of Pinzarn",
        "Symbol of Ryltan",
        "Symbol of Transal",
    },

    -- L64 Aura of the Crusader (slot 2: 30 ac, slot 3: 342-350 hp, slot 4: 3 mana/tick)
    -- L69 Armor of the Champion (slot 2: 39 ac, slot 3: 437 hp, slot 4: 4 mana/tick)
    pal_self_shield = {
        "Armor of the Champion",
        "Aura of the Crusader",
    },

    -- proc self buffs:
    -- L26 Instrument of Nife (UNDEAD: proc Condemnation of Nife)
    -- L45 Divine Might (proc Divine Might Effect)
    -- L62 Ward of Nife (UNDEAD: proc Ward of Nife Strike)
    -- L63 Pious Might (proc Pious Might Strike)
    -- L65 Holy Order (proc Holy Order Strike)
    -- L67 Silvered Fury (proc Silvered Fury Strike)
    -- L68 Pious Fury (slot 1: proc Pious Fury Strike)
    pal_proc_buff = {
        "Pious Fury",
        "Silvered Fury",
        "Holy Order",
        "Pious Might",
        "Ward of Nife",
        "Divine Might",
        "Instrument of Nife",
    },

    -- L09 Yaulp
    -- L39 Yaulp II
    -- L56 Yaulp III
    -- L60 Yaulp IV
    pal_yaulp = {
        "Yaulp IV",
        "Yaulp III",
        "Yaulp II",
        "Yaulp"
    },

    -- OOW T1 bp: Oathbound Breastplate (proc Minor Pious Shield Effect, 0.2 min)
    -- OOW T1 bp: Dawnseeker's Chestpiece of the Defender (proc Minor Pious Shield Effect, 0.4 min)
    pal_oow_bp = {
        "Dawnseeker's Chestpiece of the Defender",
        "Oathbound Breastplate",
    },
}

SpellGroups.SHD = {
    -- Combat Innates:
    -- L22 Vampiric Embrace (proc: Vampiric Embrace)
    -- L37 Scream of Death (proc: Scream of Death Strike)
    -- L67 Shroud of Discord (proc: Shroud of Discord Strike, 60 min duration) - imbues attacks with chance to steal life from target (lifetap)
    -- L70 Decrepit Skin (slot 1: proc Decrepit Skin Parry, 4 min duration) - absorb dmg
    shd_combat_innate = {
        "Decrepit Skin",
        "Shroud of Discord",
        "Scream of Death",
        "Vampiric Embrace",
    },

    -- skeleton illusion with regen:
    -- L58 Deathly Temptation (6 mana/tick, -11 hp/tick)
    -- L64 Pact of Hate (15 mana/tick, -22 hp/tick)
    -- L69 Pact of Decay (17 mana/tick, -25 hp/tick)
    -- NOTE: does not stack with ENC Clairvoyance (20 mana/tick)
    shd_lich = {
        "Pact of Decay",
        "Pact of Hate",
        "Deathly Temptation",
    },

    -- L60 Cloak of the Akheva (slot 3: 13 ac, slot 6: 5 ds, slot 10: 150 hp)
    -- L65 Cloak of Luclin (slot 3: 34 ac, slot 6: 10 ds, slot 10: 280 hp)
    -- L70 Cloak of Discord (slot 3: 49 ac, slot 6: 13 ds, slot 10: 350 hp)
    shd_self_shield = {
        "Cloak of Discord",
        "Cloak of Luclin",
        "Cloak of the Akheva",
    },

    -- epic 1.5 (30% accuracy for group, 35% melee lifetap. 10 min reuse) Innoruuk's Voice
    -- epic 2.0 (40% accuracy for group, 50% melee lifetap. 5 min reuse) Innoruuk's Dark Blessing
    shd_epic2 = {
        "Innoruuk's Dark Blessing",
        "Innoruuk's Voice",
    },

    -- oow t1 bp: Heartstiller's Mail Chestguard - Lifetap from Weapon Damage (15) for 2 ticks
    -- oow t2 bp: Duskbringer's Plate Chestguard of the Hateful - Lifetap from Weapon Damage (15) for 4 ticks. 5 min reuse
    shd_oow_bp = {
        "Duskbringer's Plate Chestguard of the Hateful",
        "Heartstiller's Mail Chestguard",
    },
}

SpellGroups.BST = {
    -- mana regen:
    -- L41 Spiritual Light (3 hp + 3 mana/tick, group)
    -- L52 Spiritual Radiance (5 hp + 5 mana/tick, group)
    -- L59 Spiritual Purity (7 hp + 7 mana/tick, group)
    -- L64 Spiritual Dominion (9 hp + 9 mana/tick, group)
    -- L69 Spiritual Ascendance (10 hp + 10 mana/tick, group, cost 900 mana)
    bst_manaregen = {
        "Spiritual Ascendance",
        "Spiritual Dominion",
        "Spiritual Purity",
        "Spiritual Radiance",
        "Spiritual Light",
    },

    -- hp type 2 - Slot 4: Increase max HP:
    -- L42 Spiritual Brawn (10 atk, 75 hp)
    -- L60 Spiritual Strength (25 atk, 150 hp)
    -- L62 Spiritual Vigor (40 atk, 225 hp, group)
    -- L67 Spiritual Vitality (52 atk, 280 hp, group)
    -- NOTE: RNG buff has more atk
    bst_hp = {
        "Spiritual Vitality",
        "Spiritual Vigor",
        "Spiritual Strength",
        "Spiritual Brawn",
    },

    -- L60 Alacrity (32-40% haste, 11 min)
    -- L63 Celerity (47-50% haste, 16 min)
    bst_haste = {
        "Celerity",
        "Alacrity",
    },

    -- weak focus - HP slot 1: Increase Max HP
    -- L53 Talisman of Tnarg (132-150 hp)
    -- L58 Talisman of Altuna (230-250 hp)
    -- L62 Talisman of Kragg (365-500 hp)
    -- L67 Focus of Alladnu (513 hp)
    bst_focus = {
        "Focus of Alladnu",
        "Talisman of Kragg",
        "Talisman of Altuna",
        "Talisman of Tnarg",
    },

    -- L17 Spirit of Bear (11-15 sta)
    -- L37 Spirit of Ox (19-23 sta)
    -- L52 Health (27-31 sta)
    -- L57 Stamina (36-40 sta)
    bst_sta = {
        "Stamina",
        "Health",
        "Spirit of Ox",
        "Spirit of Bear",
    },

    -- L14 Strengthen (5-10 str)
    -- L28 Spirit Strength (16-18 str)
    -- L41 Raging Strength (23-26 str)
    -- L54 Furious Strength (31-34 str)
    bst_str = {
        "Furious Strength",
        "Raging Strength",
        "Spirit Strength",
        "Strengthen",
    },

    -- L38 Spirit of Monkey (19-20 dex)
    -- L53 Deftness (40 dex)
    -- L57 Dexterity (49-50 dex) - blocked by Khura's Focusing (60 dex)
    bst_dex = {
        "Dexterity",
        "Deftness",
        "Spirit of Monkey",
    },

    -- L47 Frenzy (6-10 ac, 18-25 agi, 19-28 str, 25 dex, 10 min)
    -- L61 Growl of the Leopard (15% skill damage mod, 80 hp/tick, max hp 850, 1 min, cost 500 mana)
    -- L65 Ferocity (40 sta, 150 atk, 65 all resists, 6.5 min)
    -- L70 Ferocity of Irionu (52 sta, 187 atk, 65 all resists, 6.5 min, 2 min recast)
    bst_ferocity = {
        "Ferocity of Irionu",
        "Ferocity",
        "Growl of the Leopard",
        "Frenzy",
    },

    -- L37 Yekan's Quickening (43-45 str, 60% haste, 20 atk, 11-12 ac)
    -- L52 Bond of the Wild (51-55 str, 60% haste, 25 atk, 13-15 ac)
    -- L55 Omakin's Alacrity (60 str, 65-70% haste, 40 atk, 30 ac)
    -- L59 Sha's Ferocity (99-100 str, 84-85% haste, 60 atk, 60 ac)
    -- L64 Arag's Celerity (115 str, 85% haste, 75 atk, 71 ac)
    -- L68 Growl of the Beast (85% haste, 90 atk, 78 ac, 5% skill dmg mod, duration 1h)
    bst_pet_haste = {
       "Growl of the Beast",
       "Arag's Celerity",
       "Sha's Ferocity",
       "Omakin's Alacrity",
       "Bond of the Wild",
       "Yekan's Quickening",
    },

    -- L13 Spirit of Lightning (Spirit of Lightning Strike proc)
    -- L28 Spirit of Inferno (Spirit of Inferno Strike proc)
    -- L38 Spirit of the Scorpion (Spirit of Scorpion Strike proc)
    -- L46 Spirit of Vermin (Spirit of Vermin Strike proc)
    -- L51 Spirit of Wind (Spirit of Wind Strike proc, rate mod 150)
    -- L53 Spirit of the Storm (Spirit of Storm Strike, rate mod 150)
    -- L54 Spirit of Snow (Spirit of Snow Strike, rate mod 150)
    -- L56 Spirit of Flame (FIRE: Spirit of Flame Strike, rate mod 150)
    -- L63 Spirit of Rellic (COLD: Spirit of Rellic Strike, rate mod 150)
    -- L68 Spirit of Irionu (COLD: Spirit of Irionu Strike, rate mod 150, 75 dex)
    -- L70 Spirit of Oroshar (FIRE: Spirit of Oroshar Strike, rate mod 150, 75 dex)
    bst_pet_proc = {
        "Spirit of Oroshar",
        "Spirit of Irionu",
        "Spirit of Rellic",
        "Spirit of Flame",
        "Spirit of Snow",
        "Spirit of the Storm",
        "Spirit of Wind",
        "Spirit of Vermin",
        "Spirit of the Scorpion",
        "Spirit of Inferno",
        "Spirit of Lightning",
    },

    -- L09 Sharik's Replenishing
    -- L15 Keshuval's Rejuvenation
    -- L27 Herikol's Soothing (274-298 hp, decrease dr 10, pr 10, cr 10)
    -- L36 Yekan's Recovery
    -- L49 Vigor of Zehkes (671 hp, decrease dr 10, pr 10, cr 10, cost 206 mana)
    -- L52 Aid of Khurenz (1044 hp, decrease dr 16, pr 16, cr 16, cost 293 mana)
    -- L55 Sha's Restoration (1426-1461 hp, decrease dr 20, pr 20, cr 20, cost 404 mana)
    -- L61 Healing of Sorsha (2018-2050 hp, decrease dr 24, pr 24, cr 24, cost 495 mana)
    -- L66 Healing of Mikkily (2810 hp, decrease dr 28, pr 28, cr 28, cost 610 mana)
    bst_pet_heal = {
        "Healing of Mikkily",
        "Healing of Sorsha",
        "Sha's Restoration",
        "Aid of Khurenz",
        "Vigor of Zehkes",
        "Yekan's Recovery",
        "Herikol's Soothing",
        "Keshuval's Rejuvenation",
        "Sharik's Replenishing",
    },

    -- ice nukes:
    -- L12 Blast of Frost (71 hp, cost 40 mana)
    -- L26 Spirit Strike (72-78 hp, cost 44 mana)
    -- L33 Ice Spear (207 hp, cost 97 mana)
    -- L47 Frost Shard (281 hp, cost 119 mana)
    -- L54 Ice Shard (404 hp, cost 156 mana)
    -- L59 Blizzard Blast (332-346 hp, cost 147 mana)
    -- L63 Frost Spear (600 hp, cost 235 mana)
    -- L65 Trushar's Frost (742 hp, cost 274 mana)
    -- L65 Ancient: Frozen Chaos (836 hp, cost 298 mana)
    -- L69 Glacier Spear (958 hp, cost 310 mana)
    -- L70 Ancient: Savage Ice (1034 hp, cost 329 mana, 30s recast)
    bst_ice_nuke = {
        "Ancient: Savage Ice",
        "Glacier Spear",
        "Ancient: Frozen Chaos",
        "Trushar's Frost",
        "Frost Spear",
        "Blizzard Blast",
        "Ice Shard",
        "Frost Shard",
        "Ice Spear",
        "Spirit Strike",
        "Blast of Frost",
    },

    -- slow:
    -- L65 Sha's Revenge (MAGIC, 65% slow, 3m30s duration)
    -- L70 Sha's Legacy (MAGIC -30 adj, 65% slow, 1m30s duration)
    bst_slow = {
        "Sha's Legacy",
        "Sha's Revenge",
    },

    -- L06 Minor Healing (12-20 hp, cost 10 mana)
    -- L20 Light Healing (47-65 hp, cost 28 mana)
    -- L36 Healing (135-175 hp, cost 65 mana)
    -- L57 Greater Healing (280-350 hp, cost 115 mana)
    -- L62 Chloroblast (994-1044 hp, cost 331 mana)
    -- L65 Trushar's Mending (1048 hp, cost 330 mana)
    -- L67 Muada's Mending (1176-1206 hp, cost 376 mana, 3s cast time)
    bst_heal = {
        "Muada's Mending",
        "Trushar's Mending",
        "Chloroblast",
        "Greater Healing",
        "Healing",
        "Light Healing",
        "Minor Healing",
    },

    -- L19 Tainted Breath (14-19/tick, poison)
    -- L35 Envenomed Breath (59-71/tick, poison, cost 181 mana)
    -- L52 Venom of the Snake (104-114 hp/tick, poison, cost 172 mana)
    -- L61 Scorpion Venom (162-170/tick, poison, cost 350 mana)
    -- L65 Turepta Blood (168/tick, poison, cost 377 mana)
    bst_posion_dot = {
        "Turepta Blood",
        "Scorpion Venom",
        "Venom of the Snake",
        "Envenomed Breath",
        "Tainted Breath",
    },

    -- L14 Sicken (3-5/tick, disease)
    -- L65 Plague (74-79 hp/tick, disease, cost 172 mana)
    bst_disease_dot = {
        "Plague",
        "Sicken",
    },

    -- epic 1.5: Savage Lord's Totem (pet buff: double attack 5%, evasion 10%, hp 800, proc Savage Blessing Strike)
    -- epic 2.0: Spiritcaller Totem of the Feral (pet buff: double attack 8%, evasion 12%, hp 1000, proc Wild Spirit Strike)
    bst_epic2 = {
        "Spiritcaller Totem of the Feral",
        "Savage Lord's Totem",
    },

    -- oow T1 bp: Beast Tamer's Jerkin (Wild Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 18s)
    -- oow T2 bp: Savagesoul Jerkin of the Wilds (Savage Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 30s)
    bst_oow_bp = {
        "Savagesoul Jerkin of the Wilds",
        "Beast Tamer's Jerkin",
    }
}

SpellGroups.BRD = {
    -- L05 Selo's Accelerando (20-65% movement)
    brd_runspeed = {
        "Selo's Accelerando",
    },

    -- L51 Selo's Song of Travel (levi + invis)
    brd_travel = {
        "Selo's Song of Travel",
    },

    -- epic 1.5: slot 9: spell crit  8%, slot 10: dot crit  8%, slot 12: accuracy 130% (Prismatic Dragon Blade)
    -- epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140% (Blade of Vesagran)
    brd_epic2 = {
        "Blade of Vesagran",
        "Prismatic Dragon Blade",
    },

    -- oow T1 bp: increase double attack by  30% for 12s, 5 min reuse (Traveler's Mail Chestguard)
    -- oow T2 bp: increase double attack by 100% for 24s, 5 min reuse (Farseeker's Plate Chestguard of Harmony)
    brd_oow_bp = {
        "Farseeker's Plate Chestguard of Harmony",
        "Traveler's Mail Chestguard",
    },
}

SpellGroups.WAR = {
    -- epic 1.5: Champion's Sword of Eternal Power (group 600 hp)
    -- epic 2.0: Kreljnok's Sword of Eternal Power (group 800 hp)
    war_epic2 = {
        "Kreljnok's Sword of Eternal Power",
        "Champion's Sword of Eternal Power",
    },

    -- oow T1 bp: Armsmaster's Breastplate - reduce damage taken for 12s
    -- oow T2 bp: Gladiator's Plate Chestguard of War - reduce damage taken for 24s
    war_oow_bp = {
        "Gladiator's Plate Chestguard of War",
        "Armsmaster's Breastplate",
    },
}

SpellGroups.ROG = {
    -- epic 1.5: Fatestealer (35% triple backstab, Assassin's Taint Strike proc)
    -- epic 2.0: Nightshade, Blade of Entropy (45% triple backstab, Deceiver's Blight Strike proc)
    rog_epic2 = {
        "Nightshade, Blade of Entropy",
        "Fatestealer",
    },

    -- oow T1 bp: (increase 1hb dmg   taken by 20% for 12s, 5 min reuse) Darkraider's Vest
    -- oow T2 bp: (increase all melee taken by 20% for 24s, 5 min reuse) Whispering Tunic of Shadows
    rog_oow_bp = {
        "Whispering Tunic of Shadows",
        "Darkraider's Vest",
    },
}

SpellGroups.BER = {
    -- epic 1.5: Raging Taelosian Alloy Axe (+75 str, +75 str cap, +200% melee crit chance, +75 hot heal)
    -- epic 2.0: Vengeful Taelosian Blood Axe (+100 str, +100 str cap, 300% melee crit chance, 100 hot heal)
    ber_epic2 = {
        "Vengeful Taelosian Blood Axe",
        "Raging Taelosian Alloy Axe",
    },

    -- oow T1 bp: Ragebound Chain Chestguard (increase melee chance to hit by 40% for 12s)
    -- oow T2 bp: Wrathbringer's Chain Chestguard of the Vindicator (increase melee chance to hit by 40% for 24s)
    ber_oow_bp = {
        "Wrathbringer's Chain Chestguard of the Vindicator",
        "Ragebound Chain Chestguard",
    }
}

SpellGroups.MNK = {
    -- epic 1.5: Fistwraps of Celestial Discipline (15% max hp, +10000 hp, add proc Peace of the Order Strike, 0.5 min, 6 min recast)
    -- epic 2.0: Transcended Fistwraps of Immortality (25% max hp, +10000 hp, add proc Peace of the Disciple Strike, 0.5 min, 3 min recast)
    mnk_epic2 = {
        "Transcended Fistwraps of Immortality",
        "Fistwraps of Celestial Discipline",
    },
    -- oow bp t1: Stillmind Tunic (cancel beneficial buffs)
    -- oow bp t2: Fiercehand Shroud of the Focused (cancel beneficial buffs)
    mnk_oow_bp = {
        "Fiercehand Shroud of the Focused",
        "Stillmind Tunic",
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
    "shm_haste/Class|SHM/NotClass|ENC",

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
