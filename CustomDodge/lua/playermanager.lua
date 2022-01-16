_G.customdodge = customdodge or {}
customdodge.modpath = ModPath
customdodge.savepath = SavePath .. "customdodge.txt"
customdodge.settings = {
  customdodge_choice = 1,
}




function PlayerManager:skill_dodge_chance(running, crouching, on_zipline, override_armor, detection_risk)
  if customdodge.settings.customdodge_choice == 1 then
    return 0
  elseif customdodge.settings.customdodge_choice == 2 and Global.game_settings.permission == "friends_only" or Global.game_settings.permission == "private" or Global.game_settings.single_player then
    return 999
  else
    return -999
  end
end

Hooks:Add("LocalizationManagerPostInit", "customdodgelocalization_loadlocalization", function(localizationmanager)

	customdodge:Load()

	localizationmanager:add_localized_strings({
      customdodge_options_title = "Custom Dodge",
      customdodge_options_desc = "Change your dodge options",
      customdodge_choice_title = "Dodge",
      customdodge_choice_desc = "Change your dodge options",
      customdodge_no_change = "No change",
      customdodge_loads = "High dodge",
      customdodge_none = "Negative dodge"
	})
end)

function customdodge:Load()
	local file = io.open(self.savepath, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:Save() --create data in case there's no mod save data
	end
	return self.settings
end

function customdodge:Save()
	local file = io.open(self.savepath,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add("MenuManagerInitialize", "customdodge_createmenu", function(menu_manager)

	MenuCallbackHandler.callback_customdodge_choice = function(self,item)
    customdodge.settings.customdodge_choice = tonumber(item:value())
		customdodge:Save()
	end

	MenuHelper:LoadFromJsonFile(customdodge.modpath .. "/menu/options.json", customdodge, customdodge.settings)

end)
