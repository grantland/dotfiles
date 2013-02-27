##
# Settings
##

# Append to .bash_history instead of replacing it
shopt -s histappend

##==============================================================================
# Aliases
##==============================================================================

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
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
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
PS1='\[\e[1;34m\]\w\[\e[22;35m\]$(__git_ps1 " [\[\e[33m\]$(__git_status_flag)\[\e[35m\]%s]")\[\e[33m\] \$ \[\e[0m\]'

##==============================================================================
# Variables
##==============================================================================

export PATH="/usr/local/bin:$PATH:/usr/local/sbin"

# Scripts
export PATH=${PATH}:~/bin

# Android SDK
export ANDROID_PATH=~/Development/android-sdk
export PATH=${PATH}:${ANDROID_PATH}/tools
export PATH=${PATH}:${ANDROID_PATH}/platform-tools

# Android NDK
#export PATH=${PATH}:/Developer/android-ndk

# Proguard
export PATH=${PATH}:${ANDROID_PATH}/tools/proguard/lib

# Android Scripts
export PATH=${PATH}:~/bin/dex2jar-0.0.9.12
export PATH=${PATH}:~/bin/apktool1.5.0

# Terminal Colors
export CLICOLOR=1
# export LSCOLORS="GxFxCxDxBxegedabagacad"
