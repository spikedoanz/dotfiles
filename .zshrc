PS1='%F{green}%n@%m%f:%F{cyan}%~%f § '
source <(fzf --zsh)
alias cat='bat -p --paging=never'
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -l'
  alias la='eza -a'
  alias l='eza'
fi

alias copy='pbcopy'
alias paste='pbpaste'

alias icat='wezterm imgcat'

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

alias ga='git add '
alias gc='git commit -m '
alias gp='git push origin $(git branch --show-current)'
alias gl='git pull'
alias gb='git branch '
alias gt='git checkout '
alias gg='ga . && gc -m "wp" && gp'
