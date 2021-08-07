-- TODO later: auto reform raid
-- TODO later: register "/savegroup" command

local Group = {}

local onlyAllowBots = true

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Group.Init()

    mq.bind('/recallgroup', function(name, groupNumber)
        -- recalls group setup from INI, leader from group 1 will tell other leaders to form up

        print("recallgroup ", name, " ", groupNumber)

        if groupNumber == nil then
            -- XXX separate command /dropgroup:
            mq.cmd.noparse('/dgaexecute /if (${Raid.Members} > 0) /raiddisband')
            mq.cmd.noparse('/dgaexecute /if (${Group.Members} > 0) /disband')
            mq.delay(2000)
        end

        local server = mq.TLO.MacroQuest.Server()

        for g = 1,12,1
        do
            group = server .. '_' .. name .. '_' .. g
            local leader = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1', 'NULL')()

            if mq.TLO.Me.Name() == leader then
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
            elseif groupNumber == nil and leader ~= 'NULL' then
                print('TELLLING LEADER ', leader, ' TO FORM GROUP ', group)
                mq.cmd.dexecute(leader, '/recallgroup', name, g)
            end
        end
    end)

    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)
        -- Accepts group invites

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
