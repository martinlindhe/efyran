local settings = { }

settings.gems = {
    -- XXX
    ["Flight of Eagles"] = 11,
    ["Second Life"] = 12,
}

settings.self_buffs = {

    -- L80 Mask of the Shadowcat (SELF, slot 2: 9 mana/tick)
    -- XXX WORKS! (i don't have rk 2 !!!)
    "Mask of the Shadowcat",

    -- L78 Viridithorn Coat (SELF, slot 2: 86 AC, slot 3: 23 ds)
    -- L78 Viridithorn Coat Rk. II (SELF, slot 2: 98 AC, slot 3: 26 ds)
    "Viridithorn Coat",

    -- L77 Ironwood Skin (SINGLE TARGET, slot 1: 58 ac, slot 2: 1062 max hp, slot 4: 12 mana/tick)
    -- L77 Ironwood Skin Rk. II (SINGLE TARGET, slot 1: 66 ac, slot 2: 1255 max hp, slot 4: 14 mana/tick)
    -- XXXXXXX   wont detect buff ..!??!?!?! chain refresh. how is buff ranks treated?
    "Ironwood Skin",

    -- L75 Second Life (SELF, increase divine save by 25%)
    -- L75 Second Life Rk. II (SELF, increase divine save by 29%)
    "Second Life",

    -- XXX clickies
    -- Crimson Mask of Triumph: Geomantra III
    "Crimson Mask of Triumph",
}

return settings
