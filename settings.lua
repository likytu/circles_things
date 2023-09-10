dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.


function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "circles_things" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	{
		category_id = "scaling",
		ui_name = "SCALING",
		ui_description = "Change the additional difficulty scaling",
		settings = {
			{
				id = "period",
				ui_name = "Period",
				ui_description = "How many minutes between each effect",
				value_default = "1",
				text_max_length = 20,
				allowed_characters = ".0123456789",
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "amount",
				ui_name = "Amount",
				ui_description = "How much difficulty is added each period",
				value_default = "1.2",
				text_max_length = 20,
				allowed_characters = ".0123456789",
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
		},
	},
}
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

	
end
