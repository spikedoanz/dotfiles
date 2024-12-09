# fancy prompt
PS1="\[\033[34m\]\W\[\033[0m\] § " # bash
# PS1="%{%F{blue}%}%2~%{%f%} § "   # zsh

# replace ls with exa
alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias l='exa'

# shorthand
alias icat='wezterm imgcat'
alias v='source .venv/bin/activate'
alias gg='git add . && git commit -m "wp" && git push origin $(git branch --show-current)'
