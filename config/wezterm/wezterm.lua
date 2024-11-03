local wezterm = require("wezterm")
local helpers = require("utils.helpers")
local keybind = require("custom.keybind")
local tabs = require("custom.tabs")
local theme = require("custom.theme")

local config = wezterm.config_builder()

keybind.setup(config)
tabs.setup(config)
theme.setup(config)

config.window_close_confirmation = "NeverPrompt"

config.enable_wayland = true

if helpers.is_windows() then
	config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-i", "-l" }
end

-- Always maximize on startup
wezterm.on("gui-startup", function()
	local _, _, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
