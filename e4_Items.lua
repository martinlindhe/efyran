local mq = require("mq")

local Items = {}

function Items.Init()
    -- finds item by name in inventory/bags. NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    mq.bind("/fdi", function(...)
        --- collect arg into query, needed for /fdi water flask to work without quotes
        local name = ""
        for i = 1, select("#",...) do
            name = name ..  select(i,...) .. " "
        end
        name = trim(name)


        name = strip_link(name)

        print("Ssearching for ", name)

        if is_orchestrator() then
            cmd("/dgzexecute /fdi "..name)
        end

        local item = find_item(name)
        if item == nil then
            --cmd("/dgtell all", name, "not found")
            return nil
        end

        local cnt = getItemCountExact(item.Name())
        local s = item.ItemLink("CLICKABLE")() .. " in " .. inventory_slot_name(item.ItemSlot()) .. " (count:".. tostring(cnt) .. ")"
        cmd("/dgtell all "..s)
    end)

    -- find missing item
    mq.bind("/fmi", function(...)
        --- collect arg into query, needed for /fdi water flask to work without quotes
        local name = ""
        for i = 1, select("#",...) do
            name = name ..  select(i,...) .. " "
        end
        name = trim(name)

        -- XXX strip item links

        if is_orchestrator() then
            cmd("/dgzexecute /fmi "..name)
        end

        local item = find_item(name)
        if item == nil then
            cmd("/dgtell all I miss "..name)
            return nil
        end
    end)
end

function trim(s)
    return s:match( "^%s*(.-)%s*$")
end

return Items
