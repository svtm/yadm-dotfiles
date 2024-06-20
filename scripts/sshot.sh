if [[ "$XDG_SESSION_TYPE" == "wayland" ]]
then
	IMG=~/screenshots/$(date +'%Y-%m-%d-T%H-%M-%S').png && slurp | grim -g - $IMG && wl-copy < $IMG;
else
	maim -s | tee ~/screenshots/$(date +'%Y-%m-%d-T%H-%M-%S').png | xclip -selection clipboard -t image/png;
fi;
