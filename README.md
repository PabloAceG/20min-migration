Use Ansible to migrate all my configuration and have a new Linux OS running in less that 20 minutes.

# Installation
The first steps are actually external to the automatic configuration, as some of them need to have the OS running so that they can be executed with Ansible.

### Create partitions

Select the disk where the partitions are going to be created:
```shell
fdisk -l
fdisk /dev/sdX
```

Create partitions `root`, `swap` and `boot`, and assign their types:
- New partition -> Primary -> Partition number -> First sector -> Last sector (offset)
- Change partition type -> Partition number -> Type of partition:
   - `83` - Linux filesystem
   - `82` - Linux swap
   - `ef` - UEFI FAT 16/32
```shell
n p 1 <enter> +300M # Hex code ef00
t 1 ef <enter>

n p 2 <enter> +250M # Hex code 8300
t 2 83 <enter>

n p 3 <enter> +500G (to be encrypted) Hex code 8300
t 3 83 <enter>
```

Format partitions:
```shell
mkfs.fat -F 32 /dev/sdX1
mkfs.ext4 /dev/sdX2
```

### System Encription
Setup the encryption of the system:
```shell
cryptsetup --cipher aes-xts-plain64 --verify-passphrase --use-random luksFormat /dev/sdX3
cryptsetup luksOpen /dev/sdX3 luks
```

Create encrypted partitions - this creates on partition for root, modify if need `/home` or other partitions separate.

```shell
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate --size 8G vg0 --name swap
lvcreate -l +100%FREE vg0 --name root
```

Create filesystems on encrypted partitions:
```shell
mkfs.ext4 /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap
```

### Mount the system
```shell
mount /dev/mapper/vg0-root /mnt # /mnt is the installed system

swapon /dev/mapper/vg0-swap # Not needed but a good thing to test

mkdir /mnt/boot
mount /dev/sdX2 /mnt/boot

mkdir /mnt/boot/efi
mount /dev/sdX1 /mnt/boot/efi
```

### Install basic packages

```shell
pacstrap /mnt base base-devel git vim lvm2 grub-efi-x86_64 efibootmgr os-prober linux linux-firmware
```

### Install fstab
```shell
genfstab -pU /mnt >> /mnt/etc/fstab

tmpfs	/tmp	tmpfs	defaults,noatime,mode=1777	0	0
# Make /tmp a ramdisk (add the following line to /mnt/etc/fstab)
# Change relatime on all non-boot partitions to noatime (reduces wear if using an SSD)
```

### Enter the system
```shell
arch-chroot /mnt /bin/bash
```

### Setup system clock
```shell
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc --utc
```

### Set the hostname
```shell
echo HOSTNAME > /etc/hostname
```

### Update locale
```shell
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf
echo LC_ALL=C >> /etc/locale.conf
```

### Set root password
```shell
passwd
```

### Configure mkinitcpio with modules for decryption for the initrd image
```shell
vim /etc/mkinitcpio.conf
# Add 'ext4' to MODULES
# Add 'encrypt' and 'lvm2' to HOOKS before filesystems

# Regenerate initrd image
mkinitcpio -p linux
```

### Setup grub
```shell
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-ud=GRUB
# In /etc/default/grub:
# -  edit the line GRUB_CMDLINE_LINUX to GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdX3:luks:allow-discards" 
# - uncomment GRUB_DISABLE_OS_PROBER=false
# then run:
grub-mkconfig -o /boot/grub/grub.cfg
```

### Automatic installation

Finally, you need to copy this repository and run the playbook
```shell
git clone https://github.com/PabloAceG/20min-migration.git
ansible-playbook run.yml

# Exit the newly created and configured system
exit
```

### Reboot
Unmount all partitions and then reboot:
```shell
umount -R /mnt swapoff -a
```


