
local Default = {}

-- REQUEST DEFAULTS BY CLASS
Default.WAR = {
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
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "mag_single_ds/Class|MAG",
}

Default.SHD = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "mag_single_ds/Class|MAG",
}

Default.PAL = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

--    "mag_single_ds/Class|MAG",
    "dru_str/Class|DRU",
}

Default.BRD = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",            -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "rng_atk/Class|RNG",
    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.CLR = {
    -- XXX should do self buff + aego ?
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.DRU = {
    "clr_symbol/Class|CLR",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "clr_spellhaste/Class|CLR",
    "clr_vie/Class|CLR",

    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.SHM = {
    "clr_symbol/Class|CLR",
    "dru_skin/Class|DRU",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    "clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
}

Default.ENC = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "bst_manaregen/Class|BST",
    "clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",

    --"mag_single_ds/Class|MAG",

    "dru_runspeed/Class|DRU",
}

Default.WIZ = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",
    "clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

Default.MAG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",
    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

Default.NEC = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"pal_hp/Class|PAL",                 -- 1st
    --"bst_hp/Class|BST/NotClass|PAL",    -- 2nd
    --"rng_hp/Class|RNG/NotClass|PAL,BST",-- 3rd
    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",

    "bst_manaregen/Class|BST",
    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    "enc_magic_resist/Class|ENC",
}

Default.RNG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    "enc_manaregen/Class|ENC",
    --"bst_manaregen/Class|BST",   -- XXX out of buff slots, sep 2022

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "dru_str/Class|DRU",
}

Default.ROG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.MNK = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.BST = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",                 -- 1st

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.BER = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_hp/Class|RNG/CheckFor|Brell's Brawny Bulwark,Spiritual Vitality",                 -- 1st
    --"bst_hp/Class|BST/NotClass|RNG",    -- 2nd
    --"pal_hp/Class|PAL/NotClass|RNG,BST",-- 3rd

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC/CheckFor|Hastening of Salik",

    --"dru_fire_resist/Class|DRU",
    "enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

return Default
