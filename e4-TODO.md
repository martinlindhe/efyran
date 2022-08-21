# TODO

- BRD: invis/travel songs break after each casted tick??
    issue with mq2medley... ??? or how i invoke it

- LIVE: /followon mq.bind does not register for some reason?!?! some binds works, others dont..

- LIVE: XXX MOST mq.bind seem to be broken, a few works for some reason?????. /followme WORKS. rest does not!?
-       /recallgroup does not work.




OLD TODO ....:::


buffs:
    - read toon INI for buffs, like e3 syntax (init when macro loads)
    - spells and clickies
    - use lua root for toon configs! create initial empty ini


moving:
    - clickit, rtz, followon, followoff
    - NOTE: /rtz useless, /afollow works across zones
    - LATER: check out MQ2Nav. XXX how to download "1.5 gigabyte" of community nav meshes? redguide offers them with membership...


corpses:
    - aerez
    - autoloot, see https://www.mmobugs.com/wiki/index.php?title=MQ2Rez
    - wait for rez

assisting:
    - assiston /filter
    - backoff


DanNet:
    - channels... can we have one called "debug" and a external listener program for that channel ???
    - can we log channel text to disk?


loot:
    check out 
    https://www.mmobugs.com/wiki/index.php?title=MQ2AutoLoot
    https://www.mmobugs.com/wiki/index.php?title=MQ2MasterLooter


performance:
    - how to strip clients 2021 ??! slow load times...
    https://www.mmobugs.com/wiki/index.php?title=MQ2EQWire
    https://www.mmobugs.com/wiki/index.php?title=MQ2FPS


xp tracking:
    https://www.mmobugs.com/wiki/index.php?title=MQ2XPTracker

stat food:
    https://www.mmobugs.com/wiki/index.php?title=MQ2FeedMe


QoL:
    task getter? https://www.mmobugs.com/wiki/index.php?title=MQ2GetMission
    /link ???  https://www.mmobugs.com/wiki/index.php?title=MQ2LinkDB

    check out more plugins at https://www.mmobugs.com/wiki/index.php?title=Plugin_List

    MQ2Discord to post to discord on tells etc...

    /count command - report bots + zones if not nearby

    auto disable option "Auto Turn On AFK" on bot

    disable free to play nagging url open at exit (kill processes???): MQ2NoGold (mmobugs) or MQ2NoNagWindows (redguides)



# REQUIREMENTS

MQ2AdvPath - for auto following (replaces MQ2MoveUtils ??? ... still need /stick for combat.. or mq2melee ???)
MQ2DanNet - bot communication (replaces MQ2EQBC and MQ2NetBots)
MQ2Cast - for spell & clickies


# DIFFERENCES TO E3

+ /rtz is useless. bots will /followon across zone lines

+ and more


# reported bugs:
mq2medley: https://gitlab.com/redguides/plugins/MQ2Medley/-/issues/1

