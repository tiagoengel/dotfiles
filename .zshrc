# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh

dircolors $HOME/.dir_colors/dircolors.256dark > /dev/null
ZSH_THEME="agnoster"
DEFAULT_USER="$USER"

plugins=(git mvn extract history-substring-search themes)

source $ZSH/oh-my-zsh.sh > /dev/null 2>&1
source $HOME/.exports
source $HOME/.functions
source $HOME/.aliases
source $HOME/.hashes

eval "$(rbenv init -)"

fortune | cowsay
