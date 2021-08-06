-- TODO later: auto reform raid
-- TODO later: register "/savegroup" command

local Group = {}

local onlyAllowBots = true

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Group.Init()

    mq.bind('/recallgroup', function(name)
        -- recalls group setup from INI

        -- XXX make sure sender is netbot
        print("recallgroup ", name)

        -- XXX get server shortname
        local server = 'antonius'

        local group = server .. '_' .. name .. '_1'
        local topLeader = tostring(mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1', 'NULL'))
        if mq.TLO.Me.Name() == topLeader then
            -- XXX separate command /dropgroup:
            mq.cmd.noparse('/dgaexecute /if (${Raid.Members} > 0) /raiddisband')
            mq.cmd.noparse('/dgaexecute /if (${Group.Members} > 0) /disband')
            mq.delay(2000)
        end

        for g = 1,12,1
        do
            group = server .. '_' .. name .. '_' .. g
            local leader = tostring(mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1', 'NULL'))

            if mq.TLO.Me.Name() == leader then
                for n = 2,6,1
                do
                    local member = "Member" .. n

                    -- FIXME tostring() needed because Ini() returns type 'userdata' //aug 2021
                    local name = tostring(mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, member, 'NULL'))
                    if name ~= 'NULL' then
                        if mq.TLO.DanNet(name) ~= nil then
                            print("Inviting ", group, ' ', member, ' ', name)
                            mq.cmd.invite(name)
                        else
                            mq.cmd.dgtell("WARNING: ", name, " not connected. will not invite to group")
                        end
                    end
                end
            elseif mq.TLO.Me.Name() == topLeader and leader ~= 'NULL' then
                print('TELLLING LEADER ', leader, ' TO FORM GROUP ', group)
                mq.cmd.dexecute(leader, '/recallgroup ' .. name)
            end
        end

    end)


    -- Automatically accepts group invites
    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)

        -- only allow invites from my bots
        if onlyAllowBots and mq.TLO.DanNet(sender) == nil then
            mq.cmd.dgtell('WARNING: IGNORING GROUP INVITE FROM NON-BOT ', sender)
            return
        end

        mq.cmd.dgtell('GROUP INVITE FROM ' .. sender)

        --[[
        /if (${Me.Casting.ID} && ${Me.Class.ShortName.NotEqual[BRD]}) {
            /call interrupt
            /delay 5s !${Me.Casting.ID}
          }
        ]]--

        mq.cmd.squelch('/target clear')
        mq.delay(500)
        mq.cmd.squelch('/invite')

        --[[
          /declare retryTimer timer local 5s
          :retry_Invite
          /squelch /target clear
          /delay 3
          /invite
          /delay 1s ${Bool[${Group}]}
          /if (!${Bool[${Group}]}) {
            /if (${retryTimer}) {
              /goto :retry_Invite
            } else {
              /echo Failed to join the group.
            }
          }
        ]]--

    end)



    print('DONE: Group.Init')
end

return Group
