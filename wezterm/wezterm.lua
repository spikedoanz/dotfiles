local wezterm = require 'wezterm'

-- Prelude
local c = {}
if wezterm.c_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end

local act = wezterm.action

-- Keybinding
c.keys = {
  -- window bindings
  { key="-", mods="ALT", action=act.SplitVertical({ domain = "CurrentPaneDomain" }), },
  { key="=", mods="ALT", action=act.SplitHorizontal({ domain = "CurrentPaneDomain" }), },
  { key="Q", mods="ALT", action=act.CloseCurrentPane({ confirm = true }) },
  { key="H", mods="ALT", action=act.ActivateTabRelative(-1) },
  { key="L", mods="ALT", action=act.ActivateTabRelative(1) },
  { key="h", mods="ALT", action=act.ActivatePaneDirection("Prev")},
  { key="l", mods="ALT", action=act.ActivatePaneDirection("Next")},
  -- vim bindings
  { key = 'b', mods = 'ALT', action = act.SendString '\x1bb' },
  { key = 'w', mods = 'ALT', action = act.SendString '\x1bf' },
  { key = '0', mods = 'ALT', action = act.SendString '\x01' },
  { key = '4', mods = 'ALT', action = act.SendString '\x05' }, -- alias for $, but is the same thing
  { key = '$', mods = 'ALT', action = act.SendString '\x05' },
  { key = 'd', mods = 'ALT', action = act.SendString '\x17' },
  { key = 'D', mods = 'ALT', action = act.SendString '\x0b' },
  { key = 'x', mods = 'ALT', action = act.SendString '\x1b[3~' },
}

-- Appearance
c.font = wezterm.font('JetBrainsMono Nerd Font Mono')
c.font_size = 24
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
c.enable_kitty_graphics = false
c.enable_sixel = true
c.color_scheme = 'Catppuccin Mocha'
c.use_fancy_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true
c.max_fps = 144

return c
