-- write current char info to a ini file for later consumption by another tool
--
--
-- raw stats: int str etc, hp mana
-- all item slots and content
-- all bags & bank content (so u can search inventories on resulting webpage)

-- TODO: can we record output from /keys to file?



local mq = require("mq")
require("ezmq")


local timeStart = os.time()

local DUMP_KNOWN_AA = true
local DUMP_SPELLBOOK = true


-- rof2 client:
local SPELLBOOK_SIZE = 720      -- size of spellbook: 8 * 90 pages (RoF2)
local MAX_INV_SLOTS  = 10
local MAX_AUG_SLOTS  = 3

local me = mq.TLO.Me

local settingsRoot = "D:/dev-mq/mqnext-e4-lua/dumptoon"
local iniFile = settingsRoot .. "/Dumptoon."..me.Name()..".ini"
local aaMapFile = settingsRoot .. "/AAMap."..current_server()..".ini"



cmd("/lua stop e4")
drop_all_buffs()
delay(1000)


print("--- DUMP TOON ---")

-- Overview
cmd("/ini "..iniFile.." Overview Name "..me.Name())
cmd("/ini "..iniFile..' Overview Class '..me.Class.ID())
cmd("/ini "..iniFile..' Overview Race '..me.Race.ID())
cmd("/ini "..iniFile.." Overview Gender "..me.Gender())
cmd("/ini "..iniFile.." Overview Deity "..me.Deity.ID())

cmd("/ini "..iniFile.." Spawn Zone "..mq.TLO.Zone.ID())
cmd("/ini "..iniFile.." Spawn X "..me.X())
cmd("/ini "..iniFile.." Spawn Y "..me.Y())
cmd("/ini "..iniFile.." Spawn Z "..me.Z())


-- Bind points
for i = 0, 5 do
    cmd("/ini "..iniFile.." BindPoints "..i.." "..me.BoundLocation(i).Zone.ID().."|"..me.BoundLocation(i).X().."|"..me.BoundLocation(i).Y().."|"..me.BoundLocation(i).Z())
end


-- Tribute/Favor
cmd("/ini "..iniFile.." Favor Current ".. me.CurrentFavor())
cmd("/ini "..iniFile.." Favor Career "..me.CareerFavor())

-- XP
cmd("/ini "..iniFile.." XP Level "..me.Level())
cmd("/ini "..iniFile.." XP Exp "..me.Exp())
cmd("/ini "..iniFile.." XP AAExp "..me.AAExp())
cmd("/ini "..iniFile.." XP AAPoints "..me.AAPoints())
cmd("/ini "..iniFile.." XP AAPointsSpent "..me.AAPointsSpent())
-- XXX not available in peq-mq2 version: ${Me.GroupLeaderExp}, ${Me.GroupLeaderPoints}

-- LDoN
cmd("/ini "..iniFile.." LDoN Points "..me.LDoNPoints())
cmd("/ini "..iniFile.." LDoN GukEarned "..me.GukEarned())
cmd("/ini "..iniFile.." LDoN MirEarned "..me.MirEarned())
cmd("/ini "..iniFile.." LDoN MMEarned "..me.MMEarned())
cmd("/ini "..iniFile.." LDoN RujEarned "..me.RujEarned())
cmd("/ini "..iniFile.." LDoN TakEarned "..me.TakEarned())

-- coins
cmd("/ini "..iniFile.." Coins Copper "..me.Copper())
cmd("/ini "..iniFile.." Coins CopperBank "..me.CopperBank())
cmd("/ini "..iniFile.." Coins Silver "..me.Silver())
cmd("/ini "..iniFile.." Coins SilverBank "..me.SilverBank())
cmd("/ini "..iniFile.." Coins Gold "..me.Gold())
cmd("/ini "..iniFile.." Coins GoldBank "..me.GoldBank())
cmd("/ini "..iniFile.." Coins Platinum "..me.Platinum())
cmd("/ini "..iniFile.." Coins PlatinumBank "..me.PlatinumBank())
cmd("/ini "..iniFile.." Coins PlatinumShared "..me.PlatinumShared())


