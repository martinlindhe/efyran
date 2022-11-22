local GroupBuffs = {} -- XXX the name is misleading, it is both group and single target buffs

GroupBuffs.Lookup = {
    ["shm_focus"] = "SHM",
    ["shm_runspeed"] = "SHM",
    ["shm_haste"] = "SHM",
    ["shm_resist"] = "SHM",
    ["shm_sta"] = "SHM",
    ["shm_str"] = "SHM",
    ["shm_agi"] = "SHM",
    ["shm_dex"] = "SHM",
    ["shm_cha"] = "SHM",

    ["clr_symbol"] = "CLR",
    ["clr_ac"] = "CLR",
    ["clr_aegolism"] = "CLR",
    ["clr_vie"] = "CLR",
    ["clr_spellhaste"] = "CLR",

    ["dru_skin"] = "DRU",
    ["dru_fire_resist"] = "DRU",
    ["dru_cold_resist"] = "DRU",
    ["dru_corruption"] = "DRU",
    ["dru_regen"] = "DRU",
    ["dru_ds"] = "DRU",
    ["dru_str"] = "DRU",
    ["dru_skill_dmg_mod"] = "DRU",
    ["dru_runspeed"] = "DRU",

    ["enc_manaregen"] = "ENC",
    ["enc_haste"] = "ENC",
    ["enc_resist"] = "ENC",
    ["enc_cha"] = "ENC",
    ["enc_group_rune"] = "ENC",
    ["enc_single_rune"] = "ENC",

    ["mag_group_ds"] = "MAG",
    ["mag_single_ds"] = "MAG",

    ["nec_group_levitate"] = "NEC",
    ["nec_single_levitate"] = "NEC",

    ["rng_hp"] = "RNG",
    ["rng_atk"] = "RNG",
    ["rng_ds"] = "RNG",
    ["rng_skin"] = "RNG",

    ["pal_hp"] = "PAL",
    ["pal_symbol"] = "PAL",

    ["bst_manaregen"] = "BST",
    ["bst_hp"] = "BST",
    ["bst_haste"] = "BST",
    ["bst_focus"] = "BST",
    ["bst_sta"] = "BST",
    ["bst_str"] = "BST",
    ["bst_dex"] = "BST",
}

