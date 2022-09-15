# TODO

misc:
-- TODO trigger event to reload and recalculate all settings: find best aura, re-evaluate toon settings file etc
-- BUG: mq.TLO.NearestSpawn() results should be fetched directly and then looped over the results, as they can change
    in the middle of iteration otherwise.

-- BUG: ?? 15 sep 2022: item.Expendables() seem to be broken, always returns false ? https://discord.com/channels/511690098136580097/840375268685119499/1019900421248126996
    needed to fix /clickies

-- /evac: hard code evac spells, reduce ini.allow for rog escape (?)



MQ2Lua gotchas:
    /itemnotify seem to require delay(1) or it wont always register
    - spell links: missing from macroquest atm.
    - detect if on emu. cant do atm
    - detect eqgame.exe build date. cant do atm. would want so i can detect rof2 or underfoot





OLD TODO ....:::


item swap:
    https://gitlab.com/redguides/plugins/MQ2Exchange


buffs:
    - /dson mode = clicky ds buffs + auto ask for MAG & RNG ds (for power leveling)

curing:
    https://gitlab.com/redguides/plugins/MQ2Debuffs


moving:
    - LATER: check out MQ2Nav. XXX how to download "1.5 gigabyte" of community nav meshes? redguide offers them with membership...
    - check out https://gitlab.com/redguides/plugins/mq2portalsetter


tribute:
    https://gitlab.com/redguides/plugins/MQ2TributeManager

corpses:
    - autoloot, see https://www.mmobugs.com/wiki/index.php?title=MQ2Rez
    - check out https://gitlab.com/redguides/plugins/mq2rez


dps meter:
    check out
    https://gitlab.com/redguides/plugins/mq2dpsadv
    https://gitlab.com/redguides/plugins/mq2damagemeter


DanNet:
    - channels... can we have one called "debug" and a external listener program for that channel ???
    - can we log channel text to disk?


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

stat food:
    auto forage + mq2feedme maybe perfect (auto save pod of water, roots etc and auto eat those-all classes have Forage AA)
    mq2feedme is limited... check out https://www.redguides.com/community/threads/mq2cursor.66818/


QoL:
    task getter? https://www.mmobugs.com/wiki/index.php?title=MQ2GetMission
    /link ???  https://www.mmobugs.com/wiki/index.php?title=MQ2LinkDB

    check out more plugins at https://www.mmobugs.com/wiki/index.php?title=Plugin_List

    MQ2Discord to post to discord on tells etc...

    /count command - report bots + zones if not nearby

    auto disable option "Auto Turn On AFK" on bot

    disable free to play nagging url open at exit (kill processes???): MQ2NoGold (mmobugs) or MQ2NoNagWindows (redguides)

