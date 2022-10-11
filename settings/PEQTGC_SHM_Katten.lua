local settings = { }

settings.swap = {
    ["main"] = "Blessed Spiritstaff of the Heyokah|Mainhand/Shield of the Planar Assassin|Offhand",
    ["melee"] = "Blessed Spiritstaff of the Heyokah|Mainhand", -- 1hb
}

settings.gems = {
    ["Ancient: Wilslik's Mending"] = 1,
    ["Spirit of the Panther"] = 2,
    ["Ice Age"] = 3,
    ["Malos"] = 4,
    ["Curse of Sisslak"] = 6,
    ["Talisman of Wunshi"] = 7,
    ["Blood of Nadox"] = 8,
    ["Remove Greater Curse"] = 9,
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- mana regen clicky:
    -- Chaotic Enlightenment (slot 8: 10 mana regen, slot 10: 6 hp regen)
    "Earring of Dragonkin",

    -- mana pool clicky:
    -- Reyfin's Racing Thoughts (slot 4: 450 mana pool, tacvi)
    --"Xxeric's Matted-Fur Mask",

    -- hp regen clicky:
    -- Form of Rejuvenation III (slot 12: 12 hp/tick, slot 6: immunity)
    "Warped Mask of Animosity",

    "Talisman of Wunshi/MinMana|15",

    "Talisman of the Tribunal/MinMana|50",
}

settings.combat_buffs = { -- XXX impl
--[[
Proc Buff (On/Off)=On
; proc buffs:
; L50 Spirit of the Puma (add proc Puma Maw, rate mod 400, 1 min)
; L57 Spirit of the Jaguar (add proc Jaguar Maw, rate mod 400, 1 min)
; L61 Spirit of the Leopard (add proc Leopard Maw, rate mod 400, 1 min)
; L69 Spirit of the Panther (add proc Panther Maw, rate mod 400, 1 min)
Proc Buff=Spirit of the Panther/MinMana|30
Proc Buff Class=BRD/ROG/MNK/BER
Instant Buff=
Combat Buff=
]]--
}


settings.pet = {
    ["auto"] = false,
    ["heals"] = {
        "Ancient: Wilslik's Mending/HealPct|25/MinMana|70",
    },
    ["buffs"] = {
        "Talisman of Celerity/MinMana|50/CheckFor|Hastening of Salik", -- haste
    },
}

