dofile_once("mods/circles_things/files/scripts/lib/injection.lua")
function set_shop(filename)
	inject(args.SS, modes.A, filename, "function spawn_all_shopitems( x, y )", [[
    local newgame_n = tonumber( SessionNumbersGetValue( "NEW_GAME_PLUS_COUNT") )
	
	local biomes =
	{
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 1,
		[5] = 1,
		[6] = 1,
		[7] = 2,
		[8] = 2,
		[9] = 2,
		[10] = 2,
		[11] = 2,
		[12] = 2,
		[13] = 3,
		[14] = 3,
		[15] = 3,
		[16] = 3,
		[17] = 4,
		[18] = 4,
		[19] = 4,
		[20] = 4,
		[21] = 5,
		[22] = 5,
		[23] = 5,
		[24] = 5,
		[25] = 6,
		[26] = 6,
		[27] = 6,
		[28] = 6,
		[29] = 6,
		[30] = 6,
		[31] = 6,
		[32] = 6,
		[33] = 6,
	}


	local biomepixel = math.floor(y / 512)
	local biomeid = biomes[biomepixel] or 0
	if biomepixel > 33 then
		biomeid = 7
	end
	local random_offset = Randomf() ^ 2
	biomeid = biomeid + math.floor(random_offset * newgame_n)
	if biomeid > 7 then biomeid = 10 end

]])
	inject(args.SS, modes.R, filename, "SetRandomSeed( x, y )", "SetRandomSeed( x+newgame_n, y +newgame_n)")
	inject(args.SS, modes.R, filename, "true, nil, true", "true, biomeid, true")
	inject(args.SS, modes.R, filename, "false, nil, true", "false, biomeid, true")
	inject(args.SS, modes.R, filename, "false, nil, true", "false, biomeid, true")
	inject(args.SS, modes.R, filename, "generate_shop_wand( x + (i-1)*item_width, y, true )",
		"generate_shop_wand( x + (i-1)*item_width, y, true , biomeid)")
	inject(args.SS, modes.R, filename, "generate_shop_wand( x + (i-1)*item_width, y, false )",
		"generate_shop_wand( x + (i-1)*item_width, y, false , biomeid)")
end
