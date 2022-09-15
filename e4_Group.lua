local mq = require("mq")
local log = require("knightlinc/Write")

local Group = { settings = nil }

-- FIXME: add /savegroup command to fill this data automatically. then we dont need to error if file not found
local savedGroupsTemplate = [[
local groups = { }
groups.team12 = {
    {"One", "Two", "Three", "Four", "Five", "Six"},
    {"Second", "Group", "Toons", "Here", "They", "Are"},
}
return groups
]]

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Group.Init()

    if Group.settings == nil then
        local settingsFile = settingsRoot .. '/' .. current_server() .. '__Saved Groups.lua'

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

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber)

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
            cmd("/noparse /dgaexecute /if (${Group.Members} > 0) /disband")
            delay(5000, function() return not in_raid() and not in_group() end)
            delay(2000)
        else
            log.Info("Recalling group %s %d", name, groupNumber)
        end

        for idx, group in pairs(Group.settings[name]) do
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
                        cmdf("/dgtell all ERROR: %s not connected. Can not invite to group.", groupMember)
                    end
                end
            elseif orchestrator and groupLeader ~= 'NULL' then
                log.Info("Telling group leader %s to form group %d", groupLeader, idx)
                cmdf("/dexecute %s /recallgroup %s %d", groupLeader, name, idx)
            end
        end

        if orchestrator then
            cmdf("/dgtell all Recalling raid %s with leader %s", name, raidLeader)
--            delay(2000)

            -- The raid leader invites the other groups to raid
            for idx, group in pairs(Group.settings[name]) do
                local groupLeader = group[1]
                if is_peer(groupLeader) then
                    if mq.TLO.Me.Name() == raidLeader and mq.TLO.Me.Name() ~= groupLeader then
                        log.Info("Inviting group leader %s to raid", raidLeader, groupLeader)
                        cmdf("/raidinvite %s", groupLeader)
                    elseif raidLeader ~= groupLeader then
                        log.Info("Telling raid leader %s to invite group leader %s to raid", raidLeader, groupLeader)
                        cmdf("/dexecute %s /raidinvite %s", raidLeader, groupLeader)
                    end
                    delay(50)
                else
                    cmdf("/dgtell all WARNING: %s not connected. will not invite to raid", groupLeader)
                end
            end
        end
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        if is_peer(sender) then
            wait_until_not_casting()
            cmd("/squelch /target clear")
            delay(100)
            cmd("/squelch /invite")
        end
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        if is_peer(sender) then
            wait_until_not_casting()
            cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
            cmd("/squelch /raidaccept")
        end
    end)

end

return Group
