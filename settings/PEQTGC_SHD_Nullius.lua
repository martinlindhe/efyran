local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Morguecaller|Mainhand/Shield of the Lightning Lord|Offhand/Screaming Skull of Discontent|Ranged",
    ["bfg"] = "Breezeboot's Frigid Gnasher|Mainhand",

    ["ranged"] = "Plaguebreeze|Ranged",

    ["noriposte"] = "Aged Left Eye of Xygoz|Mainhand/Shield of the Lightning Lord|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    -- for mpg trial of weaponry (group):
    ["slashdmg"] = "Innoruuk's Dark Blessing|Mainhand",
    ["piercedmg"] = "Warspear of Vexation|Mainhand",
    ["bluntdmg"] = "Girplan Hammer of Carnage|Mainhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Combat Innates:
    -- L22 Vampiric Embrace (proc: Vampiric Embrace)
    -- L37 Scream of Death (proc: Scream of Death Strike)
    -- L67 Shroud of Discord (proc: Shroud of Discord Strike, 60 min duration) - imbues attacks with chance to steal life from target (lifetap)
    -- L70 Decrepit Skin (slot 1: proc Decrepit Skin Parry, 4 min duration) - absorb dmg
    "Decrepit Skin",
    --Combat Buff=Decrepit Skin

    -- Form of Endurance III (slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense
    "Necklace of the Steadfast Spirit",

    -- PAL/SHD mana regen clicky:
    -- Glyphed Greaves of Conflict ALL/ALL: Aura of Eternity (slot 8: 5 mana regen, slot 10: 5 hp regen)
    -- Pendant of Discord ALL/ALL: Aura of Taelosia (slot 8: 7 mana regen, slot 10: 7 hp regen)
    -- NOTE: NOT ENOUGH BUFF SLOTS
    --"Pendant of Discord",

    -- skeleton illusion with regen:
    -- NOTE: does not stack with ENC Clairvoyance (20 mana/tick)
    -- L58 Deathly Temptation (6 mana/tick, -11 hp/tick)
    -- L64 Pact of Hate (15 mana/tick, -22 hp/tick)
    -- L69 Pact of Decay (17 mana/tick, -25 hp/tick)
    --"Pact of Decay",

    -- DS slot 2:
    --"Cloak of Retribution",

    -- XXX WANT DS slot 3:
    --"Spined Chain Mail",

    -- DS slot 4:
    --"Pauldron of Dark Auspices",
}

settings.healing = { -- XXX implement
    ["life_support"] = {
        "Distillate of Divine Healing XI/HealPct|7/CheckFor|Resurrection Sickness",

        -- oow t1 bp: Heartstiller's Mail Chestguard - Lifetap from Weapon Damage (15) for 2 ticks
        -- oow t2: Duskbringer's Plate Chestguard of the Hateful - Lifetap from Weapon Damage (15) for 4 ticks. 5 min reuse
        "Duskbringer's Plate Chestguard of the Hateful/HealPct|35/CheckFor|Resurrection Sickness",
        
        -- timer 3:
        -- L59 Deflection Discipline (12s use, 40m reuse) - block most attacks with shield
        "Deflection Discipline/HealPct|10/CheckFor|Resurrection Sickness",
        
        -- timer 2:
        -- L60 Leechcurse Discipline (42 end upkeep, 24s use, 1h7m reuse) - heal for 100% of all melee dmg
        "Leechcurse Discipline/HealPct|8/CheckFor|Resurrection Sickness",
        
        -- timer 4:
        -- L56 Ichor Guard (absorb 25% melee dmg up to 2500)
        -- L61 Soul Guard (absorb 25% melee dmg up to 6000)
        -- L69 Soul Shield (absorb 25% melee dmg up to 10000, 30s use, 15m reuse)
        "Soul Shield/HealPct|15/CheckFor|Resurrection Sickness",
    },
    ["lifetap"] = { -- XXX implement. was [Shadow Knight].LifeTap in e3
        -- L70 Touch of the Devourer (-740 hp, -200 magic resist, 448 mana, 10s recast)
        "Touch of the Devourer/Gem|3/HealPct|50|MinMana|10",
    },
}

