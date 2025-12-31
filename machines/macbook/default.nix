# machines/macbook/default.nix - Complete macbook configuration
# Everything for this machine lives in this folder.
{ pkgs, lib, ... }:

{
  #############################################################################
  # SYSTEM (nix-darwin)
  #############################################################################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [ home-manager ];
  programs.zsh.enable = true;
  system.stateVersion = 5;

  #############################################################################
  # MACOS SETTINGS
  #############################################################################

  system.defaults = {
    # Dock
    dock.autohide = true;
    dock.show-recents = false;
    dock.mru-spaces = false;  # don't rearrange spaces based on recent use

    # Finder
    finder.FXPreferredViewStyle = "Nlsv";  # list view

    # Keyboard - fast repeat
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;  # key repeat instead of accent menu

    # Trackpad
    trackpad.TrackpadRightClick = true;

    # Misc
    NSGlobalDomain.AppleInterfaceStyle = "Dark";  # dark mode
  };

  # User
  system.primaryUser = "spike";
  users.users.spike = {
    shell = pkgs.zsh;
    home = "/Users/spike";
  };

  #############################################################################
  # HOMEBREW (only for things not in nixpkgs)
  #############################################################################

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [];
    brews = [];

    casks = [
      "claude-code"
      "ghostty@tip"      # tip build not in nixpkgs
      "mactex"           # large LaTeX distribution
    ];
  };

  #############################################################################
  # HOME-MANAGER
  #############################################################################

  home-manager.users.spike = { pkgs, ... }: {
    home.username = "spike";
    home.homeDirectory = "/Users/spike";
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    #--------------------------------------------------------------------------
    # Packages
    #--------------------------------------------------------------------------
    home.packages = with pkgs; [
      # Core CLI
      ripgrep fzf eza tree curl jq htop ncdu
      coreutils findutils gnused gawk

      # Dev tools
      uv gh git-lfs gnupg
      cmake gnumake

      # Languages
      python312
      nodejs_22

      # Media
      ffmpeg imagemagick

      # System tools
      colima scrcpy rclone
      android-tools  # adb, fastboot

      # Window manager
      aerospace
    ];

    #--------------------------------------------------------------------------
    # Git
    #--------------------------------------------------------------------------
    programs.git = {
      enable = true;
      settings.user = {
        name = "spikedoanz";
        email = "spikedoanz@gmail.com";
      };
    };

    #--------------------------------------------------------------------------
    # Neovim
    #--------------------------------------------------------------------------
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;

      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.lua p.python p.markdown p.markdown_inline
          p.javascript p.typescript p.haskell p.nix p.json p.yaml p.bash
        ]))
      ];

      extraPackages = with pkgs; [
        pyright typescript-language-server lua-language-server nil
        ripgrep fzf
      ];
    };

    xdg.configFile."nvim/init.lua".source = ../../config/nvim/init.lua;
    xdg.configFile."nvim/lazy-lock.json".source = ../../config/nvim/lazy-lock.json;

    #--------------------------------------------------------------------------
    # Aerospace (tiling window manager)
    #--------------------------------------------------------------------------
    home.file.".aerospace.toml".source = ../../config/aerospace/.aerospace.toml;

    #--------------------------------------------------------------------------
    # Ghostty (terminal)
    #--------------------------------------------------------------------------
    xdg.configFile."ghostty/config".source = ../../config/ghostty/config;
    xdg.configFile."ghostty/cursor.glsl".source = ../../config/ghostty/cursor.glsl;

    #--------------------------------------------------------------------------
    # Tmux
    #--------------------------------------------------------------------------
    programs.tmux = {
      enable = true;
      prefix = "C-s";
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      historyLimit = 1000000;
      mouse = true;
      keyMode = "vi";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        tmux-fzf
        tmux-thumbs
        tmux-floax
      ];

      extraConfig = ''
        bind-key C-a last-window #KB: tmux | C-s | - | C-a | Last window
        bind-key e send-prefix #KB: tmux | C-s | - | e | Send prefix

        # Status bar
        set -g status-position bottom
        set -g status-bg default
        set -g status-fg white
        set -g status-style bold
        set -g status-left ""
        set -g status-right "#[fg=white,bold]#S "
        set -g status-right-length 50
        set -g status-left-length 20

        # Copy mode
        bind-key -T copy-mode-vi v send -X begin-selection #KB: tmux | none | copy | v | Begin selection
        bind-key -T copy-mode-vi y send -X copy-selection

        # Pane navigation
        bind h select-pane -L #KB: tmux | C-s | - | h | Select pane left
        bind j select-pane -D #KB: tmux | C-s | - | j | Select pane down
        bind k select-pane -U #KB: tmux | C-s | - | k | Select pane up
        bind l select-pane -R #KB: tmux | C-s | - | l | Select pane right

        # Pane resizing
        bind -r H resize-pane -L 5 #KB: tmux | C-s | - | H | Resize pane left
        bind -r J resize-pane -D 5 #KB: tmux | C-s | - | J | Resize pane down
        bind -r K resize-pane -U 5 #KB: tmux | C-s | - | K | Resize pane up
        bind -r L resize-pane -R 5 #KB: tmux | C-s | - | L | Resize pane right

        # Window status
        setw -g window-status-current-format " #I:#W#F "
        setw -g window-status-format " #I:#W#F "
        setw -g window-status-style "fg=white,bg=default"
        setw -g window-status-current-style "fg=black,bg=white,bold"

        set-option -g allow-rename off

        # Clipboard
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy" #KB: tmux | none | copy | y | Copy to clipboard

        # Plugin settings
        set -g @thumbs-key Space #KB: tmux | C-s | - | Space | Thumbs (copy hints)
        set -g @floax-change-path "false"
        set -g @floax-width "90%"
        set -g @floax-height "100%"
      '';
    };

    #--------------------------------------------------------------------------
    # Claude Code
    #--------------------------------------------------------------------------
    xdg.configFile."claude/settings.json".source = ../../config/claude/settings.json;
    xdg.configFile."claude/statusline.sh".source = ../../config/claude/statusline.sh;

    #--------------------------------------------------------------------------
    # Zsh
    #--------------------------------------------------------------------------
    home.file.".zshrc".source = ../../config/sh/.zshrc;
  };
}
