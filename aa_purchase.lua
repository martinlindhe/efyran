-- TODO read array from settings/autoaa.lua

local mq = require("mq")
local log = require("efyran/knightlinc/Write")

require("ezmq")


local aaPrioList = {
    ROG = { -- 1321 AA for ALL (DoN)
        -- Defensive
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Fear Resistance"] = 3,
        ["Master of Disguise"] = 1, -- permanent illusion

        -- DPS
        ["Precision"] = 3, -- backstab %
        ["Ferocity"] = 3, -- double attack %
        ["Ingenuity"] = 3, -- crit hit %
        ["Slippery Attacks"] = 5, -- reduce enemy's riposte %
        ["Weapon Affinity"] = 5, -- effect ratio %
        ["Ambidexterity"] = 1, -- dual wield %
        ["Combat Fury"] = 6, -- crit %
        ["Double Riposte"] = 6, -- counter-attack
        ["Seized Opportunity"] = 3, -- dps
        ["Triple Backstab"] = 6, -- dps
        ["Veteran's Wrath"] = 3, -- dps
        ["Sinister Strikes"] = 1, -- secondary dmg
        ["Chaotic Stab"] = 1, -- frontal stab
        ["Virulent Venom"] = 5, -- poison proc %

        -- DPS, low prio
        ["Shielding Resistance"] = 5, -- reduce ds dmg
        ["Heightened Endurance"] = 6, -- endurance regen
        ["Finishing Blow"] = 9, -- low level kill-shot

        -- Defensive, low prio
        ["Escape"] = 1, -- active ability
        ["Hasty Exit"] = 5, -- reduce Escape reuse time

        ["Physical Enhancement"] = 1, -- hp
        ["Planar Power"] = 10,
        ["Innate Regeneration"] = 10,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Natural Healing"] = 3,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Acrobatics"] = 3, -- reduce fall dmg
        ["Innate Metabolism"] = 3,

        ["Hastened Stealth"] = 3, -- hide/evade reduce time
        ["Shroud of Stealth"] = 1, -- ability: permanent invis

        ["Purge Poison"] = 1, -- self cure
        ["Hastened Purification"] = 3, -- reduce Purge Poison reuse time

        -- Misc
        ["Nerves of Steel"] = 5, -- no-break invis
        ["Nimble Evasion"] = 5, -- chance to hide/evade while moving

        ["Poison Mastery"] = 4, -- tradeskill + apply poison

        ["Trap Circumvention"] = 5, -- reduce % of set off chest traps
        ["Adv. Trap Negotiation"] = 3, -- reduce disarm trap time
        ["Thief's Intuition"] = 1, -- detect traps
        ["Innate Lung Capacity"] = 6,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps

        -- lowest prio / leftovers
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    WAR = { -- 1237 AA for ALL (DoN)
        -- General ALL
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Origin"] = 1,
        ["Planar Power"] = 10,
        ["Innate Metabolism"] = 3,

        -- General TANK
        ["Innate Charisma"] = 15,
        ["Innate Lung Capacity"] = 6,

        -- Archetype
        ["Combat Fury"] = 6,
        ["Double Riposte"] = 6,
        ["Fear Resistance"] = 3,
        ["Ferocity"] = 3,
        ["Heightened Endurance"] = 6,
        ["Ingenuity"] = 3,
        ["Natural Healing"] = 3,
        ["Punishing Blade"] = 3,
        ["Shield Block"] = 3,
        ["Shielding Resistance"] = 5,
        ["Slippery Attacks"] = 5,
        ["Weapon Affinity"] = 5,
        ["Finishing Blow"] = 9,

        -- Class
        ["Ambidexterity"] = 1,
        ["Area Taunt"] = 1,
        ["Extended Shielding"] = 3,
        ["Flurry"] = 9,
        ["Hastened Instigation"] = 3,
        ["Hastened Rampage"] = 3,
        ["Living Shield"] = 3,
        ["Physical Enhancement"] = 1,

        ["Planar Durability"] = 3,
        ["Press the Attack"] = 1,
        ["Rampage"] = 1,
        ["Sinister Strikes"] = 1,
        ["Stalwart Endurance"] = 3,
        ["Strengthened Strike"] = 3,
        ["Sturdiness"] = 5,
        ["Tactical Mastery"] = 6,
        ["Veteran's Wrath"] = 3,
        ["War Cry"] = 3,
        ["Warlord's Tenacity"] = 6,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Angry Thoughts"] = 1, -- +30% hate
        ["Glyph of Courage"] = 1, -- dps

        -- lowest prio / leftovers
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    MNK = { -- XXX finish ordering. 1067 AA excl tradeskill, 1230 AA for ALL (DoN)
        -- General ALL
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Origin"] = 1,
        ["Planar Power"] = 10,
        ["Innate Metabolism"] = 3,

        ["Packrat"] = 5, -- monk weight

        -- Archetype
        ["Combat Fury"] = 6, -- crit %
        ["Double Riposte"] = 6, -- counter-attack
        ["Fear Resistance"] = 3,
        ["Ferocity"] = 3,
        ["Finishing Blow"] = 9,
        ["Heightened Endurance"] = 6,
        ["Ingenuity"] = 3,
        ["Natural Healing"] = 3,
        ["Punishing Blade"] = 3,
        ["Shielding Resistance"] = 5,
        ["Slippery Attacks"] = 5,
        ["Weapon Affinity"] = 5,
        ["Veteran's Wrath"] = 3,

        -- Class
        ["Ambidexterity"] = 1,
        ["Sinister Strikes"] = 1,

        ["Crippling Strike"] = 3,
        ["Destructive Force"] = 3,
        ["Dragon Punch"] = 1,
        ["Eye Gouge"] = 3,

        ["Heightened Awareness"] = 5,
        ["Imitate Death"] = 1,
        ["Kick Mastery"] = 6,
        ["Physical Enhancement"] = 1,
        ["Purify Body"] = 1,
        ["Hastened Purification of the Body"] = 3,
        ["Rapid Feign"] = 3,
        ["Rapid Strikes"] = 5,
        ["Return Kick"] = 3,

        ["Acrobatics"] = 3,
        ["Stonewall"] = 5,
        ["Strikethrough"] = 6,
        ["Stunning Kick"] = 3,
        ["Technique of Master Wu"] = 5,

        -- Healing
        ["First Aid"] = 3,
        ["Critical Mend"] = 6,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps

        -- Low prio stuff
        ["Innate Lung Capacity"] = 6,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
    },

    BER = { -- XXX sort prio. 1177 AA for ALL (DoN)
        -- General ALL
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Origin"] = 1,
        ["Planar Power"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Combat Fury"] = 6, -- crit %
        ["Double Riposte"] = 6, -- counter-attack
        ["Fear Resistance"] = 3,
        ["Ferocity"] = 3,
        ["Finishing Blow"] = 9,
        ["Heightened Endurance"] = 6,
        ["Ingenuity"] = 3,
        ["Natural Healing"] = 3,

        ["Punishing Blade"] = 3,
        ["Weapon Affinity"] = 5,

        -- War cry
        ["Hastened War Cry"] = 3,
        ["Echoing Cries"] = 3,

        -- Class
        ["Blood Pact"] = 3,
        ["Blur of Axes"] = 8,
        ["Dead Aim"] = 3,
        ["Desperation"] = 1,
        ["Flurry"] = 9,
        ["Hastened Rampage"] = 3,
        ["Physical Enhancement"] = 1,
        ["Planar Durability"] = 3,
        ["Rampage"] = 1,
        ["Savage Spirit"] = 3,
        ["Stalwart Endurance"] = 3,
        ["Tactical Mastery"] = 6,
        ["Throwing Mastery"] = 3,
        ["Tireless Sprint"] = 3,
        ["Untamed Rage"] = 3,
        ["Veteran's Wrath"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps

        -- Low prio stuff
        ["Innate Lung Capacity"] = 6,
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        ["First Aid"] = 3,
        ["Bandage Wound"] = 3,
        ["Mithaniel's Binding"] = 2,

        -- tradeskills
        ["Salvage"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    BST = { -- XXX prio order. 1344 for ALL (DoN)
        -- General ALL
        ["Mnemonic Retention"] = 1,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Discordant Defiance"] = 5,
        ["Delay Death"] = 5,

        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Origin"] = 1,
        ["Planar Power"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Combat Fury"] = 6,
        ["Critical Affliction"] = 6,
        ["Double Riposte"] = 6,
        ["Expansive Mind"] = 5,
        ["Fear Resistance"] = 3,
        ["Fury of Magic"] = 3,
        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Mastery of the Past"] = 6,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,
        ["Persistent Minion"] = 1,
        ["Pet Affinity"] = 1,
        ["Quick Buff"] = 3,
        ["Spell Casting Fury"] = 3,
        ["Spell Casting Reinforcement"] = 4,
        ["Suspended Minion"] = 2,
        ["Veteran's Wrath"] = 3,
        ["Natural Healing"] = 3,
        ["Shielding Resistance"] = 5,
        ["Slippery Attacks"] = 5,
        ["Weapon Affinity"] = 5,
        ["Finishing Blow"] = 9,

        -- Class
        ["Pet Discipline"] = 1,
        ["Advanced Pet Discipline"] = 2,

        ["Ambidexterity"] = 1,
        ["Sinister Strikes"] = 1,

        ["Bestial Alignment"] = 3,
        ["Bestial Frenzy"] = 5,
        ["Body and Mind Rejuvenation"] = 1,
        ["Feral Swipe"] = 1,
        ["Frenzy of Spirit"] = 1,

        ["Hobble of Spirits"] = 1,
        ["Mass Group Buff"] = 1,

        ["Mend Companion"] = 1,
        ["Hastened Mending"] = 3,

        ["Paragon of Spirit"] = 4,

        ["Physical Enhancement"] = 1,
        ["Replenish Companion"] = 3,
        ["Roar of Thunder"] = 3,

        ["Warder's Alacrity"] = 5,
        ["Warder's Fury"] = 5,
    },

    CLR = { -- XXX prio order. 1292 AA for ALL (DoN)
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Healing Boon"] = 3,
        ["Persistent Casting"] = 3,
        ["Quick Buff"] = 3,

        ["Radiant Cure"] = 6,
        ["Hastened Curing"] = 3,

        ["Spell Casting Mastery"] = 3,
        ["Spell Casting Reinforcement"] = 4,

        ["Mental Clarity"] = 3,
        ["Mastery of the Past"] = 6,
        ["Innate Enlightenment"] = 5,

        --["Expansive Mind"] = 5,

        --["Spell Casting Fury"] = 3,


        -- Class
        ["Divine Arbitration"] = 3, -- group hp balance
        ["Unfailing Divinity"] = 3, -- DI chance

        ["Purify Soul"] = 1,
        ["Hastened Purification of the Soul"] = 3,
        ["Touch of the Divine"] = 5, -- chance to survive death

        ["Mass Group Buff"] = 1,
        ["Celestial Regeneration"] = 6,

        ["Divine Resurrection"] = 1,

        ["Sanctuary"] = 1, -- defensive
        ["Divine Retribution"] = 1, -- defensive
        ["Divine Avatar"] = 3, -- defensive

        --["Bestow Divine Aura"] = 1,
        --["Celestial Hammer"] = 3,
        --["Exquisite Benediction"] = 8, -- heal ward
        --["Innate Invis to Undead"] = 1,

        --["Turn Undead"] = 4,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    ENC = { -- XXX order. 1150 AA for ALL
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Secondary Forte"] = 1,
        ["Expansive Mind"] = 5,
        ["Innate Enlightenment"] = 5,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,


        ["Quick Buff"] = 3,
        ["Spell Casting Mastery"] = 3,
        ["Spell Casting Reinforcement"] = 4,

        -- Class
        ["Color Shock"] = 1,
        ["Mesmerization Mastery"] = 1,
        ["Enhanced Forgetfulness"] = 5,
        ["Mass Group Buff"] = 1,
        ["Permanent Illusion"] = 1,
        ["Soothing Words"] = 3,

        ["Total Domination"] = 3,
        ["Stasis"] = 3,

        ["Pet Affinity"] = 1,

        ["Dire Charm"] = 1,

        ["Gather Mana"] = 1,
        ["Hastened Gathering"] = 3,

        ["Animation Empathy"] = 3,

        ["Eldritch Rune"] = 3,
        ["Mind Over Matter"] = 3,

        ["Project Illusion"] = 1,
        ["Doppelganger"] = 3,

        ["Quick Mass Group Buff"] = 3,

        -- Low prio
        ["Spell Casting Expertise"] = 3,
        ["Mastery of the Past"] = 6,

        ["Spell Casting Fury"] = 3,
        ["Destructive Fury"] = 3,
        ["Fury of Magic"] = 6,

        ["Arcane Tongues"] = 3,
        ["Suspended Minion"] = 2,
        ["Persistent Minion"] = 1,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    MAG = { -- XXX prio. 1312 AA for ALL (DoN)
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Pet Affinity"] = 1,
        ["Suspended Minion"] = 2,
        ["Persistent Minion"] = 1,
        ["Secondary Forte"] = 1,
        --["Arcane Tongues"] = 3,

        ["Spell Casting Fury"] = 3,
        ["Fury of Magic"] = 6,
        ["Destructive Fury"] = 3,

        ["Expansive Mind"] = 5,
        ["Innate Enlightenment"] = 5,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,

        ["Spell Casting Deftness"] = 3,
        ["Spell Casting Expertise"] = 3,

        ["Spell Casting Mastery"] = 3,
        ["Mastery of the Past"] = 6,

        -- Class
        ["Pet Discipline"] = 1,
        ["Advanced Pet Discipline"] = 2,
        ["Elemental Agility"] = 3,
        ["Elemental Alacrity"] = 5,
        ["Elemental Durability"] = 3,

        ["Elemental Fury"] = 5,
        ["Elemental Pact"] = 1, -- no pet reagent
        ["Frenzied Burnout"] = 1,
        ["Host of the Elements"] = 6,

        ["Mend Companion"] = 1,
        ["Hastened Mending"] = 3,
        ["Replenish Companion"] = 3,

        ["Quick Damage"] = 3,

        ["Quick Summoning"] = 3,
        ["Servant of Ro"] = 3,
        ["Shared Health"] = 5,
        ["Mass Group Buff"] = 1,

        --["Elemental Form: Air"] = 3,
        ["Heart of Vapor"] = 1,

        --["Elemental Form: Earth"] = 3,
        ["Heart of Stone"] = 1,

        --["Elemental Form: Water"] = 3,
        ["Heart of Ice"] = 1,

        --["Elemental Form: Fire"] = 3,
        ["Heart of Flames"] = 1,

        ["Improved Reclaim Energy"] = 1,
        ["Turn Summoned"] = 4,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
        ["Glyph of Frantic Infusion"] = 1, -- pet dps
    },

    WIZ = { -- XXX PRIO. 1250 AA for ALL (DoN)
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Secondary Forte"] = 1,

        ["Spell Casting Fury"] = 3,
        ["Spell Casting Fury Mastery"] = 8,
        ["Destructive Fury"] = 3,

        ["Expansive Mind"] = 5,
        ["Innate Enlightenment"] = 5,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,

        ["Spell Casting Deftness"] = 3,
        ["Spell Casting Expertise"] = 3,

        ["Spell Casting Mastery"] = 3,
        ["Mastery of the Past"] = 6,

        -- Class
        ["Call of Xuzl"] = 5,
        ["Exodus"] = 1,
        ["Hastened Exodus"] = 3,
        ["Quick Damage"] = 3,
        ["Mind Crash"] = 3,
        ["Quick Evacuation"] = 3,

        ["Frenzied Devastation"] = 3,
        ["Prolonged Destruction"] = 3,

        ["Harvest of Druzzil"] = 1,

        ["Mana Blast"] = 1,
        ["Mana Burn"] = 1,


        ["Improved Familiar"] = 3,
        ["Druzzil's Mystical Familiar"] = 2,
        ["E'ci's Icy Familiar"] = 2,
        ["Ro's Flaming Familiar"] = 2,

        ["Secondary Recall"] = 1,
        ["Teleport Bind"] = 1,

        ["Ward of Destruction"] = 5,

        ["Strong Root"] = 1,
        ["Hastened Root"] = 3,

        ["Nexus Gate"] = 1,
        ["Arcane Tongues"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps

        -- lowest prio / leftovers
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    NEC = { -- XXX PRIO.
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Secondary Forte"] = 1,

        ["Pet Discipline"] = 1,
        ["Advanced Pet Discipline"] = 2,
        ["Pet Affinity"] = 1,
        ["Suspended Minion"] = 2,
        ["Persistent Minion"] = 1,

        ["Critical Affliction"] = 6,

        ["Spell Casting Fury"] = 3,
        ["Fury of Magic"] = 6,
        ["Destructive Fury"] = 3,

        ["Expansive Mind"] = 5,
        ["Innate Enlightenment"] = 5,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,

        ["Spell Casting Deftness"] = 3,
        ["Spell Casting Expertise"] = 3,

        ["Spell Casting Mastery"] = 3,
        ["Mastery of the Past"] = 6,

        -- Class
        ["Mass Group Buff"] = 1,

        ["Quickening of Death"] = 5, -- pet flurry
        ["Death's Fury"] = 5, -- pet crit
        ["Swarm of Decay"] = 3, -- swarm pet

        ["Death Peace"] = 1,
        ["Theft of Life"] = 8, -- lifetap crit
        ["Wake the Dead"] = 3,
        ["Army of the Dead"] = 3,

        ["Call to Corpse"] = 1, -- no component summon corpse
        ["Dead Mesmerization"] = 1,

        ["Fear Storm"] = 1,
        ["Life Burn"] = 1,

        ["Mend Companion"] = 1,
        ["Replenish Companion"] = 3,
        ["Hastened Mending"] = 3,

        -- low prio
        ["Flesh to Bone"] = 1,
        ["Feigned Minion"] = 3,
        ["Arcane Tongues"] = 3,
        ["Dire Charm"] = 1,
        ["Innate Invis to Undead"] = 1,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
        ["Glyph of Frantic Infusion"] = 1, -- pet dps

        -- lowest prio / leftovers
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Strength"] = 15,
        --["Innate Agility"] = 15,
        --["Innate Dexterity"] = 15,
        --["Innate Intelligence"] = 15,
        --["Innate Stamina"] = 15,
        --["Innate Wisdom"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Tailoring Mastery"] = 3,
        ["Baking Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
        ["Blacksmithing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
    },

    RNG = { -- XXX PRIO. 1384 AA for ALL
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Critical Affliction"] = 6,
        ["Double Riposte"] = 6,
        ["Expansive Mind"] = 5,
        ["Fear Resistance"] = 3,
        ["Ferocity"] = 3,
        ["Fury of Magic"] = 3,
        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Mastery of the Past"] = 6,
        ["Mental Clarity"] = 3,
        ["Persistent Casting"] = 3,
        ["Punishing Blade"] = 3, -- 2h dps
        ["Quick Buff"] = 3,
        ["Spell Casting Fury"] = 3,
        ["Spell Casting Reinforcement"] = 4,
        ["Natural Healing"] = 3,
        ["Shielding Resistance"] = 5,
        ["Slippery Attacks"] = 5,
        ["Weapon Affinity"] = 5,
        ["Finishing Blow"] = 9,

        -- Class
        ["Combat Fury"] = 6,
        ["Ambidexterity"] = 1,
        ["Sinister Strikes"] = 1,

        ["Auspice of the Hunter"] = 3,
        ["Body and Mind Rejuvenation"] = 1,
        ["Coat of Thistles"] = 5,
        ["Endless Quiver"] = 1,
        ["Entrap"] = 1,
        ["Flaming Arrows"] = 3,
        ["Frost Arrows"] = 3,
        ["Guardian of the Forest"] = 6,
        ["Headshot"] = 1,
        --["Hunter's Attack Power"] = 16, -- auto gained
        ["Innate Camouflage"] = 1,
        ["Mass Group Buff"] = 1,
        ["Nature's Bounty"] = 3,
        ["Physical Enhancement"] = 1,
        ["Precision of the Pathfinder"] = 6,
        ["Strengthened Strike"] = 3,
        ["Tracking Mastery"] = 5,
        ["Veteran's Wrath"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    DRU = { -- XXX PRIO. 1271 AA for ALL
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Archetype
        ["Secondary Forte"] = 1,
        ["Spell Casting Mastery"] = 3,
        ["Persistent Casting"] = 3,
        ["Critical Affliction"] = 6,
        ["Destructive Fury"] = 3,
        ["Expansive Mind"] = 5,
        ["Fury of Magic"] = 6,

        ["Radiant Cure"] = 6,
        ["Hastened Curing"] = 3,

        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Mastery of the Past"] = 6,
        ["Mental Clarity"] = 3,

        ["Quick Buff"] = 3,
        ["Spell Casting Fury"] = 3,
        ["Spell Casting Reinforcement"] = 4,

        ["Innate Enlightenment"] = 5,

        -- Class
        ["Exodus"] = 1,
        ["Hastened Exodus"] = 3,
        ["Spirit of the Wood"] = 6,
        ["Call of the Wild"] = 1,
        ["Enhanced Root"] = 1,
        ["Viscid Roots"] = 1,
        ["Entrap"] = 1,
        ["Innate Camouflage"] = 1,
        ["Mass Group Buff"] = 1,
        ["Nature's Bounty"] = 3,
        ["Quick Damage"] = 3,
        ["Quick Evacuation"] = 3,
        ["Wrath of the Wild"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps

        -- Low prio
        ["Nature's Boon"] = 8,
        ["Secondary Recall"] = 1,
        ["Advanced Tracking"] = 5,
        ["Dire Charm"] = 1,

        -- lowest prio / leftovers
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        --["Innate Intelligence"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    SHM = { -- XXX PRIO
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,
        ["Spell Casting Subtlety"] = 3,

        -- Archetype
        ["Secondary Forte"] = 1,
        ["Radiant Cure"] = 6,
        ["Hastened Curing"] = 3,

        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Healing Boon"] = 3,

        ["Spell Casting Mastery"] = 3,
        ["Persistent Casting"] = 3,

        ["Spell Casting Reinforcement"] = 4,

        ["Critical Affliction"] = 6,

        ["Spell Casting Fury"] = 3,
        ["Fury of Magic"] = 6,
        ["Destructive Fury"] = 3,

        ["Expansive Mind"] = 5,
        ["Mental Clarity"] = 3,

        ["Mastery of the Past"] = 6,

        ["Quick Buff"] = 3,

        ["Innate Enlightenment"] = 5,

        -- Class
        ["Ancestral Aid"] = 3,
        ["Call of the Ancients"] = 8,
        ["Call of the Wild"] = 1,
        ["Cannibalization"] = 1,
        ["Mass Group Buff"] = 1,

        ["Spirit Call"] = 5, -- swarm pet
        ["Spiritual Channeling"] = 1,
        ["Virulent Paralysis"] = 3,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
        ["Glyph of Frantic Infusion"] = 1, -- pet dps

        -- lowest prio / leftovers
        ["Pet Affinity"] = 1,
        ["Pet Discipline"] = 1,
        ["Advanced Pet Discipline"] = 2,
        ["Persistent Minion"] = 1,
        ["Suspended Minion"] = 2,

        ["Rabid Bear"] = 1,
        ["Hastened Rabidity"] = 3,

        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Wisdom"] = 15,
        --["Innate Intelligence"] = 15,
        ["First Aid"] = 3,

        -- tradeskills
        ["Salvage"] = 3,
        ["Alchemy Mastery"] = 3,
        ["Baking Mastery"] = 3,
        ["Blacksmithing Mastery"] = 3,
        ["Brewing Mastery"] = 3,
        ["Fletching Mastery"] = 3,
        ["Jewel Craft Mastery"] = 3,
        ["Pottery Mastery"] = 3,
        ["Tailoring Mastery"] = 3,
        ["New Tanaan Crafting Mastery"] = 6,
    },

    BRD = { -- XXX PRIO
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,

        -- Archetype
        ["Combat Fury"] = 6,
        ["Fear Resistance"] = 3,
        ["Finishing Blow"] = 9,

        ["Spell Casting Expertise"] = 3,
        ["Mastery of the Past"] = 6,

        ["Persistent Casting"] = 3,

        ["Shielding Resistance"] = 5,
        ["Slippery Attacks"] = 5,
        ["Veteran's Wrath"] = 3,
        ["Weapon Affinity"] = 5,

        -- spell damage
        ["Critical Affliction"] = 6,
        ["Spell Casting Fury"] = 3,
        ["Fury of Magic"] = 3,

        -- mana
        ["Mental Clarity"] = 3,
        ["Expansive Mind"] = 5,
        ["Natural Healing"] = 3,

        -- Class
        ["Acrobatics"] = 3,
        ["Adv. Trap Negotiation"] = 3,
        ["Ambidexterity"] = 1,
        ["Sinister Strikes"] = 1,
        ["Boastful Bellow"] = 11,
        ["Dance of Blades"] = 3,
        ["Extended Notes"] = 6,
        ["Fading Memories"] = 1,
        ["Fleet of Foot"] = 2,
        ["Furious Refrain"] = 3,
        ["Harmonious Attack"] = 5,
        ["Instrument Mastery"] = 4,
        ["Jam Fest"] = 3,
        ["Master of Disguise"] = 1,
        ["Physical Enhancement"] = 1,
        ["Scribble Notes"] = 1,
        ["Shield of Notes"] = 3,
        ["Singing Mastery"] = 4,

        ["Innate Lung Capacity"] = 6,
        ["Innate Cold Protection"] = 15,
        ["Innate Disease Protection"] = 15,
        ["Innate Fire Protection"] = 15,
        ["Innate Magic Protection"] = 15,
        ["Innate Poison Protection"] = 15,
        ["Innate Regeneration"] = 10,
        ["Innate Metabolism"] = 3,

        -- lowest prio / leftovers
        ["Body and Mind Rejuvenation"] = 1,
        ["Packrat"] = 5,
        ["Foraging"] = 1,
        ["Thief's Intuition"] = 1, -- detect traps
        ["Tune of Pursuance"] = 5, -- tracking cap
        ["Innate Charisma"] = 15,
        ["Innate Agility"] = 15,
        ["Innate Dexterity"] = 15,
        ["Innate Stamina"] = 15,
        ["Innate Strength"] = 15,
        ["Innate Intelligence"] = 15,
        ["Innate Wisdom"] = 15,
        ["First Aid"] = 3,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    PAL = {
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,

        -- Arcetype
        ["Fear Resistance"] = 3,
        ["Fearless"] = 1,

        ["Combat Fury"] = 6,
        ["Double Riposte"] = 6,
        ["Expansive Mind"] = 5,
        ["Finishing Blow"] = 9,
        ["Fury of Magic"] = 3,
        ["Healing Adept"] = 9,
        ["Healing Gift"] = 9,
        ["Healing Boon"] = 3,
        ["Mastery of the Past"] = 6,
        ["Mental Clarity"] = 3,
        ["Natural Healing"] = 3,
        ["Persistent Casting"] = 3,
        ["Quick Buff"] = 3,
        ["Radiant Cure"] = 3,
        ["Shield Block"] = 3,
        ["Spell Casting Fury"] = 3,
        ["Spell Casting Reinforcement"] = 4,
        ["Veteran's Wrath"] = 3,
        ["Weapon Affinity"] = 5,


        -- Class
        ["Divine Stun"] = 2,

        ["Lay on Hands"] = 17,
        ["Fervent Blessing"] = 3,
        ["Hand of Piety"] = 9,
        ["Hastened Piety"] = 3,

        ["2 Hand Bash"] = 1,
        ["Act of Valor"] = 1,
        ["Body and Mind Rejuvenation"] = 1,
        ["Holy Steed"] = 1,
        ["Immobilizing Bash"] = 3,
        ["Knight's Advantage"] = 3,
        ["Mass Group Buff"] = 1,
        ["Physical Enhancement"] = 1,
        ["Planar Durability"] = 3,
        ["Purification"] = 1,
        ["Rush to Judgment"] = 3,
        ["Slay Undead"] = 3,
        ["Speed of the Knight"] = 3,
        ["Steadfast Will"] = 3,
        ["Valiant Steed"] = 1,
        ["Vicious Smash"] = 5,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    SHD = { -- XXX prio
        -- General ALL
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Natural Durability"] = 3,
        ["Delay Death"] = 5,
        ["Discordant Defiance"] = 5,
        ["Mnemonic Retention"] = 1,
        ["Mystical Attuning"] = 5,
        ["Planar Power"] = 10,

        -- Arcetype
        ["Fear Resistance"] = 3,
        ["Fearless"] = 1,

        ["Combat Fury"] = 6,
        ["Critical Affliction"] = 6,
        ["Double Riposte"] = 6,
        ["Expansive Mind"] = 5,
        ["Finishing Blow"] = 9,
        ["Fury of Magic"] = 3,

        ["Spell Casting Expertise"] = 3,
        ["Mastery of the Past"] = 6,

        ["Mental Clarity"] = 3,
        ["Natural Healing"] = 3,
        ["Persistent Casting"] = 3,

        ["Shield Block"] = 3,
        ["Spell Casting Deftness"] = 3,

        ["Spell Casting Fury"] = 3,
        ["Spell Casting Reinforcement"] = 4,
        ["Veteran's Wrath"] = 3,
        ["Weapon Affinity"] = 5,

        ["Pet Affinity"] = 1,
        ["Suspended Minion"] = 2,
        ["Pet Discipline"] = 1,
        ["Advanced Pet Discipline"] = 2,

        -- Class
        ["2 Hand Bash"] = 1,
        ["Abyssal Steed"] = 1,
        ["Body and Mind Rejuvenation"] = 1,
        ["Consumption of the Soul"] = 5,
        ["Death Peace"] = 1,
        ["Death's Fury"] = 5,
        ["Harm Touch"] = 14, -- auto gained ?
        ["Immobilizing Bash"] = 3,
        ["Intense Hatred"] = 5,
        ["Knight's Advantage"] = 3,
        ["Leech Touch"] = 1,
        ["Physical Enhancement"] = 1,
        ["Planar Durability"] = 3,
        ["Soul Abrasion"] = 6,
        ["Speed of the Knight"] = 3,
        ["Steadfast Will"] = 3,
        ["Theft of Life"] = 8,
        ["Touch of the Cursed"] = 3,
        ["Touch of the Wicked"] = 3,
        ["Unholy Steed"] = 1,
        ["Vicious Smash"] = 5,

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
        ["Glyph of Frantic Infusion"] = 1, -- pet dps
    },


}









-- main


local aas = aaPrioList[class_shortname()]
if aas == nil then
    log.Error("Class missing! %s. Should not happen", class_shortname())
    return
end

if not mq.TLO.Window("OptionsWindow").Child("OGP_AANoConfirmCheckBox").Checked() then
    log.Info("Enabling fast AA purchase ...")
    mq.cmd("/notify OptionsWindow OGP_AANoConfirmCheckBox leftmouseup")
end

-- TODO iterate in order of declaration. need to rework all because lua lacks such feature
for name, rank in pairs(aas) do
    log.Debug("Want to purchase %s rank %d", name, rank)

    if not is_alt_ability(name) then
        all_tellf("ERROR: no such AA: '%s'", name)
    else

        -- NOTE: Observe the use of both TLO.AltAbility and TLO.Me.AltAbility. It is finicky, but this appears to work on emu build (jul 2023)
        if mq.TLO.AltAbility(name).CanTrain() then
            -- rank 1
            log.Info("Buying \ag%s\ax (id %d)", mq.TLO.AltAbility(name).Name(), mq.TLO.AltAbility(name).Index())
            mq.cmdf("/alt buy %d", mq.TLO.AltAbility(name).Index())
            mq.delay(500)
        end

        -- rest of the ranks
        while mq.TLO.Me.AltAbility(name).CanTrain() and mq.TLO.Me.AltAbility(name).Rank() < rank do
            log.Info("Buying \ag%s\ax rank %d (id %d)", name, mq.TLO.Me.AltAbility(name).Rank()+1, mq.TLO.Me.AltAbility(name).NextIndex())
            mq.cmdf("/alt buy %d", mq.TLO.Me.AltAbility(name).NextIndex())
            mq.delay(500)
        end

        if mq.TLO.AltAbility(name).MaxRank() ~= rank then
            all_tellf("WARN: %s, listed rank is not the max: %d vs max %d", name, rank, mq.TLO.AltAbility(name).MaxRank())
        end

    end

end
