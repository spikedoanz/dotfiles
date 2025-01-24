########################
## spike's nix config ##
########################
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ./cachix.nix ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Core system configuration
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
    extraModulePackages = [ 
      config.boot.kernelPackages.nvidia_x11
    ];
  };

  fileSystems."/media/hdd0" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g";
    options = [ "defaults" ];
  };

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        nvidia-vaapi-driver
      ];
    };
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    bluetooth.enable = true;
  };

  # Enable Docker with NVIDIA support
  virtualisation.docker.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # Font configuration
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono # Default monospace font
      noto-fonts # Fallback for sans-serif and serif
      noto-fonts-cjk-sans # For CJK characters
      noto-fonts-emoji # For emojis
      font-awesome # For icons
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" "Noto Sans Mono" ]; # Default to JetBrains Mono
        sansSerif = [ "JetBrains Mono" "Noto Sans" ]; # Fallback to Noto Sans
        serif = [ "JetBrains Mono" "Noto Serif" ]; # Fallback to Noto Serif
        emoji = [ "Noto Color Emoji" ]; # For emojis
      };

      hinting = {
        enable = true;
        style = "slight"; # Light hinting for better readability
      };

      subpixel = {
        rgba = "rgb"; # Subpixel rendering for LCD screens
        lcdfilter = "default"; # Default LCD filter
      };

      antialias = true; # Enable anti-aliasing
      useEmbeddedBitmaps = true; # Use embedded bitmaps in fonts
      allowBitmaps = true; # Allow bitmap fonts
    };
  };

  # Environment variables for font rendering
  environment.variables = {
    GDK_USE_XFT = "1"; # Enable Xft for GTK applications
    QT_XFT = "true"; # Enable Xft for Qt applications
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Auto-scale for high-DPI displays
    GDK_SCALE = "1"; # Scale factor for GTK applications
    GDK_DPI_SCALE = "1"; # DPI scaling for GTK applications
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Utils
    home-manager
    pulseaudio
    brightnessctl
    flameshot
    feh
    wmctrl
    picom
    udisks2
    usbutils
    ntfs3g
    mullvad-vpn
    lxappearance
    pavucontrol
    bluetuith

    # CUDA/OpenCL
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    cudaPackages.cudnn
    cudatoolkit
    ocl-icd
    opencl-headers
    clinfo

    # Gaming
    steam
    wineWowPackages.stable
    winetricks
    lutris

    # General
    bash zsh git ripgrep tree curl fzf
    zip unzip eza lsof htop ncdu xclip
    rofi pass gnupg pinentry-curses neovim
    yazi neofetch

    # Apps
    wezterm ghostty firefox syncthing
    zathura zed-editor nemo obsidian
    vscode ollama

    # Media
    ffmpeg gimp mpv obs-studio qbittorrent
    inkscape

    # Python (with CUDA support)
    (python312.withPackages (ps: with ps; [
      requests
      numpy
      pandas
      pillow
      pytorch-bin
      torchvision-bin
      jupyterlab
      matplotlib
      pip
      pyarrow
      selenium
      tiktoken
      bottle
      tinygrad
      manim
      opencv4
      nibabel
      flask
    ]))
    pyright

    # Development tools
    gcc clang cmake gnumake
    ghc julia elan
    sqlite
    obsidian

    qemu
    virt-manager

  ];

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    extraHosts = ''
    '';
  };

  security.rtkit.enable = true;

  # Services
  services = {
    logind = {
      lidSwitch = "ignore";
      extraConfig = ''
        HandleSuspendKey=ignore
        HandleHibernateKey=ignore
        HandleLidSwitch=ignore
        IdleAction=ignore
      '';
    };
    mullvad-vpn.enable = true;
    displayManager.defaultSession = "none+i3";
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    blueman.enable = true;

    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3;
        extraPackages = with pkgs; [
          i3status
          i3lock
        ];
      };
      xkb.layout = "us";
    };

    syncthing = {
      enable = true;
      user = "spike";
      dataDir = "/home/spike/Documents";
      configDir = "/home/spike/.config/syncthing";
      settings.gui.theme = "dark";
    };

    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      settings = {
        glx-no-stencil = true;
        glx-no-rebind-pixmap = true;
      };
    };

    dbus.enable = true;
    redshift = {
      enable = true;
      temperature.day = 5500;
      temperature.night = 3700;
    };
  };

  # Location and time
  location = {
    latitude = 40.7128;
    longitude = -74.0060;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix settings
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Programs
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glibc
        openssl
        libffi
      ];
    };
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
  users.users.spike = {
    isNormalUser = true;
    description = "spike";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
    shell = pkgs.bash;
  };
}
