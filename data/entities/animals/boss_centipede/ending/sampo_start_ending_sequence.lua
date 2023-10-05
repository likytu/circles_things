dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)


GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/new_game_plus/create", x, y)
EntityKill(entity_id)
GameClearOrbsFoundThisRun()
local player_id = EntityGetClosestWithTag(x, y, "player_unit")
if (player_id ~= nil and player_id ~= 0) then
	local px, py = 227, -110
	EntitySetTransform(player_id, px, py)
	local comp = EntityGetComponent(player_id, "DamageModelComponent")
	if (comp ~= nil) then
	for _, component in ipairs(comp) do
		local max_hp = ComponentGetValue(component, "max_hp")
		ComponentSetValue2(component, "hp", max_hp)
	end
end
end
AddFlagPersistent("progress_ngplus")
do_newgame_plus()
