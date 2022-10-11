local cures = {}

cures.disease = {
    -- order: most powerful first
    "Radiant Cure/Group",           -- XXX Group filter ?!
    "Word of Vivification/Group",   -- CLR/69: 3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana
    "Word of Replenishment/Group",  -- CLR/64: 2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana
    "Blood of Nadox/Group",         -- SHM/52: -9 poison x2, -9 disease x2 (group)
    "Difinecting Aura",             -- SHM/52: -10 poison x2, -10 disease x2
    "Abolish Disease",              -- SHM/48, BST/63: -36 disease
    "Crusader's Purity",            -- PAL/67: -32 disease, -32 poison, -16 curse
    "Crusader's Touch",             -- PAL/62: -20 disease, -20 poison, -5 curse
    "Counteract Disease",           -- SHM/22, DRU/28, CLR/28, BST/45, PAL/56, RNG/61, NEC/36: -8 disease
    "Cure Disease",                 -- SHM/01, DRU/04, CLR/04, BST/04, PAL/11, RNG/22, NEC/13: -1 to -4 disease
}

cures.poison = {
    -- order: most powerful first
    "Radiant Cure/Group",
    "Puratus",                      -- CLR/70: cure all poisons from target + block next posion spell from affecting them, 15s recast
    "Word of Vivification/Group",   -- CLR/69: 3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana
    "Word of Replenishment/Group",  -- CLR/64: 2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana
    "Purge Posion/Self",            -- ROG/59: -99 poison x12 (AA)   TODO "Self" flag
    "Antidote",                     -- CLR/58: -16 poison x4
    "Difinecting Aura",             -- SHM/52: -10 poison x2, -10 disease x2
    "Pure Blood",                   -- CLR/51, DRU/52: -9 poison x4
    "Abolish Poison",               -- CLR/48: -36 posion
    "Crusader's Purity",            -- PAL/67: -32 disease, -32 poison, -16 curse
    "Crusader's Touch",             -- PAL/62: -20 disease, -20 poison, -5 curse
    "Counteract Poison",            -- CLR/22, SHM/26, DRU/28, PAL/34, BST/61, RNG/61: -8 posion
    "Cure Poison",                  -- CLR/01, SHM/02, DRU/05, PAL/05, BST/13, RNG/13: -1 to -4 poison
}

cures.curse = {
    -- order: most powerful first
    "Radiant Cure/Group",
    "Remove Greater Curse",         -- CLR/54, DRU/54, SHM/54, PAL/60: -9 curse x5
    "Remove Curse",                 -- CLR/38, DRU/38, SHM/38, PAL/45: -4 curse x2
    "Remove Lesser Curse",          -- CLR/23, DRU/23, SHM/24, PAL/34: -4 curse
    "Remove Minor Curse",           -- CLR/08, DRU/08, SHM/09, PAL/19: -2 curse
}

cures.any = {
    -- order: most powerful first
    "Pure Spirit",              -- SHM/69: 95% chance to remove detrimental effect from target, 12s recast

    "Blessing of Purification", -- PAL/80: remove all negative effects (AA), xxx reuse

    --"Desperate Renewal",        -- CLR/70: heal 4935 hp, -18 pr, -18 dr, -18 curse, cost 1375 mana

    "Purify Body/Self",         -- MNK/59: remove all negative effects, 30 min reuse (21 min reuse with Hastened Purification of the Body Rank 3)

    "Purification/Self",        -- PAL/65: remove all negative effects, 1h12 min reuse (14m24s reuse with Hastened Purification Rank 8)

    "Radiant Cure/Group",       -- XXX Group filter ?!, xxx reuse
}


cures.detrimental = {
    --################
    -- Omens of War ##
    --################
    "Chailak Venom/Cure|poison",    -- 9 poison counters, riftseekers
    "Chaotica/Cure|curse",          -- 18 curse counters, multiple zones
    "Infected Bite/Cure|disease",   -- 36 disease counters, multiple zones
    "Freezing Touch/Cure|any",      -- mesmerize, riftseekers basement
    "Whipping Dust/Cure|curse",     -- 72 curse counters, causeway
    "Deathly Chants/Cure|curse",    -- 9 curse counters, CLR 1.5 + 2.0 fights + SHM 2.0
    "Plague of Hulcror/Cure|disease",   -- 36 disease counters, wallofslaughter
    "Complex Gravity/Cure|curse/Class|SHD",   -- 75 curse counters, snare, chambersb (mpg endurance raid. assumes kiter is SHD)

    -- anguish:
    "Gaze of Anguish/Cure|disease",    -- 30 disease counters, 5 ticks, amv
    "Chains of Anguish/Cure|curse",    -- 50 curse counters, snare, 5 ticks, hanvar

    -- Warden Hanvar, 350 mana dot, 5 ticks
    "Feedback Dispersion/Cure|curse/Class|priests",  -- 45 curse counters. XXX FILTER ON Class priests, cure priests !!!

    -- Keldovan the Harrier - decrease healing effectiveness by 80%
    "Packmaster's Curse/Cure|curse/Class|tanks", -- 16 curse counters, XXX FILTER ON Class tanks. only cure tanks from this!!!

    -- Overlord Mata Muram, -25% accuracy, -100 casting level, 1.0 min
    "Torment of Body/Cure|curse", -- 24 curse counters

    -- Overlord Mata Muram - silence
    "Void of Suppression/Cure|disease/Class|priests", -- 24 disease counters, silence. XXX FILTER ON Class priests, cure priests !!!

    -- Overlord Mata Muram - increase spell cast time by 100%, 0.5 min
    "Relinquish Spirit/Cure|curse/Class|priests", -- 24 curse counters



    --####################
    -- Gates of Discord ##
    --####################
    "Wanton Destruction/Cure|curse", -- 36 curse, 100 mana dot, txevu,anguish
    "Kneeshatter/Cure|poison",      -- 18 poison counters, snare, ikkinz,qvic,provinggrounds

    "Fulmination/Cure|poison", -- 45 poison counters, 250 mana/tick dot, qvic,txevu

    "Skullpierce/Cure|poison", -- 18 poison, qvic,provinggrounds
    "Malicious Decay/Cure|disease", -- 9 disease counters
    "Insidious Decay/Cure|disease", -- 9 disease counters
    "Chaos Claws/Cure|poison", -- 9 poison counters

    "Stonemite Acid/Cure|any", -- vxed,tipt
    "Tigir's Insects/Cure|disease", -- 16 disease counters

    "Clinging Apathy/Cure|any", -- snare
    "Malo/Cure|any",
    "Debilitating Curse of Noqufiel/Cure|curse", -- 45 curse counters, root (cursecallers, inktuta)



    --####################
    -- Planes of Power  ##
    --####################

    "Gravel Rain/Cure|curse", -- 72 curse counters, snare, potactics,poearthb
    --"Solar Storm/Cure|curse", -- 9 curse counters, poair, NOTE: makes tanks die if all clerics cure this
    "Storm Comet/Cure|curse", -- 36 curse counters, snare, poair
    "Curse of the Fiend/Cure|curse", -- 9 curse counters, solrotower


    "Marl/Cure|curse", -- 36 curse counters, poearthb


    --#####################
    -- Shadows of Luclin ##
    --#####################
    "Feeblemind/Cure|curse", -- 9 curse counters, thedeep

    "Curse of Rhag`Zadune/Cure|curse", -- 9 curse counters, 200 mana/tick

    "Rabies/Cure|disease", -- 1 disease counter, chardok
}

return cures
