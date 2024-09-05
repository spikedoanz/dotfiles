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
c.color_scheme = 'Catppuccin Mocha'
c.use_fancy_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true

return c