GroupBuffs.SHM = {
    -- weak focus - HP slot 1: Increase Max HP
    -- L32 Talisman of Tnarg (132-150 hp)
    -- L40 Talisman of Altuna (230-250 hp)
    -- L55 Talisman of Kragg (365-500 hp)

    -- focus - HP Slot 1: Increase Max HP + stats
    -- L46 Harnessing of Spirit (243-251 hp, 67 str, 50 dex, cost 425 mana)
    -- L60 Focus of Spirit (405-525 hp, 67 str, 60 dex, cost 500 mana)
    -- L60 Khura's Focusing (430-550 hp, 67 str, 60 dex, cost 1250 mana, group)
    -- L62 Focus of Soul (544 hp, 75 str, 70 dex, cost XXX mana)
    -- L65 Focus of the Seventh (544 hp, 75 str, 70 dex, cost 1800 mana, group)
    -- L68 Wunshi's Focusing (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 780 mana)
    -- L70 Talisman of Wunshi (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 2340 mana)
    ["shm_focus"] = {
        "Harnessing of Spirit/MinLevel|1",
        "Khura's Focusing/MinLevel|45",
        "Focus of the Seventh/MinLevel|47",
        "Talisman of Wunshi/MinLevel|62",
    },

    -- L09 Spirit of Wolf (48-55% speed, 36 min)
    -- L36 Spirit of Bih`Li (48-55% run speed, 15 atk, 36 min, group)
    ["shm_runspeed"] = {
        "Spirit of Bih`Li/MinLevel|1/CheckFor|Flight of Eagles",
    },

    -- L26 Quiuckness (27--30% haste, 11 min)
    -- L42 Alacrity (32-40% haste, 11 min)
    -- L56 Celerity (47-50% haste, 16 min)
    -- L63 Swift Like the Wind (60% haste, 16 min)
    -- L64 Talisman of Celerity (60% haste, 36 min, group)
    ["shm_haste"] = {
        "Alacrity/MinLevel|1",
        "Celerity/MinLevel|43",
        "Swift Like the Wind/MinLevel|46",
        "Talisman of Celerity/MinLevel|47/CheckFor|Hastening of Salik",
    },

    -- L50 Talisman of Jasinth (45 dr, group)
    -- L53 Talisman of Shadoo (45 pr, group)
    -- L58 Talisman of Epuration (55 dr, 55 pr, group)
    -- L62 Talisman of the Tribunal (65 dr, 65 pr, group)
    ["shm_resist"] = {
        "Talisman of Jasinth/MinLevel|1",
        "Talisman of Epuration/MinLevel|44",
        "Talisman of the Tribunal/MinLevel|46",
    },

    -- L23 Regeneration (5 hp/tick, 17.5 min, cost 100 mana)
    -- L39 Chloroplast (10 hp/tick, 17.5 min, cost 200 mana)
    -- L52 Regrowth (20 hp/tick, 17.5 min, cost 300 mana)
    -- L61 Replenishment (40 hp/tick, 20.5 min, cost 275 mana)
    -- L63 Blessing of Replenishment (40 hp/tick, 20.5 min, cost 650 mana, group)
    -- L66 Spirit of Perseverance (60 hp/tick, 21 min, cost 343 mana)
    -- L69 Talisman of Perseverance (60 hp/tick, 20.5 min, cost 812 mana, group)
    ["shm_regen"] = {
        "Chloroplast/MinLevel|1",
        "Regrowth/MinLevel|41",
        "Replenishment/MinLevel|45",
        "Spirit of Perseverance/MinLevel|62",
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
    ["shm_ac"] = {
        "Guardian/MinLevel|1",
        "Shroud of the Spirits/MinLevel|42",
        "Ancestral Guard/MinLevel|46",
        "Ancestral Bulwark/MinLevel|62",
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
    ["shm_sta"] = {
        "Stamina/MinLevel|1",
        "Talisman of the Brute/MinLevel|43",
        "Talisman of the Boar/MinLevel|46",
        "Talisman of Fortitude/MinLevel|62",
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
    ["shm_str"] = {
        "Strength/MinLevel|1",
        "Maniacal Strength/MinLevel|43",
        "Talisman of the Rhino/MinLevel|44",
        "Talisman of the Diaku/MinLevel|47",
        "Talisman of Might/MinLevel|62",
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
    ["shm_agi"] = {
        "Agility/MinLevel|1",
        "Deliriously Nimble/MinLevel|41",
        "Talisman of the Cat/MinLevel|43",
        "Talisman of the Wrulan/MinLevel|46",
    },

    -- DEX - affects bard song missed notes, procs & crits
    -- L01 Dexterous Aura (5-10 dex)
    -- L21 Spirit of Monkey (19-20 dex)
    -- L25 Rising Dexterity (26-30 dex)
    -- L39 Deftness (40 dex)
    -- L48 Dexterity (49-50 dex) - blocked by Khura's Focusing (60 dex)
    -- L58 Mortal Deftness (60 dex)
    -- L59 Talisman of the Raptor (60 dex, group)
    ["shm_dex"] = {
        "Dexterity/MinLevel|1",
        "Talisman of the Raptor/MinLevel|44",
    },

    -- CHA - affects sale prices and DI success rate
    -- L10 Spirit of Snake (11-15 cha)
    -- L28 Alluring Aura (20-23 cha)
    -- L37 Glamour (28-32 cha)
    -- L47 Charisma (40 cha)
    -- L58 Talisman of the Serpent (40 cha, group)
    -- L59 Unfailing Reverence (55 cha)
    ["shm_cha"] = {
        "Charisma/MinLevel|1",
        "Unfailing Reverence/MinLevel|44",
    },
}

GroupBuffs.GroupHealSpells = {
    -- priority: the first spell in list that is memorized and not on cooldown will be used

    -- CLR - cast group heals with cure component
    "Word of Vivification",     -- CLR/69: 3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana
    "Word of Replenishment",    -- CLR/64: 2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana
    "Word of Redemption",       -- CLR/60: 7500 hp, cost 1100 mana
    "Word of Restoration",      -- CLR/57: 1788-1818 hp, cost 898 mana
    "Word of Health",           -- CLR/30: 380-485 hp, cost 302 mana

    "Hand of Piety",            -- PAL/??: AA Rank 1-XXX (24 min reuse with Hastened Piety Rank 3)
    "Wave of Piety",            -- PAL/70: 1316 hp, cost 1048 mana
    "Wave of Trushar",          -- PAL/65: 1143 hp, cost 921 mana
    "Wave of Marr",             -- PAL/65: 960 hp, cost 850 mana
    "Healing Wave of Prexus",   -- PAL/58: 688-698 hp
    "Wave of Healing",          -- PAL/55: 439-489 hp
    "Wave of Life",             -- PAL/39: 201-219 hp

    -- "Moonshadow",               -- DRU/70: 1500 hp, cost 1100 mana (18s recast time)
}

GroupBuffs.CLR = {
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
    -- L80 Kaerra's Mark (1563 hp, cost 3130 mana)
    -- NOTE: stacks with DRU Skin and AC
    clr_symbol = {
        "Symbol of Naltron/MinLevel|1", -- single
        "Symbol of Marzin/MinLevel|42", -- single
        "Naltron's Mark/MinLevel|44",
        "Kazad's Mark/MinLevel|46",
        "Balikor's Mark/MinLevel|62",
        "Elushar's Mark/MinLevel|71", -- XXX unsure of minlevel
        "Kaerra's Mark/MinLevel|76", -- XXX unsure of minlevel
    },

    -- L61 Ward of Gallantry (slot 4: 54 ac)
    -- L66 Ward of Valiance (slot 4: 72 ac)
    -- L71 Ward of the Dauntless (slot 4: 86 ac)
    -- L76 Ward of the Resolute Rk. II (solt 4: 109 ac)
    -- L80 Order of the Resolute Rk. II (slot 4: 109 ac, group)
    -- NOTE: stacks with Symbol + DRU Skin + Focus
    ["clr_ac"] = {
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
    ["clr_aegolism"] = {
        "Blessing of Temperance/MinLevel|1",
        "Blessing of Aegolism/MinLevel|45",
        "Hand of Virtue/MinLevel|47",
        "Hand of Conviction/MinLevel|62",
        "Hand of Tenacity/MinLevel|71", -- XXX unsure of minlevel
        "Hand of Temerity/MinLevel|76",-- XXX unsure of minlevel
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
    ["clr_vie"] = {
        "Guard of Vie/MinLevel|1",
        "Protection of Vie/MinLevel|42",
        "Bulwark of Vie/MinLevel|46",
        "Panoply of Vie/MinLevel|62",
        "Rallied Aegis of Vie/MinLevel|71", -- XXX unsure of minlevel
        "Rallied Shield of Vie/MinLevel|76", -- XXX unsure of minlevel
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
    ["clr_spellhaste"] = {
        "Blessing of Faith/MinLevel|1",
        "Aura of Devotion/MinLevel|62",
        "Aura of Purpose/MinLevel|71", -- XXX unsure of minlevel
        "Aura of Resolve/MinLevel|77", -- XXX unsure of minlevel
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
    ["clr_self_shielding"] = {
        -- XXX
    }
}

GroupBuffs.DRU = {
    -- hp buff:
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
    ["dru_skin"] = {
        "Protection of Nature/MinLevel|1",
        "Protection of the Nine/MinLevel|46",
        "Blessing of the Nine/MinLevel|47",
        "Blessing of Steeloak/MinLevel|62",
        "Blessing of the Direwild/MinLevel|71",     -- XXX unsure of minlevel
        "Blessing of the Ironwood/MinLevel|76",     -- XXX unsure of minlevel
    },

    -- cold & fire resists:
    -- L20 Resist Fire (slot 1: 30-40 fr)
    -- L30 Resist Cold (slot 1: 39-40 cr)
    -- L51 Circle of Winter (slot 1: 45 fr)
    -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
    ["dru_fire_resist"] = {
        "Resist Fire/MinLevel|1",
        "Circle of Winter/MinLevel|40",
        "Circle of Seasons/MinLevel|44",
        "Protection of Seasons/MinLevel|47",
    },

    -- L52 Circle of Summer (slot 4: 45 cr) - stack with Protection of Seasons
    ["dru_cold_resist"] = {
        "Circle of Summer/MinLevel|41",
    },

    -- corruption resists (CLR/DRU):
    -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
    ["dru_corruption"] = { -- XXX unused
        "Resist Corruption/MinLevel|71",    -- XXX unsure of minlevel
        "Forbear Corruption/MinLevel|76",   -- XXX unsure of minlevel
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
    ["dru_regen"] = {
        "Chloroplast/MinLevel|1",
        "Regrowth/MinLevel|42",
        "Replenishment/MinLevel|45",
        "Oaken Vigor/MinLevel|62",
        "Spirit of the Stalwart/MinLevel|76", -- XXX unsure of minlevel
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
    ["dru_single_ds"] = {
        "Shield of Thorns/MinLevel|1",
        "Shield of Blades/MinLevel|44",
        "Shield of Bracken/MinLevel|46",
        "Nettle Shield/MinLevel|62",
        "Viridifloral Shield/MinLevel|71",  -- XXX minlevel
        "Viridifloral Bulwark/MinLevel|76", -- XXX minlevel
    },

    ["dru_group_ds"] = {
        "Legacy of Spike/MinLevel|1",
        "Legacy of Thorn/MinLevel|44",
        "Legacy of Bracken/MinLevel|47",
        "Legacy of Nettles/MinLevel|62",
        "Legacy of Viridiflora/MinLevel|71",  -- XXX minlevel
        "Legacy of Viridithorns/MinLevel|76", -- XXX minlevel
    },

    -- L07 Strength of Earth (8-15 str)
    -- L34 Strength of Stone (22-25 str)
    -- L44 Storm Strength (32-35 str)
    -- L55 Girdle of Karana (42 str)
    -- L62 Nature's Might (55 str)
    -- NOTE: Shaman has STR buffs too
    ["dru_str"] = {
        "Storm Strength/MinLevel|1",
        "Girdle of Karana/MinLevel|42",
        "Nature's Might/MinLevel|46",
    },

    -- L67 Lion's Strength (increase skills dmg mod by 5%, cost 165 mana)
    -- L71 Mammoth's Strength Rk. III (increase skills dmg mod by 8%, cost 215 mana)
    -- NOTE: SHM has group version of these spells
    ["dru_skill_dmg_mod"] = {
        "Lion's Strength/MinLevel|62",
        "Mammoth's Strength/MinLevel|71", -- XXX minlevel
    },

    -- L10 Spirit of Wolf (48-55% speed, 36 min)
    -- L35 Pack Spirit (47-55% speed, 36 min, group)
    -- L54 Spirit of Eagle (57-70% speed, 1 hour)
    -- L62 Flight of Eagles (70% speed, 1 hour, group)
    ["dru_runspeed"] = {
        "Pack Spirit/MinLevel|1",
        "Spirit of Eagle/MinLevel|42",
        "Flight of Eagles/MinLevel|46",
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
    ["dru_self_ds"] = {
        -- XXX
    },

    -- L60 Mask of the Stalker (3 mana/tick)
    -- L65 Mask of the Forest (4 mana/tick)
    -- L70 Mask of the Wild (5 mana/tick)
    -- L80 Mask of the Shadowcat (SELF, slot 2: 9 mana/tick)
    ["dru_self_mana"] = {
        -- XXX
    }
}

GroupBuffs.ENC = {
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
    ["enc_manaregen"] = {
        "Boon of the Clear Mind/MinLevel|1",
        "Gift of Pure Thought/MinLevel|43",
        "Koadic's Endless Intellect/MinLevel|45",
        "Tranquility/MinLevel|46",
        "Voice of Quellious/MinLevel|47",
        --"Dusty Cap of the Will Breaker/MinLevel|1", -- TODO make use of this clicky. make sure its picked above other spells if available. need HaveItem and NotHaveItem filters !!!
        "Voice of Clairvoyance/MinLevel|62",
        "Voice of Intuition/MinLevel|71", -- XXX minlevel
        "Voice of Cognizance/MinLevel|76", -- XXX minlevel
    },

    -- L47 Swift Like the Wind (60% haste, 16 min) - L01-45
    -- L53 Aanya's Quickening  (64% haste, 24 min, DOES NOT land on lv15. DOES LAND on L42)
    -- L58 Wondrous Rapidity   (70% haste, 18.4 min)
    -- L62 Speed of Vallon     (68% haste, 41 atk, 52 agi, 33 dex, 42 min)
    -- L65 Vallon's Quickening (68% haste, 41 atk, 52 agi, 33 dex, 42 min, group)
    -- L67 Speed of Salik      (68% haste, 53 atk, 60 agi, 50 dex, 42 min 20% melee crit chance, cost 437 mana)
    -- L67 Hastening of Salik  (68% haste, 53 atk, 60 agi, 50 dex, 42 min, 20% melee crit chance, cost 1260 mana, group)
    -- L72 Speed of Ellowind   (68% haste, 64 atk, 72 agi, 60 dex, 42 min, 24% melee crit chance, %1 crit melee damage, cost 524 mana)
    -- L75 Hastening of Ellowind Rk. II (68% haste, 66 atk, 75 agi, 63 dex, 42 min, 25% melee crit chance, 2% crit melee damage, cost 1575 mana, group)
    ["enc_haste"] = {
        "Swift Like the Wind/MinLevel|1",
        "Aanya's Quickening/MinLevel|41",
        "Wondrous Rapidity/MinLevel|44",
        "Speed of Vallon/MinLevel|46",
        "Vallon's Quickening/MinLevel|47",
        "Hastening of Salik/MinLevel|62",
        "Hastening of Ellowind/MinLevel|71", -- XXX unsure of minlevel
    },

    -- L48 Group Resist Magic (53-55 mr, group)
    -- L62 Guard of Druzzil (75 mr, group)
    ["enc_resist"] = {
        "Group Resist Magic/MinLevel|1",
        "Guard of Druzzil/MinLevel|46",
    },

    -- L18 Sympathetic Aura (15-18 cha)
    -- L31 Radiant Visage (25-30 cha)
    -- L46 Adorning Grace (40 cha)
    -- L56 Overwhelming Splendor (50 cha)
    ["enc_cha"] = {
        -- XXX
    },

    -- slot 1:
    -- L69 Rune of Rikkukin (absorb 1500 dmg, group)
    -- L79 Rune of the Deep Rk. II (absorb 4118 dmg, slot 2: defensive proc Blurred Shadows Rk. II)
    ["enc_group_rune"] = {
        "Rune of Rikkukin/MinLevel|62",
        "Rune of the Deep/MinLevel|76", -- XXX unsure of minlevel
    },

    -- targeted rune - slot 1:
    -- L33 Rune III (absorb 168-230 dmg)
    -- L40 Rune IV (absorb 305-394 dmg)
    -- L52 Rune V (absorb 620-700 dmg)
    -- L61 Rune of Zebuxoruk (absorb 850 dmg)
    -- L67 Rune of Salik (absorb 1105 dmg)
    -- L71 Rune of Ellowind (absorb 2160 dmg)
    -- L76 Rune of Erradien Rk. II (absorb 5631 dmg)
    ["enc_single_rune"] = {
        "Rune IV/Reagent|Peridot/MinLevel|1",
        "Rune V/Reagent|Peridot/MinLevel|41",
        "Rune of Zebuxoruk/Reagent|Peridot/MinLevel|45",
        "Rune of Salik/Reagent|Peridot/MinLevel|62",
        "Rune of Ellowind/Reagent|Peridot/MinLevel|71",
        "Rune of Erradien/Reagent|Peridot/MinLevel|76",
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
    ["enc_self_shielding"] = {
        -- XXX
    },

}

GroupBuffs.MAG = {
    -- L07 Shield of Fire (4-6 ds, 10 fr, 15 min, single)
    -- L19 Shield of Flame (7-9 ds, 15 fr, 15 min, single)
    -- L28 Inferno Shield (13-15 ds, 20 fr, 15 min, single)
    -- L38 Barrier of Combustion (18-20 ds, 22 fr, 15 min, single)
    -- L45 Shield of Lava (25 ds, 25 fr, 15 min, single) - L1-45
    -- L53 Boon of Immolation (25 ds, 25 fr, 15 min, group)
    -- L56 Cadeau of Flame (35 ds, 33 fr, 15 min, single)
    -- L61 Flameshield of Ro (48 ds, 45 fr, 15 min, single)
    -- L63 Maelstrom of Ro (48 ds, 45 fr, 15 min, group)
    -- L66 Fireskin (62 ds - slot 1, 45 fr, 15 min, single)
    -- L70 Circle of Fireskin (62 ds, 45 fr, 15 min, group)
    ["mag_single_ds"] = {
        "Shield of Lava/MinLevel|1",
        "Cadeau of Flame/MinLevel|43",
        "Flameshield of Ro/MinLevel|45",
        "Fireskin/MinLevel|62",
    },
    ["mag_group_ds"] = {
        "Shield of Lava/MinLevel|1", -- single
        "Boon of Immolation/MinLevel|41",
        "Maelstrom of Ro/MinLevel|46",
        "Circle of Fireskin/MinLevel|62",
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
    ["mag_self_shielding"] = {
        -- XXX
        --"Elemental Aura/MinMana|80/CheckFor|Elemental Empathy R.",
    },

    -- L19 Elemental Shield (14-15 cr, 14-15 fr)
    -- L41 Elemental Armor (30 cr, 30 fr)
    -- L54 Elemental Cloak (45 cr, 45 fr)
    -- L61 Elemental Barrier (60 cr, 60 fr)
    -- NOTE: does not stack with druid resists
    ["mag_self_resist"] = {
        -- XXX
    },

    -- L11 Burnout (15 str, 12-15% haste, 7 ac)
    -- L29 Burnout II (39-45 str, 29-35% haste, 9 ac)
    -- L47 Burnout III (50 str, 60% haste, 13 ac)
    -- LXX Elemental Empathy (x)
    -- L55 Burnout IV (60 str, 65% haste, 16 ac)
    -- L60 Ancient: Burnout Blaze (80 str, 80% haste, 22 ac, 50 atk)
    -- L62 Burnout V (80 str, 85% haste, 22 ac, 40 atk)
    -- L69 Elemental Fury (85% haste, 29 ac, 52 atk, 5% skill dmg mod)
    ["mag_pet_haste"] = {
        -- XXX
    },

    -- L27 Expedience (20% movement, 12 min)
    -- L58 Velocity (59-80% movement, 36 min)
    ["mag_pet_runspeed"] = {
        -- XXX
    },

}

GroupBuffs.NEC = {
    -- L41 Dead Man Floating (61-70 pr, water breathing, see invis, levitate)
    -- L45 Dead Men Floating (65-70 pr, water breathing, see invis, levitate, group)
    ["nec_group_levitate"] = {
        "Dead Men Floating/MinLevel|1",
    },
    ["nec_single_levitate"] = {
        "Dead Man Floating/MinLevel|1",
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
    -- NOTE: if used as "Lich Spell", will cast while running
    ["nec_lich"] = {
        -- XXX
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
    ["nec_self_rune"] = {
        -- XXX
    },

    -- L23 Intensify Death (25-33 str, 21-30% haste, 6-8 ac)
    -- L35 Augment Death (37-45 str, 45-55% haste, 9-12 ac
    -- L55 Augmentation of Death (52-55 str, 65% haste, 14-15 ac)
    -- L62 Rune of Death (65 str, 70% haste, 18 ac)
    -- L67 Glyph of Darkness (5% skills dmg mod, 84 str, 70% haste, 23 ac)
    -- L72 Sigil of the Unnatural (6% skills dmg mod, 96 str, 70% haste, 28 ac)
    -- L77 Sigil of the Aberrant Rk. II (10% skills dmg mod, 122 str, 70% haste, 36 ac)
    ["nec_pet_haste"] = {
        -- XXX
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
    ["nec_self_shielding"] = {
        -- XXX
    },
}

GroupBuffs.WIZ = {
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
    ["wiz_self_shielding"] = {
        -- XXX
    },

    -- L63 Force Shield (slot 1: absorb 750 dmg, 2 mana/tick)
    -- L68 Ether Skin (slot 1: absorb 975 dmg, 3 mana/tick)
    -- L70 Shield of Dreams (slot 1: absorb 451 dmg, slot 8: +10 resists, slot 9: 3 mana/tick)
    ["wiz_self_rune"] = {
        -- XXX
    }
}

GroupBuffs.RNG = {
    -- hp type 2 - Slot 4: Increase max HP
    -- L51 Strength of Nature (25 atk, 75 hp, single, cost 125 mana)
    -- L62 Strength of Tunare (slot 1: 92 atk, slot 4: 125 hp, group, cost 250 mana)
    -- L67 Strength of the Hunter (75 atk, 155 hp, group, cost 325 mana)
    ["rng_hp"] = {
        "Strength of Nature/MinLevel|40",
        "Strength of Tunare/MinLevel|46",
        -- "Strength of the Hunter/MinLevel|62", -- NOTE: Tunare has more ATK
    },

    -- L56 Mark of the Predator (slot 2: 20 atk, group)
    -- L60 Call of the Predator (slot 2: 40 atk, group)
    -- L64 Spirit of the Predator (slot 2: 70 atk, group)
    -- L69 Howl of the Predator (slot 2: 90 atk, slot 9: double atk 3-20%, group)
    ["rng_atk"] = {
        "Mark of the Predator/MinLevel|43",
        "Call of the Predator/MinLevel|45",
        "Spirit of the Predator/MinLevel|47",
        "Howl of the Predator/MinLevel|62",
    },

    -- L29 Riftwind's Protection (slot 2: 2 ds, slot 3: 11-12 ac)
    -- L50 Call of Earth (slot 2: 4 ds, slot 3: 24-25 ac)
    -- L62 Call of the Rathe (slot 2: 10 ds, slot 3: 34 ac)
    -- L67 Guard of the Earth (slot 2: 13 ds, slot 3: 49 ac)
    ["rng_ds"] = {
        "Call of Earth/MinLevel|1",
        "Call of the Rathe/MinLevel|46",
        "Guard of the Earth/MinLevel|62",
    },

    -- L07 Skin like Wood
    -- L21 Skin like Rock
    -- L38 Skin like Steel
    -- L54 Skin like Diamond
    -- L59 Skin like Nature
    -- L65 Natureskin (18-19 ac, 391-520 hp, 4 hp/tick)
    -- L70 Onyx Skin (33 ac, 540 hp, 6 hp/tick)
    ["rng_skin"] = {
        -- XXX
    },

    -- L13 Thistlecoat
    -- L30 Barbcoat
    -- L34 Bramblecoat
    -- L42 Spikecoat
    -- L60 Thorncoat
    -- L63 Bladecoat (slot 2: 37 ac, slot 3: 6 ds)
    -- L68 Briarcoat (slot 2: 49 ac, slot 3: 8 ds)
    ["rng_self_ds"] = {
        -- XXX
    },

    -- L65 Protection of the Wild (slot 1: 34 ds, slot 2: 130 atk, slot 3: 34 ac, slot 4: 125 hp)
    -- L70 Ward of the Hunter     (slot 1: 45 ds, slot 2: 170 atk, slot 3: 49 ac, slot 4: 165 hp, slot 9: 3% double attack)
    ["rng_self_ds_atk"] = {
        -- XXX
    },

    -- L65 Mask of the Stalker (slot 3: 3 mana regen)
    ["rng_self_mana"] = {
        -- XXX
    },
}

GroupBuffs.PAL = {
    -- hp type 2 buff:
    -- L35 Divine Vigor (100 hp)
    -- L49 Brell's Steadfast Aegis (145 hp, group)
    -- L60 Brell's Mountainous Barrier (225 hp, group)
    -- L65 Brell's Stalwart Shield (330 hp, group)
    -- L70 Brell's Brawny Bulwark (412 hp, group)
    ["pal_hp"] = {
        "Brell's Steadfast Aegis/MinLevel|1",
        "Brell's Mountainous Barrier/MinLevel|45",
        "Brell's Stalwart Shield/MinLevel|47",
        "Brell's Brawny Bulwark/MinLevel|62",
    },

    -- L24 Symbol of Transal
    -- L33 Symbol of Ryltan
    -- L46 Symbol of Pinzarn
    -- L63 Symbol of Marzin
    -- L67 Symbol of Jeron
    -- L68 Jeron's Mark (group)
    ["pal_symbol"] = {
        -- XXX
    },

    -- L64 Aura of the Crusader (slot 2: 30 ac, slot 3: 342-350 hp, slot 4: 3 mana/tick)
    -- L69 Armor of the Champion (slot 2: 39 ac, slot 3: 437 hp, slot 4: 4 mana/tick)
    ["pal_shielding"] = {
        -- XXX
    },

    -- proc self buffs:
    -- L26 Instrument of Nife (undead proc Condemnation of Nife)
    -- L45 Divine Might (proc Divine Might Effect)
    -- L62 Ward of Nife (UNDEAD: proc Ward of Nife Strike)
    -- L63 Pious Might (proc Pious Might Strike)
    -- L65 Holy Order (proc Holy Order Strike)
    -- L67 Silvered Fury (proc Silvered Fury Strike)
    -- L68 Pious Fury (slot 1: proc Pious Fury Strike)
    ["pal_proc_buff"] = {
        -- XXX
    },
}

GroupBuffs.SHD = {
    -- Combat Innates:
    -- L22 Vampiric Embrace (proc: Vampiric Embrace)
    -- L37 Scream of Death (proc: Scream of Death Strike)
    -- L67 Shroud of Discord (proc: Shroud of Discord Strike, 60 min duration) - imbues attacks with chance to steal life from target (lifetap)
    -- L70 Decrepit Skin (slot 1: proc Decrepit Skin Parry, 4 min duration) - absorb dmg
    ["shd_combat_innate"] = {
        -- XXX
    },

    -- skeleton illusion with regen:
    -- L58 Deathly Temptation (6 mana/tick, -11 hp/tick)
    -- L64 Pact of Hate (15 mana/tick, -22 hp/tick)
    -- L69 Pact of Decay (17 mana/tick, -25 hp/tick)
    -- NOTE: does not stack with ENC Clairvoyance (20 mana/tick)
    ["shd_lich"] = {
        -- XXX
    },

    -- L60 Cloak of the Akheva (slot 3: 13 ac, slot 6: 5 ds, slot 10: 150 hp)
    -- L65 Cloak of Luclin (slot 3: 34 ac, slot 6: 10 ds, slot 10: 280 hp)
    -- L70 Cloak of Discord (slot 3: 49 ac, slot 6: 13 ds, slot 10: 350 hp)
    ["shd_shielding"] = {
        -- XXX
    }
}

GroupBuffs.BST = {
    -- mana regen:
    -- L41 Spiritual Light (3 hp + 3 mana/tick, group)
    -- L52 Spiritual Radiance (5 hp + 5 mana/tick, group)
    -- L59 Spiritual Purity (7 hp + 7 mana/tick, group)
    -- L64 Spiritual Dominion (9 hp + 9 mana/tick, group)
    -- L69 Spiritual Ascendance (10 hp + 10 mana/tick, group, cost 900 mana)
    ["bst_manaregen"] = {
        "Spiritual Light/MinLevel|1",
        "Spiritual Radiance/MinLevel|41",
        "Spiritual Purity/MinLevel|44",
        "Spiritual Dominion/MinLevel|47",
        "Spiritual Ascendance/MinLevel|62",
    },

    -- hp type 2 - Slot 4: Increase max HP:
    -- L42 Spiritual Brawn (10 atk, 75 hp)
    -- L60 Spiritual Strength (25 atk, 150 hp)
    -- L62 Spiritual Vigor (40 atk, 225 hp, group)
    -- L67 Spiritual Vitality (52 atk, 280 hp, group)
    -- NOTE: RNG buff has more atk
    ["bst_hp"] = {
        "Spiritual Brawn/MinLevel|1",
        "Spiritual Strength/MinLevel|45",
        "Spiritual Vigor/MinLevel|46",
        "Spiritual Vitality/MinLevel|62",
    },

    -- L60 Alacrity (32-40% haste, 11 min)
    -- L63 Celerity (47-50% haste, 16 min)
    ["bst_haste"] = {
        "Alacrity/MinLevel|45",
        "Celerity/MinLevel|46",
    },

    -- weak focus - HP slot 1: Increase Max HP
    -- L53 Talisman of Tnarg (132-150 hp)
    -- L58 Talisman of Altuna (230-250 hp)
    -- L62 Talisman of Kragg (365-500 hp)
    -- L67 Focus of Alladnu (513 hp)
    ["bst_focus"] = {
        "Talisman of Tnarg/MinLevel|41",
        "Talisman of Altuna/MinLevel|44",
        "Talisman of Kragg/MinLevel|46",
        "Focus of Alladnu/MinLevel|62",
    },

    -- L17 Spirit of Bear (11-15 sta)
    -- L37 Spirit of Ox (19-23 sta)
    -- L52 Health (27-31 sta)
    -- L57 Stamina (36-40 sta)
    ["bst_sta"] = {
        "Spirit of Ox/MinLevel|1",
        "Health/MinLevel|41",
        "Stamina/MinLevel|43",
    },

    -- L14 Strengthen (5-10 str)
    -- L28 Spirit Strength (16-18 str)
    -- L41 Raging Strength (23-26 str)
    -- L54 Furious Strength (31-34 str)
    ["bst_str"] = {
        "Raging Strength/MinLevel|1",
        "Furious Strength/MinLevel|42",
    },

    -- L38 Spirit of Monkey (19-20 dex)
    -- L53 Deftness (40 dex)
    -- L57 Dexterity (49-50 dex) - blocked by Khura's Focusing (60 dex)
    ["bst_dex"] = {
        "Spirit of Monkey/MinLevel|1",
        "Deftness/MinLevel|41",
        "Dexterity/MinLevel|43",
    },

    -- L37 Yekan's Quickening (43-45 str, 60% haste, 20 atk, 11-12 ac)
    -- L52 Bond of the Wild (51-55 str, 60% haste, 25 atk, 13-15 ac)
    -- L55 Omakin's Alacrity (60 str, 65-70% haste, 40 atk, 30 ac)
    -- L59 Sha's Ferocity (99-100 str, 84-85% haste, 60 atk, 60 ac)
    -- L64 Arag's Celerity (115 str, 85% haste, 75 atk, 71 ac)
    -- L68 Growl of the Beast (85% haste, 90 atk, 78 ac, 5% skill dmg mod, duration 1h)
    ["bst_pet_haste"] = {
        -- XXX
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
    ["bst_pet_proc"] = {
        -- XXX
    },
}


GroupBuffs.Default = {}

-- REQUEST DEFAULTS BY CLASS
GroupBuffs.Default.WAR = {
    -- should we ask for symbol / aegolism?   XXX try this out.
    --"clr_symbol/Class|DRU,CLR",         -- CLR
    --"clr_ac/Class|DRU,CLR",             -- CLR
    --"dru_skin/Class|DRU,CLR",           -- DRU
    --"clr_aegolism/Class|CLR/NotClass|DRU",  -- CLR

    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL/CheckFor|Spiritual Vitality,Strength of Tunare",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL/CheckFor|Brell's Brawny Bulwark,Strength of Tunare",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",-- 3rd
    "rng_hp/Class|RNG",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.SHD = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.PAL = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.BRD = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "rng_atk/Class|RNG",
    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "dru_fire_resist/Class|DRU",
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.CLR = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.DRU = {
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

    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.SHM = {
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
    "enc_resist/Class|ENC",
}

GroupBuffs.Default.ENC = {
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
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.WIZ = {
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
    "shm_resist/Class|SHM",
    "enc_resist/Class|ENC",
}

GroupBuffs.Default.MAG = {
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
    "shm_resist/Class|SHM",
    "enc_resist/Class|ENC",
}

GroupBuffs.Default.NEC = {
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
    "shm_resist/Class|SHM",
    "enc_resist/Class|ENC",
}

GroupBuffs.Default.RNG = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.BST = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.ROG = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.MNK = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}

GroupBuffs.Default.BER = {
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
    "enc_resist/Class|ENC",
    "shm_resist/Class|SHM",
}


return GroupBuffs
