##
# Settings
##

# Append to .bash_history instead of replacing it
shopt -s histappend

##==============================================================================
# Aliases
##==============================================================================

alias diff="diff -wbBdu"

# Git Prettylog
git() { if [[ $@ == "log" ]]; then command git prettylog; else command git "$@"; fi; }

# Set Terminal Title Alias
set_terminal_title() {
    if [[ -z $@ ]]
    then
        TERMINAL_TITLE=$PWD
    else
        TERMINAL_TITLE=$@
    fi
}
alias stt='set_terminal_title'
STANDARD_PROMPT_COMMAND='history -a ; echo -ne "\033]0;${TERMINAL_TITLE}\007"'
PROMPT_COMMAND=$STANDARD_PROMPT_COMMAND

# cd + stt Alias
cd_stt() {
    cd "$@"
    stt ${PWD##*/}
}
alias cd='cd_stt'

# Brew git Bash shell command completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# From github.com/magicmonty/bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share

    # Customizations
    GIT_PROMPT_START='\[\e[1;34m\]\w\[\e[22;35m\]'
    GIT_PROMPT_END='\[\e[33m\] \$ \[\e[0m\]'

    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# From github.com/git/git
if [ -f ~/bin/git-completion.bash ]; then
    source ~/bin/git-completion.bash
fi

if [ -f /opt/facebook/share/bash_completion ]; then
    source /opt/facebook/share/bash_completion
fi

if [ -f /opt/facebook/share/scm-prompt ]; then
  source /opt/facebook/share/scm-prompt
  export PS1='\[\e[1;34m\]\w\[\e[22;35m\]$(_dotfiles_scm_info)\[\e[33m\] \$ \[\e[0m\]'
fi

##==============================================================================
# Variables
##==============================================================================

export EDITOR=vim

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH="/usr/local/bin:$PATH:/usr/local/sbin"

# Scripts
export PATH=${PATH}:~/bin

# Sublime
export PATH="${PATH}:/Applications/Sublime Text.app/Contents/SharedSupport/bin"

# Android SDK
export ANDROID_HOME=~/Library/Android/sdk
if [ ! -d ${ANDROID_HOME} ]; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi
export PATH=${PATH}:${ANDROID_HOME}/emulator
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/tools/proguard/bin
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

# Android NDK
export ANDROID_NDK=/opt/android_ndk/android-ndk-r15fb1
export ANDROID_NDK_REPOSITORY=/opt/android_ndk

# Proguard
export PATH=${PATH}:${ANDROID_PATH}/tools/proguard/lib

# Android Scripts
export PATH=${PATH}:~/bin/dex2jar-0.0.9.15
export PATH=${PATH}:~/bin/apktool1.5.2

# Facebook
export PATH=${PATH}:~/buck/bin

# Cisco
export PATH=${PATH}:/opt/cisco/anyconnect/bin

# Terminal Colors
export CLICOLOR=1
# export LSCOLORS="GxFxCxDxBxegedabagacad"

