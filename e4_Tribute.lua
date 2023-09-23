local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local timer = require("efyran/Timer")

local Tribute = {
    rules = {
        "/Zone|txevu tacvi/Only|tanks",
        "/Zone|anguish/Only|tanks",

        --"/Zone|stillmoona/Instance|Trial of Perseverance/Only|tanks",
    },

    tributeCheckTimer = timer.new_expired(60 * 2), -- 2 min
}

function Tribute.Tick()

    if not Tribute.tributeCheckTimer:expired() then
        return
    end
    Tribute.tributeCheckTimer:restart()

    local isTributeZone = false
    for _, rule in pairs(Tribute.rules) do
        local parsed = parseFilterLine(rule)

        local skip = false
        if parsed.Instance ~= nil and mq.TLO.Task(parsed.Instance).Index() == nil then
            log.Error("Tribute: in zone %s but not in instance %s!", parsed.Zone, parsed.Instance)
            skip = true
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
        elseif mq.TLO.Me.CurrentFavor() < 25000 then
            all_tellf("\ayWARNING: Getting low on tribute (%d points)\ax", mq.TLO.Me.CurrentFavor())
        end
        all_tellf("Tribute >>\agAuto Enabled\ax<< in \ay%s\ax", zone_shortname())
        Tribute.Enable()
    elseif not isTributeZone and mq.TLO.Me.TributeActive() then
        all_tellf("Tribute >>\agAuto Disabled\ax<< in \ay%s\ax (timer %s)", zone_shortname(), mq.TLO.Me.TributeTimer().TimeHMS)
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