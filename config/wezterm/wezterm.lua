local wezterm = require("wezterm")
local h = require("utils.helpers")

local config = wezterm.config_builder()

config.window_close_confirmation = "NeverPrompt"

config.color_scheme = h.theme
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar  = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_frame = {
	font = wezterm.font("Fira Code", {}),
}

config.font_size = 14
config.font = wezterm.font("Fira Code", {})

config.enable_wayland = true

if h.is_windows() then
	config.default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe', '-NoLogo' }
end

return config
