#######################
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

  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps,terminate:ctrl_alt_bksp,lv3:ralt_switch,altwin:swap_alt_win";
  };
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  nixpkgs.config.allowUnfree = false;
  # nix search $package-name
  environment.systemPackages = with pkgs; [
    # Apparently you have to do this????
    #nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    #nix-channel --update    
    home-manager

    # General
    git
    neovim
    ripgrep
    tree
    curl
    wget
    fzf
    zip
    unzip
    eza
    lsof
    htop
    ncdu
    xclip
    flameshot

    # Media
    ffmpeg
    gimp
    mpv
    obs-studio
    qbittorrent
    inkscape

    # Dev
    (python311.withPackages (ps: with ps; [
	requests
	numpy
	pandas
	pillow
	pip
	pyarrow
	selenium
	tinygrad
	pyright
    ]))
    pyright
    zig
    go

    # Apps
    wezterm
    gnome-tweaks
    zed-editor
    gnomeExtensions.forge
    ledger
  ];
  environment.variables.EDITOR = "nvim";

  fonts.packages = with pkgs; [ nerdfonts ];

  system.stateVersion = "unstable"; # Did you read the comment?
}
