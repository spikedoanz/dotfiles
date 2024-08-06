# fancy prompt
PS1="%F{blue}%2~%f § "

alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias l='exa'
alias icat='kitty +kitten icat'
alias sv='source venv/bin/activate'
alias pee='pip install -e .'
alias web='open -a "Google Chrome" '
alias llma='llm -m "claude-3-5-sonnet-20240620" '
alias llmq='llm -m "groq-mixtral" '

# paths for script
export PATH=$PATH:~/.scripts/
export PATH=$PATH:~/.local/bin
