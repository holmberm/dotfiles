#!/bin/sh

# Change the keyboard layout:
# xkbcomp -w 0 ~/.myconfig/.keyconf.xkb $DISPLAY
setxkbmap dvorak

# Set default colors and stuff for apps.
xrdb -merge ~/.myconfig/.Xresources

#source ~/.xinitrc_local
terminology &
exec xmonad

