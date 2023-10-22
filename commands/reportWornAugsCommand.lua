local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("CommandQueue")

local function execute()
    log.Info("Currently worn auguments:")
    local hp = 0
    local mana = 0
    local endurance = 0
    local ac = 0
    for i = 0, 22 do
        if mq.TLO.Me.Inventory(i).ID() then
            for a = 0, mq.TLO.Me.Inventory(i).Augs() do
                if mq.TLO.Me.Inventory(i).AugSlot(a)() ~= nil then
                    local item = mq.TLO.Me.Inventory(i).AugSlot(a).Item
                    hp = hp + item.HP()
                    mana = mana + item.Mana()
                    endurance = endurance + item.Endurance()
                    ac = ac + item.AC()
                    log.Info(inventory_slot_name(i).." #"..a..": "..item.ItemLink("CLICKABLE")().." "..item.HP().." HP")
                end
            end
        end
    end
    log.Info("Augument total: "..hp.." HP, "..mana.." mana, "..endurance.." endurance, "..ac.." AC")
end

-- reports all currently worn auguments
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/wornaugs", createCommand)
