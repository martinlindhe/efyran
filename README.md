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

---

TODO TODO TODO--

# How auto buffing works

also rework buffing like this:
	- bots request the buffs from nearby bots.
	this way a bot will be able to: ask for conviction if no DRU nearby. DROP conviction etc if DRU shows up.
	- this way healers wont have to dannet probe buff status on each toon (SUPER SLOW!!!!!)


