# This script is intended to be used inside chroot

# Basic configs {{
  echo "-----------------------------------------------------"
  read -p "COMPUTER NAME: " COMPUTER_NAME
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

  echo "ROOT PASSWORD"
  passwd

# }}

# Default User {{
  
  echo "-----------------------------------------------------"
  read -p "USER NAME:" USERNAME
  useradd -m -g users -G users,audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$USERNAME"
  passwd "$USERNAME"
  # Uncomment to allow members of group wheel to execute any command
  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

# }}

# MULTILIB {{

  echo "[multilib]
Include = /etc/pacman.d/mirrorlist
" >> /etc/pacman.conf 
  pacman -Syu
  pacman -S --noconfirm base-devel 
  yes | pacman -S gcc-multilib lib32-fakeroot lib32-libltdl

# }}

# GRUB {{
 
  pacman -S --noconfirm grub
  
  grub-install --recheck /dev/sdb
  grub-mkconfig -o /boot/grub/grub.cfg

# }}

# Dotfiles {{

  # Check out the dotfiles repo to use in the next boot
  pacman -S --noconfirm git
  su -l $USERNAME --command="git clone https://github.com/tiagoengel/dotfiles"

# }}

exit  