-- stats as seen by client - XXX can we get raw ones excluding gear and buffs?
-- XXX AC and ATK numbers?
cmd("/ini "..iniFile.." CurrentStats MaxHPs "..me.MaxHPs())
cmd("/ini "..iniFile.." CurrentStats MaxMana "..me.MaxMana())
cmd("/ini "..iniFile.." CurrentStats MaxEndurance "..me.MaxEndurance())
cmd("/ini "..iniFile.." CurrentStats STR "..me.STR())
cmd("/ini "..iniFile.." CurrentStats STA "..me.STA())
cmd("/ini "..iniFile.." CurrentStats AGI "..me.AGI())
cmd("/ini "..iniFile.." CurrentStats DEX "..me.DEX())
cmd("/ini "..iniFile.." CurrentStats WIS "..me.WIS())
cmd("/ini "..iniFile.." CurrentStats INT "..me.INT())
cmd("/ini "..iniFile.." CurrentStats CHA "..me.CHA())
cmd("/ini "..iniFile.." CurrentStats svPoison "..me.svPoison())
cmd("/ini "..iniFile.." CurrentStats svMagic "..me.svMagic())
cmd("/ini "..iniFile.." CurrentStats svDisease "..me.svDisease())
cmd("/ini "..iniFile.." CurrentStats svFire "..me.svFire())
cmd("/ini "..iniFile.." CurrentStats svCold "..me.svCold())
cmd("/ini "..iniFile.." CurrentStats svCorruption"..me.svCorruption())
cmd("/ini "..iniFile.." CurrentStats svChromatic "..me.svChromatic())
cmd("/ini "..iniFile.." CurrentStats svPrismatic "..me.svPrismatic())
cmd("/ini "..iniFile.." CurrentStats CurrentWeight "..me.CurrentWeight())
cmd("/ini "..iniFile.." CurrentStats AttackSpeed "..me.AttackSpeed())
cmd("/ini "..iniFile.." CurrentStats Haste "..me.Haste())

-- bonuses from gear as seen by client
cmd("/ini "..iniFile.." Bonuses HPBonus "..me.HPBonus())
cmd("/ini "..iniFile.." Bonuses HPRegenBonus "..me.HPRegenBonus())
cmd("/ini "..iniFile.." Bonuses ManaBonus "..me.ManaBonus())
cmd("/ini "..iniFile.." Bonuses ManaRegenBonus "..me.ManaRegenBonus())
cmd("/ini "..iniFile.." Bonuses EnduranceBonus "..me.EnduranceBonus())
cmd("/ini "..iniFile.." Bonuses EnduranceRegenBonus "..me.EnduranceRegenBonus())

cmd("/ini "..iniFile.." Bonuses AccuracyBonus "..me.AccuracyBonus())
cmd("/ini "..iniFile.." Bonuses AttackBonus "..me.AttackBonus())
cmd("/ini "..iniFile.." Bonuses AvoidanceBonus "..me.AvoidanceBonus())
cmd("/ini "..iniFile.." Bonuses ClairvoyanceBonus "..me.ClairvoyanceBonus())
cmd("/ini "..iniFile.." Bonuses CombatEffectsBonus "..me.CombatEffectsBonus())
cmd("/ini "..iniFile.." Bonuses DamageShieldBonus "..me.DamageShieldBonus())
cmd("/ini "..iniFile.." Bonuses DamageShieldMitigationBonus "..me.DamageShieldMitigationBonus())
cmd("/ini "..iniFile.." Bonuses DoTShieldBonus "..me.DoTShieldBonus())
cmd("/ini "..iniFile.." Bonuses HealAmountBonus "..me.HealAmountBonus())
cmd("/ini "..iniFile.." Bonuses ShieldingBonus "..me.ShieldingBonus())
cmd("/ini "..iniFile.." Bonuses SpellDamageBonus "..me.SpellDamageBonus())
cmd("/ini "..iniFile.." Bonuses SpellShieldBonus "..me.SpellShieldBonus())
cmd("/ini "..iniFile.." Bonuses StrikeThroughBonus "..me.StrikeThroughBonus())
cmd("/ini "..iniFile.." Bonuses StunResistBonus "..me.StunResistBonus())

doevents()

-- skills ... 1-78 is in use
-- IMPORTANT: skill ID:s do not match between rof2 client and eqemu server, so export skill names. rof2 id 50 = Stringed Instruments, eqemu id 50 = Swimming
for i = 1, 78 do
    if me.Skill(i)() then
        if mq.TLO.Skill(i).Name() ~= "None" then
            cmd("/ini "..iniFile..' Skill "'..mq.TLO.Skill(i).Name()..'"  '..me.Skill(i)())
        end
    end
end


-- languages (numbered 1-25)
for i = 1, 25 do
    cmd("/ini "..iniFile..' LanguageSkill "'..me.Language(i)()..'" '..tostring(me.LanguageSkill(i)()))
end



-- spell book content
if DUMP_SPELLBOOK then
    for i = 1, SPELLBOOK_SIZE do
        if me.Book(i).ID() then
            cmd("/ini "..iniFile.." Spells "..i.." "..tostring(me.Book(i).ID()))
        end
    end
end

doevents()


