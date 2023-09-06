-- TODO read array from settings/autoaa.lua

local mq = require("mq")
local log = require("efyran/knightlinc/Write")

require("ezmq")


local aaPrioList = {
    ROG = {
        -- Defensive
        ["Origin"] = 1,
        ["Innate Run Speed"] = 5,
        ["Mystical Attuning"] = 5,
        ["Natural Durability"] = 3,
        ["Combat Agility"] = 13,
        ["Combat Stability"] = 13,
        ["Fear Resistance"] = 3,

        -- DPS
        ["Precision"] = 3, -- backstab %
        ["Ferocity"] = 3, -- double attack %
        ["Ingenuity"] = 3, -- crit hit %
        ["Slippery Attacks"] = 5, -- reduce enemy's riposte %
        ["Weapon Affinity"] = 5, -- effect ratio %
        ["Ambidexterity"] = 1, -- dual wield %
        ["Combat Fury"] = 6, -- crit %
        ["Double Riposte"] = 9, -- counter-attack
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
        ["Master of Disguise"] = 1, -- permanent illusion

        ["Nerves of Steel"] = 5, -- no-break invis
        ["Nible Evasion"] = 5, -- chance to hide/evade while moving

        ["Poison Mastery"] = 4, -- tradeskill + apply poison

        ["Trap Circumvention"] = 3, -- reduce % of set off chest traps
        ["Adv. Trap Negotiation"] = 3, -- reduce disarm trap time
        ["Thief's Intuition"] = 1, -- detect traps

        -- Expendables
        ["Glyph of Stored Life"] = 1, -- heal
        ["Glyph of Courage"] = 1, -- dps
    },

    WAR = {
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
        --"Finishing Blow"] = 9,

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
        ["Sturdiness"] = 5,
        ["Tactical Mastery"] = 6,
        ["Veteran's Wrath"] = 3,
        ["War Cry"] = 3,
        ["Warlord's Tenacity"] = 6,
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

for name, rank in pairs(aas) do
    log.Info("Want to purchase %s rank %d", name, rank)


    -- TODO iterate in order of declaration. need to rework all because lua lacks such feature

    if mq.TLO.AltAbility(name).CanTrain() then
        -- rank 1
        log.Info("BUYING %s, CURRENT RANK %d/%d. index %d", mq.TLO.AltAbility(name).Name(), mq.TLO.AltAbility(name).Rank(), mq.TLO.AltAbility(name).MaxRank(), mq.TLO.AltAbility(name).Index())
        mq.cmdf("/alt buy %d", mq.TLO.AltAbility(name).Index())
        mq.delay(1000)

        -- rest of the ranks
        while mq.TLO.Me.AltAbility(name).CanTrain() and mq.TLO.Me.AltAbility(name).Rank() < rank do
            log.Info("Buying rank %d of %s", mq.TLO.Me.AltAbility(name).Rank()+1, name)
            mq.cmd("/alt buy " .. mq.TLO.Me.AltAbility(name).NextIndex())
            mq.delay(1000)
        end

    end
end
