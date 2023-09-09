CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")
RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff40ec3b, "spawn_barrier_rock" )
function init( x, y)
    LoadPixelScene("mods/circles_things/files/biome_impl/solid_wall_temple.png", "", x, y, "data/biome_impl/essenceroom_background.png", true, true )
end
function spawn_barrier_rock(x, y)
    EntityLoad( "mods/circles_things/files/entities/buildings/barrier_rock.xml", x, y )
end