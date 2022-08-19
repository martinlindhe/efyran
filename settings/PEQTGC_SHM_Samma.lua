local settings = { }

settings.swap = {
    ["main"] = "Blessed Spiritstaff of the Heyokah|Mainhand/Shield of the Planar Assassin|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",
    ["melee"] = "Blessed Spiritstaff of the Heyokah|Mainhand", -- 1hb
}

settings.gems = {
    ["Ancient: Wilslik's Mending"] = 1,
    ["Spirit of the Panther"] = 2,
    ["Balance of Discord"] = 3,
    ["Spiritual Serenity"] = 4,
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

    -- bear illusion:
    -- L25 Form of the Bear (1 hp/tick, 5 wis)
    -- L55 Form of the Great Bear (2 hp/tick, 10 wis)
    --"Form of the Great Bear/MinMana|60",

    -- regen:
    -- L23 Regeneration (5 hp/tick, 17.5 min, cost 100 mana)
    -- L39 Chloroplast (10 hp/tick, 17.5 min, cost 200 mana)
    -- L52 Regrowth (20 hp/tick, 17.5 min, cost 300 mana)
    -- L61 Replenishment (40 hp/tick, 20.5 min, cost 275 mana)
    -- L63 Blessing of Replenishment (40 hp/tick, 20.5 min, cost 650 mana, group)
    -- NOTE: druid handles regen buffs
    --"Replenishment/MinMana|20/CheckFor|Regrowth of the Grove",

    -- frenzy buffs:
    -- L16 Frenzy (6-10 ac, 18-25 agi, 19-28 str, 25 dex, 10 min)
    -- L30 Fury (12-15 ac, 32-35 agi, 25-35 str, 35 dex, 10 min)
    -- L45 Rage (17-18 ac, 47-55 agi, 47-51 str, 47-60 dex, 15m42s)
    --"Rage/MinMana|40",
}

settings.group_buffs = {
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
    ["run"] = {
        "SSpirit of Bih`Li/MinLevel|1/CheckFor|Flight of Eagles",  -- XXX CheckFor on group buffs... ?!
    }
}

