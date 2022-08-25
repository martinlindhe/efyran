-- quality of life tweaks

local QoL = {}

-- returns true if I am in a guild
function in_guild()
    return mq.TLO.Me.Guild() ~= nil
end

function QoL.Init()

    if is_rof2() then
        -- rof2 client has no persistent setting for /tgb on. it has been permanently auto enabled on live
        mq.cmd.tgb("on")
    end

    if mq.TLO.Me.Combat() then
        mq.cmd.attack("off")
    end

    if is_orchestrator() then
        mq.cmd.djoin("skillup")
    end

    if in_guild() then
        -- enable auto consent for guild
        mq.cmd("/consent guild")
    end

    clear_cursor()

    QoL.verifySpellLines()

    mq.event("missing_component", "You are missing #1#.", function(text, name)
        if name ~= "some required components" then
            mq.cmd.dgtell("Missing component", name)
            mq.cmd.beep(1)
        end
    end)

    mq.event("tell", "#1# tells you, #2#", function(text, name, msg)
        local s = string.lower(msg)
        if s == "buff me" or s == "buffme" then
            -- XXX commandeer all to buff this one. how to specify orchestrator if buff is in background? we enqueue it to a zone channel !!!
            mq.cmd.dgtell("XXX FIXME handle 'buffme' tell from ", name)
            mq.cmd.beep(1)
        else
            if name == mq.TLO.Me.Pet.CleanName() then
                print("GNORING TELL FROM MY PET '".. name.. "'': ", msg)
            else
                mq.cmd.dgtell("all GOT A TELL FROM", name, ": ", msg, " my pet:",mq.TLO.Me.Pet.Name())
                mq.cmd.beep(1)
            end
        end
    end)

    mq.event("skillup", "You have become better at #1#! (#2#)", function(text, name, num)
        mq.cmd.dgtell("skillup ".. name .. " (".. num.."/".. tostring(mq.TLO.Skill(name).SkillCap()) ..")")
    end)
    
    mq.event("xp", "You gain experience!", function()
        mq.cmd.dgtell("xp gain")
    end)

    -- clear all chat windows on current peer
    mq.bind("/clr", function(name)
        mq.cmd.clear()
    end)

    -- clear all chat windows on all peers
    mq.bind("/cls", function(name)
        mq.cmd.dgaexecute("/clear")
    end)

    mq.bind("/self", function(name)
        mq.cmd("/target myself")
    end)

    -- hide existing corpses
    mq.bind("/hce", function(name)
        mq.cmd("/hidec all")
    end)

    -- hide looted corpses
    mq.bind("/hcl", function(name)
        mq.cmd("/hidec looted")
    end)

    -- hide no corpses
    mq.bind("/hcn", function(name)
        mq.cmd("/hidec none")
    end)

    -- quickly exits all eqgame.exe instances using task manager (prevents url open on f2p game exit)
    mq.bind("/exitall", function(name)
        mq.cmd.exec('TASKKILL "/F /IM eqgame.exe"')
    end)

    -- open loot window on closest corpse
    mq.bind("/lcorpse", function()
        if has_target() ~= nil then
            mq.cmd.target("clear")
        end
        mq.cmd.target("corpse radius 100")
        mq.delay(500, function()
            return has_target()
        end)
        mq.cmd.loot()
    end)

    
    -- reports all toons that are not running e4
    mq.bind("/note4", function()
        mq.cmd("/dgaexecute /lua run note4")
    end)

    mq.bind("/running", function()
        -- XXX reports all running scripts on all toons
        print("FIXME impl /running: report all running scripts on all toons")
    end)
end

