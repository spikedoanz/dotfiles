local wezterm = require 'wezterm'

return {
  font = wezterm.font('JetBrainsMono Nerd Font'),
  font_size = 12,
  
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  
  colors = {
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
  },
  
  -- WezTerm doesn't have a direct equivalent to Alacritty's option_as_alt
  -- You might need to adjust your key bindings separately
  
  -- WezTerm uses a different method for search highlighting
  -- You may need to customize this further if you want exact Alacritty behavior
  
  -- Additional WezTerm-specific options you might want to adjust:
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 1.0,
}
