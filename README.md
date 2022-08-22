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


## eqbc -> dannet migration


/bca  => xxx



## command reference

/assiston ${Target.ID}    	- run from main driver, tells bots to kill ID
/backoff                  	- call of assist


/followme					- movement
/stopfollow					- movement
/clickit					- click a "door" object to zone


/buffon                     - auto buffs
/buffoff
/buffit						- buff target


/finditem, /fdi             - find item by partial name
/fmi                        - find missing item. report peers who lack an item


xxx document rest