settings.bot_buffs = {
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
    -- NOTE: Kesok does Talisman of Might, Drutten does single target

    ["Talisman of Fortitude/MinMana|60"] = {
        "Bandy", "Nullius", "Crusade", "Manu",
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

    -- DEX - affects bard song missed notes, procs & crits
    -- L01 Dexterous Aura (5-10 dex)
    -- L21 Spirit of Monkey (19-20 dex)
    -- L25 Rising Dexterity (26-30 dex)
    -- L39 Deftness (40 dex)
    -- L48 Dexterity (49-50 dex) - blocked by Khura's Focusing (60 dex)
    -- L58 Mortal Deftness (60 dex)
    -- L59 Talisman of the Raptor (60 dex, group)

    -- NOTE: I do focus team18, Erland does rest
    ["Talisman of Wunshi/MinMana|50"] = {
        -- team18
        "Stor", "Bandy", "Crusade", "Spela", "Azoth", "Blastar",
        "Myggan", "Absint", "Trams", "Kamaxia", "Gerwulf", "Redito",
        "Kniven", "Besty", "Grimakin", "Chancer", "Fandinu",
    },

    -- resist buffs:
    -- L50 Talisman of Jasinth (45 dr, group)
    -- L53 Talisman of Shadoo (45 pr, group)
    -- L58 Talisman of Epuration (55 dr, 55 pr, group)
    -- L62 Talisman of the Tribunal (65 dr, 65 pr, group)
    -- NOTE: limited now because of 15 buff-limit
    ["Talisman of the Tribunal/MinMana|40"] = {
        "Bandy", "Manu", "Crusade", "Nullius",
    },
}

settings.combat_buffs = { -- XXX impl
--[[
; combat buffs:
; L60 Avatar (100 atk, 100 agi, 100 str, 100 dex, 6.0 min, cost 325 mana) - DOES NOT stack with Night's Dark Terror
; L60 Primal Avatar (100 atk, 100 agi, 100 str, 100 dex, 6.4 min, cost 325 mana)
; L65 Ferine Avatar (140 atk, 140 agi, 140 str, 140 dex, 6.5 min, cost 350 mana)
; L70 Champion (140 atk, 140 agi, 140 str, 140 dex, 10% all skills dmg mod, aerange 60 all nearby, cost 1500 mana)
; NOTE: SHM Erland does ae Champion
;Combat Buff=Champion/Bandy/Gem|8

; L68 Lingering Sloth (add a pet proc that can slow mobs that hit it)
; NOTE: Sloth done by Erland

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



settings.pet = { -- XXX impl
    ["auto"] = false, -- XXX if true, will auto-summon and auto-buff pet
    -- L32 Companion Spirit
    -- L37 Vigilant Spirit
    -- L41 Guardian Spirit
    -- L45 Frenzied Spirit
    -- L55 Spirit of the Howler
    -- L61 True Spirit (pet WAR/58)
    -- L67 Farrel's Companion (pet WAR/63)
    ["spell"] = "Farrel's Companion/MinMana|80/Reagent|Bag of the Tinkerers",
 
    ["heals"] = {
        "Ancient: Wilslik's Mending/HealPct|25/MinMana|70",
    },

    ["buffs"] = {
        -- pet haste:
        -- L50 Spirit Quickening (30 str, 20% haste, 19-27 ac, 60 min)
        -- L63 Swift Like the Wind (60% haste, 16 min)
        -- L64 Talisman of Celerity (60% haste, 36 min, group)
        "Talisman of Celerity/MinMana|50",
    },
}

settings.healing = { -- XXX implement
    ["life_support"] = { -- XXX implement
        -- Ancestral Guard - 15 min reuse
        -- Lxx Ancestral Guard Rank 1 AA (id:8218,  mitigate 25% melee dmg until 5000 absorbed)
        -- Lxx Ancestral Guard Rank 2 AA (id:8219,  mitigate 50% melee dmg until 5000 absorbed)
        -- L70 Ancestral Guard Rank 3 AA (id:x)
        -- L70 Ancestral Guard Rank 6 AA (id:13518, mitigate 75% melee dmg until 11000 absorbed)
        "Ancestral Guard/HealPct|50/CheckFor|Resurrection Sickness",

        "Distillate of Divine Healing XI/HealPct|10/CheckFor|Resurrection Sickness",
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
        "Stor", "Kamaxia", "Maynarrd", "Arriane", "Helge", "Gerrald", "Hankie",
        "Drutten", "Lofty", "Gimaxx", "Erland", "Kesok",
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
        "Zun'Muram's Spear of Doom/HealPct|80",
        "Ancient: Wilslik's Mending/HealPct|75/MinMana|5",
    },

    ["all_heal"] = {-- XXX impl
        "Ancient: Wilslik's Mending/HealPct|48/MinMana|20",
    },

    ["who_to_heal"] = "Tanks/ImportantBots/All", -- XXX impl

    ["hot"] = { -- XXX impl
        -- hot - slot 1:
        -- L65 Quiescence (420 hp/tick, 0.4 min, cost 280 mana)
        -- L65 Breath of Trushar (630 hp/tick, 0.4 min, cost 420 mana)
        -- L70 Spiritual Serenity (820 hp/tick, 0.4 min, cost 520 mana)
        "Spiritual Serenity/HealPct|85/CheckFor|Pious Elixir",
    },

    ["who_to_hot"] = "Tanks", -- XXX impl
}

settings.assist = {
    ["nukes"] = { -- XXX implement
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

        --"Ice Age/NoAggro/Gem|3/MinMana|40",

        --;;FastFire=Yoppa's Spear of Venom/NoAggro/Gem|3/MinMana|40
        --;;FastCold=Ice Age/NoAggro/Gem|3/MinMana|40
        --BigCold=
        --LureCold=
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
        -- slow:
        -- L05 Drowsy (11-25% slow, 2.6 min, 20 mana)
        -- L13 Walking Sleep (23-35% slow, 2.6 min, 60 mana)
        -- L27 Tagar's Insects (33-50% slow, 2.6 min, 125 mana)
        -- L38 Togor's Insects (48-70% slow, 2.6 min, 5s cast, 175 mana)
        -- L51 Turgur's Insects (MAGIC: 66-75% slow, 5.1 min, 3s cast, 250 mana)
        -- L54 Plague of Insects (DISEASE: 25% slow, 3.3 min, 6.4s cast, 250 mana)
        -- L61 Cloud of Grummus (DISEASE: 40% slow, 3.3 min, 6.4s cast, 400 mana)
        -- L65 Balance of the Nihil (MAGIC: 75% slow, 1.5 min, 1.5s cast, 300 mana)
        -- L69 Balance of Discord (MAGIC: resist adj -60, 75% slow, 1.5 min, 1.5s cast, 350 mana)
        -- L70 Hungry Plague (DISEASE: resist adj -50, 40% slow, 1 min, 3s cast, 450 mana)
        -- NOTE: Samma is main slower!
        "Balance of Discord/MaxTries/3|MinMana|10",

        -- malos (slot 2: cr, slot 3: mr, slot 4: pr, slot 5: fr):
        -- L60 Malo (-45 cr, -45 mr, -45 pr, -45 fr, unresistable, cost 350 mana)
        -- L63 Malosinia (-70 cr, -70 mr, -70 pr, -70 fr, cost 300 mana)
        -- L65 Malos (-55 cr, -55 mr, -55 pr, -55 fr, unresistable, cost 400 mana)
        -- NOTE: Erland does Malos, Myggan does Malosinia, Kesok does Putrid Decay
        --"Malos/Gem|3/MaxTries|2/MinMana|20",

        -- decay - stacks with malos:
        -- L17 Insidious Fever (-18-35 dr)
        -- L38 Insidious Malady (-48-60 dr) xxx spell data seems switched with Insidious Decay ?
        -- L52 Insidious Decay (-36-60 dr)
        -- L63 Malicious Decay (-51-70 dr)
        -- L66 Putrid Decay (slot 2: -55 dr, slot 6: -55 pr)   XXX have some shm cast this

        -- L61 Virulent Paralysis Rank 1 AA (id:3274, disease resist adj -10, root 1.2 min)
        -- L63 Virulent Paralysis Rank 2 AA (xxx)
        -- Lxx Virulent Paralysis Rank 3 AA (xxx)
        --"Virulent Paralysis",
    },

    ["debuffs_on_command"] = {  -- XXX impl
        "Hungry Plague/Gem|7/MinMana|30",
    },

    ["quickburns"] = {
        -- epic 1.5: Crafted Talisman of Fates
        -- epic 2.0: Blessed Spiritstaff of the Heyokah
        "Blessed Spiritstaff of the Heyokah",

        -- oow t1: Spiritkin Tunic (reduce resist rate by 40%)
        "Quick Burn=Spiritkin Tunic",

        -- L61 Spirit Call Rank 1 AA (swarm pets, 15 min reuse / 10 min with Hastened Spirit Call)
        -- Lxx Spirit Call Rank 5 AA
        "Spirit Call",

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
        "Call of the Ancients",
    }
}

settings.pbae = { -- XXX impl
--[[
; ae slow:
; L58 Tigir's Insects (50% slow, decrease hate 200, aerange 20, 3 min)
; L69 Breath of Antraygus (directional AoE, 1200 dmg, 12s recast, cost 700 mana)
; L70 Vindictive Spirit (50% slow, -100 magic adj, aerange 50, 0.3 min)
;;PBAE=Breath of Antraygus/Rotate/Gem|6/MinMana|10
;;PBAE=Vindictive Spirit/Rotate/Gem|3/MinMana|10

; "aura" idol:
; L55 Idol of Malo
; L70 Idol of Malos
;PBAE=Idol of Malos/Gem|3
]]--
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
