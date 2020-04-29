if (( $+commands[lsd] )); then
	alias ls="lsd --size=short"
	alias lt="ls --tree"
fi
alias l="ls -lAh"
alias la="ls -Ah"
alias ll="ls -lh"

if (( $+commands[xcp] )); then
	alias cp="xcp -w 0"
else
	alias cp="cp -v"
fi
alias mv="mv -v"

if (( $+commands[nvim] )); then
	export EDITOR="nvim"
	alias v="nvim"
fi

alias update-mirrorlist="sudo reflector --verbose -c 'IT' -c 'GE' -c 'NL' -c 'UA' --age 1 --sort rate --save /etc/pacman.d/mirrorlist"
alias full-update="yay -Syu --noconfirm && echo '\nFlatpak:' && flatpak update --noninteractive && echo '\nCargo:' && cargo install-update -a"
alias h=htop

alias m="mpv"
alias mt="mpv --profile=twitch"
alias mi="mpv --profile=interpolation"

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

alias md="mkdir -p"

# vim: set ft=zsh:
