local mq = require("mq")
local log = require("knightlinc/Write")

-- auto adjusts map height filter in some zones
local function autoMapHeightFilter()
    local heights = {
        -- old
        guktop = {min = 30, max = 30},
        soltemple = {min = 10, max = 10},
        soldunga = { min = 15, max = 15},
        lavastorm = { min = 100, max = 100},
        unrest = { min = 9, max = 9},
        felwithea = { min = 10, max = 10},
        highkeep = { min = 10, max = 10},
        blackburrow = { min = 10, max = 10},

        -- kunark?
        chardok = {min = 60, max = 60},
        sirens = {min = 50, max = 50},
        necropolis = {min = 80, max = 80},

        -- luclin
        fungusgrove = {min = 80, max = 80},

        -- pop
        codecay = {min = 30, max = 30},
        poair = {min = 160, max = 160},

        -- omens
        riftseekers = {min = 120, max = 120},

        -- DoN
        stillmoona = {min = 50, max = 50},
        thundercrest = {min = 70, max = 70},
        broodlands = {min = 140, max = 140},
    }

    local data = heights[zone_shortname()]
    local unknown = false
    if data == nil then
        data = {min = 20, max = 20}
        unknown = true
    end

    local currentMin = mq.TLO.Window("MVW_MapToolBar/MVW_MinZEditBox").Text()
    local currentMax = mq.TLO.Window("MVW_MapToolBar/MVW_MaxZEditBox").Text()

    log.Info("autoMapHeightFilter setting min %d, max %d (was min %s, max %s)", data.min, data.max, currentMin, currentMax)

    -- NOTE: this need recent macroquest, past july 25 2023 for the SetText
    mq.TLO.Window("MVW_MapToolBar/MVW_MinZEditBox").SetText(string.format("%d", data.min))
    mq.TLO.Window("MVW_MapToolBar/MVW_MinZEditBox").SetText(string.format("%d", data.min))

    -- if Height Filter button is not enabled, then enable it !
    if not unknown then
        if not mq.TLO.Window("MVW_MapToolBar/MVW_ZFilterButton").Checked() then
            log.Info("autoMapHeightFilter height filter was off, enabling now!")
            cmd("/notify MVW_MapToolBar MVW_ZFilterButton leftmouseup")
        end
    else
        if mq.TLO.Window("MVW_MapToolBar/MVW_ZFilterButton").Checked() then
            log.Info("autoMapHeightFilter height filter was on, disabling for unknown zone!")
            cmd("/notify MVW_MapToolBar MVW_ZFilterButton leftmouseup")
        end
    end

    return true
end

return {
    AutoMapHeightFilter = autoMapHeightFilter
}
