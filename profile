#.bashrc

if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
    # Set config variables first
    GIT_PROMPT_ONLY_IN_REPO=1

    # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

    # GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
    GIT_PROMPT_SHOW_UNTRACKED_FILES=all # can be no, normal or all; determines counting of untracked files

    GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

    # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

    # GIT_PROMPT_START="[\t] \[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\]\w:\[$(tput sgr0)\]""]]]"   # uncomment for custom prompt start sequence
    # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

    # as last entry source the gitprompt script
    # GIT_PROMPT_THEME=SolarizedDark # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
    GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
    GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme

    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi

if ! [[ -z $PS1 ]]; then
    bind Space:magic-space
    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward
    export PS1="\t\[\033[01;30m\]|\[\033[01;34m\]\u\[\033[01;32m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\n\$ "
fi

# Autoload ssh-agent
if ! ps aux | grep ssh-agent | grep `whoami` | grep -v grep > /dev/null; then
    eval $(ssh-agent)
    ssh-add 2> /dev/null
fi

if [[ -f `brew --prefix`/etc/bash_completion ]]; then
    . `brew --prefix`/etc/bash_completion
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
    if ![ -z $PS1 ]; then
        source "$HOME/.rvm/contrib/ps1_functions"
        ps1_set
    fi
fi

if [[ -f $HOME/.general_exports ]]; then
    . $HOME/.general_exports
fi


if ! [ -z $PS1 ]; then
    alias ls='ls -GFhb'
    shopt -s checkwinsize # Check window after each command
    shopt -s cdspell      # This will correct minor spelling errors in a cd cmd
    shopt -s histappend   # Append to history rather than overwrite
    shopt -s histreedit   # Edit failled substitutions
fi

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
