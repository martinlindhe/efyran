# efyran

The road to massive everquest botting.

[efyran](https://en.wikipedia.org/wiki/European_route_E4) is a bot macro for Macroquest, written in Lua.

It was created after playing with and modding the older [E3 macro](https://github.com/cream24/Macros) over a number of years.

Some concepts are borrowed from E3, while others are new. No code has been reused from E3.


## Getting started

Put this repository under your Lua folder,
so it lives in `Macroqest\lua\efyran`.

Then start it with `/lua run efyran/e4`

You can auto start efyran with this `Macroquest\config\zoned.cfg`:

```
/setwintitle ${Me.Name}
/if (!${Bool[${Lua.PIDs}]}) /lua run efyran/e4
```

For ease of starting / stopping / re-launching efyran, you can also put the following in your `Macroquest\config\MacroQuest.ini`:

```ini
[Aliases]
/e4=/multiline ; /lua stop efyran/e4 ; /timed 5 /lua run efyran/e4
/e4all=/dgaexecute /multiline ; /lua stop efyran/e4 ; /timed 5 /lua run efyran/e4
/stope4=/lua stop efyran/e4
/stopall=/dgaexecute /lua stop efyran/e4
```

## Moving around

Add some socials to simplify control:

| Social                    |  Command
|---------------------------|-------------
| /hotbutton FOLLOW         | /followon
| /hotbutton STOP           | /followoff
| /hotbutton KILL           | /assiston



## How auto healing works

Instead of all healers constantly monitoring everyone, the peers instead report when they need healing.

All healers join the special zone healing channel, "server_shortname_healme".

When a bot is < 100%, they report their name and current HP % to the healme channel, "Avicii 73".

Healers read the message and given some conditions, puts the message on their internal heal queue.

The heal queue is separate from the command queue and is always prioritized ahead of other actions.

When picking from the queue:
- tanks, then important bots is always picked ahead of the rest in queue




# How auto buffing works

e3 had a concept of Bot Buffs and Group Buffs. Efyran chose to instead implement a beg-for-buff system,
which makes use of "buff groups" (tags mapping to multiple buffs). This setup allows for a zero-configuration
buff bot with default settings, while still allowing fine grained control where you need to.





## Debugging

To begin, type `/debug`

This will toggle the display of debug messages on your toon.
This value defaults to false and is not remembered across sessions.

If you want to permanently enable debugging, you need to add a per-character setting:

```lua
local settings = { }

settings.debug = true -- enable debug logging for this peer
```


## Buff spell level and PC target levels

```
Buff Spell Level   Minimum Target Level
1-50:				Level 1
51: 				Level 40
52-53: 				Level 41
54-55: 				Level 42
56-57: 				Level 43
58-59: 				Level 44
60-61: 				Level 45
62-63: 				Level 46
64-65: 				Level 47
66-70: 				Level 62
71+:                ???
```

## Terminology
- Orchestrator = the main driver toon you are playing from
- Peer = A connected character that you control
- Buff group = A tag such as "clr_symbol", which translates to a table of the Cleric "Symbol" line of buffs


## Command reference

```
/assiston ${Target.ID}      - run from main driver, tell peers to kill spawn by ID
/backoff                    - call of assist
/pbaeon                     - start PBAE
/spellset <name>            - switch currently used spell set. defaults to "main"

/quickburns
/longburns
/fullburns

/mana                       - tell peers to report mana %

/followon					- tell peers to follow you
/followoff					- tell peers to stop
/movetome                   - tell peers to move to your location
/clickit					- click a "door" object to zone
/rtz                        - face zoneline and run it to instruct bots to cross the zoneline
/hailit                     - hail/talk to nearby NPC
/hailall                    - have all peers hail/talk to nearby NPC
/cohgroup                   - let current mage summon their group with Call of the Hero

/buffon                     - auto buffs
/buffoff
/buffit						- buff target
/dropbuff <name>            - drop buff from all peers in zone, partial buff name match. "all" to drop all buffs
/dropinvis                  - drop invisibility on all peers in zone
/gathercorpses              - summon nearby corpses into a pile
/factions                   - report faction status. currently only tracks Dranik Loyalists max ally (oow t2 armor)
/factionsall             	- tell all peers to report faction

/fdi             			- find item by partial name
/fmi                        - find missing item. report peers who lack an item
/clickies                   - lists all clickies on current toon
/banker                     - summons a banker
/autobank                   - autobanks loot listed in tradeskills.ini

/recallgroup <name>         - recalls a group/raid formation

/shrinkgroup                - shrink group members shrink spells/clickies
/shrinkall                  - tell all to shrink their groups

/wornaugs                   - reports all worn augs and total hp/mana/endurance/ac
/tongues                    - reports quest status for GoD Discord Skin Samples

/handin                     - performs NPC hand-ins, see handin.lua
/wordheal                   - clerics: cast word heal (group heal with cure effect)
/aetl                       - wizard: cast AE TL spell

/rezit                      - rez target
/aerez                      - perform ae rez

/lootcorpses                - loot your corpses
/lootallcorpses             - tell peers to loot all

```

xxx document rest





## e3 differences

mag: in e3 you could list Molten Orb as a nuke and it will auto summon,
in e4 it was changed to work with any spells, so you need to be explicit with the Summon filter.
Example: "Molten Orb/NoAggro/Summon|Summon: Molten Orb"

Also, efyran is written for modern Macroquest.



## Special channels

"skillup" - ability skill-ups is posted here
"xp" - xp gains is posted here

"server_zone_healme" - heal request channel for current zone




## Spell filter lines

Many are borrowed from e3, some are new.


for heals.life_support (Heal.performLifeSupport)
- HealPct = when to start using this ability (number)
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

for heals and life support (healPeer)
- MinMana|50
- HealPct|80
