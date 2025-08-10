{ config, pkgs, ... }:

{
  home.username = "spike";
  home.homeDirectory = "/home/spike";
  home.stateVersion = "25.05";

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
      PS1='\[\033[32m\]\u@\h\[\033[0m\]:\[\033[36m\]\w\[\033[0m\] § '
      if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
          fi
      if [[ ! -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]]; then
        ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
      fi
      source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
      ssh-add -q ~/.ssh/gh 2>/dev/null
      source ~/.env

      PS1="\[\033[34m\]\W\[\033[0m\] § "
      eval "$(fzf --bash)"
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
      rebuild = "sudo nixos-rebuild switch";
      nixedit = "sudoedit /etc/nixos/configuration.nix";

      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gb = "git branch";
      gk = "git checkout";
    };
  };


  fonts.fontconfig.enable = true;        
}
