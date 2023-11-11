# efyran

The road to massive everquest botting.

[efyran](https://en.wikipedia.org/wiki/European_route_E4) is a bot macro for Macroquest, written in Lua.

It was created after playing with and modding the older [E3 macro](https://github.com/cream24/Macros) over a number of years.

Some concepts are borrowed from E3, while others are new.


## Getting started

Please see the [wiki](https://github.com/martinlindhe/efyran/wiki/Getting-started).


## Moving around

Add some socials to simplify control:

| Social
|-------
| /hotbutton FOLLOW 18 /followon
| /hotbutton STOP 18 /followoff
| /hotbutton KILL 13 /assiston

See [Command Reference](https://github.com/martinlindhe/efyran/wiki/Command-Reference) for more commands.



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
