local wezterm = require 'wezterm'

-- Prelude
local c = {}
if wezterm.c_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end

local act = wezterm.action

-- Keys
c.keys = {
  { key="-", mods="ALT", action=act.SplitVertical({ domain = "CurrentPaneDomain" }), },
  { key="=", mods="ALT", action=act.SplitHorizontal({ domain = "CurrentPaneDomain" }), },
  { key="Q", mods="ALT", action=act.CloseCurrentPane({ confirm = true }) },
  { key="H", mods="ALT", action=act.ActivateTabRelative(-1) },
  { key="L", mods="ALT", action=act.ActivateTabRelative(1) },
  { key="h", mods="ALT", action=act.ActivatePaneDirection("Prev")},
  { key="l", mods="ALT", action=act.ActivatePaneDirection("Next")},
}

-- Appearance
c.font = wezterm.font('JetBrainsMono Nerd Font')
c.font_size = 12
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

c.colors = {
  foreground = "#cdd6f4",
  background = "#1e1e2e",
  cursor_bg = "#f5e0dc",
  cursor_fg = "#1e1e2e",
  cursor_border = "#f5e0dc",
  selection_fg = "#1e1e2e",
  selection_bg = "#f5e0dc",
  scrollbar_thumb = "#45475a",
  split = "#45475a",
  
  ansi = {
    "#45475a",
    "#f38ba8",
    "#a6e3a1",
    "#f9e2af",
    "#89b4fa",
    "#f5c2e7",
    "#94e2d5",
    "#bac2de",
  },
  brights = {
    "#585b70",
    "#f38ba8",
    "#a6e3a1",
    "#f9e2af",
    "#89b4fa",
    "#f5c2e7",
    "#94e2d5",
    "#a6adc8",
  },
  indexed = {
    [16] = "#fab387",
    [17] = "#f5e0dc",
  },
  -- Tab bar colors
  tab_bar = {
    background = "#1e1e2e",
    active_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#cdd6f4",
    },
    inactive_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#6c7086",
    },
    inactive_tab_hover = {
      bg_color = "#1e1e2e",
      fg_color = "#a6adc8",
    },
    new_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#6c7086",
    },
    new_tab_hover = {
      bg_color = "#1e1e2e",
      fg_color = "#a6adc8",
    },
  }
}
c.use_fancy_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true
c.window_background_opacity = 1.0

return c
