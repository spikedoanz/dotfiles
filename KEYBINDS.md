# system keybindings

## window manager (i3)
mod key = super (windows key)

### core operations
```
mod + shift + return    terminal
mod + shift + q         kill window
mod + p                 application launcher
mod + d                 window switcher
mod + shift + c         reload i3 config
mod + shift + r         restart i3
mod + shift + escape    exit i3
```

### window navigation
```
mod + h                 focus left
mod + j                 focus down
mod + k                 focus up
mod + l                 focus right

mod + shift + h         move window left
mod + shift + j         move window down
mod + shift + k         move window up
mod + shift + l         move window right
```

### window management
```
mod + shift + o         split horizontal
mod + shift + i         split vertical
mod + f                 toggle fullscreen
mod + shift + space     toggle floating
mod + space             toggle focus floating/tiling
```

### layout control
```
mod + s                 layout: stacking
mod + w                 layout: tabbed
mod + e                 layout: toggle split

mod + semicolon         enter resize mode
    h                   shrink width
    j                   grow height
    k                   shrink height
    l                   grow width
    return/escape       exit resize mode
```

### workspace management
```
mod + [0-9]            switch to workspace
mod + shift + [0-9]    move window to workspace
```

### hardware controls
```
xf86audioraisevolume    volume up
xf86audiolowervolume    volume down
xf86audiomute           toggle mute
xf86audiomicmute        toggle mic mute
xf86monbrightnessup     brightness up
xf86monbrightnessdown   brightness down
print                   screenshot (flameshot)
```

## terminal (wezterm)

### pane management
```
alt + -                split vertically
alt + =                split horizontally
alt + q                close pane
alt + t                cycle theme
```

### pane navigation
```
alt + h                focus left
alt + j                focus down
alt + k                focus up
alt + l                focus right
```

### pane resizing
```
alt + h                resize left
alt + j                resize down
alt + k                resize up
alt + l                resize right
```

### vim-style navigation
```
alt + b                word back
alt + w                word forward
alt + 0                start of line
alt + 4/$              end of line
alt + d                delete word forward
alt + d                delete to end of line
alt + x                delete character
alt + v                enter copy mode
```

## editor (neovim)
leader key = space

### file navigation
```
<leader>ff             find files
<leader>fg             live grep
<leader>fb             browse buffers
<leader>fh             help tags
```

### editor features
```
<leader>n              toggle line numbers
<leader>r              toggle relative numbers
<leader>t2             set tab width to 2
<leader>t4             set tab width to 4
ctrl + b               toggle file tree
ctrl + j               move 10 lines down
ctrl + k               move 10 lines up
```

### special characters
```
greek letters:
\alpha, \beta, etc.    greek symbols

math symbols:
\in                    ∈ (element of)
\forall               ∀ (for all)
\exists               ∃ (exists)
\therefore            ∴ (therefore)
\sum                  ∑ (summation)
\prod                 ∏ (product)

operators:
\union                ∪ (union)
\intersect            ∩ (intersection)
\subset               ⊂ (subset)
\supset               ⊃ (superset)

arrows:
\implies              ⟹ (implies)
\iff                  ⟺ (if and only if)
\to                   → (to)
\gets                 ← (gets)
```

note: all special character insertions work in insert mode.
