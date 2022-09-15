-- auto sells inventory item listed in loot settings

require("ezmq")
local log = require("knightlinc/Write")

require("e4_Loot")

local loot = ReadLootSettings()

open_nearby_merchant()

if not window_open("MerchantWnd") then
    return
end

if is_rof2() then
    -- XXX is open bags needed on rof2 with the new macroquest features? worked on live without them.
    open_bags()
end

for n = 1, num_inventory_slots() do
    local pack = "Pack"..tostring(n)
    local bag = get_inventory_slot(pack)
    if bag ~= nil and is_container(bag) then

        --print(bag.Name(), " ", is_container(bag))

        -- list content of each container
        for i = 1, bag.Container() do
            local item = mq.TLO.Me.Inventory(pack).Item(i)

            local skip = false
            if item() == nil or item.NoDrop() then
                skip = true
            end

            if not skip then
                if not window_open("MerchantWnd") then
                    log.Error("Merchant window was closed, giving up")
                    return
                end
                -- XXX for all items without settings, they should be enqueued for moderation by orchestrator.
                -- enqueue by posting to a special chanel, moderate using a custom UI

                -- Until above is done, just write "Keep" for new items
                local lootSetting = GetLootItemSetting(loot, item)
                --print(item, lootSetting)

                if lootSetting ~= nil then
                    --print("LOOT SETTING: ", item, " ",lootSetting)

                    if lootSetting == "Sell" then
                        local s =  item.ItemLink("CLICKABLE")()
                        if item.Stackable() then
                            s = s .. " x " .. item.Stack()
                        end

                        log.Error("Selling %s", s)

                        cmdf("/ctrl /itemnotify in Pack%d %d leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
                        delay(10)

                        -- retry sell twice
                        for j = 1, 2 do
                            cmd("/shift /notify MerchantWnd MW_Sell_Button leftmouseup")
                            delay(1000, function()
                                -- XXX see if bag is now empty ...
                                --print("is bag slot empty? ",  mq.TLO.Me.Inventory(pack).Item(i)()  )
                                return mq.TLO.Me.Inventory(pack).Item(i)() == nil
                            end)
                        end

                        -- XXX look and error if item is still in my inventory
                        if mq.TLO.Me.Inventory(pack).Item(i)() ~= nil then
                            log.Error("Failed to sell %s", item.Name())
                        end

                    end
                else
                    cmdf("/dgtell all New loot. Keeping %s", item.ItemLink("CLICKABLE")())
                    SetLootItemSetting(loot, item, "Keep")
                end

            end

        end

   end
end

WriteLootSettings(loot)

close_merchant_window()

if is_rof2() then
    close_bags()
end
