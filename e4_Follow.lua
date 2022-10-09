local mq = require("mq")
local log = require("knightlinc/Write")
local globalSettings = require("e4_Settings")

local Follow = {
    spawn = nil, -- the current spawn I am following
}

function Follow.Pause()
    if globalSettings.followMode:lower() == "mq2nav" and mq.TLO.Navigation.Active() then
        cmd("/nav stop")
    elseif globalSettings.followMode:lower() == "mq2advpath" then
        cmd("/afollow off")
    elseif globalSettings.followMode:lower() == "mq2moveutils" then
        cmd("/stick off")
    end
end

local lastHeading = ""

-- called from QoL.Tick() on every tick
function Follow.Update()
    local exe = ""
    if Follow.spawn ~= nil and Follow.spawn.Distance3D() > Follow.spawn.MaxRangeTo() then
        if globalSettings.followMode:lower() == "mq2nav" then
            if not mq.TLO.Navigation.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
                exe = string.format("/nav id %d | dist=15 log=critical", Follow.spawn.ID())
                lastHeading = Follow.spawn.HeadingTo()
            end
        elseif globalSettings.followMode:lower() == "mq2advpath" then
            if not mq.TLO.AdvPath.Following() or lastHeading ~= Follow.spawn.HeadingTo() then
                exe = string.format("/afollow spawn %d", Follow.spawn.ID())
            end
        elseif globalSettings.followMode:lower() == "mq2moveutils" then
            --if not mq.TLO.Stick.Active() or lastHeading ~= Follow.spawn.HeadingTo() then
                cmdf("/target id %d", Follow.spawn.ID())
                exe = string.format("/stick hold 15 uw") -- face upwards to better run over obstacles
            --end
        end
    end
    if exe ~= "" then
        log.Info("Follow.Update: %s", exe)
        cmd(exe)
    end
end

return Follow