function QoL.verifySpellLines()
    -- make sure I know all listed abilities

    verifySpellLines("evac", botSettings.settings.evac)
    verifySpellLines("self_buffs", botSettings.settings.self_buffs)

    if botSettings.settings.assist ~= nil then
        verifySpellLines("taunts", botSettings.settings.assist.taunts)
        verifySpellLines("pbae", botSettings.settings.assist.pbae)
        verifySpellLines("abilities", botSettings.settings.assist.abilities)
        verifySpellLines("quickburns", botSettings.settings.assist.quickburns)
        verifySpellLines("longburns", botSettings.settings.assist.longburns)
        verifySpellLines("fullburns", botSettings.settings.assist.fullburns)

        if botSettings.settings.assist.nukes ~= nil then
            for k, v in pairs(botSettings.settings.assist.nukes) do
                verifySpellLines(k, v)
            end
        end    
    end

    if botSettings.settings.healing ~= nil then
        verifySpellLines("life_support", botSettings.settings.healing.life_support)
        verifySpellLines("tank_heal", botSettings.settings.healing.tank_heal)
        verifySpellLines("important_heal", botSettings.settings.healing.important_heal)

        if botSettings.settings.healing.cures ~= nil then
            for k, v in pairs(botSettings.settings.healing.cures) do
                verifySpellLines("cures", {k})
            end
        end
    end

    if botSettings.settings.songs ~= nil then
        for k, v in pairs(botSettings.settings.songs) do
            verifySpellLines(k, v)
        end
    end

    if botSettings.settings.group_buffs ~= nil then
        for k, v in pairs(botSettings.settings.group_buffs) do
            verifySpellLines(k, v)
        end
    end

    -- XXX TODO validate more fields
end

-- warns if you lack any item etc listed in `lines`.
function verifySpellLines(label, lines)
    if lines == nil then
        return
    end
    for k, row in pairs(lines) do
        local spellConfig = parseSpellLine(row)
        if not known_spell_ability(spellConfig.Name) then
            mq.cmd.dgtell("all Missing "..label..": "..spellConfig.Name)
            mq.cmd.beep(1)
        end
    end
end

function me_healer()
    return is_healer(mq.TLO.Me.Class.ShortName())
end

function me_priest()
    return is_priest(mq.TLO.Me.Class.ShortName())
end

function me_tank()
    return is_tank(mq.TLO.Me.Class.ShortName())
end

-- true if CLR,DRU,SHM,PAL,RNG,BST
function is_healer(class)
    if class == nil then
        mq.cmd.dgtell("all is_healer called without class. did you mean me_healer() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM" or class == "PAL" or class == "RNG" or class == "BST"
end

-- true if CLR,DRU,SHM
function is_priest(class)
    if class == nil then
        mq.cmd.dgtell("all is_priest called without class. did you mean me_priest() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM"
end

function is_tank(class)
    if class == nil then
        mq.cmd.dgtell("all is_tank called without class. did you mean me_tank() ?")
        mq.cmd.beep(1)
    end
    return class == "WAR" or class == "PAL" or class == "SHD"
end

-- XXX add more:
-- Silk (ENC,MAG,NEC,WIZ)
-- Chain (ROG,BER,SHM,RNG)
-- Leather (DRU,BST,MNK)
-- Plate (WAR,BRD,CLR,PAL,SHD)
-- Knight(PAL,SHD)
-- Melee(BRD,BER,BST,MNK,PAL,RNG,ROG,SHD,WAR)
-- Hybrid (PAL,SHD,RNG,BST)

-- runs every second
function QoL.Tick()
    -- close f2p nag screen
    if mq.TLO.Window("AlertWnd").Open() then
        mq.cmd.notify("AlertWnd ALW_Dismiss_Button leftmouseup")
    end

    -- auto accept trades
    if mq.TLO.Window("tradewnd").Open() then
        if has_target() and mq.TLO.DanNet(mq.TLO.Target())() ~= nil then
            mq.cmd.dgtell("all Accepting trade in 5s with", mq.TLO.Target())
            mq.delay(5000) -- 5.0s
            mq.cmd.notify("tradewnd TRDW_Trade_Button leftmouseup")
        else
            mq.cmd.dgtell("all Ignoring trade from unknown toon ", mq.TLO.Target())
            mq.cmd.beep(1)
        end
    end

    if mq.TLO.Me.Class.ShortName() == "WIZ" and have_pet() then
        print("dropping wiz familiar ...", mq.TLO.Me.Pet.ID(), type(mq.TLO.Me.Pet.ID()))
        mq.cmd.pet("get lost")
    end

end

return QoL