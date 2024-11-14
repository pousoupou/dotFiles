-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font("ComicShannsMono Nerd Font")
config.font_size = 14

-- config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 8

config.initial_cols = 100
config.initial_rows = 30

config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.colors = {
    tab_bar = {
        background = "#1e1e2e",

        active_tab = {
            bg_color = "#6c7086",
            fg_color = "#cdd6f4",
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
        },

        inactive_tab = {
            bg_color = "#1e1e2e",
            fg_color = "#f2cdcd",
        },

        new_tab = {
            bg_color = "#1e1e2e",
            fg_color = "#f2cdcd",
        },

        new_tab_hover = {
            bg_color = "#6c7086",
            fg_color = "#1e1e2e",
        },
    },
}

-- and finally, return the configuration to wezterm
return config
