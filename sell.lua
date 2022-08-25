-- auto sells inventory item listed in loot settings

require("ezmq")

require("e4_Loot")

local loot = ReadLootSettings()

-- Opens trade with the nearest merchant.
function open_nearby_merchant()

    local merchant = spawn_from_query("Merchant radius 100 los")
    if merchant == nil then
        print("ERROR no merchant nearby")
        return
    end

    print("... OPENING TRADE WITH MERCHANT ", merchant, " ", type(merchant))

    move_to(merchant)

    open_merchant_window(merchant)
end

open_nearby_merchant()

open_bags()



-- https://docs.macroquest.org/reference/general/slot-names/


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
                -- XXX for all items without settings, they should be enqueued for moderation by orchestrator.
                -- enqueue by posting to a special chanel, moderate using a custom UI

                -- Until above is done, just write "Keep" for new items
                local lootSetting = GetLootItemSetting(loot, item)
                --print(item, lootSetting)

                if lootSetting ~= nil then
                    --print("LOOT SETTING: ", item, " ",lootSetting)

                    if lootSetting == "Sell" then
                        print("Selling ", item.Name())

                        local itemNotifyQuery = "/ctrl /itemnotify in Pack"..tostring(item.ItemSlot()-22).." "..tostring(item.ItemSlot2()+1).." leftmouseup"
 
                        --itemNotifyQuery = '/ctrl /itemnotify "'..item.Name()..'" leftmouseup'
                        print("itemNotifyQuery: ", itemNotifyQuery)
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
                    -- XXX write "Keep" for new loot item.
                    mq.cmd.dgtell("all New loot. Marking as keep. ", item.ItemLink("CLICKABLE"))
                    SetLootItemSetting(loot, item, "Keep")
                end
                
            end

        end

   end
end

WriteLootSettings(loot)




-- close_merchant_window()
-- close_bags()

