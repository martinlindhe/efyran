local GroupBuffs = {}

GroupBuffs.SHM = {
    -- STA - affects HP:
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
    ["sta"] = {
        "Stamina/MinLevel|1",
        "Talisman of the Brute/MinLevel|43",
        "Talisman of the Boar/MinLevel|46",
        "Talisman of Fortitude/MinLevel|62",
    },

    -- focus - HP Slot 1: Increase Max HP:
    -- L46 Harnessing of Spirit (243-251 hp, 67 str, 50 dex, cost 425 mana)
    -- L60 Focus of Spirit (405-525 hp, 67 str, 60 dex, cost 500 mana)
    -- L60 Khura's Focusing (430-550 hp, 67 str, 60 dex, cost 1250 mana, group)
    -- L62 Focus of Soul (544 hp, 75 str, 70 dex, cost XXX mana)
    -- L65 Focus of the Seventh (544 hp, 75 str, 70 dex, cost 1800 mana, group)
    -- L68 Wunshi's Focusing (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 780 mana)
    -- L70 Talisman of Wunshi (680 hp, 85 str, 85 dex, str cap 85, dex cap 85, cost 2340 mana)
    ["focus"] = {
        "Harnessing of Spirit/MinLevel|1",
        "Khura's Focusing/MinLevel|45",
        "Focus of the Seventh/MinLevel|47",
        "Talisman of Wunshi/MinLevel|62",
    },

    -- L09 Spirit of Wolf (48-55% speed, 36 min)
    -- L36 Spirit of Bih`Li (48-55% run speed, 15 atk, 36 min, group)
    ["runspeed"] = {
        "Spirit of Bih`Li/MinLevel|1/CheckFor|Flight of Eagles",
    },

    ["shm_haste"] = {
        -- L26 Quiuckness (27--30% haste, 11 min)
        -- L42 Alacrity (32-40% haste, 11 min)
        -- L63 Swift Like the Wind (60% haste, 16 min)
        -- L64 Talisman of Celerity (60% haste, 36 min, group)
        "Alacrity/MinLevel|1",
        "Swift Like the Wind/MinLevel|46",
        "Talisman of Celerity/MinLevel|47/CheckFor|Hastening of Salik",
    },
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
    ["symbol"] = {
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
        "Blessing of Temperance/MinLevel|1",
        "Blessing of Aegolism/MinLevel|45",
        "Hand of Virtue/MinLevel|47",
        "Hand of Conviction/MinLevel|62",
        "Hand of Tenacity/MinLevel|71", -- XXX unsure of minlevel
        "Hand of Temerity/MinLevel|76",-- XXX unsure of minlevel
    },

    ["absorb_melee"] = {
        -- absorb melee:
        -- L20 Ward of Vie (absorb 10% melee dmg to 460)
        -- L40 Guard of Vie (absorb 10% melee dmg to 700)
        -- L54 Protection of Vie (absorb 10% melee dmg to 1200)
        -- L62 Bulwark of Vie (absorb 10% melee dmg to 1600)
        -- L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
        -- L73 Aegis of Vie (absorb 10% of melee dmg to 2496, 36 min)
        -- L75 Rallied Aegis of Vie Rk. II (absorb 10% of melee dmg to 2600, 36 min, group)
        -- L78 Shield of Vie Rk. II (absorb 10% of melee dmg to 3380, 36 min)
        -- L80 Rallied Shield of Vie Rk. II (absorb 10% of melee dmg to 3380, 36 min, group)
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
    ["spellhaste"] = {
        "Blessing of Faith/MinLevel|1",
        "Aura of Devotion/MinLevel|62",
        "Aura of Purpose/MinLevel|71", -- XXX unsure of minlevel
        "Aura of Resolve/MinLevel|77", -- XXX unsure of minlevel
    },
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
    ["skin"] = {
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
    -- L51 Circle of Winter (slot 1: 45 fr) - don't stack with Protection of Seasons
    -- L52 Circle of Summer (slot 4: 45 cr) - stack with Protection of Seasons
    -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
    ["dru_resists"] = {-- XXX unused
        "Resist Fire/MinLevel|1",
        "Resist Cold/MinLevel|1",
        "Circle of Seasons/MinLevel|44",
        "Protection of Seasons/MinLevel|47",
    },

    -- corruption resists (CLR/DRU):
    -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
    ["corruption"] = { -- XXX unused
        "Resist Corruption/MinLevel|71",    -- XXX unsure of minlevel
        "Forbear Corruption/MinLevel|76",   -- XXX unsure of minlevel
    },

    ["regen"] = {
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
        "Chloroplast/MinLevel|1",
        "Regrowth/MinLevel|42",
        "Replenishment/MinLevel|45",
        "Oaken Vigor/MinLevel|62",
        "Spirit of the Stalwart/MinLevel|76", -- XXX unsure of minlevel
    },

    ["ds"] = {
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
        "Shield of Thorns/MinLevel|1",
        "Shield of Blades/MinLevel|44",
        "Shield of Bracken/MinLevel|46",
        "Nettle Shield/MinLevel|62", -- XXX unsure of minlevel
        "Viridifloral Shield/MinLevel|71",  -- XXX unsure of minlevel
        "Viridifloral Bulwark/MinLevel|76", -- XXX unsure of minlevel
    },

    ["str"] = {
        -- L07 Strength of Earth (8-15 str)
        -- L34 Strength of Stone (22-25 str)
        -- L44 Storm Strength (32-35 str)
        -- L55 Girdle of Karana (42 str)
        -- L62 Nature's Might (55 str)
        "Storm Strength/MinLevel|1",
        "Girdle of Karana/MinLevel|42",
        "Nature's Might/MinLevel|46",
    },

    -- L67 Lion's Strength (increase skills dmg mod by 5%, cost 165 mana)
    -- L71 Mammoth's Strength Rk. III (increase skills dmg mod by 8%, cost 215 mana)
    -- NOTE: SHM has group version of these spells
    ["skill_dmg_mod"] = {
        "Lion's Strength/MinLevel|62",
        "Mammoth's Strength/MinLevel|71", -- XXX minlevel
    },

    -- L09 Spirit of Wolf (48-55% speed, 36 min)
    -- L35 Pack Spirit (47-55% speed, 36 min, group)
    -- L54 Spirit of Eagle (57-70% speed, 1 hour)
    -- L62 Flight of Eagles (70% speed, 1 hour, group)
    ["runspeed"] = {
        "Pack Spirit/MinLevel|1",
        "Spirit of Eagle/MinLevel|42",
        "Flight of Eagles/MinLevel|46", 
    },
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
    ["manaregen"] = {
        "Boon of the Clear Mind/MinLevel|1",
        "Gift of Pure Thought/MinLevel|43",
        "Koadic's Endless Intellect/MinLevel|45",
        "Tranquility/MinLevel|46",
        "Voice of Quellious/MinLevel|47",
        "Dusty Cap of the Will Breaker/MinLevel|1", -- XXX make sure its picked above other spells if available.
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
    ["magic_resist"] = {
        "Group Resist Magic/MinLevel|1",
        "Guard of Druzzil/MinLevel|46",
    },

    ["group_rune"] = {
        -- slot 1:
        -- L69 Rune of Rikkukin (absorb 1500 dmg, group)
        -- L79 Rune of the Deep Rk. II (absorb 4118 dmg, slot 2: defensive proc Blurred Shadows Rk. II)
        "Rune of Rikkukin/MinLevel|62",
        "Rune of the Deep/MinLevel|76", -- XXX unsure of minlevel
    },

    ["rune"] = {
        -- targeted rune - slot 1:
        -- L33 Rune III (absorb 168-230 dmg)
        -- L40 Rune IV (absorb 305-394 dmg)
        -- L52 Rune V (absorb 620-700 dmg)
        -- L61 Rune of Zebuxoruk (absorb 850 dmg)
        -- L67 Rune of Salik (absorb 1105 dmg)
        -- L71 Rune of Ellowind (absorb 2160 dmg)
        -- L76 Rune of Erradien Rk. II (absorb 5631 dmg)
        "Rune IV/Reagent|Peridot/MinLevel|1",
        "Rune V/Reagent|Peridot/MinLevel|41",
        "Rune of Zebuxoruk/Reagent|Peridot/MinLevel|45",
        "Rune of Salik/Reagent|Peridot/MinLevel|62",
        "Rune of Ellowind/Reagent|Peridot/MinLevel|71",
        "Rune of Erradien/Reagent|Peridot/MinLevel|76",
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
    ["ds"] = {
        -- single ds buff
        "Shield of Lava/MinLevel|1",
        "Cadeau of Flame/MinLevel|43",
        "Flameshield of Ro/MinLevel|45",
        "Fireskin/MinLevel|62",
    },
    ["groupds"] = {  
        "Boon of Immolation/MinLevel|41",
        "Maelstrom of Ro/MinLevel|46",
        "Circle of Fireskin/MinLevel|62",
    },
}

GroupBuffs.NEC = {
    ["dmf"] = {
        -- L41 Dead Man Floating (61-70 pr, water breathing, see invis, levitate)
        -- L45 Dead Men Floating (65-70 pr, water breathing, see invis, levitate, group)
        "Dead Men Floating/MinLevel|1",
    }
}

GroupBuffs.RNG = {
    -- TODO MORE
    ["hp_atk"] = {
        "Strength of Tunare/MinLevel|46",
    }
}

GroupBuffs.PAL = {
    ["brells"] = {
        -- TODO !!!
    }
}

GroupBuffs.Beastlord = {
    -- TODO !!!
}

return GroupBuffs