-- slot names: https://www.macroquest2.com/wiki/index.php/Slot_Names
-- equipment: 0-22 is worn gear, 23-32 is inventory top level (usually 10 backpacks)
-- Inventory ini section format: key is slot id, val is: item.ID|item.Stack|item.Name
for i = 0, 32 do
    local key = "inv"..tostring(i)
    if me.Inventory(i).ID() then
        cmd("/ini "..iniFile.." Inventory "..key..' "'..tostring(me.Inventory(i).ID()).."|"..me.Inventory(i).Charges()..'"')
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            if me.Inventory(i).AugSlot(a)() ~= nil then
                cmd("/ini "..iniFile.." Inventory "..sub..' "'..me.Inventory(i).AugSlot(a).Item.ID().."|"..me.Inventory(i).AugSlot(a).Item.Charges()..'"')
            else
                cmd("/ini "..iniFile.." Inventory "..sub.." NULL")
            end
        end
    else
        cmd("/ini "..iniFile.." Inventory "..key.." NULL")
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            cmd("/ini "..iniFile.." Inventory "..sub.."NULL")
        end
    end
end

doevents()

-- backpack content
for i = 1, MAX_INV_SLOTS do
    local key = "pack"..tostring(i)
    if mq.TLO.InvSlot(key).Item() ~= nil and mq.TLO.InvSlot(key).Item.Container() > 0 then
        for slot = 1, mq.TLO.InvSlot(key).Item.Container() do
            local sub = key.."_slot"..tostring(slot)
            if mq.TLO.InvSlot(key).Item.Item(slot)() ~= nil then
                cmd("/ini "..iniFile.." Inventory "..sub..' "'..mq.TLO.InvSlot(key).Item.Item(slot).ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).Charges()..'"')
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a)() ~= nil then
                        cmd("/ini "..iniFile.." Inventory "..aug..' "'..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.Charges()..'"')
                    else
                        cmd("/ini "..iniFile.." Inventory "..aug.." NULL")
                    end
                end
            else
                cmd("/ini "..iniFile.." Inventory "..sub.." NULL")
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    cmd("/ini "..iniFile.." Inventory "..aug.." NULL")
                end
            end
        end
    end
end

doevents()

-- bank top level slots: 1-24 is bank bags for rof2 (bank1-24), 25-26 is shared bank (shared1-2)
for i = 1, 26 do
    if me.Bank(i)() ~= nil then
        local key = "bank"..tostring(i)
        if i >= 25 then
            key = "shared"..tostring(i - 24)
        end
        cmd("/ini "..iniFile.." Inventory "..key..' "'..me.Bank(i).ID().."|"..me.Bank(i).Stack()..'"')

        if me.Bank(i).Container() > 0 then
            for e = 1, me.Bank(i).Container() do
                local sub = key.."_slot"..tostring(e)
                if me.Bank(i).Item(e)() ~= nil then
                    cmd("/ini "..iniFile.." Inventory "..sub..' "'..me.Bank(i).Item(e).ID().."|"..me.Bank(i).Item(e).Stack()..'"')
                else
                    cmd("/ini "..iniFile.." Inventory "..sub.." NULL")
                end
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if me.Bank(i).Item(e).AugSlot(a)() ~= nil then
                        cmd("/ini "..iniFile.." Inventory "..aug..' "'..me.Bank(i).Item(e).AugSlot(a).Item.ID().."|"..me.Bank(i).Item(e).AugSlot(a).Item.Stack()..'"')
                    else
                        cmd("/ini "..iniFile.." Inventory "..aug.." NULL")
                    end
                end
            end
        end
    end
end

doevents()

-- all purchased AA:s with rank
if DUMP_KNOWN_AA then
    for i = 1, 16000 do
        if me.AltAbility(i)() ~= nil then
            -- maps ID => rank|maxrank|purchased points
            cmd("/ini "..iniFile.." AARank "..me.AltAbility(i).ID()..' "'..me.AltAbility(i).Rank().."|"..me.AltAbility(i).MaxRank().."|"..me.AltAbility(i).PointsSpent()..'"')

            -- if aa missing in aamap.ini, write it
            if mq.TLO.Ini(aaMapFile, "AAMap", me.AltAbility(i).ID(), "-")() == "-" then
                cmd("/dgtell all FOUND NEW AA "..me.AltAbility(i).ID().." "..me.AltAbility(i).Name())
                cmd("/ini "..aaMapFile.." AAMap "..me.AltAbility(i).ID()..' "'..me.AltAbility(i).Name()..'"')
            end
        end
    end
end

-- combat abilities
for i = 1, 200 do
    if me.CombatAbility(i)() ~= nil then
        -- maps ID => rank|maxrank|purchased points
        cmd("/ini "..iniFile.." CombatAbility "..me.CombatAbility(i).ID()..' "'..me.CombatAbility(i).Name()..'"')
    end
end


local seondsElapsed = os.time() - timeStart
cmd("/dgtell all DUMPTOON DONE AFTER "..seondsElapsed.."s")

