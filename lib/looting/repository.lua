local mq = require("mq")

local log = require("knightlinc/Write")

require("persistence")

---@class LootItem
---@field public Id integer
---@field public Name string
---@field public Sell boolean should we auto sell item?
---@field public Destroy boolean should we auto destroy item?

local lootFile = efyranConfigDir() .. "\\" .. current_server() .. "__Loot Settings.lua"

local function loadStore()
    local configData, err = loadfile(lootFile)
    if err then
        -- failed to read the config file, create it using pickle
        mq.pickle(lootFile, {})
        return {}
    elseif configData then
        -- file loaded, put content into your config table
        return configData()
    end
end

---@class LootRepository
local LootRepository = {
    items = loadStore()
}

---@param item LootItem
function LootRepository:add(item)
    table.insert(self.items, item)
end

---@param itemId integer
---@return LootItem?
function LootRepository:tryGet(itemId)
    for i, v in ipairs (self.items) do
        if (v.Id == itemId) then
            return v
        end
    end

    return nil
end

---@param upsertItem LootItem
function LootRepository:upsert(upsertItem)
    for k, v in ipairs (self.items) do
        if (v.Id == upsertItem.Id) then
            self.items[k] = upsertItem
            return
        end
    end

    self:add(upsertItem)
    local filePath = lootFile
    mq.pickle(filePath, LootRepository.items)
end

-- reads the loot settings from disk
function LootRepository.ReadLootSettings()
    local o = persistence.load(lootFile)
    if o == nil then
        log.Warn("No loot settings found (", lootFile, "), creating new table")

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

function LootRepository.WriteLootSettings(settings)
    -- WARNING DO not write from multiple toons.

    -- XXX force reload of settings on all other toons!

    persistence.store(lootFile, settings)
end

function LootRepository.GetLootItemSetting(lootSettings, item)
    local first = item.Name():sub(1, 1)
    return lootSettings[first][item.Name()]
end

function LootRepository.SetLootItemSetting(lootSettings, item, value)
    local first = item.Name():sub(1, 1)
    lootSettings[first][item.Name()] = value
end

return LootRepository
