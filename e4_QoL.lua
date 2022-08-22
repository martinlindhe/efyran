-- quality of life tweaks

local QoL = {}

function QoL.Init()

    if is_rof2() then
        -- rof2 client has no persistent setting for /tgb on. it has been permanently auto enabled on live
        mq.cmd.tgb("on")
    end

    if mq.TLO.Me.Combat() then
        mq.cmd.attack("off")
    end

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

    -- open loot window on closest corpse
    mq.bind("/lcorpse", function()
        if mq.TLO.Target() ~= nil then
            mq.cmd.target("clear")
        end
        mq.cmd.target("corpse radius 100")
        mq.delay(500, function()
            return mq.TLO.Target() ~= nil
        end)
        mq.cmd.loot()
    end)
end

function QoL.verifySpellLines()
    -- make sure I know all listed abilities

    verifySpellLines(botSettings.settings.self_buffs)
    if botSettings.settings.healing ~= nil then
        verifySpellLines(botSettings.settings.healing.life_support)
        verifySpellLines(botSettings.settings.healing.tank_heal)
        verifySpellLines(botSettings.settings.healing.important_heal)
    end
    if botSettings.settings.assist ~= nil then
        verifySpellLines(botSettings.settings.assist.abilities)
    end
    if botSettings.settings.nukes ~= nil then
        verifySpellLines(botSettings.settings.nukes.main)  -- XXX loop all groups
    end

    -- XXX TODO validate more fields
end

-- makes sure you have the item etc. ..
function verifySpellLines(lines)
    if lines == nil then
        return
    end
    for k, row in pairs(lines) do
        local spellConfig = parseSpellLine(row)
        if not known_spell_ability(spellConfig.Name) then
            mq.cmd.dgtell("all Missing ", spellConfig.Name)
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
        if mq.TLO.Target() ~= nil and mq.TLO.DanNet(mq.TLO.Target())() ~= nil then
            mq.cmd.dgtell("all Accepting trade in 5s with", mq.TLO.Target())
            mq.delay(5000) -- 5.0s
            mq.cmd.notify("tradewnd TRDW_Trade_Button leftmouseup")
        else
            mq.cmd.dgtell("all Ignoring trade from unknown toon ", mq.TLO.Target())
            mq.cmd.beep(1)
        end
    end

    if mq.TLO.Me.Class.ShortName() == "WIZ" and mq.TLO.Me.Pet.ID() ~= 0 then
        print("dropping wiz familiar ...", mq.TLO.Me.Pet.ID(), type(mq.TLO.Me.Pet.ID()))
        mq.cmd.pet("get lost")
    end

    if mq.TLO.Me.MaxMana() > 0 and not mq.TLO.Me.Moving() then
        if mq.TLO.Me.PctMana() < 70 and mq.TLO.Me.Standing() then
            mq.cmd.dgtell("all low mana, medding! ", mq.TLO.Me.PctMana())
            mq.cmd.sit("on")
        elseif mq.TLO.Me.PctMana() >= 100 and not mq.TLO.Me.Standing() and not mq.TLO.Window("SpellBookWnd").Open() then
            mq.cmd.dgtell("all Ending medbreak, full mana.")
            mq.cmd.sit("off")
        end
    end

end

return QoL