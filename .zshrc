# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
# End of lines configured by zsh-newuser-install

# custom completions
fpath+=~/.zfunc

if type brew &>/dev/null; then
  # brew install zsh-completions
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# enable bash completion in zsh
# brew install bash-completion@2 to get bash completions scripts and use them in zsh
# usually not required but can use bash-completions so use it if you really need it
autoload -U bashcompinit
bashcompinit

# export
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
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

# zoxide
eval "$(zoxide init zsh)"

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
[ ! -e "~/.zfunc/_helm" ] &&  helm completion zsh > ~/.zfunc/_helm
# helm completion zsh > ~/.zfunc/_helm

# kind completion
[ ! -e "~/.zfunc/_kind" ] &&  kind completion zsh > ~/.zfunc/_kind
# kind completion zsh > $~/.zfunc/_kind

# minikube completion
[ ! -e "~/.zfunc/_minikube" ] &&  minikube completion zsh > ~/.zfunc/_minikube
# minikube completion zsh > $~/.zfunc/_minikube

# k9s completion
[ ! -e "~/.zfunc/_k9s" ] &&  k9s completion zsh > ~/.zfunc/_k9s
# k9s completion zsh > ~/.zfunc/_k9s

# opa completion
[ ! -e "~/.zfunc/_opa" ] &&  opa completion zsh > ~/.zfunc/_opa
# opa completion zsh > ~/.zfunc/_opa

# aws completion
if type brew &>/dev/null && [[ -e "$(brew --prefix)/bin/aws_completer" ]] then
  complete -C "$(brew --prefix)/bin/aws_completer" aws
  complete -C "$(brew --prefix)/bin/aws_completer" awspersonal
elif [[ -e "/usr/local/bin/aws_completer" ]] then
  complete -C '/usr/local/bin/aws_completer' aws
  complete -C '/usr/local/bin/aws_completer' awspersonal
fi

# pipx completion
eval "$(register-python-argcomplete pipx)"

# alias
alias l="lazygit"
alias n="nvim"
alias sz="source ~/.zshrc"
alias awspersonal="aws --profile personal --no-verify-ssl"
alias kk="kubectl"
alias http="http --verify=no"
alias ls="exa --git"
alias tree="exa -T"
alias gg="git log --oneline --graph --all"
alias ga="git add --all"
alias gco="git checkout"
alias gcm="git commit -m"
alias gss="git status"
alias gb="git branch"
alias gr="git remote"


export MANROFFOPT="-c"
export FZF_ALT_C_COMMAND="fd"

# to use this install fzf from github https://github.com/junegunn/fzf?tab=readme-ov-file#using-git
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

if type brew &>/dev/null && [[ -e $(brew --prefix)/bin/nvm ]] then
  [ -s $(brew --prefix)/opt/nvm/nvm.sh ] && \. $(brew --prefix)/opt/nvm/nvm.sh  # This loads nvm
  [ -s $(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm ] && \. $(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm  # This loads nvm bash_completion
else
  # nvm init for Linux
  [ -e /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

[ -e "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
