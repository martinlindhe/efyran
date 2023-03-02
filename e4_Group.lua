local mq = require("mq")
local log = require("efyran/knightlinc/Write")

local Group = { settings = nil }

-- FIXME: add /savegroup command to fill this data automatically
local savedGroupsTemplate = [[
local groups = {
    -- load this group with "/recall team6"
    team6 = {
        {"One", "Two", "Three", "Four", "Five", "Six"},
    },
    team12 = {
        {"One", "Two", "Three", "Four", "Five", "Six"},
        {"Second", "Group", "Toons", "Here", "They", "Are"},
    },
}

return groups
]]

local mq = require("mq")

function Group.Init()

    if Group.settings == nil then
        local settingsFile = getEfyranRoot() .. '/settings/' .. current_server() .. '__Saved Groups.lua'

        local settings = loadfile(settingsFile)
        if settings ~= nil then
            Group.settings = settings()
        else
            log.Error("No Saved Groups layouts for the server found, creating %s with phony data, PLEASE EDIT THIS FILE !!!", settingsFile)
            cmd("/beep 1")

            local f = assert(io.open(settingsFile, "w"))
            f:write(savedGroupsTemplate)
            f:close()
        end
    end

end

---@param name string
---@param groupNumber string|nil
function Group.RecallGroup(name, groupNumber)

    if Group.settings[name] == nil then
        log.Error("/recallgroup: no such group %s", name)
        cmd("/beep 1")
        return
    end

    local orchestrator = false
    local raidLeader = ""
    if groupNumber == nil then
        orchestrator = true -- the instance doing /recallgroup
        cmd("/noparse /dgaexecute /if (${Raid.Members} > 0) /raiddisband")
        delay(1000)
        cmd("/noparse /dgaexecute /if (${Group.Members} > 0) /disband")
        delay(1000)
    else
        log.Info("Recalling group %s %d", name, groupNumber)
    end

    for idx, group in ipairs(Group.settings[name]) do
        local groupLeader = group[1]
        if idx == 1 then
            raidLeader = groupLeader
        end

        -- The group leader invites the other group members
        if mq.TLO.Me.Name() == groupLeader then
            for n = 2, 6 do
                local groupMember = group[n]
                if groupMember == nil then
                    break
                end
                if is_peer(groupMember) then
                    log.Info("Inviting %s to group", groupMember)
                    cmdf("/invite %s", groupMember)
                else
                    all_tellf("ERROR: %s not connected. Can not invite to group.", groupMember)
                end
            end
        elseif orchestrator and groupLeader ~= 'NULL' then
            log.Info("Telling group leader %s to form group %d", groupLeader, idx)
            cmdf("/dexecute %s /recallgroup %s %d", groupLeader, name, idx)
        end
    end

    if orchestrator then
        all_tellf("Recalling raid %s with leader %s", name, raidLeader)
--            delay(2000)

        -- The raid leader invites the other groups to raid
        for idx, group in pairs(Group.settings[name]) do
            local groupLeader = group[1]
            if is_peer(groupLeader) then
                if mq.TLO.Me.Name() == raidLeader and mq.TLO.Me.Name() ~= groupLeader then
                    log.Info("Inviting group leader %s to raid", groupLeader)
                    cmdf("/raidinvite %s", groupLeader)
                elseif raidLeader ~= groupLeader then
                    log.Info("Telling raid leader %s to invite group leader %s to raid", raidLeader, groupLeader)
                    cmdf("/dexecute %s /raidinvite %s", raidLeader, groupLeader)
                end
                delay(50)
            else
                all_tellf("WARNING: %s not connected. will not invite to raid", groupLeader)
            end
        end
    end
end

return Group
