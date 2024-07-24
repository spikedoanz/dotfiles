# (f)uzzy (d)irectory finder
alias fd='cd "./$(find -type d | fzf)"'      # from anywhere
alias fds='cd;cd "./$(find -type d | fzf)"'  # from home

# replace ls with exa
alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias l='exa'

