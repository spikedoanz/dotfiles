######################
## spike's shell rc ##
######################
PS1='%F{green}%n@%m%f:%F{cyan}%~%f § '

source ~/.env
source <(fzf --zsh)
. "$HOME/.local/bin/env"

export EDITOR=nvim
eval "$(zoxide init zsh)"
if [[ -z "$SSH_AGENT_PID" ]]; then
    eval $(ssh-agent -s) > /dev/null
fi

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
# aliases 
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
alias cat='bat -p --paging=never'

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
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="$HOME/.bin/:$PATH"
