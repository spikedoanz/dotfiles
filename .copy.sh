#!/bin/sh
copy_config() {
    local src="$1"
    local dest_dir="$2"
    local dest_file="$3"
    
    if [ -f "$src" ]; then
        mkdir -p "$dest_dir"
        cp "$src" "$dest_dir/$dest_file"
        echo "✓ Copied $src"
    else
        echo "⚠ Warning: $src not found, skipping..."
    fi
}

#           source                                  dest                file
copy_config ~/.config/nvim/init.lua                 nvim                init.lua
copy_config ~/.config/wezterm/wezterm.lua           wezterm             wezterm.lua
copy_config ~/.config/zed/settings.json             zed                 settings.json
copy_config ~/.shrc                                 .                   .shrc

copy_config /etc/nixos/configuration.nix            nix                 configuration.nix
copy_config ~/.config/home-manager/home.nix         nix/home-manager    home.nix

copy_config ~/.xmonad/xmonad.hs                     wm/xmonad/.xmonad   xmonad.hs
copy_config ~/.config/xmonad/xmobar/xmobar.config   wm/xmonad/xmobar    xmobar.config

copy_config ~/.config/i3/config                     wm/i3/i3            config
copy_config ~/.config/i3status/config               wm/i3/i3status      config
