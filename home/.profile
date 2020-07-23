export PATH="$HOME/.cargo/bin:$PATH"

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then startx; fi
