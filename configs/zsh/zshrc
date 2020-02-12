### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

autoload -Uz zargs zmv zcp zln

source ~/.zsh/variables.zsh

# Prompt
zinit ice depth=1 atload"!source ~/.zsh/powerlevel10k-settings.zsh" lucid nocd
zinit light romkatv/powerlevel10k

# Oh-my-zsh libs
zinit snippet OMZ::lib/history.zsh

zinit snippet OMZ::lib/key-bindings.zsh

zinit ice wait lucid
zinit snippet OMZ::lib/git.zsh

zinit ice wait lucid
zinit snippet OMZ::lib/completion.zsh

zinit ice wait lucid
zinit snippet OMZ::lib/grep.zsh

# Oh-my-zsh plugins
zinit ice wait lucid atload"unalias grv"
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/systemd/systemd.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/extract/extract.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/archlinux/archlinux.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/systemadmin/systemadmin.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/golang/golang.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh

zinit ice wait lucid as'completion' blockf
zinit snippet OMZ::plugins/ripgrep/_ripgrep

# Plugins

zinit light mafredri/zsh-async

zinit ice wait"1" lucid
zinit light wfxr/forgit

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait"1" lucid
zinit light hlissner/zsh-autopair

zinit ice wait"1" lucid
zinit light peterhurford/up.zsh

zinit ice wait lucid
zinit light zdharma/history-search-multi-word

zinit ice wait"1" lucid
zinit light MichaelAquilina/zsh-you-should-use

zinit ice wait blockf lucid atpull"zinit creinstall -q ."
zinit light clarketm/zsh-completions

zinit ice wait lucid atinit"zicompinit; zicdreplay" atload"unset 'FAST_HIGHLIGHT[chroma-whatis]' 'FAST_HIGHLIGHT[chroma-man]'"
zinit light zdharma/fast-syntax-highlighting

zinit ice wait lucid compile"{src/*.zsh,src/strategies/*.zsh}" atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid atload"bindkey '$terminfo[kcuu1]' history-substring-search-up; bindkey '$terminfo[kcud1]' history-substring-search-down"
zinit light zsh-users/zsh-history-substring-search

source ~/.zsh/aliases.zsh
