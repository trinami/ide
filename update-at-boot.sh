#!/bin/bash

#remove db lock file
sudo rm /var/lib/pacman/db.lck

# Update keyring
sudo pacman -S --noconfirm archlinux-keyring

# Update system packages
sudo pacman -Syu --noconfirm

# Update Flatpaks
flatpak update --noninteractive

# Update yay's
sudo yay -Syu --noconfirm
