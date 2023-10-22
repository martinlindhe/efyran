-- quality of life tweaks

local mq = require("mq")
local log = require("knightlinc/Write")
local timer = require("Timer")

local assist  = require("assisting/Assist")
local follow  = require("e4_Follow")
local commandQueue = require("CommandQueue")
local botSettings = require("e4_BotSettings")
local loot  = require("looting/Loot")
local buffs   = require("e4_Buffs")
local globalSettings = require("e4_Settings")

require("autobank")

local Alerts = {
}

-- register raid alert handlers
function Alerts.Init()
    -- MPG raids
    mq.event("mpg-foresight-duck", "From the corner of your eye, you notice a Kyv taking aim at your head. You should duck.", function(text)
        log.Info("mpg-foresight DUCK")
        if zone_shortname() ~= "chambersc" then
            return
        end

        assist.backoff()

        local hp = mq.TLO.Me.PctHPs()

        for i = 1, 10 do
            if not mq.TLO.Me.Ducking() then
                cmd("/keypress duck")
            end
            delay(200)
        end

        if mq.TLO.Me.Ducking() then
            cmd("/keypress duck")
        end

        if mq.TLO.Me.PctHPs() < hp then
            all_tellf("foresight1: failed DUCK origHP %d, currHP %d", hp, mq.TLO.Me.PctHPs())
        end
    end)

    mq.event("mpg-foresight-pbae", "You notice that the Dragorn before you is preparing to cast a devastating close-range spell.", function(text)
        cmd("/popup Dragorn PBAE Inc")
        if is_raid_leader() then
            cmd("/rs @@@ PBAE INC @@@")
        end
    end)

    mq.event("mpg-foresight-blast", "You notice that the Dragorn before you is making preparations to cast a devastating spell.  Doing enough damage to him might interrupt the process.", function(text)
        cmd("/popup Dragorn Blast Inc")
        if is_raid_leader() then
            cmd("/rs @@@ BLAST INC @@@")
        end
    end)

    mq.event("mpg-foresight-thorn", "The Dragorn before you is sprouting sharp spikes.", function(text)
        cmd("/popup Dragorn Thorns Inc")
        if is_raid_leader() then
            cmd("/rs ^^^ Thorns ON ^^^")
        end
    end)

    mq.event("mpg-foresight-reflect", "The Dragorn before you is developing an anti-magic aura.", function(text)
        cmd("/popup Dragorn Reflect Inc")
        if is_raid_leader() then
            cmd("/rs ~~~ Reflect ON ~~~")
        end
    end)

    mq.event("bloodfields-gazz-ramp", "Gazz the Gargantuan slows its gait and begins flailing muscular arms in all directions#*#", function(text)
        cmd("/popup >>^<< Gazz begins to ramp - MELEE OFF and CASTER ON >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< Gazz begins to ramp - MELEE OFF and CASTER ON >>^<<")
        end
    end)

    mq.event("inktuta-cursecaller-dt", "The thoughts of a cursed trusik invade your mind#*#", function(text)
        if zone_shortname() == "inktuta" then
            cmdf("/rs I, >>^<< %s >>^<<, who am about to die, salute you!!", mq.TLO.Me.Name())
        end
    end)

    mq.event("uqua-key", "The #1# must unlock the door to the next room.", function(text, key)
        if zone_shortname() == "uqua" then
            cmdf("/rs >>^<< The %s unlocks the door >>^<<", key)
            cmdf("/popup >>^<< The %s unlocks the door >>^<<", key)
        end
    end)

    mq.event("tactics-stampede", "You hear the pounding of hooves.", function(text, key)
        if zone_shortname() == "potactics" then
            cmdf("/gsay STAMPEDE!")
        end
    end)

    mq.event("anguish-ture", "Ture roars with fury as it surveys its attackers.", function(text, key)
        if zone_shortname() == "anguish" then
            cmd("/popup Ture roars >> MOVE AWAY MELEE <<")
            if is_raid_leader() then
                cmdf("/rs Ture roars >> MOVE AWAY MELEE <<")
            end
        end
    end)

    mq.event("anguish-mask", "You feel a gaze of deadly power focusing on you.", function(text, key)
        if zone_shortname() == "anguish" then
            cmdf("/rs ~~~Mask on Me~~~ Ready: %s", mq.TLO.Me.ItemReady("Mirrored Mask")())

            --            /if (!${Bool[${FindItem[=Mirrored Mask]}]}) {
            --                /bc [+r+] I dont have a Mirrored Mask
            --                /return
            --              } else /if (${FindItem[=Mirrored Mask].ItemSlot} >=23 ) {
            --                /if (${Me.Casting.ID}) /call interrupt
            --                /delay 3s !${Me.Casting.ID}
            --                /declare OMM_Mask string local ${Me.Inventory[face].Name}
            --                /call WriteToIni "${MacroData_Ini},${Me.CleanName}-${MacroQuest.Server},Pending Exchange" "${OMM_Mask}/face" 1
            --                /delay 3
            --                /echo calling swapitem
            --                /call SwapItem "Mirrored Mask" "face"
            --                /delay 5 ${Me.Inventory[face].Name.Equal[Mirrored Mask]}
            --                /call SwapItem "Mirrored Mask" "face"
            --                /delay 5 ${Me.Inventory[face].Name.Equal[Mirrored Mask]}
            --                /call SwapItem "Mirrored Mask" "face"
            --                /delay 5 ${Me.Inventory[face].Name.Equal[Mirrored Mask]}
            --              }
            --              /if (${Me.Inventory[face].Name.Equal[Mirrored Mask]}) {
            --                /declare numtries int local=0
            --                /if (${Me.Casting.ID}) /call interrupt
            --                /delay 3s !${Me.Casting.ID}
            --                :retry
            --                /varcalc numtries ${numtries}+1
            --                /casting "Mirrored Mask" -maxtries|3
            --                /delay 1s
            --                /if (!${Bool[${Me.Song[Reflective Skin]}]} && ${numtries} < 8) /goto :retry
            --              }
            --              |/if (${OMM_Mask.Length}) /call SwapItem "${OMM_Mask}" "face"
            --cmdf("/rs ~~~Mask on Me~~~ Ready: %s", mq.TLO.Me.ItemReady("Mirrored Mask")())

        end
    end)

    mq.event("ikkinz-priest", "The creature cannot stand up to the power of healers#*#", function(text)
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< PRIEST >>^<<")
        end
    end)

    mq.event("ikkinz-hybrid", "The creature appears weak to the combined effort of might and magic#*#", function(text)
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< HYBRID >>^<<")
        end
    end)

    mq.event("ikkinz-caster", "The creature will perish under the strength of intelligent magic#*#", function(text)
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< CASTER >>^<<")
        end
    end)

    mq.event("ikkinz-melee", "The creature appears weak to the combined effort of strength and cunning#*#", function(text)
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< MELEE >>^<<")
        end
    end)

    mq.event("ikkinz-class-war", "The creature fears brute force and brawn#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< WARRIOR >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< WARRIOR >>^<<")
        end
    end)

    mq.event("ikkinz-class-shm", "You sense the creature cringe at the appearance of talismans#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< SHAMAN >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< SHAMAN >>^<<")
        end
    end)

    mq.event("ikkinz-class-bst", "The creature fears deep gashes of feral savagery#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< BEASTLORD >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< BEASTLORD >>^<<")
        end
    end)

    mq.event("ikkinz-class-nec", "The creature cowers from the doom of death#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< NECROMANCER >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< NECROMANCER >>^<<")
        end
    end)

    mq.event("ikkinz-class-clr", "The creature has a dread of celestial spirits#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< CLERIC >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< CLERIC >>^<<")
        end
    end)

    mq.event("ikkinz-class-shd", "It appears that this creature dreads the strike of death#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< SHADOWKNIGHT >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< SHADOWKNIGHT >>^<<")
        end
    end)

    mq.event("ikkinz-class-mnk", "The creature fears focused tranquility#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< MONK >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< MONK >>^<<")
        end
    end)

    mq.event("ikkinz-class-brd", "The creature fears a foreboding melody#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< BARD >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< BARD >>^<<")
        end
    end)

    mq.event("ikkinz-class-pal", "A holy blade daunts the creature#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< PALADIN >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< PALADIN >>^<<")
        end
    end)

    mq.event("ikkinz-class-rog", "The creature ignores anything behind it#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< ROGUE >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< ROGUE >>^<<")
        end
    end)

    mq.event("ikkinz-class-enc", "The creature's mind and body are vulnerable#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< ENCHANTER >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< ENCHANTER >>^<<")
        end
    end)

    mq.event("ikkinz-class-wiz", "#*#falters when struck with the power of the elements#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< WIZARD >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< WIZARD >>^<<")
        end
    end)

    mq.event("ikkinz-class-ber", "The creature shies from heavy blades#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< BERSERKER >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< BERSERKER >>^<<")
        end
    end)

    mq.event("ikkinz-class-mag", "The creature appears vulnerable to summoned elements#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< MAGICIAN >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< MAGICIAN >>^<<")
        end
    end)

    mq.event("ikkinz-class-dru", "The creature seems weak in the face of the power of nature#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< DRUID >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< DRUID >>^<<")
        end
    end)

    mq.event("ikkinz-class-rng", "The creature fears true shots and fast blades#*#", function(text)
        cmd("/popup Spawn must be killed by a >>^<< RANGER >>^<<")
        if is_raid_leader() then
            cmd("/rs Spawn must be killed by a >>^<< RANGER >>^<<")
        end
    end)

    mq.event("don-kessdona-ae", "Kessdona rears back and fills her lungs, preparing to exhale a cone of disintegrating flame.", function(text)
        cmd("/popup >>^<< Directional AE >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< Directional AE >>^<<")
        end
    end)

    mq.event("don-rikkukin-ae-right", "Rikkukin pulls his right arm back, preparing to cut a swathe through his opponents with his razor sharp claws.", function(text)
        cmd("/popup >>^<< AE on right side >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< AE on right side >>^<<")
        end
    end)

    mq.event("don-rikkukin-ae-left", "Rikkukin pulls his left arm back, preparing to cut a swathe through his opponents with his razor sharp claws.", function(text)
        cmd("/popup >>^<< AE on left side >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< AE on left side >>^<<")
        end
    end)

    mq.event("don-rikkukin-ae-rear", "Rikkukin twirls his tail, preparing to sweat away those foolish enough to take up position behind him.", function(text)
        cmd("/popup >>^<< AE on rear side >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< AE on rear side >>^<<")
        end
    end)

    mq.event("don-rikkukin-ae-front", "Rikkukin rears backs and fills his lungs, preparing to exhale a cone of ice.", function(text)
        cmd("/popup >>^<< AE on front side >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< AE on front side >>^<<")
        end
    end)

    mq.event("don-rikkukin-blind", "Rikkukin twists his body so that the ambient light starts to reflect from his silvery scales.", function(text)
        cmd("/popup >>^<< Immune  Light (TURN AWAY) >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< Blinding Light (TURN AWAY) >>^<<")
        end
    end)

    mq.event("don-rikkukin-immune", "Rikkukin's skin seal over with a caustic sheet of malleable ice. The protection will soon make him impervious to melee and magical attacks.", function(text)
        cmd("/popup >>^<< IMMUNE (BACK OFF) >>^<<")
        if is_raid_leader() then
            cmd("/rs >>^<< IMMUNE (BACK OFF) >>^<<")
        end
    end)

    mq.event("don-vishmitar-creeping-doom", "#*#You sense your doom approaching#*#", function(text)
        cmd("/rs >>^<< DOOM ON ME >>^<<")
    end)
end

return Alerts
