# spike's dotfiles

Nix flake-based dotfiles. One command to deploy everything.

## Structure

```
dotfiles/
├── flake.nix              # Entry point
├── lib/mksystem.nix       # System builder helper
└── machines/
    └── macbook/           # Everything for macbook lives here
        ├── default.nix    # System + home-manager config
        └── config/        # Dotfiles (nvim, etc.)
```

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

### 3. Clone dotfiles

```bash
git clone https://github.com/spikedoanz/dotfiles ~/.config/dotfiles
cd ~/.config/dotfiles
```

### 4. Deploy

**macOS:**
```bash
nix run nix-darwin -- switch --flake .#macbook
```

## Update

After making changes to any `.nix` file or config:

```bash
darwin-rebuild switch --flake ~/.config/dotfiles
```

Or use the alias:
```bash
rebuild
```

## Adding a new machine

1. Create `machines/<name>/default.nix` with system + home-manager config
2. Add config files to `machines/<name>/config/`
3. Add entry to `flake.nix`:
   ```nix
   darwinConfigurations.<name> = mkSystem "<name>" {
     system = "aarch64-darwin";  # or x86_64-linux
     darwin = true;              # false for linux
   };
   ```
4. Deploy: `nix run nix-darwin -- switch --flake .#<name>`
