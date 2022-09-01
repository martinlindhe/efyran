local settings = { }

--settings.mount = "Glowing Black Drum"
settings.mount = "Collapsible Roboboar"

settings.gems = {
    ["Venin"] = 1, -- poison nuke
    ["Coruscating Darkness"] = 2, -- snare
    ["Scent of Afterlight"] = 3, -- resist debuff
    ["Ashengate Pyre"] = 4, -- fire dot

    ["Dead Men Floating"] = 7,
    ["Death Peace"] = 8, -- XXX where's the AA?
    --["Shadowskin"] = 9, -- self rune
    ["Sigil of the Aberrant"] = 10, -- pet buff
    ["Dark Salve"] = 11, -- pet heal
    ["Noxious Servant"] = 12, -- pet
}

settings.self_buffs = {
    -- XXX clickies ?

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
    "Spectralside",


    -- shield - does not stack with Virtue or Focus:
    -- L01 Minor Shielding (6-10 hp, 3-4 ac)
    -- L16 Shielding (45-50 hp, 11-13 ac, 11-12 mr)
    -- L24 Major Shielding (68-75 hp, 16-18 ac, 14 mr)
    -- L33 Greater Shielding (91-100 hp, 20-22 ac, 16 mr)
    -- L41 Arch Shielding (140-150 hp, 24-27 ac, 20 mr)
    -- L54 Shield of the Magi (232-250 hp, 29-31 ac, 22-24 mr)
    -- L61 Shield of the Arcane (298-300 hp, 34-36 ac, 30 mr)
    -- L64 Shield of Maelin (350 hp, 38-39 ac, 40 mr)
    --"Shield of Maelin/MinMana|70",


    -- L41 Dead Man Floating (61-70 pr, water breathing, see invis, levitate)
    -- L45 Dead Men Floating (65-70 pr, water breathing, see invis, levitate, group)
    "Dead Men Floating",

    -- self rune, slot 1:
    -- L63 Force Shield (absorb 750 dmg, 2 mana/tick)
    -- L69 Dull Pain (absorb 975 dmg, 3 mana/tick)
    -- L73 Wraithskin Rk. II (slot 1: absorb 1219 dmg, 4 mana/tick)
    -- L78 Shadowskin Rk. II (slot 1: absorb 1585 dmg, 4 mana/tick)
    -- NOTE: does not stack with ENC rune
    "Shadowskin/MinMana|100/CheckFor|Rune of the Deep",
}


settings.healing = {
    ["life_support"] = {
        -- feign death:
        -- Lxx Feign Death (87% success, 12 sec recast)
        -- L52 Comatose (87% success, 8 sec recast)
        -- L60 Death Peace (98% success, 4s recast)
        -- L6x Death Peace AA Rank 1 (???)    - XXX disappered on live
        -- L76 Death Peace AA Rank 2 (???)
        "Death Peace/HealPct|35",

        -- invulnerability:
        -- Lxx Harmshield
        -- L58 Quivering Veil of Xarn (invulnerability 0.3 min, +150 hp)
        --"Quivering Veil of Xarn/Gem|7/HealPct|33",

        "Distillate of Divine Healing XIII/HealPct|12",
    },

    ["rez"] = {
        -- L53 Convergence (93% rez)
        --"Convergence/Reagent|Essence Emerald",
    }
}


