# TODO


MQ2Lua gotchas:
    /itemnotify seem to require mq.delay(1) or it wont always register
    - spell links: missing from macroquest atm.
    - detect if on emu. cant do atm
    - detect eqgame.exe build date. cant do atm. would want so i can detect rof2 or underfood


heal:
    make the healme requester a separate macro, thus removing the issue of not asking for heals when e4 has crashed!
        (e4 will auto start this one if it is not already running)




nukes assist:
    -- TODO read spell.Gem and use that spell gem when scribing it, if not already scribed
    -- TODO read MaxTries|3 prop and default to 1 cast ...


- /rezit /only|Samma    force SHM/DRU to use their 90% rezzes

- BRD: invis/travel songs break after each casted tick??
    issue with mq2medley... ??? or how i invoke it

- LIVE: /followon mq.bind does not register for some reason?!?! some binds works, others dont..

- LIVE: XXX MOST mq.bind seem to be broken, a few works for some reason?????. /followme WORKS. rest does not!?
-       /recallgroup does not work.


- CPU%   CHECK OUT https://gitlab.com/redguides/plugins/mq2cpuload
    - automatic load balancing. no more powershell script !!!

- CPU % check out https://gitlab.com/redguides/plugins/MQ2Profiler
    ???




OLD TODO ....:::


item swap:
    https://gitlab.com/redguides/plugins/MQ2Exchange


buffs:
    - read toon INI for buffs, like e3 syntax (init when macro loads)
    - spells and clickies
    - use lua root for toon configs! create initial empty ini
    - /dson mode = clickie ds buffs + auto ask for MAG & RNG ds (for power leveling)

curing:
    https://gitlab.com/redguides/plugins/MQ2Debuffs


moving:
    - clickit, rtz
    - LATER: check out MQ2Nav. XXX how to download "1.5 gigabyte" of community nav meshes? redguide offers them with membership...
    - check out https://gitlab.com/redguides/plugins/mq2portalsetter


tribute:
    https://gitlab.com/redguides/plugins/MQ2TributeManager

corpses:
    - aerez
    - autoloot, see https://www.mmobugs.com/wiki/index.php?title=MQ2Rez
    - wait for rez
    - check out https://gitlab.com/redguides/plugins/mq2rez

assisting:
    - assiston /filter
    - backoff


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
    https://www.mmobugs.com/wiki/index.php?title=MQ2MasterLooter


performance:
    - how to strip clients 2021 ??! slow load times...
    https://www.mmobugs.com/wiki/index.php?title=MQ2EQWire
    https://www.mmobugs.com/wiki/index.php?title=MQ2FPS


xp tracking:
    https://www.mmobugs.com/wiki/index.php?title=MQ2XPTracker

stat food:
    auto forage + mq2feedme maybe perfect (auto save pod of water, roots etc  and auto eat those-all classes have Forage AA)
    https://www.mmobugs.com/wiki/index.php?title=MQ2FeedMe
    https://gitlab.com/redguides/plugins/MQ2Autoforage


QoL:
    task getter? https://www.mmobugs.com/wiki/index.php?title=MQ2GetMission
    /link ???  https://www.mmobugs.com/wiki/index.php?title=MQ2LinkDB

    check out more plugins at https://www.mmobugs.com/wiki/index.php?title=Plugin_List

    MQ2Discord to post to discord on tells etc...

    /count command - report bots + zones if not nearby

    auto disable option "Auto Turn On AFK" on bot

    disable free to play nagging url open at exit (kill processes???): MQ2NoGold (mmobugs) or MQ2NoNagWindows (redguides)

