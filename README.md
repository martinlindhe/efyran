## How auto healing works

Instead of all healers constantly monitoring everyone, the bots instead report when they need healing.

All healers join the special zone healing channel, "server_shortname_healme".

When a bot is < 100%, they report their name and current HP % to the healme channel, "Avicii 73".

Bot waits 5 seconds before asking for another heal.

---

Healers read the message and given some conditions, puts the message+timestamp on the heal queue.

Conditions:
x- if queue don't already contain this bot
x if queue is less than 10 requests, always add it
- if queue is >= 10 long, always add if listed as tank or important bot
- if queue is >= 10 long, add with 50% chance ... if >= 20 long, beep and ignore.

When picking from the queue:
- tanks, then important bots is always picked ahead of the rest in queue






# How auto buffing works

TODO TODO TODO--

also rework buffing like this:
	- bots request the buffs from nearby bots.
	this way a bot will be able to: ask for conviction if no DRU nearby. DROP conviction etc if DRU shows up.






## buff spell level and PC target levels

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
66+: 				Level 62


## Terminology used
- Orchestrator = the main driver toon you are playing from
- Peer = A connected character that you control


## command reference

/assiston ${Target.ID}      - run from main driver, tells bots to kill ID
/backoff                    - call of assist
/pbaeon                     - start PBAE


/followon					- tell peers to follow you
/followoff					- tell peers to stop
/movetome                   - tell peers to move to your location
/clickit					- click a "door" object to zone
/rtz                        - face zoneline and run it to instruct bots to cross the zoneline
/hailit                     - hail/talk to nearby NPC
/hailall                    - have all peers hail/talk to nearby NPC

/buffon                     - auto buffs
/buffoff
/buffit						- buff target


/fdi             			- find item by partial name
/fmi                        - find missing item. report peers who lack an item
/clickies                   - lists all clickies on current toon

/recallgroup <name>         - recalls a group/raid formation

/shrinkgroup                - shrink group members shrink spells/clickies

/wornaugs                   - reports all worn augs and total hp/mana/endurance/ac

xxx document rest





## e3 differences

mag: in e3 you could list Molten Orb as a nuke and it will auto summon,
in e4 it was changed to work with any spells, so you need to be explicit with the Summon filter.
Example: "Molten Orb/NoAggro/Summon|Summon: Molten Orb"




## special channels:

"skillup" - ability skillups is posted here
"xp" - xp gains is posted here

"server_zoneshort_healme" - heal request channel for current zone



## Tricks

Put all toons in the same guild:
- easy auto consent of all toons
- travel using guild portal and guild banner
- guild bank, guild tribute



## Spell filter lines

Many are borrowed from e3, some are new.


for heals.life_support (Heal.performLifeSupport)
- HealPct = when to start using this ability (number)
- CheckFor = only cast if I don't have this in buffs/songs
- MinMobs = only cast if this many mobs nearby (number)
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

for assist.abilities and assist.nukes (Assist.castSpellAbility)
- MinMana
- PctAggro
- NoAggro
- GoM
- Summon
- NoPet

for heals and life support (healPeer)
- MinMana|50
- HealPct|80
