## Lines configured by zsh-newuser-install
#HISTFILE=~/.histfile
#HISTSIZE=1000
#SAVEHIST=1000
#setopt extendedglob
#unsetopt beep notify
#bindkey -v
## End of lines configured by zsh-newuser-install
## The following lines were added by compinstall
#zstyle :compinstall filename '/home/will/.zshrc'
#
#autoload -Uz compinit
#compinit
# End of lines added by compinstall

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

autoload -Uz compinit
zstyle ':completion:*' menu select
#zmodload zsh/compinit # Broken
compinit
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

zmodload -i zsh/complist

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.

function set_title() {
    print -Pn "\e]2;$1\a"
}

preexec() {
    echo -ne '\e[5 q' ;

    local a=${${1## *}[(w)1]}  # get the command
    local b=${a##*\/}   # get the command basename
    a="${b}${1#$a}"     # add back the parameters
    a=${a//\%/\%\%}     # escape print specials
    a="${a:gs/[[:space:][:cntrl:]]##/ /}"  # sanitize fancy characters
    
    case "$TERM" in
      screen|screen.*)
        # See screen(1) "TITLES (naming windows)".
        # "\ek" and "\e\" are the delimiters for screen(1) window titles
        print -Pn "\ek%-3~ $a\e\\" # set screen title.  Fix vim: ".
        print -Pn "\e]2;%-3~ $a\a" # set xterm title, via screen "Operating System Command"
        ;;
      rxvt-unicode-256color|alacritty)
        set_title "%m:%-3~ $a"
        ;;
    esac
}
preexec

# precmd() {
##    print -Pn "\e]2;%-3~ \a"
#    case "$TERM" in
#      screen|screen.rxvt)
#        print -Pn "\ek%-3~\e\\" # set screen title
#        print -Pn "\e]2;%-3~\a" # must (re)set xterm title
#        ;;
#    esac
#}

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

export JAVA_HOME=/lib/jvm/java-11-openjdk
export PATH=$PATH:$HOME/scripts

[[ $TERM = "alacritty" ]] && cat ~/.cache/wal/sequences
