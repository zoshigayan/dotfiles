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
export ASDF_CONFIG_FILE=$HOME/dotfiles/asdf/.asdfrc
export ASDF_NPM_DEFAULT_PACKAGES_FILE=$HOME/dotfiles/asdf/.default-npm-packages

# fzf
zplug "junegunn/fzf", \
  from:github, \
  as:command, \
  rename-to:fzf, \
  use:bin/fzf, \
  hook-build:". $ZPLUG_HOME/repos/junegunn/fzf/install --bin"

# ripgrep
zplug "BurntSushi/ripgrep", \
  from:gh-r, \
  as:command, \
  rename-to:rg

# bat
zplug "sharkdp/bat", \
  from:gh-r, \
  as:command, \
  rename-to:bat

# interactive ripgrep
fzgrep() {
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --preview 'bat --style=numbers --color=always --line-range :500 `echo {} | cut -f 1 -d ":"`'
}

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

# Use vim keybindings
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

setopt HIST_NO_STORE
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt SHAREHISTORY

fuzzy_search_history() {
  selected=`history 1 | fzf | sed -E 's/^\ *[0-9]+\ *//'`
  BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fuzzy_search_history
bindkey "^R" fuzzy_search_history

kill_buffer() {
  BUFFER=""
  zle redisplay
}
zle -N kill_buffer
bindkey "^U" kill_buffer

move_ghq_directories() {
  selected=`ghq list | fzf`
  if [ ${#selected} -gt 0 ]
  then
    target_dir="`ghq root`/$selected"
    echo "cd $target_dir"
    cd $target_dir
    zle accept-line
  fi
}
zle -N move_ghq_directories
bindkey "^]" move_ghq_directories

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

# golang
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/.go"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi
