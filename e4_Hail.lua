local mq = require("mq")
local log = require("efyran/knightlinc/Write")

local Hail = {}

local hailTargets = {
    ["poknowledge"] = {
        ["Soulbinder Jera"] = "bind my soul", -- soulbinder
        ["Grand Librarian Maelin"] = "information", -- elemental flag
        ["Herald of Druzzil Ro"] = "time", -- TL to Plane of Time
        ["Priest of Discord"] = "wish to go", -- OOW - TL to Dranik's Scar
        ["Devin Traical"] = "ready", -- TL to Shadowrest
        ["Vivian the True"] = true, -- New Beginnings starter quest
    },
    ["shadowrest"] = {
        ["Keeper of Lost Things"] = "bodies", -- summon corpses
    },

    ["oot"] = { -- Ocean of Tears
        ["Translocator Narrik"] = "travel to butcherblock", -- TL to Butcherblock
    },
    ["erudnext"] = { -- Erudin
        ["Translocator Eniela"] = "travel to erud's crossing", -- TL to Erud's Crossing
    },
    ["nro"] = { -- North Ro
        ["Translocator Ionie"] = "travel to iceclad ocean", -- TL to Iceclad Ocean
    },
    ["iceclad"] = { -- Iceclad Ocean
        ["Translocator Kurione"] = "travel to north ro", -- TL to North Ro
    },
    ["oasis"] = { -- Oasis of Marr
        ["Translocator Tradil"] = "travel to timorous deep", -- TL to Timorous Deep
    },
    ["qey2hh1"] = { -- West Karana
        ["Melaara Tenwinds"] = "interesting ore", -- LDoN flag to get Adventurer's Stone (1/2)
    },

    ["potranquility"] = {
        ["Adler Fuirstel"] = "ward", -- Grummus pre-flag - outside Plane of Disease
        ["Elder Fuirstel"] = true, -- Grummus & Bert post-flag - in sickbay, hail only
        ["Adroha Jezith"] = "tortured by nightmares", -- Hedge Maze pre-flag - in sickbay
        ["Fahlia Shadyglade"] = "i will go", -- Saryrn pre-flag - in sickbay
        ["Elder Poxbourne"] = true, -- Terris Thule post-flag - in sickbay, hail only
    },
    ["pojustice"] = {
        ["Agent of The Tribunal"] = "return", -- return from pojustice trial
    },
    ["poinnovation"] = {
        ["Giwin Mirakon"] = "i will test the machine", -- MB pre-flag
        ["Chronographer Muon"] = "yes", -- final potime flag #1
        ["Loreseeker Maelin"] = "researched", -- final potime flag #2
    },
    ["podisease"] = {
        ["a planar projection"] = true, -- Grummus flag, hail only
    },
    ["povalor"] = {
        ["a planar projection"] = true, -- AD flag, hail only
    },
    ["ponightmare"] = {
        ["Thelin Poxbourne"] = "ready", -- enter Hedge Maze - ONLY MOVE THOSE TO FLAG NEAR FOR HAIL, OR MESS UP EVENT BECAUSE ONLY FIRST 18 WILL BE PORTED
    },
    ["nightmareb"] = {
        ["a planar projection"] = true, -- Terris flag, hail only
    },
    ["codecay"] = {
        ["Tarkil Adan"] = true, -- Carprin cycle flag, hail only
        ["a planar projection"] = true, -- Bertoxxulous flag, hail only
    },
    ["bothunder"] = {
        ["Askr the Lost"] = true, -- Agnarr script, hail only
        ["Karana"] = "follow the path of the Fallen", -- Agnarr script
        ["a planar projection"] = true, -- Agnarr flag, hail only
    },
    ["hohonora"] = {
        ["a planar projection"] = true, -- hoh mini flag, hail only   - XXX other names for trial flags?
    },
    ["hohonorb"] = {
        ["a planar projection"] = true, -- LMM flag, hail only
    },
    ["potactics"] = {
        ["a planar projection"] = true, -- RZTW flag, hail only
    },
    ["potorment"] = {
        ["a planar projection"] = true, -- Saryrn flag, hail only
    },
    ["solrotower"] = {
        ["a planar projection"] = true, -- SolRo minis flag, hail only
    },
    ["poeartha"] = {
        ["a planar projection"] = true, -- Mini flag, hail only
    },
    ["pofire"] = {
        ["Essence of Fire"] = true, -- EP god fire
    },
    ["poair"] = {
        ["Essence of Air"] = true, -- EP god air
    },
    ["powater"] = {
        ["Essence of Water"] = true, -- EP god water
    },
    ["poearthb"] = {
        ["Essence of Earth"] = true, -- EP god earth
    },

    ["crescent"] = { -- Crescent Reach
        ["Vladnelg Galvern"] = "interesting ore", -- LDoN flag to get Adventurer's Stone (1/2)
        ["Priestess Aelea"] = "bind", -- soulbinder
    },
    ["sro"] = {
        ["Selephra Giztral"] = "farstone", -- LDoN flag to get Adventurer's Stone (2/2)
    },
    ["butcher"] = {
        ["Vual Stoutest"] = "farstone", -- LDoN flag to get Adventurer's Stone (2/2)
        ["Translocator Fithop"] = "travel to ocean of tears", -- TL to Ocean of Tears, in docks
        ["Translocator Gethia"] = "travel to timorous deep", -- TL to Timorous Deep, in docks
    },

    ["guildlobby"] = {
        ["Magus Alaria"] = "nedaria", -- TL to Nedaria's Landing
    },
    ["nedaria"] = {
        ["Magus Wenla"] = "natimbi", -- TL to Natimbi (or Abysmal Sea)
    },
    ["natimbi"] = {
        ["Magus Releua"] = "abysmal sea", -- TL to Abysmal Sea (or Nedaria's Landing)
        ["Madronoa"] = "wish to travel", -- TL to Qvic
    },
    ["abysmal"] = {
        ["Magus Pellen"] = "natimbi", -- TL to Natimbi (or Nedaria's Landing)
    },
    ["ferubi"] = {
        ["Smith`s Spectral Memory"] = true, -- smith rondo flag, hail only
    },
    ["kodtaz"] = {
        ["Tublik Narwethar"] = true, -- TODO show info only:
        --[[
        /echo Tublik Narwethar - ikkinz 1-3 instances
        /echo ikkinz 1 raid: [sanctuary of the righteous]
        /echo ikkinz 2 raid: [sanctuary of the glorified]
        /echo ikkinz 3 raid: [sanctuary of the transcendent]
        ]]--
    },
    ["uqua"] = {
        ["Specter of Barxt"] = true, -- uqua flag, hail only
    },
    ["inktuta"] = {
        ["An Ancient Sentinel"] = true, -- txevu flag, hail only
    },

    ["draniksscar"] = {
        ["Elder Priest of Discord"] = "go home", -- TL to PoK
    },
    ["riftseekers"] = {
        ["Taromani"] = "favors", -- CoA signets container. XXX filter: dont say if we have CoA key.
    },

    ["qrg"] = {
        ["Buff Bot"] = true, -- EZ, hail only
    },

    ["lavastorm"] = {
        ["Wayfarers Mercenary Bitral"] = "task|Population Control", -- DoN tier 0 faction solo task
        ["Chieftain Relae Aderi"] = true, -- DoN tier 0, tier 1, tier 2, tier 3 flag

        ["Private Nylaen Kel`Ther"] = true, -- DoN tier 2 flag hail

        ["Gordish Frozenheart"] = "see those", -- DoN 24-man raids Rampaging Monolith, Circle of Drakes 
    }
}

function Hail.PerformHail()
    local npcName = ""
    local text = ""

    log.Debug("PerformHail start ...")
    unflood_delay()
    drop_invis()

    local zoneTargets = hailTargets[zone_shortname():lower()]
    if zoneTargets == nil then
        log.Error("Didn't see anyone that I recognize in zone ", zone_shortname())
        return
    end


    local found = false
    local name = ""

    -- loop thru nearby NPC and see if they are in the zoneTargets...
    local spawnQuery = "npc radius 25"
    for i = 1, mq.TLO.SpawnCount(spawnQuery)() do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        local spawnName = spawn.CleanName()
        if zoneTargets[spawnName] ~= nil then
            found = true
            name = spawnName
            break
        end
    end

    if not found then
        all_tellf("PerformHail:: Found no recognized NPC nearby")
    end

    target_npc_name(name)
    local spawn = spawn_from_query("npc "..name)
    if spawn == nil or spawn() == nil then
        all_tellf("HAILIT UNLIKLEY: error looking up spawn %s", name)
        return
    end

    local zone = zone_shortname()

    local max = 3
    for i = 1, max do

        local done = false

        log.Info("Attempting to hail %s ... (%d/%d)", name, i, max)
        if spawn.Distance() > 25 then
            move_to(spawn.ID())
        end

        if zoneTargets[name] == true then
            -- hail only
            cmd("/hail")
            done = true
        end

        -- speak
        local s = split_str(zoneTargets[name], "|")
        if not done and #s == 1 then
            -- normal Speak
            cmdf("/say %s", zoneTargets[name])
            done = true
        end

        -- TODO: return if we got the task

        -- select and accept named task by hailing NPC (DoN tier 0)
        if not done and s[1] == "task" then
            -- Open the "task select" window from NPC
            cmd("/hail")
            delay(1000, function()
                return window_open("TaskSelectWnd")
            end)
            delay(500)

            -- select the proper list item
            local index = mq.TLO.Window("TaskSelectWnd/TSEL_TaskList").List("="..s[2])()
            if index == nil or index <= 0 then
                all_tellf("ERROR: cant select task '%s', not in task list!", s[2])
                return
            end

            -- select task
            log.Info("Selecting task \ag%s\ax, index %d", s[2], index)
            cmdf("/notify TaskSelectWnd TSEL_TaskList listselect %d", index)
            delay(500)

            -- Accept task
            cmd("/notify TaskSelectWnd TSEL_AcceptButton leftmouseup")
            done = true
        end

        if not done then
            all_tellf("PerformHail: ERROR unknown '%s' (%s)", s[1], zoneTargets[name])
            return
        end

        -- some hails result in rewards
        if clear_cursor() then
            return
        end

        mq.delay(5000)
        doevents()

        if zone_shortname() ~= zone then
            all_tellf("PerformHail: ended loop after zoning")
            return
        end
    end
end

return Hail
