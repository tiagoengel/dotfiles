#!/bin/bash

. ../.functions
. utils.sh

print_title "Arch post-installation script.
# This script will install and configure some useful programs.
# It is not recommended run this script more than once."
question_for_answer "Continue?"
if [ "$OPTION" != "y" ]; then 
  exit 1
fi

check_user


print_title "BASIC TOOLS"
pacman -S --noconfirm wget
install_status
sumary "Basic tools installation"
finish_function


print_title "YAOURT - https://wiki.archlinux.org/index.php/Yaourt"
pacman -S --noconfirm base-devel yajl

su -l $USERNAME --command="
wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz;
tar zxvf package-query.tar.gz;
cd package-query;
makepkg --noconfirm;
"
cd /home/$USERNAME/package-query
install_package
cd ..
rm -fr package-query*

su -l $USERNAME --command="
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz;
tar zxvf yaourt.tar.gz;
cd yaourt;
makepkg --noconfirm;
"
cd /home/$USERNAME/yaourt
install_package
cd ..
rm -fr yaourt*

install_status
sumary "Yaourt installation"
finish_function

# print_title "INTEL GPU DRIVER"
# pacman -S --noconfirm xf86-video-intel
# install_status
# sumary "Intel GPU driver installation"


# print_title "NVIDIA GPU DRIVER"
# pacman -S --noconfirm libvdpau nvidia nvidia-utils
# install_status
# sumary "Intel GPU driver installation"


# print_title "BUMBLEBEE - support NVIDIA Optimus technology under Linux"
# pacman -Rdd --noconfirm lib32-nvidia-libgl
# pacman -S --noconfirm lib32-virtualgl lib32-nvidia-utils lib32-mesa-libgl bumblebee
# gpasswd -a user bumblebee
# systemctl enable bumblebee
# install_status
# sumary "BUMBLEBEE installation"

print_title "XORG SERVER"
pacman -S --noconfirm xorg-server xorg-server-utils
install_status
sumary "Xorg server installation"


print_title "KDE"
pacman -S --noconfirm plasma sddm
systemctl enable sddm
# Do not upgrade kde wallpapers 
echo "
IgnorePkg=plasma-workspace-wallpapers
IgnorePkg=kde-wallpapers
IgnorePkg=kdeartwork-wallpapers
IgnorePkg=kdeartwork-weatherwallpapers
" >> /etc/pacman.conf
install_status
sumary "Kde installation"



