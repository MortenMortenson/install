#!bin/bash
echo What is your root password
read rootpassword

#locale and time
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo "KEYMAP=no-latin1" >> /etc/vconsole.conf

#Mirrors and pacman
reflector --country NO --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
pacman -Syy
pacman -S grub efibootmgr linux-lts base-devel btrfs-progs lightdm-gtk-greeter i3-wm alacritty networkmanager network-manager-applet

#Hostname
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

#Users and password
echo root:$rootpassword | chpasswd
useradd -m -G wheel -s /bin/zsh morten
echo morten:$rootpassword | chpasswd
sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers

#Grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/BINARIES=()/BINARIES=(btrfs)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux-lts

#Exports
#export VISUAL=nano
systemctl enable lighdm.service

