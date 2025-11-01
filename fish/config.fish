######################
## spike's fish rc  ##
######################

# NIX SETUP - MUST COME FIRST
set -x PATH /nix/var/nix/profiles/default/bin $HOME/.nix-profile/bin $PATH
if test -e ~/.nix-profile/etc/profile.d/nix.sh
    bash -c "source ~/.nix-profile/etc/profile.d/nix.sh; env" | sed 's/=/ /' | while read key value
        set -x $key $value
    end
end

function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color brgreen)
    
    if test $last_status -ne 0
        set status_color (set_color brred)
    end
    
    echo -n -s '#' (set_color brblue) (prompt_login) ' ' (set_color cyan) (prompt_pwd) $status_color ' $ ' $normal
end

# FZF
if command -v fzf >/dev/null 2>&1
    fzf --fish | source
end

# Zoxide
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end

# Editor
if command -v nvim >/dev/null 2>&1
    set -x EDITOR nvim
end

# SSH Agent
if not set -q SSH_AUTH_SOCK; or test ! -S "$SSH_AUTH_SOCK"
    # Check if agent info file exists and is valid
    if test -f ~/.ssh/ssh-agent.env
        source ~/.ssh/ssh-agent.env > /dev/null
    end
    
    # Verify the agent is actually running
    if not ssh-add -l >/dev/null 2>&1
        # Start new agent and save info
        eval (ssh-agent -c | tee ~/.ssh/ssh-agent.env)
        
        # Add your keys (uncomment and customize as needed)
        # ssh-add ~/.ssh/id_ed25519
        ssh-add ~/.ssh/gh
    end
end

#-------------------------------------------------------------------------------- 
# Clipboard aliases
if test (uname) = "Darwin"
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
else
    # Linux/Unix
    if command -v xclip >/dev/null 2>&1
        alias copy='xclip -selection clipboard'
        alias paste='xclip -selection clipboard -o'
    else if command -v xsel >/dev/null 2>&1
        alias copy='xsel --clipboard --input'
        alias paste='xsel --clipboard --output'
    else
        echo "Neither xclip nor xsel is installed. Please install one of them."
    end
end

#-------------------------------------------------------------------------------- 
alias icat='wezterm imgcat'

# Virtual environment function
function v
    # Deactivate current venv if active
    if test -n "$VIRTUAL_ENV"
        deactivate 2>/dev/null
    end
    
    # Search up the directory tree
    set -l search_dir (pwd)
    set -l max_depth 20
    
    for i in (seq 1 $max_depth)
        if test -f "$search_dir/.venv/bin/activate.fish"
            source "$search_dir/.venv/bin/activate.fish"
            return 0
        end
        set search_dir (dirname "$search_dir")
        if test "$search_dir" = "/"
            break
        end
    end
    
    return 1
end

# EZA aliases
if command -v eza >/dev/null 2>&1
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -a'
    alias l='eza'
end

# Git aliases
alias p='python'
alias vim='nvim'
alias ga='git add'
alias gc='git commit -m'
alias gl='git pull'
alias gb='git branch'
alias gt='git checkout'

# Complex git alias as function
function gg
    git add .
    git commit -m "lazycommit"
    git push origin (git branch --show-current)
end

function gp
    git push origin (git branch --show-current)
end

#================================================================================
# PATH additions
set -x PATH /opt/homebrew/opt/llvm/bin $PATH
set -x PATH /Applications/Ghostty.app/Contents/MacOS $PATH
set -x PATH /opt/homebrew/opt/qt@5/bin $PATH
set -x PATH $HOME/.bin $PATH

#--------------------------------------------------------------------------------
# Android SDK
set -x ANDROID_NDK "$HOME/Library/Android/sdk/ndk/29.0.14033849"
set -x TVM_NDK_CC "$ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android24-clang"
set -x JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
set -x TVM_SOURCE_DIR "/Users/spike/R/t-efficient-ai-notes/mlc-llm/3rdparty/tvm"
set -x PATH $HOME/Library/Android/sdk/platform-tools $PATH

# OPAM configuration
if test -r "$HOME/.opam/opam-init/init.fish"
    source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>/dev/null
end

# iTerm2 integration
if test -e "$HOME/.iterm2_shell_integration.fish"
    source "$HOME/.iterm2_shell_integration.fish"
end
if status is-interactive
    # Commands to run in interactive sessions can go here
end
