function remove_perk( perk_name )
	local key_to_perk = nil
	for key,perk in pairs(perk_list) do
		if( perk.id == perk_name) then
			key_to_perk = key
		end
	end

	if( key_to_perk ~= nil ) then
		table.remove(perk_list, key_to_perk)
	end
end
function edit_perk( perk_name , field, value)
	for key,perk in pairs(perk_list) do
		if( perk.id == perk_name) then
			perk[field] = value
		end
	end
end
remove_perk( "GENOME_MORE_LOVE" )
edit_perk("EXTRA_MONEY", "stackable", STACKABLE_NO)

local remove_immunities = tonumber(ModSettingGet("circles_things.immunities")) --5
local immunity_list = {
	[1]="PROTECTION_FIRE",
	[2]="PROTECTION_RADIOACTIVITY",
	[3]="PROTECTION_MELEE",
	[4]="PROTECTION_ELECTRICITY",
	[5]="PROTECTION_EXPLOSION",
}
for i = 1, remove_immunities do
	local to_remove = math.random(1, #immunity_list)
	local perks_death_list = {}
	for key,perk in pairs(perk_list) do
		if( perk.game_effect == immunity_list[to_remove]) or (perk.game_effect2 == immunity_list[to_remove]) then
			perks_death_list[#perks_death_list+1] = perk.id
			print("found: " .. perk.id..", with tag: " .. immunity_list[to_remove])
		end
	end

	for _, perk in ipairs(perks_death_list) do
		remove_perk(perk)
	end
	table.remove(immunity_list, to_remove)
end
--]]