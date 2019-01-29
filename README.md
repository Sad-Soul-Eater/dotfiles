<h1 align="center">Dotfiles</h1>

1. [Instalation](#installation)
2. [Requirements](#requirements)
3. [Available profiles/configurations](#profiles-configs)

Config files for i3, polybar, rofi, mpv, Xresources, alacritty and some bash-things... 

![Clean](https://i.imgur.com/0QYwR57.png "Clean")
<font size=2> <a href="https://www.reddit.com/r/Animewallpaper/comments/afj0b2/suwako_moriya_2560x1440/">Wallpaper</a> 
<a href="https://imgur.com/gallery/HwyioVB">More screenshots</a>
</font>

<div id="installation">
<h2 align="center">How to install</h2>

- Clone this repositoty
- Run <code> ./install-profile <<a href="#profiles">profile-name</a>> </code> to symlink all configs or <code> ./install-standalone <<a href="#configs">config-name</a>> </code> to symlink only one of them
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
    * [maim](https://github.com/naelstrof/maim) - (make image) takes screenshots of your desktop.
    * [feh](http://feh.finalrewind.org/) - i used it to manage wallpaper
    * [sxiv](https://github.com/muennich/sxiv) - Simple X Image Viewer
* [mpv](https://github.com/mpv-player/mpv) - video player based on MPlayer/mplayer2
* [alacritty](https://github.com/jwilm/alacritty) - fastest terminal emulator in existence
* zsh - powerful shell that operates as both an interactive shell and as a scripting language interpreter
    * [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) - delightful, open source, community-driven framework for managing your ZSH configuration
        * [spaceship](https://github.com/denysdovhan/spaceship-prompt) theme
    * [neofetch](https://github.com/dylanaraps/neofetch) - command-line system information tool written in bash 3.2+
    * [ranger](https://github.com/ranger/ranger) - VIM-inspired filemanager for the console
* [yay](https://github.com/Jguer/yay) - Yet another Yogurt - An AUR Helper written in Go
* Fonts:
    * [FiraGO](https://github.com/bBoxType/FiraGO) - main interface font
    * [FuraCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) - terminal font
    * [FontAwesome](https://fontawesome.com/) - used for icons in polybar
    * Some fonts neded for conky - [link](https://drive.google.com/file/d/1m0qbqjxZyCqe11b_lhHqRN9BeCP9MMDt/view?usp=sharing)

</div>

<div id="profiles-configs">
<h2 align="center">Available profiles/configurations</h2>

### Profiles
```
└── profiles
│  ├── server
│  └── workstation
```
### Configs
```
└── configs
│  ├── alacritty
│  ├── bin
│  ├── compton
│  ├── conky
│  ├── dotfiles
│  ├── dunst
│  ├── i3
│  ├── mpv
│  ├── neofetch
│  ├── polybar
│  ├── ranger
│  ├── xresources
│  ├── yay
│  └── zsh
```

</div>