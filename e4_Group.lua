local mq = require("mq")

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
            print("no Saved Groups layouts for the server found, creating ", settingsFile, " with phony data, PLEASE EDIT THIS FILE !!!")
            cmd("/beep 1")

            local f = assert(io.open(settingsFile, "w"))
            f:write(savedGroupsTemplate)
            f:close()
        end
    end

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber)

        if Group.settings[name] == nil then
            print("/recallgroup Error: no such group ", name)
            cmd("/beep 1")
            return
        end

        local orchestrator = false
        local raidLeader = ""
        if groupNumber == nil then
            orchestrator = true
            cmd("/noparse /dgaexecute /if (${Raid.Members} > 0) /raiddisband")
            cmd("/noparse /dgaexecute /if (${Group.Members} > 0) /disband")
            delay(5000, function() return not in_raid() and not in_group() end)
            delay(2000)
        else
            print('Recalling group ', name, ' ', groupNumber)
        end

        for idx, group in pairs(Group.settings[name])
        do
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
                        print("Inviting ", groupMember)
                        cmd("/invite "..groupMember)
                    else
                        cmd("/dgtell all WARNING: "..groupMember.." not connected. Can not invite to group.")
                    end
                end
            elseif orchestrator and groupLeader ~= 'NULL' then
                print('Telling group leader ', groupLeader, ' to form group ', idx)
                cmd("/dexecute "..groupLeader.." /recallgroup "..name.." "..idx)
            end
        end

        if orchestrator then
            cmd("/dgtell all Recalling raid "..name.." with leader "..raidLeader)
            delay(2000)

            -- The raid leader invites the other groups to raid
            for idx, group in pairs(Group.settings[name]) do
                local groupLeader = group[1]
                if is_peer(groupLeader) then
                    if mq.TLO.Me.Name() == raidLeader and mq.TLO.Me.Name() ~= groupLeader then
                        cmd("/raidinvite "..groupLeader)
                    elseif raidLeader ~= groupLeader then
                        print('Telling raid leader ', raidLeader,' to invite', groupLeader)
                        cmd("/dexecute "..raidLeader.." /raidinvite "..groupLeader)
                    end
                    delay(50)
                else
                    cmd("/dgtell all WARNING: "..groupLeader.." not connected. will not invite to raid")
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