settings.assist = {
    ["nukes"] = {
        ["main"] = {
            -- poison nukes:
            -- L54 Torbas' Venom Blast (688 hp, cost 251 mana)
            -- L61 Neurotoxin (1325 hp, cost 445 mana)
            -- L66 Acikin (1823 hp, cost 556 mana)
            -- L?? Ancient: Touch of Orshilak XXXXXX
            -- L71 Venin (2279 hp, cost 660 mana, 5% to proc essence emerald if slain)
            -- L76 Ruinous Venin Rk. II (2962 hp, cost 797 mana, 5% to proc essence emerald if slain)

            -- L75 Demand for Blood (2241 hp, cost 673 mana, adds a chance of temporary adjusting dot dmg)
            -- L80 Supplication of Blood (2532 hp, cost 742 mana, adds a chance of temporary adjusting dot dmg)
            "Venin/NoAggro/MaxHP|30/MinMana|90", -- XXX impl MaxHP  OR  MaxTargetHp to cast when HP of target is less than this
            
            -- mana drain
            -- L70 Mind Flay          (decrease mana by 360 and give to group, -200 dr check, cost 700 mana)
            -- L79 Mental Vivisection (decrease mana by 482 and give to group, -200 dr check, cost 936 mana)
            --"Mind Flay/Gem|8/MaxMana|95",  -- XXX impl MaxMana??
        },
    },

    ["dots"] = {
        -- dots:
        -- L04 Poison Bolt (10 hp/tick, poison)
        -- L13 Heart Flutter (18-22 hp/tick, -13-20 str, -7-9 ac)
        -- L36 Chilling Embrace (100-114 hp/tick, poison)
        -- L61 Dark Plague (182-190 hp/tick, resist adj -50, disease, cost 340 mana)
        -- L65 Blood of Thule (350-360 hp/tick, resist adj -50, poison)
        -- L66 Chaos Plague (247-250 hp/tick, resist adj -50, disease)
        -- L67 Grip of Mori (194-197 hp/tick, -63-65 str, -35-36 ac, cost 325 mana)
        -- L68 Fang of Death (370 hp/tick, MAGIC, resist adj -200, cost 750 mana)
        -- L69 Corath Venom (611 hp/tick, POISON,  resist adj -50, cost 655 mana)
        -- L70 Chaos Venom (473 hp/tick, POISON, resist adj -50, cost 566 mana)
        
        -- magic dots:
        -- L62 Saryrn's Kiss (191-200 hp/tick, resist adj -200, magic, cost 550 mana)
        -- L63 Horror (432-450 hp/tick, resist adj -30, magic, cost 450 mana)
        -- L67 Dark Nightmare (591 hp/tick, resist adj -30, magic, cost 585 mana)
        -- L70 Ancient: Curse of Mori (639 hp/tick, resist adj -30, magic, cost 625 mana)
        
        -- fire dots:
        -- L10 Heat Blood (28-43 hp/tick)
        -- L28 Boil Blood (67 hp/tick)
        -- L58 Pyrocruor (156-166 hp/tick)
        -- L65 Night Fire (335 hp/tick, resist adj -100)
        -- L69 Pyre of Mori (419 hp/tick, resist adj -100, cost 560 mana)
        -- L70 Dread Pyre (956 hp/tick, resist adj -100, cost 1093 mana)
        -- L74 Ashengate Pyre Rk. II (1506 hp/tick, resist adj -100, cost 1694 mana)
        -- L79 Reaver's Pyre (2372 hp/tick, resist adj -100, cost 2651 mana)
        "Ashengate Pyre/MaxTries|2/MinMana|40", -- XXX impl MaxTries
        
        -- snare dots:
        -- L04 Clinging Darkness (8 hp/tick, 24-30% snare, 0.8 min, cost 20 mana)
        -- L11 Engulfing Darkness (11 hp/tick, 40% snare, 1.0 min, cost 60 mana)
        -- L27 Dooming Darkness (20 hp/tick, 48-59% snare, 1.5 min, cost 120 mana)
        -- L47 Cascading Darkness (72 hp/tick, 60% snare, 1.6 min, cost 300 mana)
        -- L59 Devouring Darkness (123 hp/tick, 69-75% snare, 1.3 min, cost 400 mana)
        -- L63 Embracing Darkness (resist adj -20, 68-70 hp/tick, 75% snare, 2.0 min, cost 200 mana)
        -- L68 Desecrating Darkness (resist adj -20, 96 hp/tick, 75% snare, 2.0 min, cost 248 mana)
        -- L74 Coruscating Darkness Rk. II (resist adj -40, 125 hp/tick, 75% snare, 2.0 min, cost 291 mana)
        -- L79 Auroral Darkness (resist adj -30, 137 hp/tick, 75% snare, 2.9 min, cost 323 mana)
        "Coruscating Darkness/MinMana|10",

        --"Dagger of Death", -- tacvi class clicky with Horror dot

        -- Encroaching Darkness AA (damage free snare)
        --"Encroaching Darkness/MaxTries|2",
    },

    ["debuffs"] = {
        -- scent debuff:
        -- L10 Scent of Dusk (-6-9 fr, -6-9 pr, -6-9 dr)
        -- L37 Scent of Darkness (-23-27 fr, -23-27 pr, -23-27 dr)
        -- L52 Scent of Terris (-33-36 fr, -33-36 pr, -33-36 dr, poison)
        -- L68 Scent of Midnight (-55 dr, -55 pr, disease resist adj -200)
        -- L72 Scent of Twilight Rk. II   (-63 dr, -63 pr, increase spell damage by 1%, disease resist adj -200, cost 250 mana)
        -- L77 Scent of Afterlight Rk. II (-69 dr, -69 pr, increase spell damage by 1%, disease resist adj -200, cost 250 mana)
        --"Scent of Afterlight/MaxTries|2",
    },

    ["debuffs_on_command"] = {
        "Scent of Afterlight/MaxTries|3",
    },

    ["pbae"] = {
        -- L20 Word of Shadow (MAGIC, 52-58 hp, aerange 20, recast 9s, cost 85 mana)
        -- L27 Word of Spirit (MAGIC, 91-104 hp, aerange 20, recast 9s, cost 133 mana)
        -- L36 Word of Souls (MAGIC, 138-155 hp, aerange 20, recast 9s, cost 171 mana)
        --"Word of Souls/Gem|7/MinMana|10",
        --"Word of Spirit/Gem|6/MinMana|10",
    },

    ["quickburns"] = {
        -- Wake the Dead Rank 1-3 (60, 75, 90 sec)
        -- Army of the Dead Rank 1-x (3 for 60 sec, 4 for 75 sec, 5 for 90 sec)
        --"Army of the Dead",

        -- oow tier 1 bp (increase dot dmg)
        --"Deathcaller's Robe",

        -- epic 1.5: Soulwhisper (Servant of Blood, swarm pet)
        -- epic 2.0: Deathwhisper (Guardian of Blood, swarm pet)
        --"Deathwhisper",

        -- 30 min reuse
        "Swarm of Decay",
    },
}

