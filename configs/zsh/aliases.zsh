if (( $+commands[lsd] )); then
	alias ls="lsd --size=short"
	alias l="ls -lA"
	alias la="ls -A"
	alias ll="ls -l"
	alias lt="ls --tree"
fi

if (( $+commands[nvim] )); then
	export EDITOR='nvim'
	alias v="nvim"
fi

alias update-mirrorlist="sudo reflector --verbose -c 'GE' -c 'NL' -c 'UA' --age 6 -p http --sort rate --save /etc/pacman.d/mirrorlist"
alias h=htop
alias mpv-tw="mpv --profile=twitch"

alias q="exit"

alias dotfiles="cd ~/.dotfiles"
alias dotfiles-update="git -C ~/.dotfiles pull --rebase"
alias v.aliases="$EDITOR ~/.dotfiles/configs/zsh/aliases"
alias v.compton="$EDITOR ~/.dotfiles/configs/compton/compton.conf"
alias v.conky="$EDITOR ~/.dotfiles/configs/conky/conky.conf"
alias v.i3="$EDITOR ~/.dotfiles/configs/i3/config"
alias v.kitty="$EDITOR ~/.dotfiles/configs/kitty/kitty.conf"
alias v.mpv="$EDITOR ~/.dotfiles/configs/mpv/linux-mpv.conf"
alias v.nvim="$EDITOR ~/.dotfiles/configs/nvim/init.vim"
alias v.polybar="$EDITOR ~/.dotfiles/configs/polybar/config"
alias v.zsh="$EDITOR ~/.dotfiles/configs/zsh/zshrc"

# vim: set ft=zsh:
