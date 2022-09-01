-- auto sells inventory item listed in loot settings

require("ezmq")

require("e4_Loot")

local loot = ReadLootSettings()

-- Opens trade with the nearest merchant.
function open_nearby_merchant()
    if window_open("MerchantWnd") then
        return
    end
    local merchant = spawn_from_query("Merchant radius 100")
    if merchant == nil then
        print("ERROR no merchant nearby")
        return
    end

    print("... OPENING TRADE WITH MERCHANT ", merchant, " ", type(merchant))

    move_to(merchant)
    open_merchant_window(merchant)
end

open_nearby_merchant()

if not window_open("MerchantWnd") then
    return
end

--open_bags()

for n = 1, num_inventory_slots() do
    local pack = "Pack"..tostring(n)
    local bag = get_inventory_slot(pack)
    if is_container(bag) then

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
                    print("ERROR: Merchant window was closed, giving up")
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

                        print("Selling ", s)

                        local itemNotifyQuery = "/ctrl /itemnotify in Pack"..tostring(item.ItemSlot()-22).." "..tostring(item.ItemSlot2()+1).." leftmouseup"
                        mq.cmd(itemNotifyQuery)
                        mq.delay(10)

                        for j = 1, 2 do
                            mq.cmd("/shift /notify MerchantWnd MW_Sell_Button leftmouseup")
                            mq.delay(1000, function()
                                -- XXX see if bag is now empty ...
                                --print("is bag slot empty? ",  mq.TLO.Me.Inventory(pack).Item(i)()  )
                                return mq.TLO.Me.Inventory(pack).Item(i)() == nil
                            end)
                        end

                        -- XXX look and error if item is still in my inventory
                        if mq.TLO.Me.Inventory(pack).Item(i)() ~= nil then
                            print("ERROR: failed to sell", item.Name())
                        end

                    end
                else
                    mq.cmd.dgtell("all New loot. Marking as Keep. ", item.ItemLink("CLICKABLE"))
                    SetLootItemSetting(loot, item, "Keep")
                end
                
            end

        end

   end
end

WriteLootSettings(loot)

close_merchant_window()

-- close_bags()

