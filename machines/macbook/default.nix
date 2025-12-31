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

  # User
  users.users.spike = {
    shell = pkgs.bash;
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
    # Bash
    #--------------------------------------------------------------------------
    programs.bash = {
      enable = true;
      initExtra = ''
        PS1="\[\033[34m\]\W\[\033[0m\] § "
        eval "$(fzf --bash)"
        export PATH="$HOME/.bin:$PATH"
      '';
      shellAliases = {
        ls = "eza"; ll = "eza -l"; la = "eza -a"; l = "eza";
        ga = "git add"; gc = "git commit -m"; gp = "git push";
        gl = "git pull"; gb = "git branch"; gk = "git checkout";
        v = "source .venv/bin/activate";
        rebuild = "darwin-rebuild switch --flake ~/.config/dotfiles";
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
        bind-key C-a last-window
        bind-key e send-prefix

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
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi y send -X copy-selection

        # Pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Pane resizing
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # Window status
        setw -g window-status-current-format " #I:#W#F "
        setw -g window-status-format " #I:#W#F "
        setw -g window-status-style "fg=white,bg=default"
        setw -g window-status-current-style "fg=black,bg=white,bold"

        set-option -g allow-rename off

        # Clipboard
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"

        # Plugin settings
        set -g @thumbs-key Space
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
