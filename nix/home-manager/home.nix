{ config, pkgs, ... }:

{
  home.username = "spike";
  home.homeDirectory = "/home/spike";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    xorg.xrandr
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "spikedoanz@gmail.com";
    userName = "spikedoanz";
  };

  xresources.properties = {
    "Xft.dpi" = 120;
  };

  home.sessionVariables = {
    GDK_SCALE = "1.25";
    GDK_DPI_SCALE = "1.25";
  };

  programs.zsh = {
    enable = true;
    
    initExtra = ''
      # Custom prompt
      PS1="%{%F{blue}%}%2~%{%f%} § "

      # FZF integration (make sure fzf is in home.packages)
      eval "$(fzf --zsh)"

      # Key bindings for command history navigation
      bindkey '^P' up-line-or-history
      bindkey '^N' down-line-or-history
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

      icat = "wezterm imgcat";
      v = "source .venv/bin/activate";
      gg = "git add . && git commit -m \"wp\" && git push origin $(git branch --show-current)";
      rebuild = "sudo nixos-rebuild switch";
      nixedit = "sudoedit /etc/nixos/configuration.nix";
    };
  };

  fonts.fontconfig.enable = true;        
}
