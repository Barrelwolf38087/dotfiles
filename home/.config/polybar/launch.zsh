#!/usr/bin/zsh

killall -q polybar

# while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done
polybar --config=$HOME/.config/polybar/config example &

echo "Polybar started"
