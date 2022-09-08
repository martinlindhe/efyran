local settings = { }

settings.swap = {
    ["main"] = "Blessed Spiritstaff of the Heyokah|Mainhand/Shield of the Planar Assassin|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",
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
    "Xxeric's Matted-Fur Mask",

    -- hp regen clicky:
    -- Form of Rejuvenation III (slot 12: 12 hp/tick, slot 6: immunity)
    "Warped Mask of Animosity",

    "Talisman of Wunshi/MinMana|15",

    "Talisman of the Tribunal/MinMana|50",
}

settings.combat_buffs = { -- XXX impl
--[[
; combat buffs:
; L60 Avatar (100 atk, 100 agi, 100 str, 100 dex, 6.0 min, cost 325 mana) - DOES NOT stack with Night's Dark Terror
; L60 Primal Avatar (100 atk, 100 agi, 100 str, 100 dex, 6.4 min, cost 325 mana)
; L65 Ferine Avatar (140 atk, 140 agi, 140 str, 140 dex, 6.5 min, cost 350 mana)
; L70 Champion (140 atk, 140 agi, 140 str, 140 dex, 10% all skills dmg mod, aerange 60 all nearby, cost 1500 mana)
; NOTE: SHM Erland does ae Champion
Combat Buff=Champion/Azoth/Gem|4
Combat Buff=Champion/Yelwen
Combat Buff=Champion/Laser
Combat Buff=Champion/Knuck

Combat Buff=Champion/Blod
Combat Buff=Champion/Urinfact

Combat Buff=Champion/Kniven
Combat Buff=Champion/Strupen

; L68 Lingering Sloth (add a pet proc that can slow mobs that hit it)
; NOTE: Sloth done by me
Combat Buff=Lingering Sloth/Bandy/MinMana|20/Gem|6
;;Combat Buff=Lingering Sloth/Manu/MinMana|25
;;Combat Buff=Lingering Sloth/Nullius/MinMana|25
;;Combat Buff=Lingering Sloth/Spela/MinMana|30


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
        -- Ancestral Guard - 15 min reuse
        -- Lxx Ancestral Guard Rank 1 AA (id:8218,  mitigate 25% melee dmg until 5000 absorbed)
        -- Lxx Ancestral Guard Rank 2 AA (id:8219,  mitigate 50% melee dmg until 5000 absorbed)
        -- L70 Ancestral Guard Rank 3 AA (id:x)
        -- L70 Ancestral Guard Rank 6 AA (id:13518, mitigate 75% melee dmg until 11000 absorbed)
        "Ancestral Guard/HealPct|50",

        "Distillate of Divine Healing XI/HealPct|10",
    },

    ["rez"] = { -- XXX impl
        -- L59 Incarnate Anew (90% exp, 20s cast, 700 mana)
        -- Lxx Call of the Wild (0% rez, corpse can be properly rezzed later)
        "Call of the Wild",
    },

    ["cures"] = {
        --[[
        [Cures]
        ; Keldovan the Harrier - decrease healing effectiveness by 80%
        Cure=Remove Greater Curse/Bandy/CheckFor|Packmaster's Curse/Zone|anguish
        Cure=Remove Greater Curse/Manu/CheckFor|Packmaster's Curse/Zone|anguish
        Cure=Remove Greater Curse/Crusade/CheckFor|Packmaster's Curse/Zone|anguish
        Cure=Remove Greater Curse/Nullius/CheckFor|Packmaster's Curse/Zone|anguish
        Cure=Remove Greater Curse/Juancarlos/CheckFor|Packmaster's Curse/Zone|anguish

        ; mpg raid endurance
        Cure=Remove Greater Curse/Nullius/CheckFor|Complex Gravity/Zone|chambersb

        ; Warden Hanvar - mana dot
        Cure=Remove Greater Curse/Stor/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Kamaxia/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Maynarrd/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Gerrald/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Arriane/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Helge/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Erland/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Drutten/CheckFor|Feedback Dispersion/Zone|anguish
        Cure=Remove Greater Curse/Lofty/CheckFor|Feedback Dispersion/Zone|anguish

        ; rathe council:
        CureAll=Remove Greater Curse/CheckFor|Marl/Zone|poearthb

        CureAll=Remove Greater Curse/CheckFor|Gravel Rain/Zone|potactics,poearthb
        CureAll=Remove Greater Curse/CheckFor|Solar Storm/Zone|poair
        CureAll=Remove Greater Curse/CheckFor|Curse of the Fiend/Zone|solrotower

        ; CLR 1.5 + 2.0 fights + SHM 2.0:
        CureAll=Remove Greater Curse/CheckFor|Deathly Chants

        CureAll=Remove Greater Curse/CheckFor|Storm Comet/Zone|poair
        CureAll=Remove Greater Curse/CheckFor|Curse of Rhag`Zadune/Zone|ssratemple
        CureAll=Disinfecting Aura/CheckFor|Chailak Venom/Zone|riftseekers
        CureAll=Disinfecting Aura/CheckFor|Fulmination/Zone|Txevu
        CureAll=Blood of Nadox/CheckFor|Plague of Hulcror

        ; cursecaller root
        CureAll=Remove Greater Curse/CheckFor|Debilitating Curse of Noqufiel/Zone|inktuta

        ; Overlord Mata Muram, -25% accuracy, -100 casting level, 1.0 min
        CureAll=Remove Greater Curse/CheckFor|Torment of Body/Zone|anguish

        ; Overlord Mata Muram - silence on CH bots
        Cure=Remove Greater Curse/Arriane/CheckFor|Void of Suppression/Zone|anguish
        Cure=Remove Greater Curse/Gerrald/CheckFor|Void of Suppression/Zone|anguish
        Cure=Remove Greater Curse/Hankie/CheckFor|Void of Suppression/Zone|anguish
        Cure=Remove Greater Curse/Hybregee/CheckFor|Void of Suppression/Zone|anguish


        AutoRadiant (On/Off)=On
        RadiantCure=Fulmination/MinSick|1/Zone|txevu
        RadiantCure=Skullpierce/MinSick|1/Zone|qvic
        RadiantCure=Malo/MinSick|1
        RadiantCure=Insidious Decay/MinSick|1
        RadiantCure=Chaos Claws/MinSick|1
        RadiantCure=Gravel Rain/MinSick|1/Zone|potactics,poearthb
        RadiantCure=Chaotica/MinSick|1/Zone|riftseekers
        RadiantCure=Pyronic Lash/MinSick|1/Zone|riftseekers
        RadiantCure=Whipping Dust/MinSick|1/Zone|causeway

        RadiantCure=Gaze of Anguish/MinSick|1/Zone|anguish
        RadiantCure=Chains of Anguish/MinSick|1/Zone|anguish
        RadiantCure=Feedback Dispersion/MinSick|1/Zone|anguish
        RadiantCure=Wanton Destruction/MinSick|1/Zone|anguish,txevu
        ]]
    },

    ["tanks"] = {-- XXX impl
        --"Bandy",
        --"Manu",
        "Crusade",
        "Nullius",
        "Juancarlos",
    },

    ["important"] = {
        "Stor", "Kamaxia", "Maynarrd", "Arriane", "Helge", "Gerrald", "Hankie", "Hybregee",
        "Drutten", "Lofty", "Gimaxx", "Samma", "Kesok",
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
        "Ancient: Wilslik's Mending/HealPct|45/MinMana|5",
    },

    ["important_heal"] = {-- XXX impl
        "Zun'Muram's Spear of Doom/HealPct|70",
        "Ancient: Wilslik's Mending/HealPct|60/MinMana|5",
    },

    ["all_heal"] = {-- XXX impl
        "Ancient: Wilslik's Mending/HealPct|44/MinMana|20",
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
            -- ice nukes:
            -- L14 Spirit Strike (72-78 hp, cost 44 mana)
            -- L23 Frost Strike (142-156 hp, cost 78 mana)
            -- L33 Winter's Roar (236-246 hp, cost 116 mana)
            -- L44 Blizzard Blast (332-346 hp, cost 147 mana)
            -- L54 Ice Strike (511 hp, cost 198 mana)
            -- L64 Velium Strike (925 hp, cost 330 mana)
            -- L69 Ice Age (1273 hp, cost  413 mana)

            -- poison nukes:
            -- L54 Blast of Venom (704 hp, cost 289 mana)
            -- L61 Spear of Torment (870 hp, cost 340 mana)
            -- L66 Yoppa's Spear of Venom (1197 hp, cost 425 mana)
            "Ice Age/NoAggro/MinMana|40",
        },

        ["fastcold"] = {
            "Ice Age/NoAggro/MinMana|40",
        },
    },

    ["dots"] = {
        -- disease dot:
        -- L04 Sicken (3-5/tick)
        -- L19 Affliction (20-25/tick)
        -- L64 Breath of Ultor (163-170 hp/tick, cost 385 mana)
        -- L67 Breath of Wunshi (214-223 hp/tick, cost 500 mana, 1.4 min)

        -- magic dot:
        -- L64 Bane (426-440 hp/tick, cost 490 mana)
        -- L69 Curse of Sisslak (578 hp/tick, cost 609 mana, 0.5 min)
        "Curse of Sisslak/MinMana|20",

        -- poison dot:
        -- L08 Tainted Breath (14-19/tick)
        -- L24 Envenomed Breath (59-71/tick)
        -- L37 Venom of the Snake (104-114/tick, cost 172 mana)
        -- L49 Envenomed Bolt (138-146 hp/tick, cost 202 mana)
        -- L56 Bane of Nife (228-258 hp/tick, cost 493 mana)
        -- L54 Anathema (222-243 hp/tick, cost 320 mana)
        -- L65 Blood of Saryrn (320-335 hp/tick, cost 535 mana, 0.7 min)
        -- L70 Blood of Yoppa (450 hp/tick, cost 658 mana, 0.7 min)
        -- L70 Nectar of Pain (596 hp/tick, cost 660 mana, 0.7 min, -30 resist adj)
    },

    ["debuffs"] = {
        -- oow t1 bp: Spiritkin Tunic (reduce resist rate by 40% for xxx sec)
        -- oow t2 bp: Ritualchanter's Tunic of the Ancestors (reduce resists rate by xxx for 42s)
        --"Ritualchanter's Tunic of the Ancestors",

        -- L65 Malos (-55 cr, -55 mr, -55 pr, -55 fr, unresistable, cost 400 mana)
        -- NOTE: Erland does Malos, Myggan does Malosinia, Kesok does Putrid Decay
        "Malos/MaxTries|2/MinMana|20",
    },

    ["debuffs_on_command"] = {  -- XXX impl
        "Malos/MaxTries|2/MinMana|10",
    },

    ["quickburns"] = {
        -- epic 2.0: Blessed Spiritstaff of the Heyokah
        "Blessed Spiritstaff of the Heyokah",

        "Spirit Call", -- swarm pets, 15 min reuse / 10 min with Hastened Spirit Call

        -- L65 Dampen Resistance AA (reduce resist chance, 10 min reuse / X min with Hastened Dampen Resistance)
        "Dampen Resistance",
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

    ["pbae"] = { -- XXX impl
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
