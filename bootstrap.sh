#!/bin/sh

# WARNING: This script is completely untested and probably doesn't work. *Do not trust it*.

DOTFILES=true
PACKAGES=true

read -r -d '' COPY_LIST << EOM
bg.png
.config
.fehbg
scripts/clean-orphans
scripts/i3-get-window-criteria
scripts/enable-auto-pywal
.vimrc
.Xresources
.zshrc
EOM

read -r -d '' PACMAN_LIST << EOM
base-devel
dhcpcd
git
go
i3
dmenu
picom
feh
zsh
zsh-syntax-highlighting
unclutter
pulseaudio
networkmanager
EOM

read -r -d '' AUR_LIST << EOM
polybar-git
polybar-spotify-git
siji-git
EOM

# Shitty hack, *please* tell me a better way to do this.
if [ "$1" = "postelevate" ]; then install_packages; fi

dotfiles() {
    echo "$COPY_LIST" | while IFS= read -r line; do
        test -f "$HOME/$line" && mv "$HOME/$line" "$HOME/$line.orig" && echo "Backing up old ~/$line"
        cp -r "$line" "$HOME"
    done
}

install_packages() {
    if [ ! "$UID" -eq 0 ] && [ "$1" != "--noelevate" ] && [ "$2" != "--noelevate"]; then
        echo "Root required to install packages"
        echo "If your system is configured to not require root to install packages (why?), run this script with --noelevate"
        sudo /bin/sh "$0" "postelevate" "$@"
    fi 

    pacman --noconfirm -S $(echo "$PACMAN_LIST" | xargs)

    echo "Installing yay..."
    
    CLONEDIR=$(mktemp -qd)
    git clone "https://aur.archlinux.org/yay.git" "$CLONEDIR/yay"
    cd "$CLONEDIR/yay"

    makepkg --noconfirm -si

    echo "Installing AUR packages..."
    yay --noconfirm --answerclean=None --answerdiff=None --answeredit=None -S $(echo "$AUR_LIST" | xargs)

    echo "Done!"
}

if [ ! command -v pacman &> /dev/null ]; then
    echo "It looks like this isn't an Arch-based distro. Packages will not be installed."
    read -p "Do you still want to install dotfiles? [y/N] " justdotfiles
    
    PACKAGES=false
    if [ "$justdotfiles" != "y" ] && [ "$justdotfiles" != "Y" ]; then DOTFILES=false; fi
fi

if [ $DOTFILES ]; then copy_dotfiles; fi
if [ $PACKAGES ]; then install_packages; fi 
