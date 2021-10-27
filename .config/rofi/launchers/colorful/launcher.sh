#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# style_1     style_2     style_3     style_4     style_5     style_6
# style_7     style_8     style_9     style_10    style_11    style_12

# $1 should be 'window', 'windowcd', 'drun' etc
if [ -z "$1" ]
then
    mode="drun"
else
    mode=$1
fi

#mode=$1
theme="style_7"
dir="$HOME/.config/rofi/launchers/colorful"

# dark
ALPHA="#00000000"
BG="#1e222aff"
FG="#c8ccd4ff"
SELECT="#101010ff"

# light
#ALPHA="#00000000"
#BG="#FFFFFFff"
#FG="#000000ff"
#SELECT="#f3f3f3ff"

# accent colors
COLORS=('#e06c75' '#d19a66' '#e5c07b' '#98c379' '#56b6c2' '#61afef' '#c678dd' '#be5046')
ACCENT="${COLORS[$(( $RANDOM % 8 ))]}ff"

# overwrite colors file
cat > $dir/colors.rasi <<- EOF
	/* colors */

	* {
	  al:  $ALPHA;
	  bg:  $BG;
	  se:  $SELECT;
	  fg:  $FG;
	  ac:  $ACCENT;
	}
EOF

# comment these lines to disable random style
#themes=($(ls -p --hide="launcher.sh" --hide="colors.rasi" $dir))
#theme="${themes[$(( $RANDOM % 12 ))]}"

rofi  -m -1 -no-lazy-grab -show $mode -modi $mode -theme $dir/"$theme"
