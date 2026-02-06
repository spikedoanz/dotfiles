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

  # Security
  security.pam.enableSudoTouchIdAuth = false;

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

    taps = [ "wpmed92/dawn" ];
    brews = [
      "chezscheme"  # needed for idris
      "dawn"        # WebGPU
    ];

    casks = [
      "claude-code"
      "ghostty@tip"      # tip build not in nixpkgs
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
      ripgrep fzf eza bat tree curl jq htop
      coreutils findutils gawk
      wget aria2 croc magic-wormhole
      dust tokei ascii neofetch

      # Dev tools
      gh git-lfs gnupg lazygit
      cmake gnumake
      marksman  # linters/LSPs

      # Languages
      python312 uv ruff pyright
      nodejs_22
      go
      typst  # typesetting
      elan coq # proof assistants
      # coq elan stack  # proof assistants

      # Shells
      fish nushell

      # Editors
      emacs

      # Media
      ffmpeg imagemagick # image / video editing
      mpv yt-dlp
      zathura  # PDF viewer

      # TUI apps
      yazi  # file manager
      visidata  # data viewer
      newsboat  # RSS
      hledger  # accounting
      taskwarrior3
      watson  # time tracker

      # LLM agents
      codex

      # System tools
      colima scrcpy rclone
      android-tools  # adb, fastboot
      pass  # password-store
      rlwrap
      cue

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
    xdg.configFile."nvim/latex-unicoder/autoload/unicoder.vim".source = ../../config/nvim/latex-unicoder/autoload/unicoder.vim;
    xdg.configFile."nvim/latex-unicoder/plugin/unicoder.vim".source = ../../config/nvim/latex-unicoder/plugin/unicoder.vim;

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
      plugins = with pkgs.tmuxPlugins; [
        sensible
        tmux-fzf
        tmux-thumbs
        tmux-floax
      ];
      extraConfig = builtins.readFile ../../config/tmux/tmux.conf;
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
