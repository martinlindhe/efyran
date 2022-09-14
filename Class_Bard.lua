local mq = require("mq")

local defaultMelody = "general"

local Bard = { currentMelody = "" }

-- tells all bards to play given melody name
mq.bind("/playmelody", function(name)
    if is_orchestrator() then
        cmd("/dgexecute brd /playmelody "..name)
    end
    if is_brd() then
        Bard.PlayMelody(name)
    end
end)

function Bard.resumeMelody()
    if is_brd() then
        if Bard.currentMelody == "" then
            Bard.PlayMelody(defaultMelody)
        elseif Bard.currentMelody ~= "" and not is_casting() then
            Bard.PlayMelody(Bard.currentMelody)
        end
    end
end

-- memorizes and sings a set of songs defined in peer settings.songs
function Bard.PlayMelody(name)

    if botSettings.settings.songs == nil then
        cmd("/dgtell all ERROR no bard songs declared")
        delay(50000)
        return
    end

    if window_open("MerchantWnd") then
        return
    end

    local songSet = botSettings.settings.songs[name:lower()]
    if songSet == nil then
        cmd("/dgtell all ERROR no such song set "..name)
        cmd("/beep 1")
        return
    end

    print("Scribing bard song set ", name)

    local gemSet = ""
    for v, songRow in pairs(songSet) do
        local gem = memorize_spell(songRow)
        if gem ~= nil then
            gemSet = gemSet .. gem .. " "
        end
    end

    cmd("/twist "..gemSet)
    cmd("/dgtell all Playing melody \ay"..name.."\ax.")

    Bard.currentMelody = name
end

return Bard
