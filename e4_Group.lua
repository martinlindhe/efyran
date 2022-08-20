local file = require('e4_File')

local Group = { settings = nil }

-- TODO: add /savegroup command to fill this data automatically. then we dont need to error if file not found
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
        local settingsFile = settingsRoot .. '/' .. mq.TLO.MacroQuest.Server() .. '__Saved Groups.lua'

        local settings = loadfile(settingsFile)
        if settings ~= nil then
            Group.settings = settings
        else
            -- XXX create skeleton file ?
            print("no Saved Groups layouts for the server found, creating ", settingsFile, " with phony data, PLEASE EDIT THIS FILE !!!")
            mq.cmd.beep(1)

            local f = assert(io.open(settingsFile, "w"))
            local t = f:write(savedGroupsTemplate)
            f:close()

        end
    end

    -- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
    mq.bind('/recallgroup', function(name, groupNumber)

        local orchestrator = false
        local raidLeader = ""
        if groupNumber == nil then
            orchestrator = true

            mq.cmd.noparse('/dgaexecute /if (${Raid.Members} > 0) /raiddisband')
            mq.cmd.noparse('/dgaexecute /if (${Group.Members} > 0) /disband')
            mq.delay(1000)
        else
            print('Recalling group ', name, ' ', groupNumber)
        end

        local server = mq.TLO.MacroQuest.Server()

        print('group data for ',name, ' is ', Group.settings[name])

        for idx, group in pairs(Group.settings[name])
        do
            local groupLeader = group[1]
            if idx == 1 then
                raidLeader = groupLeader
            end

            print(' -- processing group ',idx, ', leader:', groupLeader)

            if mq.TLO.Me.Name() == groupLeader then
                for n = 2,6,1
                do
                    local name = group[n]
                    if mq.TLO.DanNet(name)() ~= nil then
                        print("Inviting ", name)
                        mq.cmd.invite(name)
                    else
                        mq.cmd.dgtell("WARNING:", name, "not connected. will not invite to group")
                    end
                end
            elseif orchestrator and groupLeader ~= 'NULL' then
                print('Telling group leader ', groupLeader, ' to form group ', group)
                mq.cmd.dexecute(groupLeader, '/recallgroup', name, idx)
            end
        end

        if orchestrator then
            mq.cmd.dgtell('Recalling raid', name, 'with leader', raidLeader)
            mq.delay(2000)

            for idx, group in pairs(Group.settings[name])
            do
                local groupLeader = group[1]
                if mq.TLO.DanNet(groupLeader)() ~= nil then
                    if mq.TLO.Me.Name() == raidLeader then
                        mq.cmd.raidinvite(groupLeader)
                    elseif raidLeader ~= groupLeader then
                        --print('Telling raid leader ', raidLeader,' to invite', groupLeader)
                        mq.cmd.dexecute(raidLeader, '/raidinvite', groupLeader)
                    end
                    -- mq.delay(50)
                else
                    mq.cmd.dgtell("WARNING:", groupLeader, "not connected. will not invite to raid")
                end
            end
        end
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        if mq.TLO.DanNet(sender)() ~= nil then
            -- mq.cmd.dgtell('GROUP INVITE FROM ' .. sender)
            mq.cmd.squelch('/target clear')
            mq.delay(100)
            mq.cmd.squelch('/invite')
        end
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        if mq.TLO.DanNet(sender)() ~= nil then
            -- mq.cmd.dgtell('RAID INVITE FROM ' .. sender)
            mq.cmd.notify('ConfirmationDialogBox Yes_Button leftmouseup')
            mq.cmd.squelch('/raidaccept')
        end
    end)

    --print('DONE: Group.Init')
end

return Group
