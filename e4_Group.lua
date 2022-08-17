-- TODO later: register "/savegroup" command

local Group = {}

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Group.Init()

    mq.bind('/recallgroup', function(name, groupNumber)
        -- recalls group setup from INI, orchestrator (caller) will tell the rest how to form up

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

        for g = 1,12,1
        do
            group = server .. '_' .. name .. '_' .. g
            local groupLeader = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1', 'NULL')()
            if g == 1 then
                raidLeader = groupLeader
            end

            if mq.TLO.Me.Name() == groupLeader then
                for n = 2,6,1
                do
                    local member = "Member" .. n

                    local name = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, member, 'NULL')()
                    if name ~= 'NULL' then
                        if mq.TLO.DanNet(name)() ~= nil then
                            print("Inviting ", group, ' ', member, ' ', name)
                            mq.cmd.invite(name)
                        else
                            mq.cmd.dgtell("WARNING: ", name, " not connected. will not invite to group")
                        end
                    end
                end
            elseif orchestrator and groupLeader ~= 'NULL' then
                print('Telling group leader ', groupLeader, ' to form group ', group)
                mq.cmd.dexecute(groupLeader, '/recallgroup', name, g)
            end
        end

        if orchestrator then
            mq.cmd.dgtell('Recalling raid', name, 'with leader', raidLeader)
            mq.delay(2000)

            for g = 1,12,1
            do
                group = server .. '_' .. name .. '_' .. g
                local groupLeader = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1', 'NULL')()
    
                if groupLeader ~= 'NULL' then
                    if mq.TLO.Me.Name() == raidLeader then
                        mq.cmd.raidinvite(groupLeader)
                    elseif raidLeader ~= groupLeader then
                        --print('Telling raid leader ', raidLeader,' to invite', groupLeader)
                        mq.cmd.dexecute(raidLeader, '/raidinvite', groupLeader)
                    end
                    -- mq.delay(50)
                end
            end
        end
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        -- Accepts group invites my bots
        if mq.TLO.DanNet(sender) == nil then
            mq.cmd.dgtell('WARNING: IGNORING GROUP INVITE FROM NON-BOT ', sender)
            return
        end
        -- mq.cmd.dgtell('GROUP INVITE FROM ' .. sender)
        mq.cmd.squelch('/target clear')
        mq.delay(200)
        mq.cmd.squelch('/invite')
    end)

    mq.event('joinraid', '#1# invites you to join a raid.#*#', function(text, sender)
        -- Accepts raid invites from my bots
        if mq.TLO.DanNet(sender) == nil then
            mq.cmd.dgtell('WARNING: IGNORING RAID INVITE FROM NON-BOT ', sender)
            return
        end
        -- mq.cmd.dgtell('RAID INVITE FROM ' .. sender)
        mq.cmd.notify('ConfirmationDialogBox Yes_Button leftmouseup')
        mq.cmd.squelch('/raidaccept')
    end)

    print('DONE: Group.Init')
end

return Group
