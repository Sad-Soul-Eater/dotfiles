#!/bin/bash

FOREGROUND=#%clfg%
BACKGROUND=#%clbg%
BLACK=#%cl0%
RED=#%cl1%
GREEN=#%cl2%
YELLOW=#%cl3%
BLUE=#%cl4%
MAGENTA=#%cl5%
CYAN=#%cl6%
WHITE=#%cl7%

PATTERN="$(dirname $(readlink -f $0))/rofi-xresources.pt"

if [ -e $PATTERN ]; then
  rm $PATTERN
fi
touch $PATTERN

echo "rofi.color-window:   $BACKGROUND,$BLACK,$BACKGROUND"  >>  $PATTERN
echo "rofi.color-normal:   $BACKGROUND,$FOREGROUND,$BACKGROUND,$BACKGROUND,$GREEN"  >>  $PATTERN
echo "rofi.color-active:   $BACKGROUND,$MAGENTA,$BACKGROUND,$BACKGROUND,$GREEN" >>  $PATTERN
echo "rofi.color-urgent:   $BACKGROUND,$YELLOW,$BACKGROUND,$BACKGROUND,$GREEN" >> $PATTERN

# Theming help
# color window = background, border, separator
# color normal = background, foreground, background-alt, highlight-background, highlight-foreground
# color active = background, foreground, background-alt, highlight-background, highlight-foreground
# color urgent = background, foreground, background-alt, highlight-background, highlight-foreground
