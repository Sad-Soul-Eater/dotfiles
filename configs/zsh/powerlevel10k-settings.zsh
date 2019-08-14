source ~/.zplugin/plugins/romkatv---powerlevel10k/config/p10k-lean.zsh

if [[ -o 'aliases' ]]; then
	# Temporarily disable aliases.
	'builtin' 'unsetopt' 'aliases'
	local p10k_lean_restore_aliases=1
else
	local p10k_lean_restore_aliases=0
fi

() {
	emulate -L zsh
	setopt no_unset

	typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
		# =========================[ Line #1 ]=========================
		# os_icon               # os identifier
		dir                     # current directory
		vcs                     # git status
		# =========================[ Line #2 ]=========================
		newline
		prompt_char             # prompt symbol
	)

	typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
		# =========================[ Line #1 ]=========================
		status                  # exit code of the last command
		command_execution_time  # duration of the last command
		background_jobs         # presence of background jobs
		virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
		anaconda                # conda environment (https://conda.io/)
		pyenv                   # python environment (https://github.com/pyenv/pyenv)
		nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
		nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
		nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
		go_version              # go version (https://golang.org)
		rust_version            # rustc version (https://www.rust-lang.org)
		# node_version          # node.js version
		kubecontext             # current kubernetes context (https://kubernetes.io/)
		context                 # user@host
		# =========================[ Line #2 ]=========================
		newline
		# nordvpn               # nordvpn connection status, linux only (https://nordvpn.com/)
		# public_ip             # public IP address
		# battery               # internal battery
		time                    # current time
	)

	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='▶'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='◀'

	typeset -g POWERLEVEL9K_TIME_FOREGROUND=8
	typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true
}

(( ! p10k_lean_restore_aliases )) || setopt aliases
'builtin' 'unset' 'p10k_lean_restore_aliases'

# vim: set ft=zsh:
