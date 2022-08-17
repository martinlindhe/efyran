
local Buffs = {}

function Buffs.RefreshBuffs()
    --print('-- RefreshBuffs ', mq.TLO.Me.Class.ShortName, ' ', mq.TLO.Time)

    for k, buffItem in pairs(botSettings.settings.buffs) do
        local spell
        if mq.TLO.FindItem(buffItem).ID() ~= nil then
            spell = mq.TLO.FindItem(buffItem).Clicky.Spell
            --print('using clicky ', buffItem, ', spell: ', spell)
        elseif mq.TLO.Me.Book(buffItem)() ~= nil then
            spell = mq.TLO.Me.Book(mq.TLO.Me.Book(buffItem))
            --print('using book ', buffItem, ', spell: ', spell)
        elseif mq.TLO.Me.AltAbility(buffItem)() ~= nil then
            spell = mq.TLO.Me.AltAbility(buffItem).Spell
            --print('using aa ', buffItem, ', spell: ', spell)
        else
            mq.cmd.dgtell('ERROR cant find buff ', buffItem)
            mq.cmd.beep(1)
        end

        -- print("considering buffing ", spell)

        -- refresh missing buffs or ones fading within 4 ticks
        if mq.TLO.Me.Buff(spell.Name()).ID() == nil or mq.TLO.Me.Buff(spell.Name()).Duration.Ticks() <= 4 then
            print('Refreshing buff ', spell.Name())

            if spell.TargetType() == "Self" then
                mq.cmd.casting('"' .. buffItem .. '"')
            else
                mq.cmd.casting('"' .. buffItem .. '" -targetid|'.. mq.TLO.Me.ID())
            end

            -- end loop after first successful buff
            break
        end
    end

end

return Buffs

