#!/bin/sh

# DISCLAIMER: This is the ugliest fucking shell script I have ever written, and it probably doesn't even work. You have been warned.

DOTFILES=true
PACKAGES=true

read -r -d '' PACMAN_LIST << EOM
base-devel
dhcpcd
git
go
xorg
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


dotfiles() {
#    echo "$COPY_LIST" | while IFS= read -r line; do
#        test -f "$HOME/$line" && mv "$HOME/$line" "$HOME/$line.orig" && echo "Backing up old ~/$line"
#        cp -r "$line" "$HOME"
#    done

    echo "Installing dotfiles..."
    
    cd "$0/../home"
    find | sed '/^\.$/d' | sed 's|\./||' | while read f; do
        test -f "$HOME/$f" && echo "Existing $f found, backing it up..." && mv "$HOME/$f" "$HOME/$f.old"
        cp -v "$f" "$HOME/$f"
    done
}

install_packages() {
    if [ ! "$UID" -eq 0 ] && [ "$1" != "--noelevate" ] && [ "$2" != "--noelevate"]; then
        echo "Root required to install packages"
        echo "If your system is configured to not require root to install packages (why?), run this script with --noelevate"
        echo "$(whoami)" > "$0.username" # Another stupid hack so we can de-elevate for the yay call
        sudo /bin/sh "$0" "postelevate" "$@"
    fi 

    pacman --noconfirm -S $(echo "$PACMAN_LIST" | xargs)

    echo "Installing yay..."
    
    CLONEDIR=$(mktemp -qd)
    git clone "https://aur.archlinux.org/yay.git" "$CLONEDIR/yay"
    cd "$CLONEDIR/yay"

    makepkg --noconfirm -si

    # ihateitihateitihateitihateit
    if [ "$UID" -eq 0 ]; then
        su "$(cat $0.username)" -c "/bin/sh $0 preyay $@"
    fi
}

install_aur_packages() {
    if [ "$1" = "preyay" ]; then rm "$0.username"; fi
    
    echo "Installing AUR packages..."
    yay --noconfirm --answerclean=None --answerdiff=None --answeredit=None -S $(echo "$AUR_LIST" | xargs)

    echo "Done!"
    exit
}

# Shitty hack, *please* tell me a better way to do this.
if [ "$1" = "postelevate" ]; then install_packages; fi
if [ "$1" = "preyay" ]; then install_aur_packages; fi

if [ ! command -v pacman &> /dev/null ]; then
    echo "It looks like this isn't an Arch-based distro. Packages will not be installed."
    read -p "Do you still want to install dotfiles? [y/N] " justdotfiles
    
    PACKAGES=false
    if [ "$justdotfiles" != "y" ] && [ "$justdotfiles" != "Y" ]; then DOTFILES=false; fi
fi

if [ $DOTFILES ]; then copy_dotfiles; fi
if [ $PACKAGES ]; then install_packages; install_aur_packages; fi 
