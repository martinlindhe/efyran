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
            -- XXX create skeleton file ?
            print("no Saved Groups layouts for the server found, creating ", settingsFile, " with phony data, PLEASE EDIT THIS FILE !!!")
            mq.cmd.beep(1)

            local f = assert(io.open(settingsFile, "w"))
            f:write(savedGroupsTemplate)
            f:close()

        end
    end

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber)

        if Group.settings[name] == nil then
            print("/recallgroup Error: no such group ", name)
            mq.cmd.beep(1)
            return
        end

        local orchestrator = false
        local raidLeader = ""
        if groupNumber == nil then
            orchestrator = true
            mq.cmd.noparse('/dgaexecute /if (${Raid.Members} > 0) /raiddisband')
            mq.cmd.noparse('/dgaexecute /if (${Group.Members} > 0) /disband')
            mq.delay(5000, function() return not in_raid() and not in_group() end)
            mq.delay(2000)
        else
            print('Recalling group ', name, ' ', groupNumber)
        end

        -- print('group data for ', name, ' is ', Group.settings[name])

        for idx, group in pairs(Group.settings[name])
        do
            local groupLeader = group[1]
            if idx == 1 then
                raidLeader = groupLeader
            end

            --print(' -- processing group ',idx, ', leader:', groupLeader)

            if mq.TLO.Me.Name() == groupLeader then
                -- group leader invites the other group members
                for n = 2,6
                do
                    local groupMember = group[n]
                    if groupMember == nil then
                        break
                    end
                    if mq.TLO.DanNet(groupMember)() ~= nil then
                        print("Inviting ", groupMember)
                        mq.cmd.invite(groupMember)
                    else
                        mq.cmd.dgtell("WARNING:", groupMember, "not connected. will not invite to group")
                    end
                end
            elseif orchestrator and groupLeader ~= 'NULL' then
                print('Telling group leader ', groupLeader, ' to form group ', idx)
                mq.cmd.dexecute(groupLeader, '/recallgroup', name, idx)
            end
        end

        if orchestrator then
            mq.cmd.dgtell('Recalling raid', name, 'with leader', raidLeader)
            mq.delay(2000)

            -- raid leader invites the other groups to raid
            for idx, group in pairs(Group.settings[name])
            do
                local groupLeader = group[1]
                if mq.TLO.DanNet(groupLeader)() ~= nil then
                    if mq.TLO.Me.Name() == raidLeader and mq.TLO.Me.Name() ~= groupLeader then
                        mq.cmd.raidinvite(groupLeader)
                    elseif raidLeader ~= groupLeader then
                        print('Telling raid leader ', raidLeader,' to invite', groupLeader)
                        mq.cmd.dexecute(raidLeader, '/raidinvite', groupLeader)
                    end
                    mq.delay(50)
                else
                    mq.cmd.dgtell("WARNING:", groupLeader, "not connected. will not invite to raid")
                end
            end
        end
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        if mq.TLO.DanNet(sender)() ~= nil then
            -- mq.cmd.dgtell('GROUP INVITE FROM ' .. sender)
            wait_until_not_casting()
            mq.cmd.squelch('/target clear')
            mq.delay(100)
            mq.cmd.squelch('/invite')
        end
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        if mq.TLO.DanNet(sender)() ~= nil then
            -- mq.cmd.dgtell('RAID INVITE FROM ' .. sender)
            wait_until_not_casting()
            mq.cmd.notify('ConfirmationDialogBox Yes_Button leftmouseup')
            mq.cmd.squelch('/raidaccept')
        end
    end)

    --print('DONE: Group.Init')
end

return Group
