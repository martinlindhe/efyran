local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local Tribute = {
    rules = {
        "Zone|txevu tacvi/Only|tanks",
        "Zone|anguish/Only|tanks",
        "Zone|stillmoonb/Instance|Kessdona's Perch/Only|tanks priests melee",
        "Zone|stillmoonb/Instance|Reflections of Silver/Only|tanks",
        "Zone|thundercrest/Instance|An End to the Storms/Only|tanks priests melee",
        "Zone|thenest/Instance|In the Shadows/Only|tanks priests melee",
    },

    tributeCheckTimer = timer.new(20 * 1), -- 20s
}

function Tribute.Tick()

    if not Tribute.tributeCheckTimer:expired() then
        return
    end
    Tribute.tributeCheckTimer:restart()

    local isTributeZone = false
    local instance = nil
    for _, rule in pairs(Tribute.rules) do
        local parsed = parseFilterLine(rule)

        local skip = false
        if parsed.Instance ~= nil then
            if mq.TLO.Task(parsed.Instance).Index() ~= nil then
                instance = parsed.Instance
            else
                --log.Debug("Tribute: not in instance \ay%s\ax!", parsed.Instance)
                skip = true
            end
        end

        if parsed.Zone ~= nil then
            local found = false
            for zone in parsed.Zone:gmatch("%S+") do
                if zone == zone_shortname() then
                    found = true
                    break
                end
            end
            if not found then
                skip = true
            end
        end

        if not skip and matches_filter(rule, mq.TLO.Me()) then
            isTributeZone = true
            break
        end
    end

    if isTributeZone and not mq.TLO.Me.TributeActive() then
        if mq.TLO.Me.CurrentFavor() < 500 then
            all_tellf("\arERROR: Too low tribute, not turning it on!! (%d points)\ax", mq.TLO.Me.CurrentFavor())
            return
        elseif mq.TLO.Me.CurrentFavor() < 10000 then
            all_tellf("\ayWARNING: Getting low on tribute (%d points)\ax", mq.TLO.Me.CurrentFavor())
        end
        local s = string.format("Tribute >>\agAuto Enabled\ax<< in \ay%s\ax", zone_shortname())
        if instance ~= nil then
            s = s .. string.format(" (\ay%s\ax)",  instance)
        end
        all_tellf(s)
        Tribute.Enable()
    elseif not isTributeZone and mq.TLO.Me.TributeActive() and not is_naked() then
        all_tellf("Tribute >>\agAuto Disabled\ax<< in \ay%s\ax (timer %s)", zone_shortname(), mq.TLO.Me.TributeTimer.TimeHMS())
        Tribute.Disable()
    end

    --log.Debug("Tribute status: \ay%s\ax is tribute zone \ay%s\ax", zone_shortname(), tostring(isTributeZone))
end

function Tribute.Disable()
    if not mq.TLO.Me.TributeActive() then
        return
    end
    toggleTribute()
end

function Tribute.Enable()
    if mq.TLO.Me.TributeActive() then
        return
    end
    toggleTribute()
end

return Tribute