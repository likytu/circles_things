-- all functions below are optional and can be left out

--[[







function OnModInit()
	print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
	--nothing
end


function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end
]]
--

local biomes_scaling_active = {}
local biomes_exclude = {}
local gui = GuiCreate()

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
	local function has_index(tab, val)
		for index, value in pairs(tab) do
			if index == val then
				return true
			end
		end

		return false
	end
	local time = GameGetFrameNum()
	local period = ModSettingGet("circles_things.period")
	if period == nil then
		GamePrint("bad")
		period = 0.5
	end
	period = period * 60
	
	
	
	if time % 60 == 0 then
		dofile_once("data/scripts/lib/utilities.lua")
		local times_applied = math.floor(time/ 60 / period)
		local amount = tonumber(ModSettingGet("circles_things.amount"))
		local scaling_effect = math.pow(amount, times_applied) / 3
		local newgame_n = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
		local new_enemy_hp_min = (7 + ( (newgame_n-1) * 2.5 )) * scaling_effect
		local new_enemy_hp_max = (25 + ( (newgame_n-1) * 10 )) * scaling_effect
		local new_enemy_attack_speed = (math.pow( 0.5, newgame_n )) / scaling_effect
		SessionNumbersSetValue("DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", new_enemy_hp_min)
		SessionNumbersSetValue("DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", new_enemy_hp_max)
		SessionNumbersSetValue("DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", new_enemy_attack_speed)
		SessionNumbersSave()
		if math.floor((time / 60)/period) ~= math.floor((time / 60 - 1)/period) then
			GamePrint("Scaled to level " .. tostring(times_applied))
		end
	end
	
	
	
	
	local fraction = ((time / 60) % period) / period
	local origin_x = 558
	local base_z = 0.0
	local origin_y = 52
	local width = 40.85
	local height = 4
	local player = EntityGetWithTag("player_unit")[1]
	if player == nil then return end
	--[[
	
	local comps = EntityGetComponent(player, "DamageModelComponent")
	if comps == nil then return end
	for _, component in ipairs(comps) do
		local members = ComponentGetMembers(component)
		if members ~= nil then
			if has_index(members, "air_in_lungs") and has_index(members, "air_in_lungs_max") then
				if tonumber(members["air_in_lungs"]) < tonumber(members["air_in_lungs_max"]) then
					origin_y = origin_y + 8
				end
			end
		end
	end
	--]]
	origin_y = 12
	GuiZSet(gui, base_z)
	GuiTooltip(gui, "text", "desc")
	GuiImage(gui, 2353487, origin_x + 1, origin_y, "mods/circles_things/files/ui_gfx/scaling_bar_bg.png", 1, width - 1, 1)
	GuiImage(gui, 2353488, origin_x, origin_y, "mods/circles_things/files/ui_gfx/scaling_bar_bg.png", 1, 1, height - 1)
	GuiImage(gui, 2353489, origin_x + width, origin_y, "mods/circles_things/files/ui_gfx/scaling_bar_bg.png", 1, 1,
		height)
	GuiImage(gui, 2353490, origin_x, origin_y + height - 1, "mods/circles_things/files/ui_gfx/scaling_bar_bg.png", 1,
		width, 1)
	GuiZSetForNextWidget(gui, base_z - 1)
	GuiImage(gui, 2353491, origin_x + 1, origin_y + 1, "mods/circles_things/files/ui_gfx/scaling_bar_inset.png", 1,
		width - 1, 2)
	GuiZSetForNextWidget(gui, base_z - 2)
	GuiImage(gui, 2353492, origin_x + 1, origin_y + 1, "mods/circles_things/files/ui_gfx/scaling_bar.png", 1,
		(width - 1) * fraction, 2)
	GuiImage(gui, 2353493, origin_x + width + 3, origin_y, "mods/circles_things/files/ui_gfx/scaling_icon.png", 1, 1.2,
		1.2)



	
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	EntityLoad("data/entities/items/pickup/greed_curse.xml", 227, -110)
end

function OnModPreInit() -- This is called first for all mods
	ModMaterialsFileAdd("mods/circles_things/data/circles_materials.xml")
	SessionNumbersSetValue("DESIGN_SCALE_ENEMIES", "1")
	SessionNumbersSave()
	GamePrint(tostring(SessionNumbersGetValue("DESIGN_SCALE_ENEMIES")))
end

--[[

-- This code runs when all mods' filesystems are registered
function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
	--GamePrint("Player spawned")
end
function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
	
end

--]]



local content = ModTextFileGetContent("data/translations/common.csv")
content = content .. [[
mat_circles_barrier_rock,Hardened Brickwork,,,,,,,,,,,,,
]]
content = content:gsub("\r", "")
content = content:gsub("\n\n", "\n")
ModTextFileSetContent("data/translations/common.csv", content)
--print("Example mod init done")
