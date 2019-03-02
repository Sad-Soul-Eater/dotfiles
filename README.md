<h1 align="center">✨Dotfiles✨</h1>

1. [Installation](#installation)
2. [Requirements](#requirements)
3. [Available profiles/configurations](#profiles-configs)

![Clean](https://imgur.com/mNoRwHM.png "Clean")
<p align="center">
<img align="center" height="80" style="padding-left: 5px; padding-right: 5px" src="https://imgur.com/mh8Zeuu.png">
<img align="center" height="80" style="padding-left: 5px; padding-right: 5px" src="https://imgur.com/95fKc24.png">
</p>
<p align="center">
<font size=2>
<a href="https://www.reddit.com/r/Animewallpaper/comments/afj0b2/suwako_moriya_2560x1440/">Wallpaper</a>
<a href="https://imgur.com/gallery/HwyioVB">More screenshots(old)</a>
</font>
</p>

<div id="installation">
<h2 align="center">How to install</h2>

- Clone this repositoty
- Install [jq](https://stedolan.github.io/jq/) -- It needed for dotbot config merging and [faster](https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Troubleshooting.md#why-is-my-prompt-slow) prompt in [spaceship](https://github.com/denysdovhan/spaceship-prompt) theme.
- Run <code>./install-profile <<a href="#profiles">profile-name</a>></code> to symlink all configs or <code>./install-standalone <<a href="#configs">config-name</a>></code> to symlink only one of them
- Done!

>All safe, it won't kill your dotfiles, if folder/file already exists you'll see error during install process

<font size=2> *My dotfiles managed by [DotBot™](https://github.com/anishathalye/dotbot)* </font>

</div>

<div id="requirements">
<h2 align="center">To experience the full power of my Dotfiles you need:</h2>

* [i3-gaps](https://github.com/Airblader/i3) - dynamic tiling window manager
    * [polybar](https://github.com/jaagr/polybar) - fast and easy-to-use tool for creating status bars
    * [rofi](https://github.com/DaveDavenport/rofi) - window switcher, application launcher and dmenu replacement
    * [compton](https://github.com/yshui/compton) - compositor for X
    * [dunst](https://github.com/dunst-project/dunst) - lightweight and customizable notification daemon
    * [conky](https://github.com/brndnmtthws/conky) - light-weight system monitor for X
    * [clipmenu](https://github.com/cdown/clipmenu) - clipboard management using dmenu
    * [maim](https://github.com/naelstrof/maim) - takes screenshots of your desktop.
    * [feh](http://feh.finalrewind.org/) - used to manage wallpaper
    * [sxiv](https://github.com/muennich/sxiv) - Simple X Image Viewer
* [mpv](https://github.com/mpv-player/mpv) - video player based on MPlayer/mplayer2
* [kitty](https://github.com/kovidgoyal/kitty) - A cross-platform, fast, feature full, GPU based terminal emulator with **ligatures** support
* zsh - powerful shell that operates as both an interactive shell and as a scripting language interpreter
    * [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) - delightful, open source, community-driven framework for managing your ZSH configuration
        * [spaceship](https://github.com/denysdovhan/spaceship-prompt) theme
    * [neofetch](https://github.com/dylanaraps/neofetch) - command-line system information tool written in bash 3.2+
    * [ranger](https://github.com/ranger/ranger) - VIM-inspired filemanager for the console
* [yay](https://github.com/Jguer/yay) - Yet another Yogurt - An AUR Helper written in Go
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
