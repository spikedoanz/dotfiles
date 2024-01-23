if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tama/work/anaconda3/bin/conda
    eval /home/tama/work/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

alias vim='nvim'
alias oldvim='/usr/bin/vim'

set -gx EDITOR nvim # set default editor to nvim 
set fish_greeting

starship init fish | source
