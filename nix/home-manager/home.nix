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
  home.packages = with pkgs; [];
  fonts.fontconfig.enable = true;        
}
