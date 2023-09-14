dofile("data/scripts/lib/utilities.lua")
local newgame_n = math.min(tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT")) or 0, 1)
local nxml = dofile_once("mods/circles_things/files/scripts/lib/nxml.lua")
local content = ModTextFileGetContent("data/biome/_pixel_scenes.xml")
local xml = nxml.parse(content)
local ng_coordinates_barrier = {
    --end room
    { 11, 29},
    { 12, 28},
    { 13, 29},
    { 12, 30},
    { 13, 28},
    { 11, 28},
    { 11, 30},
    { 13, 30},
    --tower
    --left wall
    { 17, 18},
    { 17, 17},
    { 17, 16},
    { 17, 15},
    { 17, 14},
    { 17, 13},
    { 17, 12},
    { 17, 11},
    { 17, 10},
    { 17, 9},
    { 17, 8},
    { 17, 7},
    --top wall
    { 18, 7},
    { 19, 7},
    { 20, 7},
    --right wall
    { 21, 18},
    { 21, 17},
    { 21, 16},
    { 21, 15},
    { 21, 14},
    { 21, 13},
    { 21, 12},
    { 21, 11},
    { 21, 10},
    { 21, 9},
    { 21, 8},
    { 21, 7},
    --bottom wall
    { 18, 18},
    { 19, 18},
    { 20, 18},
}
local coordinates_end_room = {
    { 12, 29 },
}
print("loaded change_pixel_scenes")
for element in xml:each_child() do
    if element.name == "mBufferedPixelScenes" then
        for _, coord in ipairs(ng_coordinates_barrier) do
            local x, y = coord[1] * 512, coord[2] * 512
            element:add_child(nxml.new_element("PixelScene", {
                DEBUG_RELOAD_ME = "0",
                background_filename = "data/weather_gfx/background_crypt.png",
                clean_area_before = true,
                colors_filename = "data/ui_gfx/empty.png",
                material_filename = "mods/circles_things/files/biome_impl/solid_wall_temple.png",
                pos_x = x,
                pos_y = y,
                skip_biome_checks = true,
                skip_edge_textures = false,
            }))
            element:add_child(nxml.new_element("PixelScene", {
                pos_x=x + 512/2,
                pos_y=y + 512/2,
                just_load_an_entity = "mods/circles_things/files/entities/buildings/barrier_rock.xml",
            }))
        end
        element:add_child(nxml.new_element("PixelScene", {
            DEBUG_RELOAD_ME = "0",
            clean_area_before = false,
            colors_filename = "data/biome_impl/boss_victoryroom_visual.png",
            material_filename = "mods/circles_things/files/biome_impl/boss_victoryroom.png",
            pos_x = coordinates_end_room[newgame_n + 1][1] * 512,
            pos_y = coordinates_end_room[newgame_n + 1][2] * 512,
            skip_biome_checks = true,
            skip_edge_textures = false,
        }))
    end
end
ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(xml))
