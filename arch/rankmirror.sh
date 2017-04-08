#!/bin/bash

print_title "RANKMIRROR - https://wiki.archlinux.org/index.php/Mirrors"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
sumary "New mirrorlist creation"
finish_function
