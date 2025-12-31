# spike's dotfiles

Nix flake-based dotfiles. One command to deploy everything.

## Structure

```
dotfiles/
├── flake.nix              # Entry point
├── lib/mksystem.nix       # System builder helper
├── machines/
│   └── macbook/
│       └── default.nix    # System + home-manager + homebrew config
└── config/                # Shared dotfiles
    ├── aerospace/
    ├── claude/
    ├── ghostty/
    ├── nvim/
    └── sh/
```

## What gets installed

**Via Nix (home-manager):**
- CLI: ripgrep, fzf, eza, tree, curl, jq, htop, ncdu
- Dev: uv, gh, git-lfs, cmake, gnumake
- Languages: python312, nodejs_22
- Media: ffmpeg, imagemagick
- Editor: neovim (with treesitter, LSPs)
- Terminal: tmux (with floax, fzf, thumbs plugins)

**Via Homebrew (managed by nix-darwin):**
- Casks: ghostty@tip, mactex, android-platform-tools
- Brews: ffmpeg, cmake, git-lfs, gnupg, colima, scrcpy, rclone

**Configs symlinked:**
- ~/.config/nvim/
- ~/.config/ghostty/
- ~/.config/tmux/
- ~/.config/claude/
- ~/.aerospace.toml
- ~/.zshrc

## Bootstrap (fresh machine)

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Enable flakes

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
```

### 3. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 4. Clone dotfiles

```bash
git clone https://github.com/spikedoanz/dotfiles ~/.config/dotfiles
cd ~/.config/dotfiles
```

### 5. Deploy

```bash
nix run nix-darwin -- switch --flake .#macbook
```

This single command:
- Installs all nix packages
- Installs all homebrew packages
- Symlinks all config files
- Sets up tmux plugins
- Configures the system

## Update

After making changes:

```bash
darwin-rebuild switch --flake ~/.config/dotfiles
```

Or use the alias:
```bash
rebuild
```

## Adding a new machine

1. Create `machines/<name>/default.nix`
2. Add entry to `flake.nix`
3. Deploy: `nix run nix-darwin -- switch --flake .#<name>`
