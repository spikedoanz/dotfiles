# dotfiles #

font: [jetbrains mono](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf)

wm: gnome/xmonad

term: wezterm

shell: bash/zsh

editor: nvim/zed

configuration.nix lives in /etc/nixos/

everything else is in:

```
~/.config § tree
.
├── home-manager
│   └── home.nix
├── nvim
│   ├── init.lua
│   └── lazy-lock.json
├── wezterm
│   └── wezterm.lua
└── zed
    ├── settings.json
    └── themes
```
