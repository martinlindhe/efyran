local Items = {}

-- remove item link from input text
function strip_link(s)
    -- TODO IMPLEMENT. macroquest can expose existing functionality to lua, says brainiac. someone just need to write a patch
    return s
end

function Items.Init()
    -- finds item by name in inventory/bags. NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
    mq.bind("/fdi", function(...)
        --- collect arg into query, needed for /fdi water flask to work without quotes
        local name = ""
        for i = 1, select("#",...) do
            name = name ..  select(i,...) .. " "
        end
        name = trim(name)

        print("finditem: searching for ", name  )

        name = strip_link(name)

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/fdi", name)
        end

        local item = get_item(name)
        if item == nil then
            --mq.cmd.dgtell("all", name, "not found")
            return nil
        end

        local cnt = getItemCountExact(item.Name())
        local s = item.ItemLink("CLICKABLE")() .. " in " .. inventory_slot_name(item.ItemSlot()) .. " (count:".. tostring(cnt) .. ")"
        mq.cmd.dgtell("all", s)
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

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/fmi", name)
        end

        local item = get_item(name)
        if item == nil then
            mq.cmd.dgtell("all I miss", name)
            return nil
        end
    end)
end

function trim(s)
    return s:match( "^%s*(.-)%s*$")
end

return Items
