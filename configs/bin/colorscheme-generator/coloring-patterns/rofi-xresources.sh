#!/usr/bin/env sh

FOREGROUND=%clfg%
BACKGROUND=%clbg%
BLACK=%cl0%
RED=%cl1%
GREEN=%cl2%
YELLOW=%cl3%
BLUE=%cl4%
MAGENTA=%cl5%
CYAN=%cl6%
WHITE=%cl7%

PATTERN="$(dirname "$(readlink -f "$0")")/rofi-xresources.pt"

if [ -e "$PATTERN" ]; then
	rm "$PATTERN"
fi
touch "$PATTERN"

{
	echo "rofi.color-window:   #$BACKGROUND,#$BLACK,#00$BACKGROUND
rofi.color-normal:   #00$BACKGROUND,#$FOREGROUND,#00$BACKGROUND,#00$BACKGROUND,#$MAGENTA
rofi.color-active:   #00$BACKGROUND,#$GREEN,#00$BACKGROUND,#00$BACKGROUND,#$MAGENTA
rofi.color-urgent:   #00$BACKGROUND,#$YELLOW,#00$BACKGROUND,#00$BACKGROUND,#$MAGENTA"
} >>"$PATTERN"

# Theming help
# color window = background, border, separator
# color normal = background, foreground, background-alt, highlight-background, highlight-foreground
# color active = background, foreground, background-alt, highlight-background, highlight-foreground
# color urgent = background, foreground, background-alt, highlight-background, highlight-foreground
