-- cycles thru nearby npc and attacks them. to be run from melee noob to pl together with sit.lua

require("ezmq")

local spawnQuery = "npc zradius 50 radius 40"


local hit
mq.event("xp", "You #1# #2# for #3# points of damage.", function(line, kind, target, dmg)
    --print("hit ", kind)
    hit = true
end)



print("tag.lua melee PL started, cycling thru nearby mobs ...")

local tagged = {} -- track all tagged mob id:s

while true do

    local oldY = mq.TLO.Me.Y()
    local oldX = mq.TLO.Me.X()
    local oldZ = mq.TLO.Me.Z()

    if spawn_count("pc radius 80 zradius 50") > 1 then
        for i = 1, spawn_count(spawnQuery) do

            mq.doevents()

            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            if spawn() == nil then
                break
            end

            if not tagged[spawn.ID()] then

                if line_of_sight_to(spawn) then
                    mq.cmd.stick("off")
                    mq.delay(10)
                    local meleeDistance = spawn.MaxRangeTo() * 0.75

                    print("tagging ", spawn.ID(), " ", spawn.Name())
                    mq.cmd.target("id "..spawn.ID())
                    mq.delay(10)
                    mq.cmd.face("fast")

                    local stickArg = "hold " .. meleeDistance .. " uw"
                    mq.cmd.stick(stickArg)
                    mq.cmd.attack("on")

                    hit = false
                    mq.delay(5000, function()
                        mq.doevents()
                        if spawn() == nil then
                            print("XXX inside tag delay, spawn is now nil. breaking ")
                            return true
                        end
                        if hit then
                            print("hit is true, breaking from mob id ", spawn.ID())
                            tagged[spawn.ID()] = true
                            return true
                        end
                    end)

                    if tagged[spawn.ID()] == nil and spawn() ~= nil then
                        print("never tagged mob id", spawn.ID())
                    end

                end

                tagged[spawn.ID()] = true
            end
        end
    end

    --print("ALL TAGGED, RESETTING TAGGED MOBS")
    tagged = {}
    mq.doevents()
    mq.delay(100)

    move_to_loc(oldY, oldX, oldZ)

    if in_neutral_zone() then
        mq.cmd.dgtell("all ERROR: Ending tag.lua in neutral zone")
        os.exit()
    end

end