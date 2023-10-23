local Default = {}

-- BUFF REQUEST DEFAULTS BY CLASS
Default.WAR = {
    -- should we ask for symbol / aegolism?   XXX try this out:
    --"clr_symbol/Class|DRU,CLR",         -- CLR
    --"dru_skin/Class|DRU,CLR",           -- DRU
    --"clr_aegolism/Class|CLR/NotClass|DRU",  -- CLR

    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "mag_ds/Class|MAG",
}

Default.SHD = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "mag_ds/Class|MAG",
}

Default.PAL = {
    -- XXX should do self buff + aego ?
    "clr_symbol/Class|CLR",
    "clr_ac/Class|CLR",
    "dru_skin/Class|DRU",

    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

--    "mag_ds/Class|MAG",
    "dru_str/Class|DRU",
}

Default.BRD = {
    --"clr_symbol/Class|CLR", -- expensive for my L20 CLR
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "rng_atk/Class|RNG",
    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.CLR = {
    -- XXX should do self buff + aego ?
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "enc_manaregen/Class|ENC",
    "bst_manaregen/Class|BST",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "dru_str/Class|DRU", -- for looting
}

Default.DRU = {
    "clr_symbol/Class|CLR",
    "shm_focus/Class|SHM",

    "enc_manaregen/Class|ENC",

    --"clr_vie/Class|CLR",

    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.SHM = {
    "clr_symbol/Class|CLR",
    "dru_skin/Class|DRU",

    "enc_manaregen/Class|ENC",

    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
}

Default.ENC = {
    "clr_symbol/Class|CLR",

    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",

    --"mag_ds/Class|MAG",

    "clr_ac/Class|CLR", -- for pulling
    "dru_runspeed/Class|DRU",  -- for pulling

    "dru_str/Class|DRU", -- for looting
}

Default.WIZ = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "enc_manaregen/Class|ENC",
    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    --"enc_magic_resist/Class|ENC",
}

Default.MAG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "enc_manaregen/Class|ENC",
    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    --"enc_magic_resist/Class|ENC",
}

Default.NEC = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    --"clr_vie/Class|CLR",

    --"dru_fire_resist/Class|DRU",
    "shm_disease_resist/Class|SHM",
    --"enc_magic_resist/Class|ENC",
}

Default.RNG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "shm_str/Class|SHM",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    "enc_manaregen/Class|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",

    "dru_str/Class|DRU",
}

Default.ROG = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

Default.MNK = {
    "clr_symbol/Class|CLR",
    --"clr_ac/Class|CLR",
    "dru_skin/Class|DRU",
    "shm_focus/Class|SHM",

    "shm_str/Class|SHM",
    "rng_atk/Class|RNG",
    "enc_haste/Class|ENC",
    "shm_haste/Class|SHM/NotClass|ENC",

    --"dru_fire_resist/Class|DRU",
    --"enc_magic_resist/Class|ENC",
    "shm_disease_resist/Class|SHM",
}

return Default