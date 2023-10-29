local mq = require("mq")
local log = require("knightlinc/Write")

---@class LootItem
---@field public ID integer
---@field public Name string
---@field public Sell boolean should we auto sell item?
---@field public Destroy boolean should we auto destroy item?
---@field public Keep boolean? should we keep the item?

-- is turned into bools
local shortProperties = { "Sell", "Destroy", "Keep" }

-- parses a loot line with properties, returns a object
-- example in: "Fine Steel Rapier/Sell"
---@param s string
---@return LootItem
function parseLootLine(s)
    local o = {}
    local tokens = split_str(s, "/")

    for k, token in pairs(tokens) do
        local found, _ = string.find(token, "|")
        if found then
            local key = ""
            local subIndex = 0
            for v in string.gmatch(token, "[^|]+") do
                if subIndex == 0 then
                    key = v
                end
                if subIndex == 1 then
                    o[key] = v
                end
                subIndex = subIndex + 1
            end
        else
            if in_table(shortProperties, token) then
                o[token] = true
            else
                o.Name = token
            end
        end
    end
    if s == "" then
        o.Name = ""
    end
    return o
end

local lootFile = efyranConfigDir() .. "\\" .. current_server() .. "__Loot Settings.ini"

---@class LootRepository
local LootRepository = {
}

---@param item item
---@return LootItem|nil
function LootRepository:get(item)
    local firstLetter = string.sub(item.Name(), 1, 1)
    local lootData = mq.TLO.Ini(lootFile, firstLetter, item.ID())()
    if lootData == nil then
        return nil
    end
    local o = parseLootLine(lootData)
    o.ID = item.ID()
    return o
end

function write_ini(file, section, key, val)
    local s = string.format('/ini "%s" "%s" "%s" "%s"', file, section, key, val)
    log.Info("write_ini %s", s)
    mq.cmdf('/ini "%s" "%s" "%s" "%s"', file, section, key, val)
end

-- Create or update loot entry
---@param lootItem LootItem
function LootRepository:set(lootItem)
    local firstLetter = string.sub(lootItem.Name, 1, 1)
    local val = lootItem.Name
    if lootItem.Sell then
        val = val .. "/Sell"
    end
    if lootItem.Destroy then
        val = val .. "/Destroy"
    end
    if lootItem.Keep then
        val = val .. "/Keep"
    end
    write_ini(lootFile, firstLetter, lootItem.ID, val)
end

return LootRepository
