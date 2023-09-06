# TODO

aug 2023:
- add filter to /fmi, /fdi
- enc auto mez



misc:
-- BUG: mq.TLO.NearestSpawn() results should be fetched directly and then looped over the results, as they can change
    in the middle of iteration otherwise.




MQ2Lua gotchas:
    /itemnotify seem to require delay(1) or it wont always register
    - spell links: missing from macroquest atm.
    - detect eqgame.exe build date. cant do atm. would want so i can detect rof2 or underfoot







item swap:
    https://gitlab.com/redguides/plugins/MQ2Exchange


buffs:
    - /dson mode = clicky ds buffs + auto ask for MAG & RNG ds (for power leveling)


moving:
    - check out https://gitlab.com/redguides/plugins/mq2portalsetter


tribute:
    https://gitlab.com/redguides/plugins/MQ2TributeManager




dps meter:
    check out
    https://gitlab.com/redguides/plugins/mq2dpsadv
    https://gitlab.com/redguides/plugins/mq2damagemeter


DanNet:
    - channels... can we have one called "debug" and a external listener program for that channel ???
    - can we log channel text to disk?  use sqlite backend for a logger


loot:
    check out
    https://www.mmobugs.com/wiki/index.php?title=MQ2AutoLoot
    https://gitlab.com/redguides/plugins/mq2autoloot
    https://gitlab.com/redguides/plugins/MQ2AutoLootSort
    https://www.redguides.com/wiki/MQ2LootManager                           <-- only for LIVE
    https://www.mmobugs.com/wiki/index.php?title=MQ2MasterLooter

    git submodule add -b master -f https://gitlab.com/redguides/plugins/MQ2AutoLoot.git plugins/MQ2AutoLoot
    git submodule add -b master -f https://gitlab.com/redguides/plugins/MQ2AutoLootSort.git plugins/MQ2AutoLootSort
    git submodule add -b master -f https://github.com/jessebevil/MQ2LootManager.git plugins/MQ2LootManager


xp tracking:
    https://www.mmobugs.com/wiki/index.php?title=MQ2XPTracker

auto aa:
    MQ2AAspend is buggy / dont work on emu sep 2023

        xxxx look att MQ2AAPurchase, from old emu build ... ?


stat food:
    auto forage + mq2feedme maybe perfect (auto save pod of water, roots etc and auto eat those-all classes have Forage AA)
    mq2feedme is limited... check out https://www.redguides.com/community/threads/mq2cursor.66818/


QoL:
    task getter? https://www.mmobugs.com/wiki/index.php?title=MQ2GetMission
    /link ???  https://www.mmobugs.com/wiki/index.php?title=MQ2LinkDB

    check out more plugins at https://www.mmobugs.com/wiki/index.php?title=Plugin_List

    MQ2Discord to post to discord on tells etc...

    /count command - report bots + zones if not nearby

