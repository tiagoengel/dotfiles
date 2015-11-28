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

# }}

# Default User {{
  echo "-----------------------------------------------------"
  read -p "USER NAME:" USERNAME
  useradd -m -g users -G users,audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash "$USERNAME"
  passwd "$USERNAME"
  # Uncomment to allow members of group wheel to execute any command
  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

# }}

# GRUB {{
 
  pacman -S --noconfirm grub

  grub-install --recheck /dev/sda
  grub-mkconfig -o /boot/grub/grub.cfg

# }}

exit  

