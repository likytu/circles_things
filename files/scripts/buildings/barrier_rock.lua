dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 350
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local x_orig = x
local y_orig = y
function calculate_force_radial(body_x, body_y)
	local distance = math.sqrt((x - body_x) ^ 2 + (y - body_y) ^ 2)

	local direction = 0 - math.atan2((y - body_y), (x - body_x))

	local gravity_percent = (distance_full - distance) / distance_full
	local gravity_coeff = 100

	local fx = math.cos(direction) * (gravity_coeff * gravity_percent)
	local fy = -math.sin(direction) * (gravity_coeff * gravity_percent)

	return fx, fy
end

local function is_close(ex, ey, px, py)
	return math.abs(ex - px) < 256 and math.abs(ey - py) < 256
end

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function calculate_force_at(body_x, body_y)
	local displacement_x = x - body_x
	local displacement_y = y - body_y
	local gravity_coeff = 100
	local fx = 0
	local fy = 0
	if math.abs(displacement_x) < 260 then
		local gravity_percent_y = (distance_full - displacement_y) / distance_full
		fy = gravity_coeff * gravity_percent_y * displacement_y / math.abs(displacement_y)
	end
	if math.abs(displacement_y) < 260 then
		local gravity_percent_x = (distance_full - displacement_x) / distance_full
		fx = gravity_coeff * gravity_percent_x * displacement_x / math.abs(displacement_x)
	end
	radial_fx, radial_fy = calculate_force_radial(body_x, body_y)
	fx = fx -- + radial_fx
	fy = fy -- + radial_fy
	return fx, fy
end

local projectiles = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")
for _, id in ipairs(projectiles) do
	local px, py = EntityGetTransform(id)
	if is_close(x, y, px, py) then
		EntityKill(id)
	else
		local physicscomp = EntityGetFirstComponent(id, "PhysicsBody2Component") or
			EntityGetFirstComponent(id, "PhysicsBodyComponent")
		if physicscomp == nil then -- velocity for physics bodies is done later
			local velocitycomp = EntityGetFirstComponent(id, "VelocityComponent")
			if (velocitycomp ~= nil) then
				local fx, fy = calculate_force_at(px, py)
				edit_component(id, "VelocityComponent", function(comp, vars)
					local vel_x, vel_y = ComponentGetValue2(comp, "mVelocity")

					vel_x = vel_x - fx
					vel_y = vel_y - fy


					-- limit velocity
					vel_x = clamp(vel_x, -300, 300)
					vel_y = clamp(vel_y, -300, 300)

					ComponentSetValue2(comp, "mVelocity", vel_x, vel_y)
				end)
			end
		end
	end
end
local current_worms = GlobalsGetValue("circles_worm_neutralised_list", "")
--local found_worms = {}
local worms = EntityGetInRadius(x, y, distance_full)
for _, id in ipairs(worms) do
	local cell_eater = EntityGetComponent(id, "CellEaterComponent")
	if cell_eater ~= nil then
		--found_worms[#found_worms + 1] = tostring(id)
		if not string.find(current_worms, id .. "1,") then
			local i, j = string.find(current_worms, id)
			if i == nil then
				current_worms = current_worms .. id .. "0,"
				for _, comp in ipairs(cell_eater) do
					if not ComponentHasTag(comp, "only_stain") then
						ComponentAddTag(comp, "only_stain")
					end
				end
			end
			for _, comp in ipairs(cell_eater) do
				if ComponentHasTag(comp, "only_stain") then
					ComponentSetValue2(comp, "only_stain", true)
					i, j = string.find(current_worms, id)
					current_worms = string.sub(current_worms, 1, j) ..
						"1" .. string.sub(current_worms, j + 2, string.len(current_worms))
				end
			end
		end
	end
end
--[[
local global_worms = mysplit(current_worms, ",")
for _, segment in ipairs(global_worms) do
	local id = string.sub(segment, 1, string.len(segment) - 1)
	if not has_value(found_worms, id) then
		GamePrint("Lost worm: " .. id)
		current_worms = string.gsub(current_worms, id .. "1,", "")
		GamePrint("Current worms: " .. current_worms)
		local cell_eater = EntityGetComponent(id, "CellEaterComponent")
		if cell_eater ~= nil then
			for _, comp in ipairs(cell_eater) do
				if ComponentHasTag(comp, "only_stain") then
					ComponentSetValue2(comp, "only_stain", false)
				end
			end
		end
	end
end
--]]
GlobalsSetValue("circles_worm_neutralised_list", current_worms)
-- force field for physics bodies
function calculate_force_for_body(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
	local fx, fy = calculate_force_at(body_x, body_y)

	fx = fx * 1.5 * body_mass
	fy = fy * 1.5 * body_mass

	return body_x, body_y, -fx, -fy, 0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end

local size = distance_full * 0.5
PhysicsApplyForceOnArea(calculate_force_for_body, entity_id, x - size, y - size, x + size, y + size)

if not is_in_camera_bounds(x, y, 300) then return end
local player = EntityGetWithTag("player_unit")[1]
local px, py = EntityGetTransform(player)
if player ~= nil then
	if is_close(x, y, px, py) and GameGetFrameNum() % 60 == 0 then
		local neuter = EntityLoad("mods/circles_things/files/entities/misc/barrier_rock_neuter.xml")
		EntityAddChild(player, neuter)
	end
else
	player = EntityGetWithTag("polymorphed_player")[1]
	px, py = EntityGetTransform(player)
end
if player == nil then return end
if is_close(x, y, px, py) then
	EntityInflictDamage( player, 500, "DAMAGE_CURSE", "The gods dislike trespassers", "DISINTEGRATED", 0, 0, entity_id )
	EntityKill(player)
end
