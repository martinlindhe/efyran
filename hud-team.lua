-- self-contained script that draws an imgui window and shows "HP / MANA / currently casting spell / target Name" for team
-- use MQ2DanNet to query data
-- primary used on main toon for debugging purposes.

local mq = require("mq")
local log = require("knightlinc/Write")

require("ezmq")

-- needed at least once to get mqoverlay showing
cmd("/mqoverlay resume")

-- GUI Control variables
local openGUI = true
local shouldDrawGUI = true

local hudTeamData = {}

mq.imgui.init("ui-team", function()
    if openGUI then
        openGUI, shouldDrawGUI = ImGui.Begin("Team", openGUI)

        ImGui.Columns(5)
        ImGui.Text("Name")
        ImGui.NextColumn()
        ImGui.Text("Casting")
        ImGui.NextColumn()
        ImGui.Text("Target")
        ImGui.NextColumn()
        ImGui.Text("Count")
        ImGui.NextColumn()

        ImGui.Text(string.format("%s (local)", mq.TLO.Time.Time24()))
        --ImGui.ProgressBar(mq.TLO.Time.MilliSecond() / 1000) -- 1 = 100%
        ImGui.NextColumn()

        if shouldDrawGUI then
            for k, v in pairs(hudTeamData) do
                ImGui.Text(k)
                ImGui.NextColumn()

                ImGui.Text(v.Casting)
                ImGui.NextColumn()

                ImGui.Text(v.Target)
                ImGui.NextColumn()

                ImGui.Text(v.Polls)
                ImGui.NextColumn()

                ImGui.Text(v.Time)
                --ImGui.ProgressBar(tonumber(v.Time) / 1000) -- 1 = 100%
                ImGui.NextColumn()
            end
        end
        ImGui.End()
        --mq.delay(1)
    end
end)


-- XXX 1. register watchers on all toons for their HP, MANA, casting spell & target


--local timeQuery = 'Time.MilliSecond' -- XXX needs PR https://github.com/macroquest/macroquest/pull/640
local timeQuery = 'Time.Time24'
local castingQuery = 'Me.Casting.ID'
local targetQuery = 'Target.ID'

-- XXX this dont work correctly, see https://github.com/dannuic/MQ2Dan/issues/57
--for i = 2, mq.TLO.DanNet.PeerCount() do
--    local peer = mq.TLO.DanNet.Peers(i)()


local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. " radius 50"

while true do
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        local peer = spawn.Name()
        if peer ~= nil and mq.TLO.DanNet(peer)() ~= nil then
            if hudTeamData[peer] == nil then
                -- register initial observers
                observe_peer(peer, timeQuery, 1000)
                observe_peer(peer, castingQuery, 1000)
                observe_peer(peer, targetQuery, 1000)
                hudTeamData[peer] = {}
                hudTeamData[peer].Polls = 0
            end

            hudTeamData[peer].Time = mq.TLO.DanNet(peer).O(timeQuery)()

            local spellID = mq.TLO.DanNet(peer).O(castingQuery)()
            local spellName = ""
            if spellID ~= "NULL" then
                local spell = get_spell_from_id(spellID)
                if spell ~= nil then
                    spellName = spell.Name()
                end
            end
            hudTeamData[peer].Casting = spellName

            local targetID = mq.TLO.DanNet(peer).O(targetQuery)()
            local targetName = ""
            if targetID ~= "" then
                local target = spawn_from_id(targetID)
                if target ~= nil then
                    targetName = target.Name()
                end
            end
            hudTeamData[peer].Target = targetName
            hudTeamData[peer].Polls = hudTeamData[peer].Polls + 1
        end
    end

    delay(1) -- XXX what is reasonable delay ?
--    doevents()
end
