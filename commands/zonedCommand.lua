local mq = require("mq")
local commandQueue = require("lib/CommandQueue")
local assist  = require("lib/assisting/Assist")
local pet     = require("lib/pets/Pet")
local heal    = require("lib/healing/Heal")
local buffs   = require("lib/spells/Buffs")
local map     = require("lib/quality/Map")
local log     = require("knightlinc/Write")

-- performs various tasks when toon has finished starting up / zoning
---@param delay number
local function execute(delay)
    mq.delay(delay)
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

---@param zone string|nil
---@param delay number
local function createCommand(zone, delay)
    if zone == "an area where levitation effects do not function" then
        return
    end

    commandQueue.Enqueue(function() execute(delay) end)
end

mq.event("zoned", "You have entered #1#.", function(text, zone) createCommand(zone, 4000) end)

return {
    Enqueue = createCommand
}
