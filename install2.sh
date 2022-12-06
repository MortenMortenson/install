#locale and time
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
sed 's/#en_US.UTF-8/en_US.UTF8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo "KEYMAP=no-latin1" >> /etc/vconsole.conf

#Mirrors and pacman
reflector --country NO --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sed 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
pacman -Syy

#Hostname
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

#Users and password
echo root:$rootpassword | chpasswd
useradd -m -G wheel -s /bin/zsh morten
echo morten:$rootpassword | chpasswd

#Exports
#export VISUAL=nano

