# Circle's Things(a.k.a. Enter the Gauntlet)
## Installation
Download `<>Code` as zip, and extract into `/Noita/mods`. Rename the folder to `circle_things`.
## Why was this made?
This mod is intended to attend to Noita's broken difficulty curve: it is known that after a point, the game becomes relatively free and encourages heavy grinding. Inspired by Risk of Rain's time dependent enemy scaling, this mod aims to make the game exponentially more difficult with time, in an attempt to catch up to Mina.
## Features
### Clear-cut objective
To achieve the highest 'score', which is the NG+ count on death multiplied by your difficulty rating(see below).
### Ending rewiring
All endings now enter NG+. There are no Orb requirements to enter NG+.
### (Nearly) Impassable Biome
To prevent stealing wands from the Tower, and to force the player to kill Kolmi to enter the End Room.
### Curse of Greed QoL
It now spawns above the player's spawnpoint in NG, instead of a 30 second walk away.
## Scaling
### Time-dependent enemy scaling
Configurable in mod settings, this adds a layer of exponential difficulty to the game for only the most hardy of witches. The longer you take, the harder it gets. The mod generates an approximate relative measure of difficulty depending on your settings, where 0 has no additional time-dependent scaling. This is displayed in the top right, next to the red bar that describes the time passed since the last time-dependent scaling effect, and how soon the next one will occur.
### NG+ scaling
Reworked the current NG+ scaling to be more appropriate for players coming straight from Main Path at a fast pace. This does not mean it is easy.
## Bugfixes
This mod is meant to be played as a separate gamemode. However, if you experience a bug where playing in other gamemodes still causes this mod to load, in `mod.xml`, set `is_game_mode` to `0`. This will let it act as most other mods, and can be turned off.
# References
Zather's NXML parser: [https://github.com/zatherz/luanxml](https://github.com/zatherz/luanxml)