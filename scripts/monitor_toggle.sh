#!/bin/sh

NUM_MONITORS=`xrandr | grep " connected" | wc -l`

if [[ $NUM_MONITORS -eq 3 ]]; then
    echo "Applying triple monitor layout"
    exec ~/.screenlayout/triple.sh
else
echo "Applying single monitor layout"
    exec ~/.screenlayout/single.sh
fi
