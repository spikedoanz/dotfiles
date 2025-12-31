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
      # Core
      ripgrep fzf eza tree curl jq
      # Dev
      uv gh
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

    xdg.configFile."nvim/init.lua".source = ./config/nvim/init.lua;
    xdg.configFile."nvim/lazy-lock.json".source = ./config/nvim/lazy-lock.json;

    #--------------------------------------------------------------------------
    # Aerospace (tiling window manager)
    #--------------------------------------------------------------------------
    home.file.".aerospace.toml".source = ./config/aerospace/.aerospace.toml;

    #--------------------------------------------------------------------------
    # Ghostty (terminal)
    #--------------------------------------------------------------------------
    xdg.configFile."ghostty/config".source = ./config/ghostty/config;
    xdg.configFile."ghostty/cursor.glsl".source = ./config/ghostty/cursor.glsl;

    #--------------------------------------------------------------------------
    # Tmux
    #--------------------------------------------------------------------------
    home.file.".tmux.conf".source = ./config/tmux/tmux.conf;
    xdg.configFile."tmux".source = ./config/tmux;

    #--------------------------------------------------------------------------
    # Claude Code
    #--------------------------------------------------------------------------
    xdg.configFile."claude/settings.json".source = ./config/claude/settings.json;
    xdg.configFile."claude/statusline.sh".source = ./config/claude/statusline.sh;

    #--------------------------------------------------------------------------
    # Zsh
    #--------------------------------------------------------------------------
    home.file.".zshrc".source = ./config/sh/.zshrc;
  };
}
