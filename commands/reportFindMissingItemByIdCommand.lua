local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("lib/CommandQueue")

---@class MissingItemById
---@field Id number

-- used by /fmid
---@param id integer
local function report_find_missing_item_by_id(id)

    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/fmid %s", tostring(id)))
    end

    local found = false
    if mq.TLO.Cursor.ID() == id then
        found = true
    end


    -- search equipment
    for i = 1, 22 do
        if mq.TLO.InvSlot(i).Item.ID() == id then
            found = true
        end
    end

    -- search inventory
    for i = 1, 10 do -- 10 = number of inventory slots
        local pack = string.format("pack%d", i)
        if mq.TLO.Me.Inventory(pack).ID() == id then
            found = true
        end
        if mq.TLO.Me.Inventory(pack).Container() then
            for e = 1, mq.TLO.Me.Inventory(pack).Container() do
                if mq.TLO.Me.Inventory(pack).Item(e).ID() == id then
                    found = true
                end
            end
        end
    end

    -- search bank
    for i = 1, 26 do -- 26 = number of bank slots

        if mq.TLO.Me.Bank(i).ID() == id then
            found = true
        end
        if mq.TLO.Me.Bank(i).Container() then
            for e = 1, mq.TLO.Me.Bank(i).Container() do
                if mq.TLO.Me.Bank(i).Item(e).ID() == id then
                    found = true
                end
            end
        end
    end

    if not found then
        all_tellf("\arMISSING ID %d", id)
    end

end

---@param command MissingItemById
local function execute(command)
    report_find_missing_item_by_id(command.Id)
end

-- find missing item by id
local function createCommand(id)
    commandQueue.Enqueue(function() execute({Id = toint(id)}) end)
end

bind("/fmid", createCommand)
