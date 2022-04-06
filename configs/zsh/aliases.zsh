if (( $+commands[lsd] )); then
	alias ls="lsd --size=short"
	alias lt="ls --tree"
fi
alias l="ls -lAh"
alias la="ls -Ah"
alias ll="ls -lh"

alias md="mkdir -pv"

if (( $+commands[bat] )); then
	alias cat='bat --decorations never --paging never'
fi

if (( $+commands[nvim] )); then
	EDITOR="nvim"
	alias v="nvim"
fi

if (( $+commands[reflector] )); then
	alias update-mirrorlist="sudo reflector --verbose --age 6 --sort rate --score 20 --save /etc/pacman.d/mirrorlist"
fi

if (( $+commands[htop] )); then
	alias h=htop
fi

if (( $+commands[mpv] )); then
	alias mpv-twitch="mpv --profile=twitch"
	alias mpv-interpolation="mpv --profile=interpolation"
fi

alias q="exit"

alias dotfiles="cd ~/.dotfiles"
alias dotfiles-update="git -C ~/.dotfiles pull --rebase"

alias v.aliases="$EDITOR ~/.dotfiles/configs/zsh/aliases.zsh"
alias v.powerlevel10k-settings="$EDITOR ~/.dotfiles/configs/zsh/powerlevel10k-settings.zsh"
alias v.variables="$EDITOR ~/.dotfiles/configs/zsh/variables.zsh"
alias v.zsh="$EDITOR ~/.dotfiles/configs/zsh/zshrc.zsh"

alias v.alacritty="$EDITOR ~/.dotfiles/configs/alacritty/alacritty.yml"
alias v.picom="$EDITOR ~/.dotfiles/configs/picom/picom.conf"
alias v.conky="$EDITOR ~/.dotfiles/configs/conky/conky.conf"
alias v.i3="$EDITOR ~/.dotfiles/configs/i3/config"
alias v.kitty="$EDITOR ~/.dotfiles/configs/kitty/kitty.conf"
alias v.mpv="$EDITOR ~/.dotfiles/configs/mpv/linux-mpv.conf"
alias v.nvim="$EDITOR ~/.dotfiles/configs/nvim/init.vim"
alias v.polybar="$EDITOR ~/.dotfiles/configs/polybar/config"

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

# vim: set ft=zsh:
