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

  programs.bash= {
    enable = true;
    
    initExtra = ''
      PS1="\[\033[34m\]\W\[\033[0m\] § "
      eval "$(fzf --bash)"
      ssh-add -q ~/.ssh/gh
      export PATH="$HOME/.bin:$PATH"
    '';

    shellAliases = {
      # exa aliases (ensure exa is in home.packages)
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      l = "eza";
      daily="vim + ~/Global/Vault/daily/$(date +%Y-%m-%d).md";

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
