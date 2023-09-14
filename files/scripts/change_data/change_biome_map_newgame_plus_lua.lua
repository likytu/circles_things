dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/circles_things/files/scripts/lib/injection.lua")
local filename = "data/biome_impl/biome_map_newgame_plus.lua"
inject(args.SS, modes.R, filename, "SetRandomSeed( 4573, 4621 )", "SetRandomSeed( math.random(1,10000), math.random(1,10000))")
inject(args.SS, modes.R , filename, "if( newgame_n % 2 == 0 ) then", "if( newgame_n % 2 == 1 ) then")
inject(args.SS, modes.R, filename, [[biome_crypt = 0xFF3D3E3E
end]], [[biome_crypt = 0xFF3D3E3E
else]])
inject(args.SS, modes.P, filename, "if( newgame_n % 3 == 0 ) then", "--")