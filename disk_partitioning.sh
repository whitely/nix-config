parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB 5GiB
parted /dev/sda -- mkpart primary linux-swap 5GiB 25GiB
parted /dev/sda -- mkpart primary 25GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB

parted /dev/sda set 3 lvm on
parted /dev/sda -- set 4 esp on

mkfs.ext4 -L nixos-recovery /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda4

pvcreate /dev/sda3
vgcreate vg1 /dev/sda3
lvcreate -L 100GB vg1

mkfs.ext4 -L nixos /dev/vg1/lvol0
