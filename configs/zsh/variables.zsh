# Opts
setopt interactive_comments auto_cd

# Autoload
autoload -Uz zargs allopt zed zmv zcp zln colors
colors


# Zsh autosuggest settings
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true


# Fix highlighting
ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(${(@)ZSH_AUTOSUGGEST_IGNORE_WIDGETS:#zle-\*} zle-\^line-init)


# Path's
PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if (( $+commands[go] )); then
	GOPATH=$HOME/go
	PATH="$GOPATH/bin:$PATH"
fi

if (( $+commands[ruby] )); then
	GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
	PATH="$GEM_HOME/bin:$PATH"
fi


# Disable highlighting of text pasted into the command line
zle_highlight=('paste:none')

# Use bat (https://github.com/sharkdp/bat) for man page colorizing
if (( $+commands[bat] )); then
	MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Use fd for finding files/dirs
if (( $+commands[fd] || $+commands[fdfind] )); then
	if (( $+commands[fd] )); then         # Arch
		local FD_COMMAND="fd"
	elif (( $+commands[fdfind] )); then   # Ubuntu
		local FD_COMMAND="fdfind"
	fi
	FZF_DEFAULT_COMMAND="$FD_COMMAND --type f --follow --color=always --exclude go/src --exclude go/pkg"
	FZF_DEFAULT_OPTS="--ansi"

	FZF_ALT_C_COMMAND="$FD_COMMAND --type d --follow --color=always --exclude go/src --exclude go/pkg"
	FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Show the entries of the directory
if (( $+commands[tree] )); then
	FZF_ALT_C_OPTS="--ansi --preview 'tree -C {} | head -200'"
fi

# Give a preview of directory when completing cd
if (( $+commands[lsd] )); then
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color always $realpath 2> /dev/null | head -200'
fi

# zstyle for kill completion
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# https://wiki.archlinux.org/index.php/zsh#Persistent_rehash
zstyle ':completion:*' rehash true

# vim: set ft=zsh:
