```
███████╗██████╗ ██╗██╗  ██╗███████╗ ███████╗
██╔════╝██╔══██╗██║██║ ██╔╝██╔════╝ ██╔════╝
███████╗██████╔╝██║█████╔╝ █████╗   ███████╗
╚════██║██╔═══╝ ██║██╔═██╗ ██╔══╝   ╚════██║
███████║██║     ██║██║  ██╗███████╗ ███████║
╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚══════╝
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

# system specification

## core components
os: nixos
wm: i3
terminal: wezterm
shell: zsh
editors: neovim, zed
theme: gruvbox
font: jetbrains mono nerd font

## file structure
```
/etc/nixos/configuration.nix      # system configuration
~/.config/
├── i3/config                     # wm configuration
├── nvim/init.lua                 # neovim configuration
├── wezterm/wezterm.lua           # terminal configuration
└── zed/settings.json             # zed configuration
```

## system utilities
network management: nmtui
brightness control: brightnessctl
audio: pipewire + pulseaudio
screenshot: flameshot
file management: yazi, syncthing


## system services

### power management
- tlp: battery optimization
- thermald: temperature control
- auto-cpufreq: cpu frequency scaling
- power-profiles-daemon: power management

### system maintenance
garbage collection: weekly
trim: weekly (ssd optimization)
health monitoring: smartd
updates: automatic security patches

### security
firewall: enabled by default
gpg agent: configured for runtime
ssh agent: configured for runtime
syncthing: secure default configuration

## system tasks

### system updates
```bash
sudo nixos-rebuild switch
nix-collect-garbage
```

### service status
```bash
systemctl --user status pipewire
systemctl --user status syncthing
```

### system logs
system: journalctl -xeu
wm: ~/.i3/i3log
display: /var/log/xorg.0.log

## package management
location: /etc/nixos/configuration.nix
```nix
environment.systempackages = with pkgs; [
  # package definitions
];
```
---

made with <3 by claude
