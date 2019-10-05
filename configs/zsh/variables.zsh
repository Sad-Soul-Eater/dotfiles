ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Disable highlighting of text pasted into the command line
zle_highlight=('paste:none')

# Enable Hardcore mode to enforce the use of aliases
export YSU_HARDCORE=1

# vim: set ft=zsh:
