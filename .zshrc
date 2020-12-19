# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# custom completions
fpath+=~/.zfunc

# The following lines were added by compinstall
zstyle :compinstall filename '/home/preet/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# bash completion
autoload -U bashcompinit
bashcompinit

# pipx completion
eval "$(register-python-argcomplete pipx)"

# export
export PATH="$PATH:/home/preet/go/bin"
export PATH="$PATH:/home/preet/.yarn/bin"
export PATH="$PATH:/home/preet/bear/bin:/home/preet/bear/libexec:/home/preet/bear/libexec/wrapper.d"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
MANROFFOPT="-c"
export FZF_DEFAULT_COMMAND="fd"

# prompt
eval "$(starship init zsh)"

# zplug 
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# end zplug

# alias
alias ls="exa --git"
a
