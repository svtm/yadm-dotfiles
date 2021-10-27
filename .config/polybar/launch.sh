#!/usr/bin/env sh

killall -q polybar


while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#polybar top &

echo "Bars launched"

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #PRIMARY=$(xrandr --query | grep $m | grep "primary")
    #if [ -z PRIMARY ]; then
    #  MONITOR=$m polybar --reload primary &  
    #else
    #  MONITOR=$m polybar --reload top &
    #fi
    MONITOR=$m polybar --reload top &
  done
else
  polybar --reload top &
fi
