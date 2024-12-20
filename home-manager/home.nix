{ config, pkgs, ... }:

{

  home.username = "spike";
  home.homeDirectory = "/home/spike";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "spikedoanz@gmail.com";
    userName = "spikedoanz";
  };

  programs.zsh = {
    enable = true;
    
    initExtra = ''
      # Custom prompt
      PS1="%{%F{blue}%}%2~%{%f%} § "

      # FZF integration (make sure fzf is in home.packages)
      eval "$(fzf --zsh)"
    '';

    shellAliases = {
      # exa aliases (ensure exa is in home.packages)
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      l = "eza";

      # Clipboard aliases
      copy = "xclip -selection clipboard";
      paste = "xclip -selection clipboard -o";

      # Your custom shortcuts
      icat = "wezterm imgcat";
      v = "source .venv/bin/activate";
      gg = "git add . && git commit -m \"wp\" && git push origin $(git branch --show-current)";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ [ "xkb" "us" ] ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "ctrl:nocaps" "altwin:swap_alt_win" ];
      show-all-sources = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "pink";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      font-antialiasing = "rgba";
      gtk-enable-primary-paste = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      panel-run-dialog = [ "<Super>p" ];
      maximize = [ "<Super>m" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      toggle-fullscreen = [ "F11" ];
      # Disable some default keybindings
      activate-window-menu = lib.gvariant.mkArray lib.gvariant.type.string [];
      begin-move = lib.gvariant.mkArray lib.gvariant.type.string [];
      begin-resize = lib.gvariant.mkArray lib.gvariant.type.string [];
      cycle-windows = lib.gvariant.mkArray lib.gvariant.type.string [];
      cycle-windows-backward = lib.gvariant.mkArray lib.gvariant.type.string [];
      minimize = lib.gvariant.mkArray lib.gvariant.type.string [];
      toggle-maximized = lib.gvariant.mkArray lib.gvariant.type.string [];
      unmaximize = lib.gvariant.mkArray lib.gvariant.type.string [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      control-center = [ "<Shift><Super>slash" ];
      logout = [ "<Shift><Super>Escape" ];
      search = [ "<Super>space" ];
      www = [ "<Shift><Super>b" ];
      # Disable some default shortcuts
      help = lib.gvariant.mkArray lib.gvariant.type.string [];
      magnifier = lib.gvariant.mkArray lib.gvariant.type.string [];
      magnifier-zoom-in = lib.gvariant.mkArray lib.gvariant.type.string [];
      magnifier-zoom-out = lib.gvariant.mkArray lib.gvariant.type.string [];
      screensaver = lib.gvariant.mkArray lib.gvariant.type.string [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "wezterm";
      name = "Launch Terminal";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.54263565891472876;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      accel-profile = "flat";
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/peripherals/pointingstick" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/notifications" = {
      show-banners = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:maximize,close";
    };
  };

  home.packages = with pkgs; [];
  fonts.fontconfig.enable = true;        
}
