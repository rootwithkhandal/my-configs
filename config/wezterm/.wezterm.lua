-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.colors = {
    foreground = "#C6C8D1",
    background = "#161821",
    cursor_bg = "#91ACD1",
    cursor_border = "#91ACD1",
    cursor_fg = "#91ACD1",
    selection_bg = "#1E2132",
    selection_fg = "#C6C8D1",
    ansi = { "#1E2132", "#E27878", "#B4BE82", "#E2A478", "#84A0C6", "#A093C7", "#89B8C2", "#E6E6E6" },
    brights = { "#6B7089", "#E98989", "#C0CA8E", "#E9B189", "#91ACD1", "#ADA0D3", "#95C4CE", "#D2D4DE" },
}

config.font = wezterm.font("JetbrainsMono Nerd Font")
config.font_size = 12

config.enable_tab_bar = false

config.window_decorations = "NONE"
config.window_background_opacity = 0.95
-- config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm
return config
