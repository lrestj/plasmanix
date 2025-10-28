local wezterm = require('wezterm')
return {
	-- color scheme
        window_close_confirmation = "NeverPrompt";
	color_scheme = "Kitty",
        colors = {background = '#000F0F'},
        hide_tab_bar_if_only_one_tab = true,
	--window opacity reduced
	window_background_opacity = .77,
	-- make sure you use a font you have installed
	font = wezterm.font 'Hack Nerd Font',
	font_size = 14,
	-- scroll bar
	enable_scroll_bar = true,
	-- Custom Key Bindings
	-- disable_default_key_bindings = true,
        default_prog = {'fish'}
}
