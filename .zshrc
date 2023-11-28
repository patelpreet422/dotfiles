# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# custom completions
fpath+=~/.zfunc

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# bash completion
autoload -U bashcompinit
bashcompinit

# export
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/bear/bin:$HOME/bear/libexec:$HOME/bear/libexec/wrapper.d"
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme Monokai\ Extended\ Bright'"
MANROFFOPT="-c"
export FZF_DEFAULT_COMMAND="fd"

# krew kubectl plugin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
  
# prompt
eval "$(starship init zsh)"

# zplug 
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

# end zplug

# helm completion
helm completion zsh > "${fpath[1]}/_helm"

# kind completion
kind completion zsh > "${fpath[1]}/_kind"

# k90s completion
k9s completion zsh > "${fpath[1]}/_k9s"

# alias
alias kk="kubectl"
alias ls="exa --git"
alias tree="exa -T"
alias gg="git log --oneline --graph --all"
alias gga="git add --all"
alias ggs="git status"
alias gb="git branch"
alias grl="git remote show"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


export MANROFFOPT="-c"
export FZF_ALT_C_COMMAND="fd"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
--preview 'bat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"

# use menu select for all completions
zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

# bun completions
[ -s "/Users/kmbl277064/.bun/_bun" ] && source "/Users/kmbl277064/.bun/_bun"


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
