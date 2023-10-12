local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

local function execute()
    wait_until_not_casting()
    local name = ""

    -- group heals:
    -- L30 Word of Health                          (380-485 hp, cost 302 mana)
    -- L57 Word of Restoration                     (1788-1818 hp, cost 898 mana)
    -- L60 Word of Redemption                      (7500 hp, cost 1100 mana)
    -- L64 Word of Replenishment                   (2500 hp, -14 dr, -14 pr, -7 curse, cost 1100 mana)
    -- L69 Word of Vivification                    (3417-3427 hp, -21 dr, -21 pr, -14 curse, cost 1357 mana)

    -- L80 Word of Vivacity                        (4250 hp, -21 dr, -21 pr, -14 curse, cost 1540 mana)
    -- L80 Word of Vivacity Rk. II                 (4610 hp, -21 dr, -21 pr, -14 curse, cost 1610 mana)
    -- L80 Word of Vivacity Rk. III                (4851 hp, -21 dr, -21 pr, -14 curse, cost 1654 mana)
    -- L85 Word of Recovery                        (4886 hp, -21 dr, -21 pr, -14 curse, cost 1663 mana)
    -- L85 Word of Recovery Rk. II                 (5302 hp, -21 dr, -21 pr, -14 curse, cost 1738 mana)
    -- L85 Word of Recovery Rk. III                (5578 hp, -21 dr, -21 pr, -14 curse, cost 1786 mana)
    -- L90 Word of Resurgence                      (6670 hp, -27 dr, -27 pr, -18 curse, cost 1974 mana)
    -- L90 Word of Resurgence Rk. II               (7238 hp, -27 dr, -27 pr, -18 curse, cost 2063 mana)
    -- L90 Word of Resurgence Rk. III              (7614 hp, -29 dr, -29 pr, -20 curse, cost 2120 mana)
    -- L95 Word of Rehabilitation                  (9137 hp, -32 dr, -32 pr, -23 curse, cost 2253 mana)
    -- L95 Word of Rehabilitation Rk. II           (9594 hp, -32 dr, -32 pr, -23 curse, cost 2343 mana)
    -- L95 Word of Rehabilitation Rk. III         (10074 hp, -32 dr, -32 pr, -23 curse, cost 2437 mana)

    -- L100 Word of Reformation
    -- L105 Word of Greater Reformation
    -- L110 Word of Greater Restoration
    -- L115 Word of Greater Replenishment
    -- L120 Word of Greater Rejuvenation

    if is_memorized("Word of Health") then
        name = "Word of Health"
    end
    if is_memorized("Word of Restoration") then
        name = "Word of Restoration"
    end
    if is_memorized("Word of Redemption") then
        name = "Word of Redemption"
    end
    if is_memorized("Word of Replenishment") then
        name = "Word of Replenishment"
    end
    if is_memorized("Word of Vivification") then
        name = "Word of Vivification"
    end
    if is_memorized("Word of Vivacity") then
        name = "Word of Vivacity"
    end
    if is_memorized("Word of Recovery") then
        name = "Word of Recovery"
    end
    if is_memorized("Word of Resurgence") then
        name = "Word of Resurgence"
    end
    if is_memorized("Word of Rehabilitation") then
        name = "Word of Rehabilitation"
    end
    if is_memorized("Word of Reformation") then
        name = "Word of Reformation"
    end
    if is_memorized("Word of Greater Reformation") then
        name = "Word of Greater Reformation"
    end
    if is_memorized("Word of Greater Restoration") then
        name = "Word of Greater Restoration"
    end
    if is_memorized("Word of Greater Replenishment") then
        name = "Word of Greater Replenishment"
    end
    if is_memorized("Word of Greater Rejuvenation") then
        name = "Word of Greater Rejuvenation"
    end
    if name == "" then
        all_tellf("\arERROR: no word heal memorized!")
        return
    end
    log.Info("Word heal using \ay%s\ax", name)
    castSpellAbility(nil, name)
    delay(1000) -- 1s
end

-- tell clerics to use word heals
local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/wordheal")
    end
    if not is_clr() then
        return
    end

    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/wordheal", createCommand)
