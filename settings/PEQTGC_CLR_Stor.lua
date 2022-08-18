local settings = { }

settings.swap = { -- XXX impl
--[[
    Main=Bazu Claw Hammer|Mainhand/Aegis of Superior Divinity|Offhand

    Fishing=Fishing Pole|Mainhand

    ; Weighted Hammer of Conviction (1hb)
    Melee=Weighted Hammer of Conviction|Mainhand
]]--
}

settings.buffs = {
    "Fuzzy Foothairs",


    -- mana regen clicky:
    -- Reyfin's Random Musings (slot 8: 9 mana regen, slot 10: 6 hp regen)
    "Earring of Pain Deliverance",

    -- mana pool clicky:
    -- Reyfin's Racing Thoughts (slot 4: 450 mana pool, tacvi)
    -- NOTE: ran out of buff slots at 20-jan 2022
    --"Xxeric's Matted-Fur Mask",

    -- Eternal Ward (15 all resists, 45 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense
    "Lavender Cloak of Destruction",

    -- rune clicky:
    -- Mantle of Corruption (Geomantra, mitigate 20% spell dmg of 500, decrease 2 mana/tick)
    --"Mantle of Corruption",

    -- self mana regen:
    -- L49 Armor of the Faithful (252-275 hp, 22 ac)
    -- L58 Blessed Armor of the Risen (294-300 hp, 30 ac, 6 mana/tick)
    -- L65 Armor of the Zealot (450 hp, 36 ac, 8 mana/tick)
    -- L70 Armor of the Pioous (563 hp, 46 ac, 9 mana/tick)
    -- NOTE: does not stack with DRU Skin
    --"Armor of the Zealot/MinMana|90/CheckFor|Kazad's Mark",





    -- xxx

    "Aura of Devotion",

    "Balikor's Mark",

    -- XXX IMPL THIS:
--[[

; spell haste:
; L15 Blessing of Piety (10% spell haste to L39, 40 min)
; L35 Blessing of Faith (10% spell haste to L61, 40 min)
; L62 Blessing of Reverence (10% spell haste to L65, 40 min)
; L64 Aura of Reverence (10% spell haste to L65, 40 min, group)
; L67 Blessing of Devotion (10% spell haste to L70, 40 min, 390 mana)
; L69 Aura of Devotion (10% spell haste to L70, 45 min, group, 1125 mana)
; NOTE: Stor does team18, Helge does the rest

; team18 - g1:
Self Buff=Aura of Devotion/Gem|3/MinMana|40

; Crusade don't need spell haste
Bot Buff=Aura of Devotion/Blastar/MinMana|50

; team18 - g2:
Bot Buff=Aura of Devotion/Myggan/MinMana|50
Bot Buff=Aura of Devotion/Absint/MinMana|50
Bot Buff=Aura of Devotion/Trams/MinMana|50
; Kamaxia
Bot Buff=Aura of Devotion/Redito/MinMana|50

; team18 - g3:
Bot Buff=Aura of Devotion/Samma/MinMana|50
Bot Buff=Aura of Devotion/Fandinu/MinMana|50


; absorb melee:
; L40 Guard of Vie (absorb 10% melee dmg to 700)
; L54 Protection of Vie (absorb 10% melee dmg to 1200)
; L62 Bulwark of Vie (absorb 10% melee dmg to 1600)
; L67 Panoply of Vie (absorb 10% melee dmg to 2080, 36 min)
; NOTE: Stor does team18, Helge does the rest

; team18 - g1:
Self Buff=Panoply of Vie/MinMana|70
Bot Buff=Panoply of Vie/Blastar/MinMana|40

; team18 - g2:
Bot Buff=Panoply of Vie/Myggan/MinMana|40
Bot Buff=Panoply of Vie/Absint/MinMana|40
Bot Buff=Panoply of Vie/Trams/MinMana|40
; Kamaxia
Bot Buff=Panoply of Vie/Redito/MinMana|40

; team18 - g3:
Bot Buff=Panoply of Vie/Samma/MinMana|40
Bot Buff=Panoply of Vie/Fandinu/MinMana|40



; hp buff - aegolism line (slot 2 - does not stack with DRU skin):
; L01 Courage (20 hp, 4 ac, single)
; L40 Temperance (800 hp, 48 ac, single) - LANDS ON L01
; L45 Blessing of Temperance (800 hp, 48 ac, group) - LANDS ON L01
; L60 Aegolism (1150 hp, 60 ac, single)
; L60 Blessing of Aegolism (1150 hp, 60 ac, group)
; L62 Virtue (1405 hp, 72 ac, single)
; L65 Hand of Virtue (1405 hp, 72 ac, group) - LANDS ON L47
; L67 Conviction (1787 hp, 94 ac)
; L70 Hand of Conviction (1787 hp, 94 ac, group) - XXX LANDS ON L61 ???

;Bot Buff=Temperance/Tand/MinMana|40


; hp buff - symbol line:
; L54 Symbol of Marzin (640-700 hp)
; L58 Naltron's Mark (525 hp, group)
; L60 Marzin's Mark (725 hp, group)
; L61 Symbol of Kazad (910 hp, cost 600 mana)
; L63 Kazad's Mark (910 hp, cost 1800 mana, group)
; L66 Symbol of Balikor (1137 hp, cost 780 mana)
; L70 Balikor's Mark (1137 hp, cost 2340 mana, group)
; NOTE: Stor do symbol team18, Kamaxia does the rest
Group Buff=Balikor's Mark
Self Buff=Balikor's Mark/MinMana|75

; team18 - g1:
Bot Buff=Balikor's Mark/Bandy/MinMana|40
Bot Buff=Balikor's Mark/Crusade/MinMana|40
Bot Buff=Balikor's Mark/Spela/MinMana|70
Bot Buff=Balikor's Mark/Azoth/MinMana|70
Bot Buff=Balikor's Mark/Blastar/MinMana|70

; team18 - g2:
Bot Buff=Balikor's Mark/Myggan/MinMana|70
Bot Buff=Balikor's Mark/Absint/MinMana|70
Bot Buff=Balikor's Mark/Trams/MinMana|70
; Kamaxia
Bot Buff=Balikor's Mark/Gerwulf/MinMana|70
Bot Buff=Balikor's Mark/Redito/MinMana|70

; team18 - g3:
Bot Buff=Balikor's Mark/Kniven/MinMana|70
Bot Buff=Balikor's Mark/Samma/MinMana|70
Bot Buff=Balikor's Mark/Besty/MinMana|70
Bot Buff=Balikor's Mark/Grimakin/MinMana|70
Bot Buff=Balikor's Mark/Chancer/MinMana|70
Bot Buff=Balikor's Mark/Fandinu/MinMana|70
Bot Buff=Balikor's Mark/Drutten/MinMana|70

; PL 2021
Bot Buff=Balikor's Mark/Endstand/MinMana|70
Bot Buff=Balikor's Mark/Nacken/MinMana|70
Bot Buff=Balikor's Mark/Ryggen/MinMana|70
Bot Buff=Balikor's Mark/Tervet/MinMana|70
Bot Buff=Balikor's Mark/Plin/MinMana|70
Bot Buff=Balikor's Mark/Hypert/MinMana|70
Bot Buff=Balikor's Mark/Gasoline/MinMana|70
Bot Buff=Balikor's Mark/Katan/MinMana|70
Bot Buff=Balikor's Mark/Fedt/MinMana|40
Bot Buff=Balikor's Mark/Bulf/MinMana|40
Bot Buff=Balikor's Mark/Papp/MinMana|40
Bot Buff=Balikor's Mark/Pantless/MinMana|40
Bot Buff=Balikor's Mark/Sogaard/MinMana|40
Bot Buff=Balikor's Mark/Fisse/MinMana|40
Bot Buff=Balikor's Mark/Kasta/MinMana|40
Bot Buff=Balikor's Mark/Halsen/MinMana|40
Bot Buff=Balikor's Mark/Crust/MinMana|40
Bot Buff=Balikor's Mark/Saga/MinMana|70
Bot Buff=Balikor's Mark/Brinner/MinMana|70
Bot Buff=Balikor's Mark/Katten/MinMana|70

; ac - slot 4:
; L61 Ward of Gallantry (54 ac)
; L66 Ward of Valiance (72 ac)
; NOTE: stacks with Symbol + DRU Skin + Focus
Self Buff=Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction
Bot Buff=Ward of Valiance/Bandy/MinMana|50/CheckFor|Hand of Conviction
Bot Buff=Ward of Valiance/Manu/MinMana|50/CheckFor|Hand of Conviction
Bot Buff=Ward of Valiance/Nullius/MinMana|50/CheckFor|Hand of Conviction
Bot Buff=Ward of Valiance/Crusade/MinMana|50/CheckFor|Hand of Conviction
Bot Buff=Ward of Valiance/Juancarlos/MinMana|50/CheckFor|Hand of Conviction
]]--
}

settings.cures = {  -- XXX impl
--[[
;;CureAll=Remove Greater Curse/CheckFor|Gravel Rain/Zone|potactics,poearthb
; NOTE: makes tanks die if all clerics do this:
;CureAll=Remove Greater Curse/CheckFor|Solar Storm/Zone|poair
CureAll=Remove Greater Curse/CheckFor|Curse of the Fiend/Zone|solrotower

CureAll=Remove Greater Curse/CheckFor|Feeblemind/Zone|thedeep

CureAll=Cure Disease/CheckFor|Rabies/Zone|chardok

CureAll=Antidote/CheckFor|Fulmination/Zone|Txevu

AutoRadiant (On/Off)=On
; PoP:
;;RadiantCure=Gravel Rain/MinSick|1/Zone|potactics,poearthb

; GoD:
RadiantCure=Fulmination/MinSick|1/Zone|txevu
RadiantCure=Kneeshatter/MinSick|1/Zone|qvic
RadiantCure=Skullpierce/MinSick|1/Zone|qvic
RadiantCure=Malo/MinSick|1
RadiantCure=Malicious Decay/MinSick|1
RadiantCure=Insidious Decay/MinSick|1
RadiantCure=Chaos Claws/MinSick|1

; vxed,tipt:
RadiantCure=Stonemite Acid/MinSick|1
RadiantCure=Tigir's Insects/MinSick|1

; OOW:
RadiantCure=Whipping Dust/MinSick|1/Zone|causeway
RadiantCure=Chaotica/MinSick|1/Zone|riftseekers,wallofslaughter
RadiantCure=Infected Bite/MinSick|1/Zone|riftseekers
RadiantCure=Kneeshatter/MinSick|1/Zone|provinggrounds

; rss downstairs mez - XXX dont work
;RadiantCure=Freezing Touch/Zone|riftseekers

;;RadiantCure=Pyronic Lash/Zone|riftseekers
CureAll=Pure Blood/CheckFor|Chailak Venom/Zone|riftseekers

; anguish:
RadiantCure=Gaze of Anguish/MinSick|1/Zone|anguish
RadiantCure=Chains of Anguish/MinSick|1/Zone|anguish
RadiantCure=Feedback Dispersion/MinSick|1/Zone|anguish
RadiantCure=Wanton Destruction/MinSick|1/Zone|anguish,txevu
]]--
}

settings.lifeSupport = { -- XXX implement
    "Ward of Retribution/Gem|8/HealPct|50/Delay|3m/CheckFor|Resurrection Sickness",

    "Distillate of Divine Healing XI/HealPct|18/CheckFor|Resurrection Sickness",

    -- L65 Divine Avatar Rank 1 AA (decrease melee attack by 5%, increase HoT by 100/tick)
    -- L65 Divine Avatar Rank 2 AA (decrease melee attack by 10%, increase HoT by 150/tick)
    -- L65 Divine Avatar Rank 3 AA (decrease melee attack by 10%, increase HoT by 200/tick)
    -- L70 Divine Avatar Rank 4 AA (decrease melee attack by 15%, increase HoT by 250/tick)
    -- L70 Divine Avatar Rank 5 AA (id:8157, decrease melee attack by 15%, increase HoT by 300/tick)
    -- L70 Divine Avatar Rank 6 AA (id:8158, decrease melee attack by 338%, increase HoT by 350/tick, 3.0 min, 36 min reuse)
    "Divine Avatar/HealPct|20/CheckFor|Resurrection Sickness",

    -- L70 Sanctuary AA (id:5912, removes you from combat)
    "Sanctuary/HealPct|13/CheckFor|Resurrection Sickness",

    -- defensive - stun attackers:
    -- L70 Divine Retribution I (id:5866, proc Divine Retribution Effect)
    "Divine Retribution/HealPct|25/CheckFor|Resurrection Sickness",
}

settings.heals = { -- XXX implement
--[[
    [Heals]
    Tank=Bandy
    Tank=Nullius
    ;Tank=Manu
    ;Tank=Crusade
    ;Tank=Juancarlos

    Tank Heal=Ancient: Hallowed Light/HealPct|88/Gem|4/MinMana|5

    ; MPG Efficiency:
    ;Tank Heal=Pious Remedy/HealPct|70/Gem|1/MinMana|5

    All Heal=Pious Remedy/HealPct|60/Gem|1/MinMana|30

    ; tacvi clicky:
    All Heal=Weighted Hammer of Conviction/HealPct|95


    ; curing heals:
    ; L70 Desperate Renewal (4935 hp, -18 pr, -18 dr, -18 curse, cost 1375 mana)

    ; quick heals:
    ; L01 Minor Healing (12-20 hp, 1.5s cast, 10 mana)
    ; L04 Light Healing (47-65 hp, 2s cast, 28 mana)
    ; L10 Healing (135-175 hp, 2.5s cast, 65 mana)
    ; L20 Greater Healing (280-350 hp, 3.0s cast, 115 mana)
    ; L51 Remedy (463-483 hp, 1.8s cast, 167 mana)
    ; L58 Ethereal Remedy (975 hp, 2.8s cast, 400 mana)
    ; L61 Supernal Remedy (1450 hp, 1.8s cast, 400 mana)
    ; L66 Pious Remedy (1990 hp, 1.8s cast, 495 mana)

    ; fast heals:
    ; L58 Ethereal Light (1980-2000 hp, 3.8s cast, 490 mana)
    ; L63 Supernal Light (2730-2750 hp, 3.8s cast, 600 mana)
    ; L65 Holy Light (3275 hp, 3.8s cast, 650 mana)
    ; --- Weighted Hammer of Conviction (tacvi class click) - Supernal Remedy (1.5s cast, 3m30s reuse)
    ; L68 Pious Light (3750-3770 hp, 3.8s cast, 740 mana)
    ; L70 Ancient: Hallowed Light (4150 hp, 3.8s cast, 775 mana)


    ; CH for mpg Ingenuity:
    ;;Tank Heal=Complete Heal/HealPct|80/Gem|2

    ; CH for mpg Efficency - due to zone debuff fools mq 100% hp is like 75%:
    ;;Tank Heal=Complete Heal/HealPct|70/Gem|2


    Who to Heal=Tanks/All


    ; hot:
    ; L44 Celestial Healing (180 hp/tick, 0.4 min, 225 mana)
    ; L59 Celestial Elixir (300 hp/tick, 0.4 min, 300 mana)
    ; L60 Ethereal Elixir (300 hp/tick, 0.4 min, 975 mana, group)
    ; L62 Supernal Elixir (600 hp/tick, 0.4 min, 480 mana)
    ; L65 Holy Elixir (900 hp/tick, 0.4 min, 720 mana)
    ; L67 Pious Elixir (slot 1: 1170 hp/tick, 0.4 min, 890 mana)
    ;Heal Over Time Spell=Pious Elixir/HealPct|70/Gem|4/CheckFor|Spiritual Serenity
    ;Who to HoT=Tanks


    ; group heals:
    ; L30 Word of Health (380-485 hp, cost 302 mana)
    ; L57 Word of Restoration (1788-1818 hp, cost 898 mana)
    ; L60 Word of Redemption (7500 hp, cost 1100 mana)
    ; L64 Word of Replenishment (2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana)
    ; L69 Word of Vivification (3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana)


    ; group hot:
    ; L70 Elixir of Divinity (900 hp/tick, group, cost 1550 mana)


    Join Heal Chains (On/Off)=Off
    Important Bot=
    Pet Owner=
    Important Heal=
    Pet Heal=
    Heal Over Time Spell=
    Group Heal=
    Who to HoT=
]]--
}


settings.assist = {
    ["nukes"] = { -- XXX implement
        --[[
        [Nukes]
        Main=
        ; magic nukes:
        ; L44 Retribution (372-390 hp, cost 144 mana)
        ; L54 Reckoning (571 hp, cost 206 mana)
        ; L56 Judgment (842 hp, cost 274 mana)
        ; L62 Condemnation (1175 hp, cost 365 mana)
        ; L65 Order (1219 hp, cost 379 mana)
        ; L65 Ancient: Chaos Censure (1329 hp, cost 413 mana)
        ; L67 Reproach (1424-1524 hp, cost 430 mana)
        ; L69 Chromastrike (1200 hp, cost 375 mana, chromatic resist)
        ; L70 Ancient: Pious Conscience (1646 hp, cost 457 mana)
        ;Main=Reproach/NoAggro/Gem|7/MinMana|30
        ]]--
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow bp clicky:
        -- OOW T1 bp: Sanctified Chestguard (increase healing spell potency by 1-50% for 0.5 min)
        -- OOW T2 bp: Faithbringer's Breastplate of Conviction (increase healing spell potency by 1-50% for 0.7 min)
        "Faithbringer's Breastplate of Conviction",

        -- L66 Celestial Hammer AA, 22 min reuse (XXX disabled because of casting time)
        --"Celestial Hammer",
    },
}

settings.pbae = {   -- XXX implement
--[[
; pbae magic nukes:
; L09 Word of Pain (24-29 hp, aerange 20, recast 9s, cost 47 mana)
; L19 Word of Shadow (52-58 hp, aerange 20, recast 9s, cost 85 mana)
; L26 Word of Spirit (91-104 hp, aerange 20, recast 9s, cost 133 mana)
; L34 Tremor (106-122 hp, aerange 30, recast 10s, cost 200 mana)
; L39 Word of Souls (138-155 hp, aerange 20, recast 9s, cost 171 mana)
; L44 Earthquake (214-246 hp, aerange 30, recast 24s, cost 375 mana)
; L49 Word Divine (339 hp, aerange 20, recast 9s, cost 304 mana)
; L52 Upheaval (618-725 hp, aerange 35, recast 24s, cost 625 mana)
; L59 The Unspoken Word (605 hp, aerange 20, recast 120s, cost 427 mana)
; L64 Catastrophe (850 hp, aerange 35, recast 24s, cost 650 mana)
; L69 Calamity (1105 hp, aerange 35, recast 24s, cost 812 mana - PUSHBACK 1.0)
;PBAE=Calamity/Gem|6/MinMana|10
;PBAE=Catastrophe/Gem|7/MinMana|10
]]--
}

settings.cleric = {
    ["divine_arbitration"] = 60,    -- XXX impl
    -- ["celestial_regeneration"] = 25,

    -- yaulp:
    -- L56 Yaulp V (50 atk, 10 mana/tick, 75 dex, 25% haste)
    -- L65 Yaulp VI (60 atk, 12 mana/tick, 90 dex, 30% haste)
    -- L69 Yaulp VII (80 atk, 14 mana/tick, 100 dex, 30% haste)
    --Auto-Yaulp (On/Off)=Off
    ["yaulp"] = "Yaulp VII",    -- XXX impl
}


return settings
