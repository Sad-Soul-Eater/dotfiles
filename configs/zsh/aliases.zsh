if (( $+commands[lsd] )); then
	alias ls="lsd --size=short"
	alias lt="ls --tree"
fi
alias l="ls -lAh"
alias la="ls -Ah"
alias ll="ls -lh"

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

alias v.aliases="$EDITOR ~/.dotfiles/configs/zsh/aliases.zsh"
alias v.picom="$EDITOR ~/.dotfiles/configs/picom/picom.conf"
alias v.conky="$EDITOR ~/.dotfiles/configs/conky/conky.conf"
alias v.i3="$EDITOR ~/.dotfiles/configs/i3/config"
alias v.kitty="$EDITOR ~/.dotfiles/configs/kitty/kitty.conf"
alias v.mpv="$EDITOR ~/.dotfiles/configs/mpv/linux-mpv.conf"
alias v.nvim="$EDITOR ~/.dotfiles/configs/nvim/init.vim"
alias v.polybar="$EDITOR ~/.dotfiles/configs/polybar/config"
alias v.zsh="$EDITOR ~/.dotfiles/configs/zsh/zshrc"

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'

# vim: set ft=zsh:
