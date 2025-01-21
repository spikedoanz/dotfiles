########################
## spike's nix config ##
########################
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Core system configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  # Boot and hardware
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; # Better for laptops
    powertop.enable = true; # Optimize power usage
  };

  services = {
    tlp = {
      enable = true; # TLP for power management
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
    thermald.enable = true; # Thermal management
    auto-cpufreq.enable = true; # Auto CPU frequency scaling
    fstrim.enable = true; # SSD trimming
    smartd.enable = true; # SMART monitoring
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;

    # Block distracting sites
    extraHosts = ''
      127.0.0.1 reddit.com
      127.0.0.1 www.reddit.com
      127.0.0.1 youtube.com
      127.0.0.1 www.youtube.com
    '';
  };

  # Audio
  hardware.pulseaudio.enable = false; # Disable PulseAudio in favor of PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true; # PipeWire as a PulseAudio replacement
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Locale and time
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # X11 and desktop environment
  services.libinput.enable = true; # Touchpad support
  services.libinput.touchpad.disableWhileTyping = true;
  services.xserver = {
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
  services.displayManager.defaultSession = "none+i3";

  # Drive automounting
  services.devmon.enable = true; # Automount removable drives
  services.gvfs.enable = true; # GNOME Virtual File System for automounting
  services.udisks2.enable = true; # Disk management service

  # System services
  services.printing.enable = true; # Enable CUPS for printing
  services.syncthing = {
    enable = true;
    user = "spike";
    dataDir = "/home/spike/Documents";
    configDir = "/home/spike/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings.gui.theme = "dark";
  };

  # Display compositor
  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
    settings = {
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
    };
  };

  # System maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  system.autoUpgrade.enable = true;

  # System packages
  environment = {
    systemPackages = with pkgs; [
      # System utils
      home-manager    # config manager
      brightnessctl   # brightness manager
      flameshot       # screenshot tool
      feh             # background image manager
      wmctrl          # window manager manager
      picom           # compositor
      udisks2         # disk management
      usbutils        # USB utilities
      mullvad-vpn     # VPN client

      # General
      bash            # shell 
      zsh             # backup shell
      git             # version control tool
      ripgrep         # better grep
      tree            # file tree visualizer
      curl            # download tool
      fzf             # fuzzy file searching
      zip unzip       # compression tools
      eza             # better "ls"
      lsof            # list open files
      htop            # system utilization tool
      ncdu            # disk usage monitoring
      xclip           # clipboard
      rofi            # window switcher util tool
      pass            # password manager
      gnupg           # private key creator
      pinentry-curses # in terminal prompts
      neovim          # editor number one
      yazi            # tui file browser

      # Apps
      wezterm         # terminal emulator
      ghostty         # other terminal emulator
      firefox         # browser
      syncthing       # file syncing
      zathura         # pdf reader
      zed-editor      # editor number two
      nemo            # gui file browser

      # Media
      ffmpeg          # video/gif/etc editor
      gimp            # image editor
      mpv             # video viewer
      obs-studio      # screen recording
      qbittorrent     # file "sharing"
      inkscape        # svg editor
      zotero          # reference manager
      qemu            # virtualization
      virt-manager    # VM manager
      lutris

      # Python
      (python312.withPackages (ps: with ps; [
        requests
        datasets
        numpy
        pandas
        pillow
        torch
        pip
        pyarrow
        selenium
        tiktoken
        bottle
        tinygrad
        matplotlib
        build
        twine
        nibabel
      ]))
      pyright

      # C
      gcc
      clang
      clang-tools
      cmake
      gnumake
      extra-cmake-modules
      gdb

      # Haskell
      ghc

      # Julia
      julia

      # Lean4
      lean4
      elan
      vscode
    ];
    pathsToLink = [ "/libexec" ];
  };
  fonts.packages = with pkgs; [ nerdfonts ];

  # VM
  virtualisation.libvirtd.enable = true; # Enable libvirt for VMs
  virtualisation.spiceUSBRedirection.enable = true; # USB redirection for VMs

  programs = {
    virt-manager.enable = true; # GUI for managing VMs
    nix-ld.enable = true; # Enable running dynamically linked libraries
    ssh.startAgent = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  # User configuration
  programs.zsh.enable = true;
  users.users.spike = {
    isNormalUser = true;
    description = "spike";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.bash;
    packages = with pkgs; [];
  };
}
