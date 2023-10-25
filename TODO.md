# TODO


sep 2023:

- enc auto mez

- allow to override PetBuffs, Hails, Handins, AutoTribute with per-server settings that is user supplied

- mag: auto pet weapons

- pet classes: auto equip pet focus items while summoning pets

- rez: dont try to rez "this corpse cannot be ressurected" corpses, instead force that toon to loot their corpse

- / slash commands: make sure EVERY COMMAND is put on command queue so they will not interfere.
    slash commands are async out of efyran main-loop and can change data that is beeing looped over

- nec: spell "Shadow Orb" handling

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


auto aa:
    MQ2AAspend is buggy / dont work on emu sep 2023

        xxxx look att MQ2AAPurchase, from old emu build ... ?


stat food:
    auto forage + mq2feedme maybe perfect (auto save pod of water, roots etc and auto eat those-all classes have Forage AA)
    mq2feedme is limited... check out https://www.redguides.com/community/threads/mq2cursor.66818/
