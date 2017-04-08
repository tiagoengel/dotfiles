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

#ASDF
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

fortune | cowsay

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/tiago/google-cloud-sdk/path.zsh.inc' ]; then source '/home/tiago/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/tiago/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/tiago/google-cloud-sdk/completion.zsh.inc'; fi
