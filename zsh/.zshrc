# Set up the prompt
autoload -Uz promptinit
promptinit

# Use modern completion system
autoload -Uz compinit
compinit

# Use VCS Info
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# plugins
source $HOME/.zplug/init.zsh

# manage zplug itself like other plugins
zplug "zplug/zplug", hook-build:"zplug --self-manage"
# RPROMPT (Git)
zplug "olivierverdier/zsh-git-prompt", use:zshrc.sh
# asdf
zplug "asdf-vm/asdf", \
  from:github, \
  as:command, \
  rename-to:asdf, \
  use:asdf.sh, \
  hook-load:". $ZPLUG_HOME/repos/asdf-vm/asdf/asdf.sh"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# PROMPT
NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{13} %F{0}%~%f %k${NEWLINE}%F{4}( '_') < %f"
RPROMPT='$(git_super_status)'

setopt histignorealldups sharehistory

# Use vim keybindings
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# XDG Base Directory
# export $XDG_CONFIG_HOME="$HOME/.config"
# export $XDG_CACHE_HOME="$HOME/.cache"

# path
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/nvim/bin:$PATH"

# options
setopt equals

# aliases
case ${OSTYPE} in
  darwin*)
    alias ll='ls -lahG'
    ;;
  linux*)
    alias ll='ls -lah --color=auto'
    ;;
esac
alias rl='exec $SHELL -l'
alias g='cd $(ghq root)/$(ghq list | peco)'

# golang
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/.go"
