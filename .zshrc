######################
## spike's shell rc ##
######################
PS1='%F{green}%n@%m%f:%F{cyan}%~%f § '
source ~/.env

# NIX SETUP - MUST COME FIRST
export PATH="/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:$PATH"
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

set -o emacs

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
fi

. "$HOME/.local/bin/env"
if [[ -z "$SSH_AGENT_PID" ]]; then
    eval $(ssh-agent -s) > /dev/null
fi

# capture tmux buffer in vim
bindkey -s '^X^E' 'tmux capture-pane -S - -p > /tmp/tmux-buffer.txt && nvim + /tmp/tmux-buffer.txt\n'

# edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\ev' edit-command-line

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
    alias ls='eza'
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

#================================================================================
# path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="$HOME/.bin/:$PATH"
#--------------------------------------------------------------------------------
# android sdk
export ANDROID_NDK="$HOME/Library/Android/sdk/ndk/29.0.14033849"
export TVM_NDK_CC="$ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android24-clang"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export TVM_SOURCE_DIR="/Users/spike/R/t-efficient-ai-notes/mlc-llm/3rdparty/tvm"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/spike/.opam/opam-init/init.zsh' ]] || source '/Users/spike/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
