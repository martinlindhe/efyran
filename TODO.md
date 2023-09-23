# TODO


sep 2023:
mq bug? /handin fails if item is in bag10 on emu. bag 1 to 9 seem to work fine (also bags must be open on emu, dont need on live)

- enc auto mez

- allow to override GroupBuffs, PetBuffs, Hails, Handins, AutoTribute with per-server settings that is user supplied

- mag: auto pet weapons

- pet classes: auto equip pet focus items while summoning pets

- rez: dont try to rez "this corpse cannot be ressurected" corpses, instead force that toon to autoloot their corpse



misc:
-- BUG: mq.TLO.NearestSpawn() results should be fetched directly and then looped over the results, as they can change
    in the middle of iteration otherwise.




MQ2Lua gotchas:
    /itemnotify seem to require delay(1) or it wont always register
    - spell links: missing from macroquest atm.
    - detect eqgame.exe build date. cant do atm. would want so i can detect rof2 or underfoot


pets:
    - be able to set pet type, eg for mages: water/fire/air/earth pet. https://www.eqprogression.com/magician-pet-stats/





item swap:
    https://gitlab.com/redguides/plugins/MQ2Exchange


buffs:
    - /dson mode = clicky ds buffs + auto ask for MAG & RNG ds (for power leveling)


moving:
    - check out https://gitlab.com/redguides/plugins/mq2portalsetter


tribute:
    https://gitlab.com/redguides/plugins/MQ2TributeManager




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


auto aa:
    MQ2AAspend is buggy / dont work on emu sep 2023

        xxxx look att MQ2AAPurchase, from old emu build ... ?


stat food:
    auto forage + mq2feedme maybe perfect (auto save pod of water, roots etc and auto eat those-all classes have Forage AA)
    mq2feedme is limited... check out https://www.redguides.com/community/threads/mq2cursor.66818/


QoL:
    MQ2Discord to post to discord on tells etc...
