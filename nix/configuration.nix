########################
## spike's nix config ##
########################
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ./cachix.nix];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Core system configuration
  system.stateVersion = "unstable";
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
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

  hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false;                        # change to true when this is stable
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
      pulseaudio.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [
      # Utils
      home-manager    # config manager
      pulseaudio      # audio manager
      brightnessctl   # brightness manager
      flameshot       # screenshot tool
      feh             # background image manager
      wmctrl          # window manager manager
      picom           # compositor
      cudaPackages.cudatoolkit
      udisks2
      usbutils
      ntfs3g
      mullvad-vpn

      # cuda
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cupti
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_nvtx
      cudaPackages.tensorrt
      cudaPackages.cudnn
      cudatoolkit
      linuxPackages.nvidia_x11
      libGLU libGL
      xorg.libXi xorg.libXmu freeglut
      xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr
      zlib
      nvtopPackages.nvidia

      # Gaming
      steam
      wineWowPackages.stable
      winetricks
      lutris

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
      ghostty
      firefox         # browser
      syncthing       # file syncing
      zathura         # pdf reader
      zed-editor      # editor number two
      nemo            # gui file browser
      obsidian

      # Media
      ffmpeg          # video/gif/etc editor
      gimp            # image editor
      mpv             # video viewer
      obs-studio      # screen recording
      qbittorrent     # file "sharing"
      inkscape        # svg editor

      # Python
      (python312.withPackages (ps: with ps; [
        requests
        datasets
        numpy
        pandas
        pillow
        torch
        torchvision
        matplotlib
        pip
        pyarrow
        selenium
        tiktoken
        bottle
        tinygrad
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
    ];
    pathsToLink = [ "/libexec" ];
    sessionVariables = {
        CUDA_PATH = "${pkgs.cudaPackages.cuda_cudart}";
        LD_LIBRARY_PATH = "${pkgs.cudaPackages.cuda_cudart}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.linuxPackages.nvidia_x11}/lib";
    };
  };


  fonts.packages = with pkgs; [ nerdfonts ];

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
  };
  security.rtkit.enable = true;

  services = {
    mullvad-vpn.enable = true;
    displayManager.defaultSession = "none+i3";
    xserver.videoDrivers = [ "nvidia" ];
    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true; # audio
    };

    blueman.enable = true; # bluetooth

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
      };
    };

    syncthing = {
      enable = true;
      user = "spike";
      dataDir = "/home/spike/Documents";
      configDir = "/home/spike/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings.gui.theme = "dark";
    };

    # auto mounting
    devmon.enable = true;
    gvfs.enable = true; 
    udisks2.enable = true;

    picom = {
      enable = true;
      vSync = true;
      backend = "glx";
      settings = {
        glx-no-stencil = true;
        glx-no-rebind-pixmap = true;
      };
    };

    dbus.enable = true;
  };

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

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs = {
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

  users.users.spike = {
    isNormalUser = true;
    description = "spike";
    extraGroups = [ "networkmanager" "wheel"];
    shell = pkgs.bash;
    packages = with pkgs; [];
  };
}
