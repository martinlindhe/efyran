local mq = require 'mq'

---@class LootItem
---@field public Id integer
---@field public Name string
---@field public DoSell boolean
---@field public DoDestroy boolean
---@field public NumberOfStacks number|nil
---@field public Bankable boolean|nil

local function getFilePath()
    local fileName = "loot_settings.lua"
    return string.format("%s/%s/%s", efyranConfigDir(), current_server(), fileName)
end

local function loadStore()
    local configData, err = loadfile(getFilePath())
    if err then
        -- failed to read the config file, create it using pickle
        mq.pickle(getFilePath(), {})
        return {}
    elseif configData then
        -- file loaded, put content into your config table
        return configData()
    end
end

---@class Repository
local Repository = {
    items = loadStore()
}

---@param item LootItem
function Repository:add (item)
    table.insert(self.items, item)
end

---@param itemId integer
---@return LootItem?
function Repository:tryGet (itemId)
    for i, v in ipairs (self.items) do
        if (v.Id == itemId) then
        return v
        end
    end

    return nil
end

---@param upsertItem LootItem
function Repository:upsert (upsertItem)
    for k, v in ipairs (self.items) do
        if (v.Id == upsertItem.Id) then
        self.items[k] = upsertItem
        return
        end
    end

    self:add(upsertItem)
    local filePath = getFilePath()
    mq.pickle(filePath, Repository.items)
end

return Repository
