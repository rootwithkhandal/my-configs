-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

return {
    -- font family
    -- font = wezterm.font("JetbrainsMono Nerd Font"),
    font = wezterm.font('JetBrains Mono'),
    -- font size
    adjust_window_size_when_changing_font_size = false,
    font_size = 12.0,

    -- color schemes
    -- color_scheme = 'termnial.sexy',
	color_scheme = 'Catppuccin Mocha',

    -- colors = { -- iceberg
    --     foreground = "#C6C8D1",
    --     background = "#161821",
    --     cursor_bg = "#91ACD1",
    --     cursor_border = "#91ACD1",
    --     cursor_fg = "#91ACD1",
    --     selection_bg = "#1E2132",
    --     selection_fg = "#C6C8D1",
    --     ansi = { "#1E2132", "#E27878", "#B4BE82", "#E2A478", "#84A0C6", "#A093C7", "#89B8C2", "#E6E6E6" },
    --     brights = { "#6B7089", "#E98989", "#C0CA8E", "#E9B189", "#91ACD1", "#ADA0D3", "#95C4CE", "#D2D4DE" },
    -- },

    -- windows decorations
    enable_tab_bar = false,
    window_decorations = "NONE",

    -- backgrounds
    window_background_opacity = 0.95,
    -- macos_window_background_blur = 10,
	macos_window_background_blur = 30,

	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
	-- window_background_image_hsb = {
	-- 	brightness = 0.01,
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	window_background_opacity = 0.98,
	-- window_decorations = 'RESIZE',

    -- keybindings
    keys = {
		{
			key = 'q',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = '\'',
			mods = 'CTRL',
			action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
		},
	},
	mouse_bindings = {
	  -- Ctrl-click will open the link under the mouse cursor
	  {
	    event = { Up = { streak = 1, button = 'Left' } },
	    mods = 'CTRL',
	    action = wezterm.action.OpenLinkAtMouseCursor,
	  },
	},

    -- shell

    -- Set default domain to WSL:Kali
    -- default_domain = 'WSL:Kali'

    -- Alternatively, explicitly define the startup command
    default_prog = {"wsl", "-d", "Kali-linux", "/bin/bash"}
    -- default_prog = {"kali"}
}
