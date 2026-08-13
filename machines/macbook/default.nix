# machines/macbook/default.nix - Complete macbook configuration
# Everything for this machine lives in this folder.
{ pkgs, lib, config, ... }:

let
  dotfiles = "/Users/spike/.config/dotfiles";
  kanataConfigSource = ../../kanata.kbd;
  kanataConfig = pkgs.runCommand "kanata.kbd" {
    nativeBuildInputs = [ pkgs.kanata ];
  } ''
    kanata --check --cfg ${kanataConfigSource}
    cp ${kanataConfigSource} "$out"
  '';
in

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

  environment.systemPackages = with pkgs; [ home-manager kanata ];
  programs.zsh.enable = true;
  system.stateVersion = 5;

  # Security
  #security.pam.services.sudo_local.touchIdAuth = false;
  security.pam.services.sudo_local.enable = false;

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
  # KANATA (keyboard remapper)
  #############################################################################

  # Kanata must run as root on macOS to intercept physical keyboard events.
  # Keep it in the logged-in user's launchd domain so macOS can request Input
  # Monitoring permission through the normal System Settings UI. The nixpkgs
  # package is built without the security-sensitive `cmd` action.
  security.sudo.extraConfig = ''
    spike ALL=(root) NOPASSWD: ${pkgs.kanata}/bin/kanata
  '';

  launchd.user.agents.kanata.serviceConfig = {
    Label = "org.spike.kanata";
    ProgramArguments = [
      "/usr/bin/sudo"
      "${pkgs.kanata}/bin/kanata"
      "--cfg"
      "${kanataConfig}"
      "--no-wait"
    ];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    ThrottleInterval = 3;
    StandardOutPath = "/tmp/kanata.out.log";
    StandardErrorPath = "/tmp/kanata.err.log";
  };

  #############################################################################
  # HOMEBREW (only for things not in nixpkgs)
  #############################################################################

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # Homebrew 5 deprecated `brew bundle --cleanup`; it now exits nonzero
      # when unmanaged packages exist and prevents Home Manager activation.
      cleanup = "none";
    };

    brews = [
      "chezscheme"  # needed for idris
      "agda"
      "zsh-autosuggestions" "zsh-syntax-highlighting"
    ];

    casks = [
      "emacs-app"
      "visual-studio-code"
      "codex"
      "ghostty@tip"      # tip build not in nixpkgs
    ];
  };

  #############################################################################
  # HOME-MANAGER
  #############################################################################

  home-manager.users.spike = { pkgs, config, ... }:
  let
    link = config.lib.file.mkOutOfStoreSymlink;
  in {
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
      bitwarden-cli

      # Dev tools
      gh git-lfs gnupg lazygit
      cmake gnumake

      # Languages
      python312 uv ruff pyright
      nodejs_22
      go
      elan

      # Media
      ffmpeg imagemagick # image / video editing
      mpv yt-dlp

      # TUI apps
      visidata  # data viewer
      taskwarrior3
      pkgs.tmux

      # Tmux plugins (load via run-shell in tmux.conf)
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.tmux-fzf

      # System tools
      colima scrcpy rclone
      rlwrap

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

    xdg.configFile."nvim/init.lua".source = link "${dotfiles}/config/nvim/init.lua";
    xdg.configFile."nvim/lazy-lock.json".source = link "${dotfiles}/config/nvim/lazy-lock.json";
    xdg.configFile."nvim/latex-unicoder/autoload/unicoder.vim".source = link "${dotfiles}/config/nvim/latex-unicoder/autoload/unicoder.vim";
    xdg.configFile."nvim/latex-unicoder/plugin/unicoder.vim".source = link "${dotfiles}/config/nvim/latex-unicoder/plugin/unicoder.vim";

    #--------------------------------------------------------------------------
    # Aerospace (tiling window manager)
    #--------------------------------------------------------------------------
    home.file.".aerospace.toml".source = link "${dotfiles}/config/aerospace/.aerospace.toml";

    #--------------------------------------------------------------------------
    # Kanata (the service consumes the immutable Nix-store copy)
    #--------------------------------------------------------------------------
    xdg.configFile."kanata/kanata.kbd".source = kanataConfig;

    #--------------------------------------------------------------------------
    # Ghostty (terminal)
    #--------------------------------------------------------------------------
    xdg.configFile."ghostty/config".source = link "${dotfiles}/config/ghostty/config";
    xdg.configFile."ghostty/cursor.glsl".source = link "${dotfiles}/config/ghostty/cursor.glsl";

    #--------------------------------------------------------------------------
    # Tmux
    #--------------------------------------------------------------------------
    xdg.configFile."tmux/tmux.conf".source = link (dotfiles + "/config/tmux/tmux.conf");

    #--------------------------------------------------------------------------
    # Claude Code
    #--------------------------------------------------------------------------
    xdg.configFile."claude/settings.json".source = link "${dotfiles}/config/claude/settings.json";
    xdg.configFile."claude/statusline.sh".source = link "${dotfiles}/config/claude/statusline.sh";

    #--------------------------------------------------------------------------
    # Zsh
    #--------------------------------------------------------------------------
    home.file.".zshrc".source = link "${dotfiles}/config/sh/.zshrc";

    #--------------------------------------------------------------------------
    # Local helper scripts
    #--------------------------------------------------------------------------
    home.file.".bin/nix-repair-boot".source = link "${dotfiles}/bin/nix-repair-boot";
    home.file.".bin/sol-no-cache".source = link "${dotfiles}/bin/sol-no-cache";
  };
}
