dofile_once("mods/circles_things/files/scripts/lib/injection.lua")
local filename = "data/scripts/biomes/boss_victoryroom.lua"
inject(args.SS, modes.R, filename, "spawn_rewards(", "spawn_candles(")