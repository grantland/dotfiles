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

# GIT status flag
function __git_status_flag {
    git_status="$(git status 2> /dev/null)"
    remote_pattern="^# Your branch is (. of"
    diverge_pattern="# Your branch and (. have diverged"
    if [[ ! ${git_status}} =~ "working directory clean" ]]; then
        state="⚡"
        spacer=" "
    fi

    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        spacer=" "
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="↑"
        else
            remote="↓"
        fi
    fi

    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="↕"
        spacer=" "
    fi

    echo "${state}${remote}${spacer}"
}

# From github.com/git/git
if [ -f ~/bin/git-prompt.sh ]; then
    source ~/bin/git-prompt.sh
    export PS1='\[\e[1;34m\]\w\[\e[22;35m\]$(__git_ps1 " [\[\e[33m\]$(__git_status_flag)\[\e[35m\]%s]")\[\e[33m\] \$ \[\e[0m\]'
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

export PATH="/usr/local/bin:$PATH:/usr/local/sbin"

# Scripts
export PATH=${PATH}:~/bin

# Android SDK
export ANDROID_HOME=/usr/local/opt/android-sdk
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

# BEGIN: Block added by chef, to set environment strings
# Please see https://fburl.com/AndroidProvisioning if you do not use bash
# or if you would rather this bit of code 'live' somewhere else
. ~/.fbchef/environment
# END: Block added by chef

