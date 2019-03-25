<h1 align="center">✨Dotfiles✨</h1>

1. [Installation](#installation)
2. [Requirements](#requirements)
3. [Available profiles/configurations](#profiles-configs)

![Clean](https://i.imgur.com/uqzQlGw.png "Clean")
<p align="center">
<img align="center" height="80" style="padding-left: 5px; padding-right: 5px" src="https://i.imgur.com/JvhiPSi.png">
<img align="center" height="80" style="padding-left: 5px; padding-right: 5px" src="https://i.imgur.com/OBBxDlo.png">
</p>
<p align="center">
<font size=2>
<a href="https://www.reddit.com/r/Animewallpaper/comments/b5f2vx/the_horns_original_2560x1080_1920x1080_1080x1920/">Wallpaper</a>
<a href="https://imgur.com/gallery/HwyioVB">More screenshots(old)</a>
</font>
</p>

<div id="installation">
<h2 align="center">How to install</h2>

- Clone this repositoty
- Run <code>./install-profile <<a href="#profiles">profile-name</a>></code> to symlink all configs or <code>./install-standalone <<a href="#configs">config-name</a>></code> to symlink only one of them
- Done!

>All safe, it won't kill your dotfiles, if folder/file already exists you'll see error during install process

<font size=2> *My dotfiles managed by [DotBot™](https://github.com/anishathalye/dotbot)* </font>

</div>

<div id="requirements">
<h2 align="center">To experience the full power of my Dotfiles you need:</h2>

* [i3-gaps](https://github.com/Airblader/i3) - dynamic tiling window manager - [config](configs/i3/config)
    * [polybar](https://github.com/jaagr/polybar) - fast and easy-to-use tool for creating status bars - [config](configs/polybar/config)
    * [rofi](https://github.com/DaveDavenport/rofi) - window switcher, application launcher and dmenu replacement
    * [compton](https://github.com/yshui/compton) - compositor for X - [config](configs/compton/compton.conf)
    * [dunst](https://github.com/dunst-project/dunst) - lightweight and customizable notification daemon - [config](configs/dunst/dunstrc)
    * [conky](https://github.com/brndnmtthws/conky) - light-weight system monitor for X - [config](configs/conkyrc)
    * [clipmenu](https://github.com/cdown/clipmenu) - clipboard management using dmenu
    * [maim](https://github.com/naelstrof/maim) - takes screenshots of your desktop
    * [feh](http://feh.finalrewind.org/) - used to manage wallpaper
    * [sxiv](https://github.com/muennich/sxiv) - Simple X Image Viewer
* [kitty](https://github.com/kovidgoyal/kitty) - A cross-platform, fast, feature full, GPU based terminal emulator with **ligatures** support - [config](configs/kitty)
* [neovim](https://github.com/neovim/neovim) - Vim-fork focused on **extensibility** and usability - [config](configs/nvim/init.vim)
    * [vim-plug](https://github.com/junegunn/vim-plug) - Minimalist Vim Plugin Manager
* [zsh](http://zsh.sourceforge.net) - powerful shell that operates as both an interactive shell and as a scripting language interpreter - [config](configs/zsh)
    * [zplugin](https://github.com/zdharma/zplugin) - Flexible Zsh plugin manager with **turbo mode**, clean fpath, reports, completion management
    * [neofetch](https://github.com/dylanaraps/neofetch) - command-line system information tool written in bash 3.2+ - [config](configs/neofetch/config.conf)
* [mpv](https://github.com/mpv-player/mpv) - **video player** based on MPlayer/mplayer2 - [config](configs/mpv)
* [yay](https://github.com/Jguer/yay) - Yet another Yogurt - An AUR Helper written in Go - [config](configs/yay/config.json)
* Fonts:
    * [FiraGO](https://github.com/bBoxType/FiraGO) - interface font
    * [FiraCode](https://github.com/tonsky/FiraCode) - terminal font
    * [FuraCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) - used for icons in polybar and conky
    * [FontAwesome](https://fontawesome.com/) - used for icons in polybar and conky
    * [Material Design Icons](https://aur.archlinux.org/packages/ttf-material-design-icons-git/) - used for icons in polybar and conky

</div>

<div id="profiles-configs">
<h2 align="center">Available profiles/configurations</h2>

### Profiles
```
├── server (bin dotfiles sv_htop neofetch neovim xresources zsh)
└── workstation (all configs)
```
### Configs
```
├── alacritty
├── bin
├── compton
├── conky
├── dotfiles
├── dunst
├── i3
├── kitty
├── mpv
├── neofetch
├── neovim
├── polybar
├── ranger
├── sv_htop
├── ws_htop
├── xresources
├── yay
└── zsh
```

</div>
