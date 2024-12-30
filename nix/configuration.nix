########################
## spike's nix config ##
########################
{ config, pkgs, ... }:
{
  imports = [./hardware-configuration.nix];
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services = {
    printing.enable = true;
    xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3;
        extraPackages = with pkgs; [
          i3status
          i3lock
        ];
      };
      xkb = {
        layout = "us";
        variant = "";
        options = "ctrl:nocaps,terminate:ctrl_alt_bksp,lv3:ralt_switch,altwin:swap_alt_win";
      };
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    pipewire = { enable = true; alsa = { enable = true; support32Bit = true; }; pulse.enable = true; };
  };

  users.users.spike = {
    isNormalUser = true;
    description = "spike";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.neovim = { enable = true; defaultEditor = true; vimAlias = true; };
  nixpkgs.config.allowUnfree = false;
  environment = {
    systemPackages = with pkgs; [
      # Nix utils
      home-manager

      # General
      zsh             # shell 
      git             # version control tool
      ripgrep         # better grep
      tree            # file tree visualizer
      curl            # download tool
      wget            # other download tool
      fzf             # fuzzy file searching
      zip             # self
      unzip           #      explanatory
      eza             # better "ls"
      lsof            # list open files
      htop            # system utilization tool
      ncdu            # disk usage monitoring
      xclip           # clipboard
      flameshot       # screenshot tool
      rofi            # window switcher util tool
      pulseaudio      # audiomanager
      brightnessctl   # brightness controls

    
      # Apps
      wezterm         # terminal emulator
      firefox         # browser
      syncthing       # file syncing
      # Media
      ffmpeg          # video/gif/etc editor
      gimp            # image editor
      mpv             # video viewer
      obs-studio      # screen recording
      qbittorrent     # file "sharing"
      inkscape        # svg editor


      # Python
      (python311.withPackages (ps: with ps; [
        requests
        datasets
        numpy
        pandas
        pillow
        torch
        pip
        pyarrow
        selenium
        tinygrad
      ]))

      # C
      cmake
      gnumake
      clang
      extra-cmake-modules
      pkg-config
      gcc
      
      # Haskell
      ghc
    ];
    pathsToLink = [ "/libexec" ];
  };
  fonts.packages = with pkgs; [ nerdfonts ];
  system.stateVersion = "24.11";
}
