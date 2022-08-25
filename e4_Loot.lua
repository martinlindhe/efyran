
require("persistence")

local settingsRoot = "D:/dev-mq/mqnext-e4-lua/settings"

local lootFile = settingsRoot .. "/" .. mq.TLO.MacroQuest.Server() .. "__Loot Settings.lua"

-- reads the loot settings from disk
function ReadLootSettings()
    local o = persistence.load(lootFile)
    if o == nil then
        print("No loot settings found (", lootFile, "), creating new table") 

        -- populate initial obj with keys A-Z, 0-9
        o = {}
        for n = 65, 90 do
            o[string.char(n)] = {}
        end
        for n = 0, 9 do
            o[tostring(n)] = {}
        end
    end
    return o
end

function WriteLootSettings(settings)
    -- WARNING DO not write from multiple toons.

    -- XXX force reload of settings on all other toons!

    persistence.store(lootFile, settings)
end

function GetLootItemSetting(lootSettings, item)
    local first = item.Name():sub(1, 1)
    return lootSettings[first][item.Name()]
end

function SetLootItemSetting(lootSettings, item, value)
    local first = item.Name():sub(1, 1)
    lootSettings[first][item.Name()] = value
end