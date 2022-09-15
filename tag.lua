-- cycles thru nearby npc and attacks them. to be run from melee noob to pl together with sit.lua

require("ezmq")
local log = require("knightlinc/Write")

local spawnQuery = "npc zradius 50 radius 40"


local hit
mq.event("xp", "You #1# #2# for #3# points of damage.", function(line, kind, target, dmg)
    --print("hit ", kind)
    hit = true
end)



log.Info("tag.lua melee PL started, cycling thru nearby mobs ...")

local tagged = {} -- track all tagged mob id:s

while true do

    local oldY = mq.TLO.Me.Y()
    local oldX = mq.TLO.Me.X()
    local oldZ = mq.TLO.Me.Z()

    if spawn_count("pc radius 80 zradius 50") > 1 then
        for i = 1, spawn_count(spawnQuery) do

            doevents()

            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            if spawn() == nil then
                break
            end

            if not tagged[spawn.ID()] then

                if line_of_sight_to(spawn) then
                    cmd("/stick off")
                    delay(10)
                    local meleeDistance = spawn.MaxRangeTo() * 0.75

                    log.Info("Tagging %d %s", spawn.ID(), spawn.Name())
                    cmdf("/target id %d", spawn.ID())
                    delay(10)
                    cmd("/face fast")

                    local stickArg =
                    cmdf("/stick hold %f uw", meleeDistance)
                    cmd("/attack on")

                    hit = false
                    delay(5000, function()
                        doevents()
                        if spawn() == nil then
                            log.Info("Inside tag delay, spawn is now nil. breaking")
                            return true
                        end
                        if hit then
                            log.Info("Hit is true, breaking from mob id %d", spawn.ID())
                            tagged[spawn.ID()] = true
                            return true
                        end
                    end)

                    if tagged[spawn.ID()] == nil and spawn() ~= nil then
                        log.Info("Never tagged mob id %d", spawn.ID())
                    end

                end

                tagged[spawn.ID()] = true
            end
        end
    end

    --print("ALL TAGGED, RESETTING TAGGED MOBS")
    tagged = {}
    doevents()
    delay(100)

    move_to_loc(oldY, oldX, oldZ)

    if in_neutral_zone() then
        cmd("/dgtell all ERROR: Ending tag.lua in neutral zone")
        os.exit()
    end

end