# paste.sh
#!/bin/bash

paste_config() {
    local src="$1"
    local dest_dir="$2"
    local dest_file="$3"
    local full_dest_dir
    
    # Handle .shrc specially since it goes in home directory
    if [ "$dest_dir" = "." ]; then
        full_dest_dir="$HOME"
    else
        full_dest_dir="$HOME/.config/$dest_dir"
    fi
    
    if [ -f "$src" ]; then
        # Copy the file
        cp "$src" "$full_dest_dir/$dest_file"
        echo "✓ Restored $dest_file to $full_dest_dir"
    else
        echo "⚠ Warning: $src not found, skipping..."
    fi
}

# Restore each config file
paste_config "nvim/init.lua" "nvim" "init.lua"
paste_config "wezterm/wezterm.lua" "wezterm" "wezterm.lua"
paste_config "zed/settings.json" "zed" "settings.json"
paste_config ".shrc" "." ".shrc"

echo "Done"
