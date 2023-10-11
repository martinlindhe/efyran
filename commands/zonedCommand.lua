local mq = require("mq")
local commandQueue = require('e4_commandQueue')
local assist  = require("efyran/e4_Assist")
local pet     = require("efyran/e4_Pet")
local heal    = require("efyran/e4_Heal")
local buffs   = require("efyran/e4_Buffs")
local map     = require("efyran/e4_Map")

local log = require("efyran/knightlinc/Write")

-- performs various tasks when toon has finished starting up / zoning
local function execute()
    delay(5000) -- 5s
    commandQueue.Clear()
    assist.backoff()

    log.Debug("I zoned into %s", zone_shortname())

    pet.ConfigureAfterZone()
    clear_ae_rezzed()

    memorizeListedSpells()

    heal.timeZoned = os.time()
--    heal.autoMed = true

--    buffs.refreshBuffs = true
    buffs.UpdateClickies()

    map.AutoMapHeightFilter()
end

local function createCommand(text, zone)
    if zone == "an area where levitation effects do not function" then
        return
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.event("zoned", "You have entered #1#.", createCommand)
