######################
## spike's shell rc ##
######################
#PS1=$'%F{green}%n@%m%f:%F{cyan}%~%f\n$ '
# ============================================================
# Prompt configuration
# ============================================================

zmodload zsh/datetime
setopt PROMPT_SUBST

# ---------- segments ----------
# Each segment owns one piece of prompt state.
# Convention: _seg_<name> holds the rendered string (or empty).
# Convention: _update_<name> refreshes it; called from precmd.

_seg_git=""
_update_git() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(git rev-parse --short HEAD 2>/dev/null) \
    || { _seg_git=""; return; }
  _seg_git=" %F{magenta}${branch}%f"
}

_seg_duration=""
_cmd_start=0
_update_duration() {
  if (( _cmd_start > 0 )); then
    local elapsed=$(( EPOCHREALTIME - _cmd_start ))
    _seg_duration=$(printf " %%F{red}%.2fs%%f" $elapsed)
    _cmd_start=0
  else
    _seg_duration=""
  fi
}
_start_timer() { _cmd_start=$EPOCHREALTIME }

# ---------- hooks ----------
autoload -Uz add-zsh-hook
add-zsh-hook preexec _start_timer
add-zsh-hook precmd  _update_git
add-zsh-hook precmd  _update_duration

# ---------- prompt ----------
PS1=$'%F{green}$ %n@%m%f %F{yellow}%D{%Y%m%d:%H%M%S}%f${_seg_git}${_seg_duration}\n%F{cyan}%~%f\n'

# ============================================================
# Environment
# ============================================================
source ~/.env

# HOMEBREW SETUP - static paths are much faster than spawning `brew` on every shell.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"

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

# SSH is configured in ~/.ssh/config. Do not run ssh-agent/ssh-add here:
# doing so makes every new shell pay the keychain/agent startup cost.

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
alias gs='git status '
alias ga='git add '
alias gc='git commit -m '
alias gp='git push origin $(git branch --show-current)'
alias gl='git pull'
alias gb='git branch '
alias gt='git checkout '
alias rebuild='sudo darwin-rebuild switch --flake ~/.config/dotfiles'
alias yclaude='claude --dangerously-skip-permissions'
alias ycodex='codex --yolo --no-alt-screen'

# Autosuggestions + syntax highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#================================================================================
# path
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"
export PATH="$HOME/.bin/:$PATH"
export PATH="$HOME/.config/emacs/bin/:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
#--------------------------------------------------------------------------------
# android sdk
export ANDROID_NDK="$HOME/Library/Android/sdk/ndk/29.0.14033849"
export TVM_NDK_CC="$ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android24-clang"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export TVM_SOURCE_DIR="/Users/spike/R/t-efficient-ai-notes/mlc-llm/3rdparty/tvm"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Daily notes
DAILY_NOTES_DIR="$HOME/Global/Vault/daily"
daily() {
    local dir="${1:-$DAILY_NOTES_DIR}"
    mkdir -p "$dir"
    ${EDITOR:-nvim} "$dir/$(date +%Y-%m-%d).md"
}
alias notes="${EDITOR:-nvim} $HOME/Global/Vault/"

t() {
    command task "$@"
    command task sync &>/dev/null || echo "task sync failed"
}

# bun completions
# [ -s "/Users/spike/.bun/_bun" ] && source "/Users/spike/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/.npm-global/bin:$PATH"

# 
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/spike/.juliaup/bin' $path)
export PATH
# Tab completion for juliaup and julia channel selection
[ -f "/Users/spike/.julia/juliaup/completions/zsh.zsh" ] && source "/Users/spike/.julia/juliaup/completions/zsh.zsh"

# Dedupe PATH/FPATH after Homebrew, Nix, and tool installers have all mutated them.
typeset -U path PATH fpath FPATH

# <<< juliaup initialize <<<
