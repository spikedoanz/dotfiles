local wezterm = require 'wezterm'

-- Prelude
local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end
local act = wezterm.action

-- Theme management
local themes = {
  --'Catppuccin Mocha',
  'Solarized (light) (terminal.sexy)',
  'Solarized (dark) (terminal.sexy)',
}

-- Initialize current theme index
local current_theme_index = 1
c.color_scheme = themes[current_theme_index]

-- Create theme cycling action
local function cycle_theme(delta)
  return wezterm.action_callback(function(window, pane)
    current_theme_index = current_theme_index + delta
    if current_theme_index > #themes then
      current_theme_index = 1
    elseif current_theme_index < 1 then
      current_theme_index = #themes
    end
    
    window:set_config_overrides({
      color_scheme = themes[current_theme_index]
    })
    
    -- Show theme name in toast notification
    window:toast_notification('WezTerm', 'Theme: ' .. themes[current_theme_index], nil)
  end)
end

-- Keybinding
c.keys = {
  -- Theme cycling
  { key = '`', mods = 'ALT', action = cycle_theme(1) },
  -- Existing keybindings
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
  { key = '4', mods = 'ALT', action = act.SendString '\x05' },
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
c.use_fancy_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true
c.max_fps = 144

return c
