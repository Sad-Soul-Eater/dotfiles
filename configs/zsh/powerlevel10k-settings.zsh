source ~/.zplugin/plugins/romkatv---powerlevel10k/config/p10k-lean.zsh

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
	emulate -L zsh
	setopt no_unset extended_glob
	zmodload zsh/langinfo
	if [[ ${langinfo[CODESET]:-} != (utf|UTF)(-|)8 ]]; then
		local LC_ALL=${${(@M)$(locale -a):#*.(utf|UTF)(-|)8}[1]:-en_US.UTF-8}
	fi

	typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
		# =========================[ Line #1 ]=========================
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
		kubecontext             # current kubernetes context (https://kubernetes.io/)
		context                 # user@host
		ranger                  # ranger shell (https://github.com/ranger/ranger)
		ram                     # free RAM
		load                    # CPU load
		# =========================[ Line #2 ]=========================
		newline
		time                    # current time
	)

	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='▶'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='◀'

	typeset -g POWERLEVEL9K_TIME_FOREGROUND=8
	typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'

# vim: set ft=zsh:
