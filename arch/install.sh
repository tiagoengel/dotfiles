#!/bin/bash

. ../.functions
. utils.sh

check_user

print_title "Arch installation script.
# This script will install and configure the base
# packages for arch linux.
# DO NOT run this script if you already have arch instaled"
question_for_answer "Continue?"
if [ "$OPTION" != "y" ]; then 
  exit 1
fi

. rankmirror.sh


# Base packages {{

  print_title "Installing the base packages"
  pacstrap /mnt base networkmanager sudo
  sumary "Base packages"
  finish_function

# }}


# Basic configs {{

  print_title "Basic configurations"

  arch-chroot /mnt

  read -p "Computer Name: " COMPUTER_NAME
  echo "$COMPUTER_NAME" > /etc/hostname

  # LOCALE
  ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  sed 's/^#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen -i
  locale-gen

  echo "LANG=pt_BR.utf8" > /etc/locale.conf

  echo "KEYMAP=us
  FONT=lat9w-16
  FONT_MAP=8859-1_to_uni" > /etc/vconsole.conf

  systemctl enable NetworkManager

  mkinitcpio -p linux

  sumary "Basic configurations"
  finish_function

# }}

# Default User {{

  print_title "Default user"

  read -p "User name:" $USERNAME
  useradd -m -g users -G users,audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$USERNAME"
  passwd "$USERNAME"
  # Uncomment to allow members of group wheel to execute any command
  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

  sumary "Default user creation"
  finish_function

# }}

# GRUB {{
 
  print_title "Grub"
  
  pacman -S --noconfirm grub

  grub-install --recheck /dev/sdx
  grub-mkconfig -o /boot/grub/grub.cfg

  sumary "Grub intallation"
  finish_function
# }}
  

echo "All done! Use the 'post-install' script after reboot to configure the rest of the system."
question_for_answer "Reboot now?"
if [ "$OPTION" != "y" ]; then 
  exit 1
fi

