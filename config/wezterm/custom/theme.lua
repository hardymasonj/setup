local helpers = require("utils.helpers")
local wezterm = require("wezterm")
local Module = {}

Module.setup = function(config)
	config.window_decorations = "RESIZE"
	config.hide_tab_bar_if_only_one_tab = true
	config.show_new_tab_button_in_tab_bar = false
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
	config.tab_max_width = 16
	config.switch_to_last_active_tab_when_closing_tab = true

	config.color_theme = "Afterglow"

	config.window_frame = {
		-- font = wezterm.font("Fira Code"),
		font = wezterm.font("0xProto Nerd Font Mono"),
		font_size = 11,
	}
	config.window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	}

	config.font_size = 14
	-- config.font = wezterm.font("Fira Code")
	config.font = wezterm.font("0xProto Nerd Font Mono")
end

return Module
