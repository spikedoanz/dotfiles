# fancy prompt
PS1="%F{blue}%2~%f § "

# replace ls with exa
alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias l='exa'

# shorthand
alias icat='kitty +kitten icat'
alias sv='source venv/bin/activate'
alias pee='pip install -e .'

# web [url] := opens your web browser and takes you to the link
alias web='open -a "Google Chrome" '

# google [query without quotes] := formats a link into google and looks it up
google() {
    query="$*"
    formatted_query=$(echo "$query" | sed 's/ /+/g')
    web "https://www.google.com/search?q=$formatted_query"
}

# llm# [query] := does an llm query through the api. a is anthropic, q is groq
alias llma='llm -m "claude-3-5-sonnet-20240620" '
alias llmq='llm -m "groq-mixtral" '

# fetches hackernews
alias hackernews='curl -s https://news.ycombinator.com | llma -s "summarize todays news and provide the urls to the highlight articles"'

# paths for script
export PATH=$PATH:~/.scripts/
export PATH=$PATH:~/.local/bin
