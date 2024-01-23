# For some technical reasons, the default terminal that I actually run is bash, 
# which launches a tmux instance, which launches a kitty instance. 
# This makes my life simpler and but might not be for you. 

# Start tmux if not already running
if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    exec tmux
fi
# Use the pretty starship prompt
eval "$(starship init bash)"

# Start fish
fish



