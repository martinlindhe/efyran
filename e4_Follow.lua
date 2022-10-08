local mq = require("mq")
local log = require("knightlinc/Write")

local Follow = {
    spawn = nil, -- the current spawn I am following
}

function Follow.Pause()
    if mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    end

    --cmd("/afollow off")
    --cmd("/stick off")
end

local lastHeading = ""

-- TODO LATER: allow toggle which nav module to use: MQ2Nav, MQ2AdvPath, MQ2MoveUtils
-- MQ2Nav:   cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
-- MQ2AdvPath: cmdf("/afollow spawn %d", Follow.spawn.ID())
-- MQ2MoveUtils: cmdf("/target id %d", Follow.spawn.ID())       cmd("/stick hold 15 uw") -- face upwards to better run over obstacles

-- called from QoL.Tick() on every tick
function Follow.Update()
    if Follow.spawn ~= nil and Follow.spawn.Distance3D() > Follow.spawn.MaxRangeTo() then
        if not mq.TLO.Navigation.Active() then
            cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
        elseif lastHeading ~= Follow.spawn.HeadingTo() then
            cmdf("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
            lastHeading = Follow.spawn.HeadingTo()
        end
    end
end

return Follow
