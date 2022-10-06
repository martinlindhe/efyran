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

-- XXX move to ezmq
function get_spell_from_id(id)
    local spell = mq.TLO.Spell(id)
    if spell() == nil then
        return nil
    end
    return spell
end


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

        --ImGui.Text(string.format("%d (local)", mq.TLO.Time.MilliSecond()))
        ImGui.ProgressBar(mq.TLO.Time.MilliSecond() / 1000) -- 1 = 100%
        ImGui.NextColumn()

        if shouldDrawGUI then
            for k, v in pairs(hudTeamData) do
                ImGui.Text(k)
                ImGui.NextColumn()

                ImGui.Text(v["Casting"])
                ImGui.NextColumn()

                ImGui.Text(v["Target"])
                ImGui.NextColumn()

                ImGui.Text(v["Polls"])
                ImGui.NextColumn()

                --ImGui.Text(v["Time"])
                ImGui.ProgressBar(tonumber(v["Time"]) / 1000) -- 1 = 100%
                ImGui.NextColumn()
            end
        end
        ImGui.End()
        --mq.delay(1)
    end
end)


-- XXX 1. register watchers on all toons for their HP, MANA, casting spell & target


local timeQuery = 'Time.MilliSecond' -- XXX any way to get higher precision from a TLO? (can only query TLO members with MQ2DanNet)
--local timeQuery = 'Time.Raw'
local castingQuery = 'Me.Casting.ID'
local targetQuery = 'Target.ID'

-- XXX this dont work correctly, see https://github.com/dannuic/MQ2Dan/issues/57
--for i = 2, mq.TLO.DanNet.PeerCount() do
--    local peer = mq.TLO.DanNet.Peers(i)()


-- if my banker is not ready, check all nearby peers if one is ready and use it.
local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. " radius 50"


while true do
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        local peer = spawn.Name()
        if peer ~= nil and mq.TLO.DanNet(peer)() ~= nil then
            if hudTeamData[peer] == nil then
                -- register initial observers
                observe_peer(peer, timeQuery)
                observe_peer(peer, castingQuery)
                observe_peer(peer, targetQuery)
                hudTeamData[peer] = {}
                hudTeamData[peer]["Polls"] = 0
            end

            hudTeamData[peer]["Time"] = mq.TLO.DanNet(peer).O(timeQuery)()

            local spell = get_spell_from_id(mq.TLO.DanNet(peer).O(castingQuery)())
            local spellName = ""
            if spell ~= nil then
                spellName = get_spell_from_id(spell).Name()
            end
            hudTeamData[peer]["Casting"] = spellName

            local target = spawn_from_id(mq.TLO.DanNet(peer).O(targetQuery)())
            local targetName = ""
            if target ~= nil then
                targetName = target.Name()
            end
            hudTeamData[peer]["Target"] = targetName
            hudTeamData[peer]["Polls"] = hudTeamData[peer]["Polls"] + 1
        end
        delay(1) -- XXX what is reasonable delay ?
    end

end
