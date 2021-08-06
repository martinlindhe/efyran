-- TODO later: auto reform raid
-- TODO later: register "/savegroup" command

local AutoGroup = {}

local onlyAllowNetbots = true

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function AutoGroup.Init()
    mq.bind('/recallgroup', function(arg)
        -- recalls group setup from INI
        print("recallgroup ", arg)

        mq.cmd.squelch('/bca //raiddisband')
        mq.cmd.squelch('/bca //disband')
        mq.delay(2000)

        -- XXX get server shortname
        -- FIXME LATER: support multiple group setup like in e3
        local group = 'antonius_' .. arg .. '_1'

        local leader = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, 'Member1')

        if mq.TLO.Me.Name ~= leader then
            print("SKIPPING GROUP RECALL AS I AM NOT LEADER FOR ",group)
            return
        end

        for i = 2,6,1
        do
            local member = "Member" .. i
            local name = mq.TLO.Ini(settingsRoot .. '/Saved Groups.ini', group, member)
            if mq.TLO.NetBots(name).ID() ~= 'NULL' then
                print("INVITING ", group, ' . ', member, ' . ', name, ' ', mq.TLO.NetBots(name).ID)
                mq.cmd.invite(name)
            else
                mq.cmd.bc("WARNING: ", name, " not in NetBots. will not invite to group")
            end
        end

    end)


    -- Automatically accepts group invites
    mq.event('joingroup', '#1# invites you to join a group.', function(text, sender)

        -- only allow invites from my netbots
        if onlyAllowNetbots and mq.TLO.NetBots(sender).ID() == 'NULL' then
            mq.cmd.bc('IGNORING GROUP INVITE FROM NON-NETBOT ', sender)
            return
        end

        mq.cmd.bc('GROUP INVITE FROM ' .. sender)

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



    print('DONE: AutoGroup.Init')
end


return AutoGroup


