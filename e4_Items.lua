local mq = require("mq")
local log = require("knightlinc/Write")

local Items = {}


--- collect arg into query, needed for /fdi water flask to work without quotes
function args_string(...)
    local s = ""
    for i = 1, select("#",...) do
        s = s ..  select(i,...) .. " "
    end
    return s
end

function Items.Init()
    -- finds item by name in inventory/bags. NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    mq.bind("/fdi", function(...)
        local name = trim(args_string(...))
        name = strip_link(name)

        log.Info("Ssearching for %s", name)

        if is_orchestrator() then
            cmdf("/dgzexecute /fdi %s", name)
        end

        local item = find_item(name)
        if item == nil then
            --cmd("/dgtell all", name, "not found")
            return
        end

        local cnt = getItemCountExact(item.Name())
        cmdf("/dgtell all %s in %s (count: %d)", item.ItemLink("CLICKABLE")(), inventory_slot_name(item.ItemSlot()), cnt)
    end)

    -- find missing item
    mq.bind("/fmi", function(...)
        local name = trim(args_string(...))
        name = strip_link(name)

        if is_orchestrator() then
            cmdf("/dgzexecute /fmi %s", name)
        end

        local item = find_item(name)
        if item == nil then
            cmdf("/dgtell all I miss %s", name)
            return
        end
    end)
end

return Items
