######################
## spike's shell rc ##
######################
PS1='%F{green}%n@%m%f:%F{cyan}%~%f $ '
source ~/.env

# HOMEBREW SETUP - MUST COME FIRST (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# NIX SETUP
export PATH="/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:$PATH"
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

# GHCUP
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

set -o emacs

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
fi

. "$HOME/.local/bin/env"

# SSH Agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
fi

if [ -n "$SSH_AUTH_SOCK" ]; then
    ssh-add --apple-use-keychain ~/.ssh/gh 2>/dev/null
fi

# capture tmux buffer in vim
bindkey -s '^X^E' 'tmux capture-pane -S - -p > /tmp/tmux-buffer.txt && nvim + /tmp/tmux-buffer.txt\n' #KB: zsh | C-x | - | C-e | Capture tmux buffer in nvim

# edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\ev' edit-command-line #KB: zsh | M | - | v | Edit command line in editor

#-------------------------------------------------------------------------------- 
# clipboard
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
else
    # Linux/Unix - check for xclip or xsel
    if command -v xclip >/dev/null 2>&1; then
        alias copy='xclip -selection clipboard'
        alias paste='xclip -selection clipboard -o'
    elif command -v xsel >/dev/null 2>&1; then
        alias copy='xsel --clipboard --input'
        alias paste='xsel --clipboard --output'
    else
        echo "Neither xclip nor xsel is installed. Please install one of them."
    fi
fi
# ------------------------------------------------------------------------------- 
v() {
    local current_dir="$(pwd)"
    local search_dir="$current_dir"
    local max_depth=20
    local depth=0
    
    # Deactivate current venv if active and deactivate function exists
    if [[ -n "$VIRTUAL_ENV" ]] && command -v deactivate > /dev/null 2>&1; then
        deactivate
    fi
    
    # Search up the directory tree
    while [[ "$search_dir" != "/" && $depth -lt $max_depth ]]; do
        if [[ -f "$search_dir/.venv/bin/activate" ]]; then
            source "$search_dir/.venv/bin/activate"
            return 0
        fi
        # Move up one directory
        search_dir="$(dirname "$search_dir")"
        ((depth++))
    done
    
    return 1
}
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --sort=extension'
    alias ll='eza -l'
    alias la='eza -a'
    alias l='eza'
fi
alias p='python'
alias vim='nvim'
alias gg='git add . && git commit -m "lazycommit" && git push origin $(git branch --show-current)'
alias ga='git add '
alias gc='git commit -m '
alias gp='git push origin $(git branch --show-current)'
alias gl='git pull'
alias gb='git branch '
alias gt='git checkout '
alias rebuild='sudo darwin-rebuild switch --flake ~/.config/dotfiles'

#================================================================================
# path
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"
export PATH="$HOME/.bin/:$PATH"
export PATH="$HOME/.config/emacs/bin/:$PATH"
#--------------------------------------------------------------------------------
# android sdk
export ANDROID_NDK="$HOME/Library/Android/sdk/ndk/29.0.14033849"
export TVM_NDK_CC="$ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android24-clang"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export TVM_SOURCE_DIR="/Users/spike/R/t-efficient-ai-notes/mlc-llm/3rdparty/tvm"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

export PLAN9=/Users/spike/R/plan9 export PLAN9
export PATH=$PATH:$PLAN9/bin export PATH

# Daily notes
DAILY_NOTES_DIR="$HOME/Global/Vault/daily"
daily() {
    local dir="${1:-$DAILY_NOTES_DIR}"
    mkdir -p "$dir"
    ${EDITOR:-nvim} "$dir/$(date +%Y-%m-%d).md"
}

task() {
    command task "$@"
    command task sync &>/dev/null || echo "task sync failed"
}
