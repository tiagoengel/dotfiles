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

# {{

  print_title "BASIC TOOLS"
  pacman -S --noconfirm wget git curl bc rsync mlocate bash-completion vim tar gzip bzip2 unzip unrar p7zip dbus ntfs-3g ntfsprogs dosfstools openssh samba alsa-lib alsa-utils alsa-plugins xterm fortune-mod cowsay freerdp the_silver_searcher

  systemctl enable dbus
  systemctl enable sshd

  cp /etc/samba/smb.conf.default /etc/samba/smb.conf

  sumary "Basic tools installation"
  finish_function

# }}

# {{

  print_title "YAOURT - https://wiki.archlinux.org/index.php/Yaourt"
  pacman -S --noconfirm yajl

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

  sumary "Yaourt installation"
  finish_function

# }}

# {{

  print_title "TLP - Battery improvement"
  su -l $USERNAME --command="yaourt -S --noconfirm tlp"
  systemctl enable tlp
  sumary "Tlp installation"
  finish_function
  
# }}

# {{

  print_title "ZSH"
  su -l $USERNAME --command="yaourt -S --noconfirm zsh zsh-completions oh-my-zsh-git powerline-fonts-git"
  chsh -s /bin/zsh $USERNAME
  chsh -s /bin/zsh root
  sumary "Zsh installation"
  finish_function

# }}


# {{

  print_title "DEVELOPMENT TOOLS"
  pacman -S --noconfirm jdk7-openjdk jdk8-openjdk maven apache-ant scala sbt nodejs npm meld emacs ruby jruby
  su -l $USERNAME --command="yaourt -S --noconfirm leiningen sublime-text-dev" 

  archlinux-java set java-7-openjdk

  sumary "Development Tools"
  finish_function

# }}


# {{

  print_title "FONTS"
  pacman -S --noconfirm ttf-dejavu ttf-liberation
  su -l $USERNAME --command="yes s | yaourt -S ttf-ms-fonts cairo-infinality fontconfig-infinality freetype2-infinality"
  sumary "Fonts installation"
  finish_function 

# }}


# {{

  print_title "DOCKER"
  pacman -S --noconfirm docker
  groupadd docker
  gpasswd -a $USERNAME docker
  sumary "Docker installation"
  finish_function

# }}

# {{

  print_title "INTEL GPU DRIVER"
  pacman -S --noconfirm xf86-video-intel
  sumary "Intel GPU driver installation"
  finish_function

# }}

# {{

  print_title "NVIDIA GPU DRIVER"
  pacman -S --noconfirm libvdpau nvidia nvidia-utils
  sumary "Intel GPU driver installation"
  finish_function

# }}

# {{

  print_title "BUMBLEBEE - support NVIDIA Optimus technology under Linux"
  pacman -Rdd --noconfirm lib32-nvidia-libgl
  pacman -S --noconfirm lib32-virtualgl lib32-nvidia-utils lib32-mesa-libgl bumblebee
  gpasswd -a $USERNAME bumblebee
  systemctl enable bumblebeed
  sumary "BUMBLEEE installation"
  finish_function

# }}

# {{

  print_title "XORG SERVER"
  pacman -S --noconfirm xorg-server xorg-server-utils xf86-video-vesa xorg-xinit xorg-xkill xf86-input-synaptics
  cp /usr/share/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/
  sumary "Xorg server installation"
  finish_function

# }}

# {{

  print_title "VIRTUALBOX"  
  pacman -S --noconfirm virtualbox virtualbox-guest-utils    
  gpasswd -a $USERNAME vboxusers
  echo "
vboxdrv
vboxnetflt
vboxnetadp
vboxpci
vboxguest
vboxsf
vboxvideo
" > /etc/modules-load.d/virtualbox.conf 
  install_status
  sumary "Virtualbox installation"
  finish_function

# }}

# {{

  print_title "KDE"
  pacman -S --noconfirm plasma sddm yakuake dolphin kate ark kdegraphics-okular phonon-qt5 phonon-qt5-gstreamer phonon-qt4 phonon-qt4-gstreamer kmix kde-gtk-config breeze-kde4 breeze breeze-gtk
  systemctl enable sddm
  # Do not upgrade kde wallpapers 
  sed -i "/\[options\]/aIgnorePkg=plasma-workspace-wallpapers kde-wallpapers kdeartwork-wallpapers kdeartwork-weatherwallpapers" /etc/pacman.conf
  # Configure sddm
  sddm --example-config > /etc/sddm.conf
  # Better theme
  sed -i -e '/Current=/ s/=.*/=breeze/' /etc/sddm.conf
  sed -i -e '/CursorTheme=/ s/=.*/=breeze_cursors/' /etc/sddm.conf  
  sumary "Kde installation"
  finish_function

# }}

# {{
  
  print_title "DEFAULT APPS"
  su $USERNAME --command="yaourt -S --noconfirm spotify skype skypetab-ng-git google-chrome"
  pacman -S --noconfirm vlc libreoffice-fresh libreoffice-fresh-pt-BR 
  sumary "Default apps installation"
  finish_function
  
# }}

# Link dotfiles
cd ..
chmod +x bootstrap.sh
./bootstrap.sh

su -l $USERNAME --command="
git config --global user.name 'Tiago Engel';
git config --global user.email 'tiagohngl@gmail.com';
git config --global credential.helper cache;
git config --global credential.helper cache --timeout=3600;
"

echo "All done!"
question_for_answer "Reboot now?"
if [ "$OPTION" == "y" ]; then 
  reboot
fi
