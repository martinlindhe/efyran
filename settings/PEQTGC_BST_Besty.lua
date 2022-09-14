local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Staff of Phenomenal Power|Mainhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Staff of Phenomenal Power|Mainhand", -- 1hb
}

settings.gems = {
    ["Muada's Mending"] = 1, -- quick heal
    ["Ancient: Savage Ice"] = 2,
    ["Bestial Empathy"] = 3,
    ["Spirit of Oroshar"] = 4, -- pet proc

    ["Ferocity of Irionu"] = 6,
    ["Healing of Mikkily"] = 7, -- pet heal
    ["Growl of the Panther"] = 8, -- pet buff
    ["Spiritual Ascendance"] = 9, -- bst crack
}

settings.self_buffs = {
    "Fuzzy Foothairs/CheckFor|Bestial Alignment Effect",

    "Chaos-Imbued Leather Leggings", -- Aura of Eternity (+5 mana regen slot 8)

    "Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)

    "Ring of the Beast", -- Form of Endurance III (slot 5: 270 hp)

    "Spiritual Ascendance/MinMana|20", -- 10 hp + 10 mana/tick, group, cost 900 mana
}

settings.pet = {
    ["heals"] = {
        -- L59 Mend Companion AA (36 min reuse without Hastened Mending AA)
        -- L67 Replenish Companion Rank 1 AA
        "Replenish Companion/HealPct|50",

        -- L09 Sharik's Replenishing
        -- L15 Keshuval's Rejuvenation
        -- L27 Herikol's Soothing (274-298 hp, decrease dr 10, pr 10, cr 10)
        -- L36 Yekan's Recovery
        -- L49 Vigor of Zehkes (671 hp, decrease dr 10, pr 10, cr 10, cost 206 mana)
        -- L52 Aid of Khurenz (1044 hp, decrease dr 16, pr 16, cr 16, cost 293 mana)
        -- L55 Sha's Restoration (1426-1461 hp, decrease dr 20, pr 20, cr 20, cost 404 mana)
        -- L61 Healing of Sorsha (2018-2050 hp, decrease dr 24, pr 24, cr 24, cost 495 mana)
        -- L66 Healing of Mikkily (2810 hp, decrease dr 28, pr 28, cr 28, cost 610 mana)
        "Healing of Mikkily/HealPct|40/MinMana|10",
    },

    ["buffs"] = {
        "Spirit of Oroshar/MinMana|50", -- pet proc

        "Growl of the Beast/MinMana|40", -- pet haste

        -- L69 Growl of the Panther (1 min, 20% skill dmg mod, +150 hp HoT/tick, inc maxhp 1500)
        "Growl of the Panther/CheckFor|Empathic Fury",

        -- Lxx Hobble of Spirits I AA (75 dex, Hobble of Spirits proc, rate mod 150: 40-56% snare, XXX min
        -- L70 Hobble of Spirits II AA (75 dex, Hobble of Spirits proc, rate mod 150: 50% snare, resist adj -50, 0.6 min)
        "Hobble of Spirits",

        -- epic 1.5: Savage Lord's Totem (pet buff: double attack 5%, evasion 10%, hp 800, proc Savage Blessing Strike)
        -- epic 2.0: Spiritcaller Totem of the Feral (pet buff: double attack 8%, evasion 12%, hp 1000, proc Wild Spirit Strike)
        "Spiritcaller Totem of the Feral",

        --"Symbol of Ancient Summoning/Shrink", -- 3s cast x 3 times for 0.62 height
        "Shimmering Bauble of Trickery/Shrink", -- 1s cast x 5 times for 0.62 height
    },
}

settings.healing = {
    ["life_support"] = {
        "Muada's Mending/HealPct|88/MaxMobs|0", -- heal myself after fight
        "Protective Spirit Discipline/HealPct|40",
        "Distillate of Divine Healing XI/HealPct|8",
    },

    ["important"] = {
        "Stor", "Kamaxia", "Maynarrd", "Arriane", "Helge", "Gerrald", "Hankie", "Hybregee",
        "Drutten", "Lofty", "Gimaxx", "Samma", "Erland", "Kesok",
    },

    ["important_heal"] = {-- XXX impl
        -- quick heals:
        -- L06 Minor Healing (12-20 hp, cost 10 mana)
        -- L20 Light Healing (47-65 hp, cost 28 mana)
        -- L36 Healing (135-175 hp, cost 65 mana)
        -- L57 Greater Healing (280-350 hp, cost 115 mana)
        -- L62 Chloroblast (994-1044 hp, cost 331 mana)
        -- L65 Trushar's Mending (1048 hp, cost 330 mana)
        -- L67 Muada's Mending (1176-1206 hp, cost 376 mana, 3s cast time)
        "Muada's Mending/HealPct|50/MinMana|5",
    },

    ["who_to_heal"] = "ImportantBots", -- XXX impl
}

--[[
    -- TODO COMBAT BUFF
; combat buffs:
; L47 Frenzy (6-10 ac, 18-25 agi, 19-28 str, 25 dex, 10 min)
; L61 Growl of the Leopard (15% skill damage mod, 80 hp/tick, max hp 850, 1 min, cost 500 mana)
; L65 Ferocity (40 sta, 150 atk, 65 all resists, 6.5 min)
; L70 Ferocity of Irionu (52 sta, 187 atk, 65 all resists, 6.5 min)
Combat Buff=Ferocity of Irionu/Azoth/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Yelwen/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Laser/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Knuck/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Debre/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Kniven/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Strupen/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Fosco/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Lotho/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Grimakin/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Kedel/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Blod/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Urinfact/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Sweetlard/Gem|6/CheckFor|Infusion of the Faithful
Combat Buff=Ferocity of Irionu/Rupat/Gem|6/CheckFor|Infusion of the Faithful
]]

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
    ["abilities"] = {
        "Kick",
        "Rake", -- L70 Tome of Rake
        "Feral Swipe", -- Feral Swipe AA (30s reuse)
    },
    ["nukes"] = {
        ["main"] = {
            "Roar of Thunder/PctAggro|99", -- AA, reduce aggro

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
            "Ancient: Savage Ice/MinMana|60",

            -- L68 Bestial Empathy (swarm pet, 18s recast)
            "Bestial Empathy",
        },
        ["fastfire"] = {
            "Ancient: Savage Ice/MinMana|60",
        },
        ["bigfire"] = {
            "Ancient: Savage Ice/MinMana|60"
        },
        ["fastcold"] = {
            "Ancient: Savage Ice/MinMana|60",
        },
        ["bigcold"] = {
            "Ancient: Savage Ice/MinMana|60",
        },
    },
    ["dots_on_command"] = {
        -- L14 Sicken (3-5/tick, disease)
        -- L19 Tainted Breath (14-19/tick, poison)
        -- L35 Envenomed Breath (59-71/tick, poison, cost 181 mana)
        -- L52 Venom of the Snake (104-114 hp/tick, poison, cost 172 mana)
        -- L61 Scorpion Venom (162-170/tick, poison, cost 350 mana)
        -- L65 Plague (74-79 hp/tick, disease, cost 172 mana)
        -- L65 Turepta Blood (168/tick, poison, cost 377 mana)
        "Turepta Blood/Gem|3/MinMana|70",
    },
    ["debuffs"] = {
        -- L56 Incapacitate (-45-55 agi, -45-55 str, -21-24 ac)
        -- NOTE ENC disempower debuffs is stronger versions of this
        --"Incapacitate/Gem|3/MinMana|20/MaxTries|2",
    },
    ["debuffs_on_command"] = {
        -- slow:
        -- L65 Sha's Revenge (MAGIC, 65% slow, 3m30s duration)
        -- L70 Sha's Legacy (MAGIC -30 adj, 65% slow, 1m30s duration)
        "Sha's Legacy/Gem|3/MinMana|20/CheckFor|Balance of Discord",
    },
    ["quickburns"] = {
        -- oow T1 bp: Beast Tamer's Jerkin (Wild Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 18s)
        -- oow T2 bp: Savagesoul Jerkin of the Wilds (Savage Spirit Infusion, +50% skill dmg mod, -15% dmg taken for 30s)
        "Savagesoul Jerkin of the Wilds",

        "Frenzy of Spirit",
        "Roar of Thunder",
    },
    ["longburns"] = {
        "Bestial Alignment",
        "Empathic Fury",
        "Bestial Fury Discipline",
    },
}

return settings
