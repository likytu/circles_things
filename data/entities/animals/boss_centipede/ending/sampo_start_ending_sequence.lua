dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
if ( newgame_n < 1) then
    GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/new_game_plus/create", x, y)
    EntityKill ( entity_id )
    GameClearOrbsFoundThisRun()
    local player_id = EntityGetClosestWithTag( x, y, "player_unit")
    if( player_id ~= nil and player_id ~= 0 ) then
	    local px, py = 227, -110
	    EntitySetTransform( player_id, px, py )
    end
    AddFlagPersistent( "progress_ngplus" )
    do_newgame_plus()
else
    EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y )
	EntityLoad( "data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y )
	EntityLoad( "data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y )
	EntityLoad( "data/entities/animals/boss_centipede/ending/midas_walls.xml", x, y )
    EntityLoad( "data/entities/animals/boss_centipede/ending/gold_effect.xml", x, y )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/midas/create", x, y )
			
	local ambience = EntityGetWithTag( "victoryroom_ambience" )
			
	for a,b in ipairs( ambience ) do
		EntityKill( b )
	end
			
	EntityKill( entity_id )
    local machine = EntityGetWithTag( "ending_mechanism" )
		
	if ( #machine > 0 ) then
		print("Machineryfound, trying to animate")
		local machine_id = machine[1]
		local machine_sprite = EntityGetFirstComponent( machine_id, "SpriteComponent" )
		if ( machine_sprite ~= nil ) then
			ComponentSetValue( machine_sprite, "rect_animation", "active" )
		end
	end
end