settings.healing = {
    ["life_support"] = {
        "Ancestral Guard/HealPct|50", -- 15 min reuse
        "Distillate of Divine Healing XI/HealPct|10",
    },

    ["tanks"] = {-- XXX impl
        "Bandy",
        "Manu",
        --"Crusade",
        --"Nullius",
        --"Juancarlos",
    },

    ["important"] = {
        "Stor", "Kamaxia", "Maynarrd", "Arriane", "Helge", "Gerrald", "Hankie", "Hybregee",
        "Drutten", "Lofty", "Gimaxx", "Samma", "Erland", "Kesok",
    },

    -- quick heals:
    -- L01 Minor Healing (12-20 hp, cost 10 mana)
    -- L09 Light Healing (47-65 hp, cost 28 mana)
    -- L19 Healing (135-175 hp, cost 65 mana)
    -- L29 Greater Healing (280-350 hp, cost 115 mana)
    -- L51 Superior Healing (500-600 hp, cost 185 mana)
    -- L55 Chloroblast (994-1044 hp, cost 331 mana)
    -- L62 Tnarg's Mending (1770-1800 hp, cost 560 mana)
    -- L65 Daluda's Mending (2144 hp, cost 607 mana, 3.8s cast)
    -- L65 Zun'Muram's Spear of Doom (tacvi class click with Tnarg's Mending)
    -- L68 Yoppa's Mending (2448-2468 hp, cost 691 mana, 3.8s cast)
    -- L70 Ancient: Wilslik's Mending (2716 hp, cost 723 mana, 3.8s cast)

    -- ch:
    -- L58 Kragg's Mending (1950 hp, 10s cast, cost 400 mana)

    ["tank_heal"] = {-- XXX impl
        "Ancient: Wilslik's Mending/HealPct|37/MinMana|5",
    },

    ["important_heal"] = {-- XXX impl
        "Zun'Muram's Spear of Doom/HealPct|55",
        "Ancient: Wilslik's Mending/HealPct|50/MinMana|5",
    },

    ["all_heal"] = {-- XXX impl
        "Ancient: Wilslik's Mending/HealPct|40/MinMana|20",
    },

    ["who_to_heal"] = "Tanks/ImportantBots/All", -- XXX impl

    ["hot"] = { -- XXX impl
        --"Spiritual Serenity/HealPct|85/CheckFor|Pious Elixir",
    },
    ["who_to_hot"] = "",
}

settings.assist = {
    ["nukes"] = { -- XXX implement
        ["main"] = {
            -- L69 Ice Age (1273 hp, cost  413 mana)
            "Ice Age/NoAggro/MinMana|40",
        },

        ["fastcold"] = {
            "Ice Age/NoAggro/MinMana|40",
        },
    },

    ["dots"] = {
        -- magic dot:
        -- L69 Curse of Sisslak (578 hp/tick, cost 609 mana, 0.5 min)
        "Curse of Sisslak/MinMana|20",
    },

    ["debuffs"] = {
    },

    ["debuffs_on_command"] = {  -- XXX impl
    },

    ["quickburns"] = {
        -- epic 2.0: Blessed Spiritstaff of the Heyokah
        "Blessed Spiritstaff of the Heyokah",

        "Spirit Call", -- swarm pets, 15 min reuse / 10 min with Hastened Spirit Call

        -- L65 Dampen Resistance AA (reduce resist chance, 10 min reuse / X min with Hastened Dampen Resistance)
        --"Dampen Resistance",
    },

    ["longburns"] = {
        -- Ancestral Aid Rank 1 AA (xxx)
        -- Ancestral Aid Rank 2 AA (id:5934, str/agi/dex cap+60, HoT cap +305)
        -- Ancestral Aid Rank 3 AA (id:5935, str/agi/dex cap+90, HoT cap +333)
        -- also MGB:ed sometimes so only not on burns
        --"Ancestral Aid",  -- XXX condition to cast it if MGB aa is > 15 minute

        -- L65 Call of the Ancients AA (heal ward, 30 min reuse)
        --"Call of the Ancients",
    },

    ["pbae"] = {
        -- ae slow:
        -- L58 Tigir's Insects (50% slow, decrease hate 200, aerange 20, 3 min)
        -- L70 Vindictive Spirit (50% slow, -100 magic adj, aerange 50, 0.3 min)
        --"Breath of Antraygus/Gem|6/MinMana|10"

        -- directional ae:
        -- L69 Breath of Antraygus (directional AoE, 1200 dmg, 12s recast, cost 700 mana)
        --"Vindictive Spirit/Gem|3/MinMana|10",

        -- "aura" idol:
        -- L55 Idol of Malo
        -- L70 Idol of Malos
        "Idol of Malos/Gem|3",
    },
}

settings.shaman = { -- XXX impl / rearrange
--[[
Auto-Canni (On/Off)=On
; cannibalize:
; L23 Cannibalize (19-32 mana, cost 50 hp)
; L38 Cannibalize II (30-46 mana, cost 67 hp)
; L54 Cannibalize III (39-51 mana, cost 74 hp)
; L58 Cannibalize IV (81-82 mana, cost 148 hp)
; Lxx Cannibalization AA (xxx mana / hp)
; L65 Ancient: Chaotic Pain (360 mana, cost 668 hp, 18s recast)
; L68 Pained Memory (360 mana, cost 668 hp, 18s recast)
; L70 Ancient: Ancestral Calling (468 mana, cost 868 hp, 18s recast)
; L70 Spiritual Channeling AA (xxx)

; NOTE: not doing spell AA because its wasting time & gem slot
;Canni=Ancient: Ancestral Calling/Gem|9/MinHP|60/MaxMana|90
;Canni=Cannibalization/MinHP|60/MaxMana|80
Canni=Spiritual Channeling/MinHP|60/MaxMana|30
]]--
}

return settings
