----------------------------
-- spike's wezterm config --
----------------------------

local wezterm = require 'wezterm'
local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
  c:set_strict_mode(true)
end
local act = wezterm.action

-- Theme switching
local themes = {
    'Rosé Pine (base16)',
    'Rosé Pine Dawn (base16)',
--  'GruvboxDark',
--  'GruvboxLight',
--  'catppuccin-mocha',
--  'catppuccin-latte',
}

local current_theme_index = 1
local last_switch_time = 0
c.color_scheme = themes[current_theme_index]
c.front_end = "WebGpu"
local function cycle_theme()
  return wezterm.action_callback(function(window, pane)
    local current_time = os.time()
    if current_time - last_switch_time < 0.1 then
      return
    end
    last_switch_time = current_time
    current_theme_index = current_theme_index + 1
    if current_theme_index > #themes then
      current_theme_index = 1
    end
    window:set_config_overrides({
      color_scheme = themes[current_theme_index]
    })
  end)
end

c.adjust_window_size_when_changing_font_size = false

-- Keybinding
c.keys = {
  { key = 'm', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
  { key = 'h', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
  { key = 'l', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
  { key = '-', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
  { key = '=', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
  --------------------------------------------------------------------------------------------
  { key = "-", mods = "CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "=", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Theme cycling
  { key = 'T', mods = 'ALT', action = cycle_theme() },
  -- Split management
  { key = "d", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  -- Window focus (hjkl)
  { key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },
  -- Window resizing (HJKL)
  { key = "H", mods = "CMD", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "CMD", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "CMD", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "CMD", action = act.AdjustPaneSize({ "Right", 5 }) },
  -- Select mode
  { key = 'v', mods = 'ALT', action = wezterm.action.ActivateCopyMode, },
  { key = 'u', mods = 'ALT', action = act.CopyMode 'ClearPattern' },
}
-- Appearance
-- c.font = wezterm.font('JetBrainsMono Nerd Font Mono')
c.font_size = 20
c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
c.use_fancy_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true
c.enable_wayland = false
return c
