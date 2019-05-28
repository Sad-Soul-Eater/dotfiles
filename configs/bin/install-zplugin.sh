#!/usr/bin/env bash

ZPLG_HOME="${ZDOTDIR:-$HOME}/.zplugin"
if [ ! -d "$ZPLG_HOME" ]; then

	echo -n "Install Zplugin? (y/n)? "
	read -r answer

	if [ "$answer" != "${answer#[Yy]}" ]; then
		if ! test -d "$ZPLG_HOME"; then
			mkdir "$ZPLG_HOME"
			chmod g-rwX "$ZPLG_HOME"
		fi

		echo ">>> Downloading zplugin to $ZPLG_HOME/bin"
		if test -d "$ZPLG_HOME/bin/.git"; then
			cd "$ZPLG_HOME/bin"
			git pull origin master
		else
			cd "$ZPLG_HOME"
			git clone --depth 10 https://github.com/zdharma/zplugin.git bin
		fi

		echo ">>> Done"
	else
		echo "Okay :c"
	fi
else
	echo ">>> Zplugin already installed in $ZPLG_HOME/bin"
fi
