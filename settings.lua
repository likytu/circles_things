dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.
dofile("mods/circles_things/files/scripts/lib/all_things_scaling.lua")
local amount = tonumber(ModSettingGet("circles_things.amount")) or 0
local period = tonumber(ModSettingGet("circles_things.period")) or 1
local immunities_removed = tonumber(ModSettingGet("circles_things.immunities")) or 0
local difficulty = get_difficulty(amount, period, immunities_removed)
local max_period = 30
function mod_setting_scaling_change_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
	if new_value == "" then return end
	if setting.id == "period" then
		period = tonumber(new_value)
		if period > max_period then
			ModSettingSet("circles_things.period", max_period)
			period = max_period
		end
	end
	if setting.id == "amount" then
		amount = tonumber(new_value)
	end
	if setting.id == "immunities" then
		immunities_removed = new_value
	end
	difficulty = get_difficulty(amount, period,immunities_removed)
	print(amount, period, difficulty)
end

function ui_fn_difficulty(mod_id, gui, in_main_menu, im_id, setting)
	local text = "Difficulty Rating: " .. difficulty
	GuiText(gui, mod_setting_group_x_offset, 0, text)
end

local mod_id = "circles_things" -- This should match the name of your mod's folder.
mod_settings_version = 1        -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
	{
		id = "difficulty_rating",
		ui_fn = ui_fn_difficulty,
	},
	{
		category_id = "scaling",
		ui_name = "SCALING",
		ui_description = "Change the additional difficulty scaling",
		foldable = true,
		_folded = true,
		settings = {
			{
				id = "period",
				ui_name = "Period",
				ui_description = "How many minutes between each effect, if above " .. max_period ..
				", set to " .. max_period,
				value_default = "1",
				text_max_length = 20,
				allowed_characters = ".0123456789",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_scaling_change_callback,
			},
			{
				id = "amount",
				ui_name = "Amount",
				ui_description = "How much difficulty is added each period",
				value_default = "1.2",
				text_max_length = 20,
				allowed_characters = ".0123456789",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_scaling_change_callback,
			},
		},
	},
	{
		category_id = "misc",
		ui_name = "MISC CHANGES",
		ui_description = "Perk configuration",
		foldable = true,
		_folded = true,
		settings = {
			{
				id = "immunities",
				ui_name = "Immunity Removal",
				ui_description = "Removes this number of immunities from the perk pool",
				value_default = 0,
				value_min = 0,
				value_max = 5,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn=mod_setting_scaling_change_callback,
			},
		},
	},
}
function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
	mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
