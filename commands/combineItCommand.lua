local mq = require("mq")
local commandQueue = require("lib/CommandQueue")

local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local destroyItemIDs = {
    8238,9674,10281,14091,16598,16915,16925,16929,16933,19198,21612,21614,9686,10269,3053,3056,3061,3066,28799,21615,25653,77817,77818,72615,
    2776,  -- Reinforced Hopperhide Gorget
    25655, -- Crystalline Silk Mantle
    25659, -- Crystalline Silk Wristbands
    25660, -- Crystalline Silk Gloves
    25654, -- Crystalline Silk Shirt
}

-- autoinventories all items on cursor and autodestroys known items. returns false on failure
local function clear_cursor_and_autodestroy()
    while true do
        if mq.TLO.Cursor.ID() == nil then
            return true
        end
        if mq.TLO.Me.FreeInventory() == 0 then
            all_tellf("Cannot clear cursor, no free inventory slots")
            cmd("/beep 1")
            return false
        end

        if in_array(destroyItemIDs, mq.TLO.Cursor.ID()) then
            print("Destroying ", mq.TLO.Cursor.Name(), " ...")
            cmd("/destroy")
            delay(1)
        else
            all_tellf("Putting cursor item %s in inventory.", mq.TLO.Cursor())
            cmd("/autoinventory")
            delay(250)
        end
        delay(250)
        doevents()
    end
end

local outOfStuff = false
mq.event("missing_components", "Sorry, but you don't have everything you need for this recipe in your general inventory.", function(text, name)
    outOfStuff = true
end)

local function execute()
    clear_cursor()

    if mq.TLO.Cursor.ID() ~= nil then
        print("/combineit ERROR: Re-run the script without items on the cursor.")
        return
    end

    while true do

        if not window_open("TradeskillWnd") then
            print("combine.lua: tradeskill window is not open. Ending combine.")
            return
        end

        if mq.TLO.Window("TradeskillWnd").Child("CombineButton").Enabled() then
            cmd("/notify TradeskillWnd CombineButton leftmouseup")
            delay(1000, function() return mq.TLO.Cursor.ID() ~= nil end)
            if not clear_cursor_and_autodestroy() then
                print("Failed to clear cursor, giving up.")
                return
            end
        end

        delay(10)
        doevents()

        if outOfStuff then
            all_tellf("Combine ending: out of stuff")
            break
        end
    end
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute() end)
end

 -- NOTE: /combine is reserved for MacroQuest.
bind("/combineit", createCommand)
