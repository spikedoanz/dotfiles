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

# source                              dest                    file
cfg ~/.zshrc                          sh                      .zshrc
cfg ~/.config/nvim/init.lua           nvim                    init.lua
cfg ~/.config/karabiner/karabiner.json karabiner              karabiner.json
cfg ~/.aerospace.toml                 aerospace               .aerospace.toml
cfg ~/.config/tmux/tmux.conf          tmux                    tmux.conf 
cfg ~/.claude/settings.json           claude                  settings.json
cfg ~/.claude/statusline.sh           claude                  statusline.sh
cfg ~/.config/ghostty/config          ghostty                 config

cfg /etc/nixos/configuration.nix      nix                     configuration.nix
cfg ~/.config/home-manager/home.nix   nix/home-manager        home.nix

cfg ~/.config/i3/config               i3/i3                   config
cfg ~/.config/i3status/config         i3/i3status             config

cfg ~/.config/wezterm/wezterm.lua     experimental/wezterm    wezterm.lua 
cfg ~/.config/zed/settings.json       experimental/zed        settings.json
cfg ~/.config/zed/keymap.json         experimental/zed        settings.json
