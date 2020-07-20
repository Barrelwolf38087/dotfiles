#!/bin/zsh

# In the future, there will be shit here! Wow!

if [ ! command -v pacman &> /dev/null ]; then
    echo >&2 "pacman not found, aborting!"
    exit 1
fi

