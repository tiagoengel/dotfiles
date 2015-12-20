#!/bin/bash

# partition disk - cfdisk
# create file system - mkfs.ext4 
# mount on /mnt

# DOWNLOAD wget --no-check-certificate https://github.com/tiagoengel/dotfiles/archive/master.tar.gz

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

  genfstab -p /mnt >> /mnt/etc/fstab
  
  # Copy to /mnt to use with arch-chroot
  cp ./basic-configs.sh /mnt
  arch-chroot /mnt ./basic-configs.sh
  rm /mnt/basic-configs.sh

  sumary "Basic configurations"
  finish_function

# }}

print_line

echo "All done! Use the 'post-install' script after reboot to configure the rest of the system."
question_for_answer "Reboot now?"
if [ "$OPTION" == "y" ]; then 
  reboot
fi
