### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Path's
PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Direnv hook
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

if [[ -f "$HOME/.zsh/powerlevel10k-generated.zsh" ]]; then
    zinit snippet "$HOME/.zsh/powerlevel10k-generated.zsh"
else
    zinit snippet 'https://github.com/Sad-Soul-Eater/dotfiles/raw/master/configs/zsh/powerlevel10k-generated.zsh'
fi

if [[ -f "$HOME/.zsh/powerlevel10k-settings.zsh" ]]; then
    zinit snippet "$HOME/.zsh/powerlevel10k-settings.zsh"
else
    zinit snippet 'https://github.com/Sad-Soul-Eater/dotfiles/raw/master/configs/zsh/powerlevel10k-settings.zsh'
fi

# Prompt
zinit depth'1' nocd light-mode for \
    romkatv/powerlevel10k

# Oh My Zsh libs
# https://github.com/ohmyzsh/ohmyzsh/tree/master/lib
zinit light-mode for \
    OMZL::clipboard.zsh \
    OMZL::completion.zsh \
    OMZL::correction.zsh \
    OMZL::directories.zsh \
    OMZL::functions.zsh \
    OMZL::git.zsh \
	OMZL::grep.zsh \
    if'[[ -z "$commands[atuin]" ]]' OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::spectrum.zsh \
    OMZL::termsupport.zsh

# Oh My Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
zinit wait'0a' lucid light-mode for \
    OMZP::colored-man-pages \
    OMZP::extract \
    OMZP::git \
    OMZP::sudo \
    OMZP::systemd

# Completions
zinit depth'1' wait'0a' lucid blockf atpull'zinit creinstall -q .' light-mode for \
    zsh-users/zsh-completions \
    zchee/zsh-completions

# Plugins
zinit depth'1' wait"0a" lucid light-mode for \
    has'atuin' atload'$(atuin sync >/dev/null 2>&1 &)' atuinsh/atuin \
    if'[[ -z "$commands[atuin]" ]]' zdharma-continuum/history-search-multi-word \
    has'fzf' Aloxaf/fzf-tab \
    has'fzf' wfxr/forgit \
    MichaelAquilina/zsh-you-should-use

zinit depth'1' wait'0c' lucid light-mode for \
    zdharma-continuum/fast-syntax-highlighting \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(reset-prompt); _zsh_autosuggest_start' atinit'ZINIT[COMPINIT_OPTS]=-u; zpcompinit; zpcdreplay' \
        zsh-users/zsh-autosuggestions \

if (( $+commands[lsd] )); then
	alias ls="lsd --size=short"
	alias lt="ls --tree"
fi

if (( $+commands[bat] )); then
	alias cat='bat --decorations never --paging never'
fi

if (( $+commands[nvim] )); then
	export EDITOR="nvim"
	alias v="nvim"
fi

if (( $+commands[htop] )); then
	alias h=htop
fi

if (( $+commands[kubectl] )); then
	alias k=kubectl
fi

if (( $+commands[paru] )); then
	alias puconf='paru -Pg'
	alias puupg='paru -Syu'
	alias pusu='paru -Syu --noconfirm'
	alias puin='paru -S'
	alias puins='paru -U'
	alias pure='paru -R'
	alias purem='paru -Rns'
	alias purep='paru -Si'
	alias pureps='paru -Ss'
	alias puloc='paru -Qi'
	alias pulocs='paru -Qs'
	alias pulst='paru -Qe'
	alias puorph='paru -Qtd'
	alias puinsd='paru -S --asdeps'
	alias pumir='paru -Syy'
	alias puupd='paru -Sy'
fi

# Integrate atuin in zsh-autosuggest
if (( $+commands[atuin] )); then
    _zsh_autosuggest_strategy_atuin_top() {
        suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix "$1")
    }
    ZSH_AUTOSUGGEST_STRATEGY=atuin_top
fi

# Disable highlighting of text pasted into the command line
zle_highlight=('paste:none')

# https://wiki.archlinux.org/index.php/zsh#Persistent_rehash
zstyle ':completion:*' rehash true
