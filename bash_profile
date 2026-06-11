##
# Settings
##

# Append to .bash_history instead of replacing it
shopt -s histappend

##==============================================================================
# Brew PATH
##==============================================================================

# Default brew
export PATH=/opt/homebrew/bin:${PATH}
export PATH=${PATH}:/opt/homebrew/sbin

# Local brew
export PATH=${HOME}/homebrew/bin:${PATH}
export PATH=${PATH}:${HOME}/homebrew/sbin

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

# Cache brew prefix once — `brew --prefix` spawns Ruby (~290ms) per call.
BREW_PREFIX=$(brew --prefix 2>/dev/null)

# Brew git Bash shell command completion
if [ -f "$BREW_PREFIX/etc/bash_completion" ]; then
    . "$BREW_PREFIX/etc/bash_completion"
fi

# From github.com/git/git
if [ -f ~/bin/git-completion.bash ]; then
    source ~/bin/git-completion.bash
fi

if [ -f /opt/facebook/share/bash_completion ]; then
    source /opt/facebook/share/bash_completion
fi

# ==============================================================================
# VCS-aware prompt — identical look on Mac, home Linux, and work devservers.
#   - git repos (Mac + home): fast single-call status via porcelain=v2
#   - Sapling/Mercurial (fbsource on devservers): delegated to scm-prompt
# Reads .git/HEAD-style state directly and makes at most ONE `git` subprocess,
# so it stays ~100ms/prompt instead of bash-git-prompt's ~925ms. See git log.
# ==============================================================================

# scm-prompt provides _dotfiles_scm_info for hg/sl repos; load it if present.
[ -f /opt/facebook/share/scm-prompt ] && source /opt/facebook/share/scm-prompt

# git segment: branch[↑ahead↓behind][+staged][*unstaged][%untracked][|OP]
_vcs_git_segment() {
  local root="$1" line branch="" ab="" staged="" unstaged="" untracked="" xy a b up="" op="" stash=""
  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*) branch="${line#\# branch.head }" ;;
      "# branch.ab "*)   ab="${line#\# branch.ab }" ;;
      "1 "*|"2 "*) xy="${line:2:2}"
                   [ "${xy:0:1}" != "." ] && staged="+"
                   [ "${xy:1:1}" != "." ] && unstaged="*" ;;
      "u "*) staged="+"; unstaged="*" ;;
      "? "*) untracked="%" ;;
    esac
  done < <(git status --porcelain=v2 --branch 2>/dev/null)
  [ "$branch" = "(detached)" ] && branch="$(git rev-parse --short HEAD 2>/dev/null)"
  [ -z "$branch" ] && return
  if [ -n "$ab" ]; then
    a="${ab%% *}"; b="${ab##* }"
    [ "$a" != "+0" ] && up="${up}↑${a#+}"
    [ "$b" != "-0" ] && up="${up}↓${b#-}"
  fi
  # Stash + in-progress operation — cheap file checks, no subprocess (real .git dirs only)
  if [ -d "$root/.git" ]; then
    [ -f "$root/.git/refs/stash" ] && stash="\$"
    if   [ -d "$root/.git/rebase-merge" ] || [ -d "$root/.git/rebase-apply" ]; then op="|REBASE"
    elif [ -f "$root/.git/MERGE_HEAD" ];        then op="|MERGE"
    elif [ -f "$root/.git/CHERRY_PICK_HEAD" ];  then op="|CHERRY"
    elif [ -f "$root/.git/BISECT_LOG" ];        then op="|BISECT"
    fi
  fi
  # Match git's __git_ps1 convention: one space between branch and status flags.
  local flags="${up}${staged}${unstaged}${stash}${untracked}"
  printf " (%s%s%s)" "$branch" "${flags:+ $flags}" "$op"
}

# Walk up to find repo type without spawning processes, then render the segment.
_vcs_prompt() {
  local d="$PWD"
  while :; do
    if [ -e "$d/.git" ];                        then _vcs_git_segment "$d"; return; fi
    if [ -d "$d/.hg" ] || [ -d "$d/.sl" ];      then break; fi
    [ "$d" = "/" ] || [ -z "$d" ] && break
    d="${d%/*}"
  done
  # Sapling/Mercurial fallback (devservers): scm-prompt already returns " (name)".
  if declare -F _dotfiles_scm_info >/dev/null 2>&1; then
    _dotfiles_scm_info
  fi
}

export PS1='\[\e[1;34m\]\w\[\e[22;35m\]$(_vcs_prompt)\[\e[33m\] \$ \[\e[0m\]'

# fzf shell integration (cached — `fzf --bash` spawns fzf each startup, ~650ms)
if command -v fzf >/dev/null; then
  _fzf_cache="$HOME/.cache/fzf-bash-init.bash"
  if [ ! -f "$_fzf_cache" ] || [ "$(command -v fzf)" -nt "$_fzf_cache" ]; then
    mkdir -p "$(dirname "$_fzf_cache")"
    fzf --bash > "$_fzf_cache" 2>/dev/null
  fi
  source "$_fzf_cache"
fi

##==============================================================================
# Variables
##==============================================================================

export EDITOR=vim

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH=/usr/local/bin:$PATH:/usr/local/sbin

# Scripts
export PATH=${PATH}:~/bin

# Sublime
export PATH="${PATH}:/Applications/Sublime Text.app/Contents/SharedSupport/bin"

# Android SDK — fb4a path on work machines, Android Studio path on personal
if [ -d /opt/android_sdk ]; then
  export ANDROID_SDK=/opt/android_sdk
  export ANDROID_HOME=${ANDROID_SDK}
elif [ -d ~/Library/Android/sdk ]; then
  export ANDROID_HOME=~/Library/Android/sdk
else
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi
export PATH=${PATH}:${ANDROID_HOME}/emulator
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/tools/bin
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

# Claude Code
export CLAUDE_CODE_NO_FLICKER=1

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init - bash)"

# Added by Antigravity
export PATH="/Users/grantland/.antigravity/antigravity/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Added by Antigravity IDE
export PATH="/Users/grantland/.antigravity-ide/antigravity-ide/bin:$PATH"

# --- cmux shell integration (load last so it composes onto the final prompt) ---
# Sourced directly instead of relying on cmux's exported PROMPT_COMMAND bootstrap,
# which this profile overwrites (line ~40) and bash-git-prompt re-wraps. Loading it
# here restores: new-tab/window cwd inheritance, scrollback restore on relaunch, and
# shell-state reporting. It composes (PROMPT_COMMAND="_cmux_prompt_command;$PROMPT_COMMAND"),
# preserving bash-git-prompt + your title/history hooks.
if [ -n "${CMUX_SHELL_INTEGRATION_DIR:-}" ] && [ -r "${CMUX_SHELL_INTEGRATION_DIR}/cmux-bash-integration.bash" ]; then
    source "${CMUX_SHELL_INTEGRATION_DIR}/cmux-bash-integration.bash"
fi

# Machine-local overrides (persistent per-machine config; not overwritten by restore)
[ -f ~/.bash_profile.local ] && source ~/.bash_profile.local

# Work setup scripts (e.g. setup_fb4a.sh) append below this line.
# The `backup` script truncates here so those appends never reach the repo.
# ===== END MANAGED DOTFILES =====
