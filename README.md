# efyran

The road to massive everquest botting.

[efyran](https://en.wikipedia.org/wiki/European_route_E4) is a bot macro for Macroquest, written in Lua.

It was created after playing with and modding the older [E3 macro](https://github.com/cream24/Macros) over a number of years.

Some concepts are borrowed from E3, while others are new.


## Getting started

Oct 2023: When using git version, make sure you pull the submodules (external dependencies)

```sh
git submodule update --init
```

Place the `efyran` folder in `Macroqest-Root\lua\efyran`.

Then start it with `/lua run efyran`

## Auto-starting
You can auto start efyran with this `Macroquest\config\zoned.cfg`:

```
/setwintitle ${Me.Name}
/if (!${Bool[${Lua.PIDs}]}) /lua run efyran
```

For ease of starting / stopping / re-launching, you can also put the following in your `Macroquest\config\MacroQuest.ini`:

```ini
[Aliases]
/e4=/multiline ; /lua stop efyran ; /timed 5 /lua run efyran
/e4all=/bcaa //multiline ; /lua stop efyran ; /timed 5 /lua run efyran
/stope4=/lua stop efyran
/stopall=/bcaa //lua stop efyran
```

## Moving around

Add some socials to simplify control:

| Social                    |  Command
|---------------------------|-------------
| /hotbutton FOLLOW         | /followon
| /hotbutton STOP           | /followoff
| /hotbutton KILL           | /assiston

See [Command Reference](#command-reference) for more commands.



# How auto buffing works

e3 had a concept of Bot Buffs and Group Buffs. Efyran chose to instead implement a beg-for-buff system,
which makes use of "buff groups" (tags mapping to multiple buffs). This setup allows for a zero-configuration
buff bot if using the default settings, while still allowing fine grained control where you need to.





## Debugging

To begin, type `/debug`

This will toggle the display of debug messages on your toon.
This value defaults to false and is not remembered across sessions.

If you want to permanently enable debugging, you need to add a per-character setting:

```lua
local settings = { }
settings.debug = true -- enable debug logging for this peer
```



## Terminology
- Orchestrator = the main driver toon you are playing from
- Peer = A connected character that you control, including the orchestrator
- Buff group = A tag such as "clr_symbol", which translates to a table of the Cleric "Symbol" line of buffs


## Command Reference

```
/assiston <filter>          - tell peers to kill current target
/assiston ${Target.ID} <filter> - tell peers to kill spawn by ID
/backoff <filter>           - call off assist
/pbaeon                     - start PBAE
/pbaeoff                    - stop PBAE
/spellset <name>            - switch currently used spell set. default set is called "main"

/quickburns
/longburns
/fullburns

/mana                       - tell peers to report mana %
/weight                     - tell peers to report current weight
/food                       - tell peers to report food & drink status

/followon <filter>          - tell peers to follow you
/followoff                  - tell peers to stop
/movetome                   - tell peers to move to your location
/clickit                    - click a "door" object to zone
/rtz                        - run to zone. face zoneline and run /rtz to instruct bots to run forward in your direction

/hailit                     - hail/talk to nearby NPC
/hailall                    - have all peers hail/talk to nearby NPC
/gotflag                    - reports peers who got character flag
/noflag                     - reports peers who did not get character flag
/bark <text>                - have all peers say <text> to targeted NPC

/circleme                   - line up peers in a circle around you

/cohgroup                   - let current mage summon their group with Call of the Hero

/buffon, /buffoff           - toggle auto buffing
/medon, /medoff             - toggle auto med
/buffit                     - buff target
/dropbuff <name>            - drop buff from all peers in zone, partial buff name match. "all" to drop all buffs
/dropinvis                  - drop invisibility on all peers in zone
/gathercorpses              - summon nearby corpses into a pile
/naked                      - reports naked peers

/factions                   - report faction status. currently only tracks Dranik Loyalists max ally (oow t2 armor)
/factionsall                - tell all peers to report faction

/playmelody <name>          - bards: play specific song set. default name is "general"
/playmelody off             - stop melodies

/teleportbind               - WIZ: port group to bind point using "Teleport Bind" AA
/secondaryrecall            - WIZ/DRU: port to secondary bind

/findslot <name> <filter>   - reports equipped inventory slot (eg /findslot face /only|plate chain)
/fdi <name> <filter>        - find item by partial name and optional filter (eg /fdi crystal /only|ROG)
/fmi <name> <filter>        - find missing item by item name (all peers who lack an item)
/fmid <id>                  - find missing item by item ID (eg. for 'Shard of Dark Matter')

/listclickies               - lists every clickie on current toon
/reportclickies <filter>    - report detected auto clickes on current toon
/banker                     - summons a banker
/autobank                   - autobanks loot listed in tradeskills.ini

/recallgroup <name>         - recalls a group/raid formation
/disbandall                 - disband all peers from group/raids

/listtasks                  - lists all active tasks
/hastask <name>

/shrinkgroup                - shrink group members shrink spells/clickies
/shrinkall                  - tell all to shrink their groups

/wornaugs                   - reports all worn augs and total hp/mana/endurance/ac
/tongues                    - reports quest status for GoD Discord Skin Samples
/coaaugs                    - reports missing CoA auguments
/lucidshards                - reports missing Lucid shards

/trade                      - tell peers to accept any open trades
/handin                     - performs NPC hand-ins, see handin.lua
/wordheal                   - clerics: cast word heal (group heal with cure effect)
/aetl                       - wizard: cast AE TL spell
/mgbready                   - reports if MGB is ready to use
/count                      - report peer status (out of range or not in zone)

/rezit                      - rez target
/aerez                      - perform ae rez

/rc                         - use radiant cure
/counters                   - report debuff counters

/lootmycorpse               - loot your corpse
/lootallcorpses             - tell peers to loot their corpse
/usecorpsesummoner          - summon corpse in guild lobby

/looton, /lootoff           - toggle autoloot (non-persistent. Use peer `settings.autoloot = true` to make it permanent)
/doloot                     - manually trigger autoloot on this peer

/scribe                     - scribes all spells in inventory

/train <skill>              - train skill [language, begging, alcohol]
```

TODO document the remaining commands





## Auto cure

Each group needs a curer, and toons will auto beg for cures. This allows for zero-setup auto curing.
Assumes that each group has at least 1 curer (shm/dru/pal/clr)





## Spell filter lines

Many are borrowed from e3, some are new.


for heals.life_support (Heal.performLifeSupport)
- HealPct = when to start using this ability (number)
- MinMana = minimum % mana required to use ability
- MaxMana = maximum % mana required to use ability (eg. Cannibalization)
- MinEnd = minimum % endurance required to use ability
- MinHP = minimum % HP required to use ability (eg. Cannibalization)
- CheckFor = only cast if I don't have this in buffs/songs
- MinMobs = only cast if at least many mobs nearby (number)
- MaxMobs = only cast if at most this many mobs nearby (number)
- Zone|anguish      = only use this ability in the listed zone. TODO support multiple comma-separated zones: "Zone|anguish,tacvi"


for pet.buffs (Pet.BuffMyPet)
- MinMana
- CheckFor
- Reagent
- Shrink   = lists a pet shrink ability


for buffs (spellConfigAllowsCasting)
- MinMana
- CheckFor
- Reagent
- Shrink

for assist.abilities and assist.nukes (castSpellAbility)
- MinMana
- PctAggro
- NoAggro
- GoM
- Summon
- NoPet
- MaxHP   = only use if mob is equal or below this HP %
- MaxLevel = only use if mob is equal or below this level
- Delay   = Number of seconds between reuse of this spell/ability

for heals and life support (healPeer)
- MinMana|50
- HealPct|80

for taunts (Assist.TankTick)
- MinMana
- MinEnd
- CheckFor
- MinMobs