settings.pet = { -- XXX impl
--[[
; L68 Son of Decay (WAR/60)
; AA Deathly Pact to not need Bone Chips
;;Pet Spell=Son of Decay/MinMana|10/Reagent|Bag of the Tinkerers

Pet Heal=

; pet haste
; L69 Rune of Decay (65% haste, 85 str, 22 ac)
Pet Buff=Rune of Decay

Pet Taunt (On/Off)=Off
Pet Auto-Shrink (On/Off)=Off
Pet Summon Combat (On/Off)=Off
Pet Buff Combat (On/Off)=Off
Pet Spell=
]]--
}

settings.assist = {
    ["type"] = "Melee", -- XXX "Ranged",  "Off"
    ["stick_point"] = "Front",
    ["melee_distance"] = 15,
    --SmartTaunt(On/Off)=On -- XXX impl
    ["ranged_distance"] = 60,
    ["engage_percent"] = 100,  -- XXX implement!

    ["abilities"] = {   -- XXX implememt !!!
        "Bash",
        "Disarm",
    },

    ["nukes"] = { -- XXX implement
        --[[
        ; L67 Terror of Discord (1800 hate, 60 mana, instant cast, 6s recast)
        Main=Terror of Discord/Gem|8

        ; L70 Theft of Agony (1200 hate, 100 mana, 1.5s cast, 60s recast)
        Main=Theft of Agony/Gem|1


        ; L67 Inruku's Bite (250 dd, -500 disease check, 1.5s cast, 60s recast)
        Main=Inruku's Bite/Gem|9


        ; L70 Theft of Hate (-130 hp, increase atk)
        Main=Theft of Hate/Gem|2
        ]]
    },

    ["dots"] = { -- XXX implement. was called "DoTs on assist" in e3
        --[[
        [DoTs on Assist]
        ; Encroaching Darkness AA (damage free snare)
        ;Main=Encroaching Darkness/MaxTries|2

        ; duration taps - self heals:
        ; L57 Vampiric Curse (-200 magic, 21 hp/tick self heal)
        ; L62 Bond of Decay (-200 magic, 80 hp/tick self heal)
        ; L66 Bond of Inruku (-200 magic, 135 hp/tick self heal)

        ; duration taps - group heals:
        ; L62 Zevfeer's Bite (-500 disease, 200 hp nuke + group heal)
        ; L65 Ancient: Bite of Chaos (-500 disease, 300 hp nuke + group heal)
        ; L67 Inruku's Bite (-500 disease, 260 hp nuke + group heal)
        ; L70 Ancient: Bite of Muram (-500 disease, 375 hp nuke + group heal)
        Main=Ancient: Bite of Muram/Gem|4/MinMana|10

        ; disease dots:
        ; L05 Disease Cloud (cost 10, -5 hp/tick)
        ; L36 Heart Flutter (cost 41, -20 str, -9 ac, -22 hp/tick)
        ; L60 Asytole (cost 98, 42s use, -40 str, -18 ac, -62 hp/tick)
        ; L66 Dark Constriction (cost 300, 1m use, -60 str, -27 ac, -100 hp/tick)
        ;Main=Dark Constriction/MaxTries|2/Gem|2/MinMana|10

        Magic=
        Poison=
        Disease=
        ]]--
    },

    ["dots_on_command"] = { -- XXX implement. was called "DoTs on command" in e3
        --[[
        [DoTs on Command]
        Main=
        Magic=
        Poison=
        Disease=
        ]]--
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow T2 bp: Duskbringer's Plate Chestguard of the Hateful (Leeching Embrace, melee lifetap 15% heal)
        "Duskbringer's Plate Chestguard of the Hateful",

        -- epic 1.5 (30% accuracy for group, 35% melee lifetap. 10 min reuse) Innoruuk's Voice 
        -- epic 2.0 (40% accuracy for group, 50% melee lifetap. 5 min reuse) Innoruuk's Dark Blessing - XXX targets self which makes tanking crap
        "Innoruuk's Dark Blessing"
    },

    ["longburns"] = { -- XXX implememt !!!
        -- timer 1:
        -- L55 Unholy Aura Discipline (cost 900 end, 5m use, 36m reuse) - increase lifetap dmg
        "Unholy Aura Discipline",
    },
}

return settings