--[[
[Necromancer]
-- lifetaps:
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
-- L71 Drain Life (1505 hp, cost 667 mana)
-- L76 Siphon Essence Rk. II (1956 hp, -200 mr resist, cost 806 mana)
;LifeTap=Deflux/gem|1/HealPct|70

Mana Dump (On/Off)=On

Who to Mana Dump=Stor/95
Who to Mana Dump=Kamaxia/95
Who to Mana Dump=Maynarrd/95
Who to Mana Dump=Helge/95
Who to Mana Dump=Arriane/95
Who to Mana Dump=Gerrald/95
Who to Mana Dump=Hankie/90
Who to Mana Dump=Hybregee/90
Who to Mana Dump=Trams/80
Who to Mana Dump=Kasper/80

-- mana dump:
-- L21 Rapacious Subvention (60 mana, cost 200 mana)
-- L43 Covetous Subversion (100 mana, cost 300 mana, 8s recast)
-- L56 Sedulous Subversion (150 mana, cost 400 mana, 8s recast)
Mana Dump=Sedulous Subversion/MinMana|5/Gem|4
Mana Dump=Covetous Subversion/MinMana|5/Gem|3
Lich Spell=
LifeTap=


]]--


settings.pet = {
    -- L01 Cavoting Bones
    -- L04 Leering Corpse
    -- L08 Bone Walk
    -- L12 Convoke Shadow
    -- L16 Restless Bones
    -- L20 Animate Dead
    -- L24 Haunting Corpse
    -- L29 Summon Dead
    -- L33 Invoke Shadow
    -- L39 Malignant Dead (pet is L33)
    -- L56 Servant of Bones (pet is L44)
    -- L59 Emissary of Thule (pet is L47)
    -- L61 Legacy of Zek (pet WAR/XX)
    -- L63 Saryrn's Companion (pet ROG/60)
    -- L67 Lost Soul (pet WAR/65)
    -- L70 Dark Assassin (pet ROG/65)
    -- L72 Riza`farr's Shadow (xxx)
    -- L75 Putrescent Servant (xxx)
    -- L77 Relamar's Shade (xxx)
    -- L80 Noxious Servant (xxx)
    -- NOTE: skip reagent with Deadly Pact AA
    ["spell"] = "Noxious Servant/MinMana|10/Reagent|Bag of the Tinkerers",

    ["heals"] = {
        -- pet heals:
        -- L07 Mend Bones (22-32 hp)
        -- L26 Renew Bones (121-175 hp)
        -- L64 Touch of Death (1190-1200 hp, -24 dr, -24 pr, -24 curse, cost 290 mana)
        -- L69 Dark Salve (1635-1645 hp, -28 dr, -28 pr, -28 curse, cost 358 mana)
        -- L6x Replenish Companion AA Rank 1
        -- L69 Replenish Companion AA Rank 3
        -- L73 Chilling Renewal (2420-2440 hp, -34 dr, -34 pr, -34 curse, -8 corruption, cost 504 mana)

        "Replenish Companion/HealPct|40",

        "Dark Salve/HealPct|60",
    },

    ["buffs"] = {
        -- haste
        -- L23 Intensify Death (25-33 str, 21-30% haste, 6-8 ac)
        -- L35 Augment Death (37-45 str, 45-55% haste, 9-12 ac
        -- L55 Augmentation of Death (52-55 str, 65% haste, 14-15 ac)
        -- L62 Rune of Death (65 str, 70% haste, 18 ac)
        -- L67 Glyph of Darkness (5% skills dmg mod, 84 str, 70% haste, 23 ac)
        -- L72 Sigil of the Unnatural (6% skills dmg mod, 96 str, 70% haste, 28 ac)
        -- L77 Sigil of the Aberrant Rk. II (10% skills dmg mod, 122 str, 70% haste, 36 ac)
        "Sigil of the Aberrant/MinMana|30",

        "Tiny Companion/Shrink",

        --"Algae Covered Stiletto/Shrink", -- XXX farm this clicky in powater
    },
}



return settings
