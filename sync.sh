#!/bin/sh
# copies files from local to this directory
cfg() {
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

# source                              dest                file
cfg ~/.config/nvim/init.lua           nvim                init.lua
cfg ~/.config/wezterm/wezterm.lua     wezterm             wezterm.lua
cfg ~/.config/zed/settings.json       zed                 settings.json
cfg ~/.shrc                           .                   .shrc

cfg /etc/nixos/configuration.nix      nix                 configuration.nix
cfg ~/.config/home-manager/home.nix   nix/home-manager    home.nix


cfg ~/.config/i3/config               i3/i3               config
cfg ~/.config/i3status/config         i3/i3status         config
