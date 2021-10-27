MOUSE_INPUT_ID=`xinput list | grep "Logitech Wireless Mouse" | sed 's/.*id=\([0-9 ]*\).*/\1/'`
xinput set-button-map $MOUSE_INPUT_ID 1 2 3 4 5 6 7 10 11 9 8

