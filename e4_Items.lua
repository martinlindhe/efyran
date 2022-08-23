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

        local item = getItem(name)
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

        local item = getItem(name)
        if item == nil then
            mq.cmd.dgtell("all I miss", name)
            return nil
        end
    end)
end

function trim(s)
    return s:match( "^%s*(.-)%s*$")
end




 

local baseSlots = { -- XXX this should be accessible from mq TLO ?
    [0] = "charm",
    [1] = "leftear",
    [2] = "head",
    [3] = "face",
    [4] = "rightear",
    [5] = "neck",

    [6] = "shoulder",
    [7] = "arms",
    [8] = "back",
    [9] = "leftwrist",
    [10] = "rightwrist",
    [11] = "ranged",
    [12] = "hands",
    [13] = "mainhand",
    [14] = "offhand",
    [15] = "leftfinger",
    [16] = "rightfinger",
    [17] = "chest",
    [18] = "legs",
    [19] = "feet",
    [20] = "waist",
    [21] = "powersource",
    [22] = "ammo",

    [23] = "pack1",
    [24] = "pack2",
    [25] = "pack3",
    [26] = "pack4",
    [27] = "pack5",
    [28] = "pack6",
    [29] = "pack7",
    [30] = "pack8",
    [31] = "pack9",
    [32] = "pack10",
}
-- returns a text representation of inventory slot id, see https://docs.macroquest.org/reference/general/slot-names/

function inventory_slot_name(n)
    if baseSlots[n] ~= nil then
        return baseSlots[n]
    end

    mq.cmd.dgtell("all XXX lookup inv slot", n, "failed")
end

return Items
