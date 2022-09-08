local settings = { }

settings.swap = {   -- XXX implement
    ["main"] = "Vengeful Taelosian Blood Axe|Mainhand",
    ["noks"] = "The Sword of Ssraeshza|Mainhand",
    ["noriposte"] = "Fishing Pole|Mainhand/Howling Blood-Stained Bulwark|Offhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",
    "Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)
    "Symbol of the Planemasters", -- proc buff: Pestilence Shock
}

settings.healing = {
    ["life_support"] = {
        "Desperation/HealPct|40", -- L70 Desperation AA, 22 min reuse - more dmg the closer to death
        "Reckless Discipline/HealPct|30", -- L56 Reckless Discipline (increase riposte rate)
        "Distillate of Divine Healing XI/HealPct|8",
    }
}

    -- XXX IMPL COMBAT BUFFS:
    -- L68 Cry Havoc (id 8003: group 100% melee crit chance. 1 min. works with TGB)
    --Combat Buff=Cry Havoc/Blod/MinEnd|10

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
    ["ranged_distance"] = 60, -- XXX 60 range worked for skillups in Throwing 87/310

    ["abilities"] = {
        -- L?? Frenzy (ability)
        -- L?? Kick (ability) - XXX share timer with Frenzy?
        "Frenzy",
        --"Kick",

        "Disarm",

        -- L69 Destroyer's Volley (timer 1, ranged attack)
        "Destroyer's Volley",

        -- L69 Baffling Strike (timer 1, ranged attack, distract)
        "Baffling Strike/PctAggro|90",
    },

    ["quickburns"] = {-- XXX implememt !!!
        -- EPIC 1.5: Raging Taelosian Alloy Axe (+75 str, +75 str cap, +200% melee crit chance, +75 hot heal)
        -- EPIC 2.0: Vengeful Taelosian Blood Axe (+100 str, +100 str cap, 300% melee crit chance, 100 hot heal)
        "Vengeful Taelosian Blood Axe",

        -- oow T1 bp: Ragebound Chain Chestguard (increase melee chance to hit by 40% for 12s)
        -- oow T2 bp: Wrathbringer's Chain Chestguard of the Vindicator
        "Ragebound Chain Chestguard", -- XXX hand in t2

        -- L6x Blood Pact AA, 15 min reuse
        "Blood Pact",

        -- timer 8:
        -- Lxx Battle Cry (id:5027) 10 atk, -1% melee haste (??)
        -- L70 Bloodthirst
        --"Bloodthirst",

        -- timer 3:
        -- L54 Cleaving Rage Discipline (timer 3) - every hit a critical
        -- L58 Blind Rage Discipline (increase damage)
        -- L60 Burning Rage Discipline (timer 3)
        "Cleaving Rage Discipline",

        -- L70 Vengeful Flurry Discipline (timer 5)
        "Vengeful Flurry Discipline",

        -- L66 Unpredictable Rage Discipline (timer 6)
        "Unpredictable Rage Discipline",
    },

    ["longburns"] = {
        -- L6x Untamed Rage AA, 36 min reuse
        -- L70 Cascading Rage AA, 36 min reuse
        "Cascading Rage",

        -- L65 Cleaving Anger Discipline (timer 2)
        "Cleaving Anger Discipline",

        -- L68 Unflinching Will Discipline (timer 4)
        "Unflinching Will Discipline",

        -- L6x Savage Spirit Rank 1 AA, 1h reuse
        "Savage Spirit",
    },
}

-- XXX impl:
--[[

[Berserker]
; L01 Corroded Axe (Basic Axe Components)
; L05 Blunt Axe (Basic Axe Components)
; L10 Steel Axe (Basic Axe Components)
; L15 Bearded Axe (Basic Axe Components)
; L20 Mithril Axe
; L25 Balanced War Axe
; L30 Bonesplicer Axe
; L35 Fleshtear Axe (Axe Components)
; L40 Cold Steel Cleaving Axe
; L45 Mithril Bloodaxe
; L50 Rage Axe
; L55 Bloodseeker's Axe
; L60 Battlerage Axe
; L65 Tainted Axe of Hatred
; L65 Deathfury Axe
; L66 Axe of the Destroyer (Balanced Axe Components)
Axe Ability=Axe of the Destroyer/Reagent|Balanced Axe Components/CheckFor|80
]]--


return settings