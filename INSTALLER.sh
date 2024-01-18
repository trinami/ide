#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

#Update all
sudo pacman -Syu --noconfirm

#serial permissions
sudo usermod -a -G uucp $USER
sudo wget https://raw.githubusercontent.com/micronucleus/micronucleus/master/commandline/49-micronucleus.rules -O /etc/udev/rules.d/49-micronucleus.rules

#firewall setup
sudo pacman -Sy --noconfirm ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

#Auto update scripts
chmod +x update-at-boot.sh
sudo cp "${SCRIPT_DIR}/update-at-boot.sh" "/usr/local/bin/"
sudo cp "${SCRIPT_DIR}/update-at-boot.service" "/etc/systemd/system/"
sudo systemctl enable update-at-boot.service

#Remove Packages
sudo pacman -R --noconfirm epiphany
sudo pacman -R --noconfirm gnome-software
sudo pacman -R --noconfirm gnome-weather cheese gnome-video-effects gnome-tour gnome-photos gnome-music gnome-maps gnome-disk-utility gnome-contacts gnome-text-editor totem yelp gnome-user-docs

#Install Opendoas
sudo pacman -S --noconfirm opendoas
echo "permit persist :wheel" | sudo tee -a /etc/doas.conf
sudo usermod -aG wheel $USER


#Install packages
sudo pacman -S --noconfirm python jdk-openjdk go rust lua ruby git bash-completion zsh flatpak qemu-full xorg-xwayland keepassxc minicom nextcloud-client restic gedit vim gparted ghex android-tools mtpfs gvfs-mtp monero cmake autoconf gnupg seahorse python-pip astyle cmake gcc ninja openssl python-pytest python-pytest-xdist unzip libxslt doxygen graphviz valgrind veracrypt nodejs npm p7zip unp mono torbrowser-launcher monero-gui docker docker-compose gnupg pcsclite ccid hopenpgp-tools zsh k9s rsync

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

#Instal pips
pip3 install cryptography --break-system-packages
pip3 install argon2-cffi --break-system-packages

#Install flatpaks
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
wget -P /home/$USER/git/rustdesk.pkg.tar.zst https://github.com/rustdesk/rustdesk/releases/download/1.2.3/rustdesk-1.2.3-0-x86_64.pkg.tar.zst
flatpak install --noninteractive --user rustdesk.pkg.tar.zst
flatpak install --noninteractive --user flathub com.visualstudio.code
flatpak install --noninteractive --user flathub com.discordapp.Discord
flatpak install --noninteractive --user flathub com.github.Eloston.UngoogledChromium
flatpak install --noninteractive --user flathub flathub info.mumble.Mumble
flatpak install --noninteractive --user flathub org.mozilla.firefox
flatpak install --noninteractive --user flathub org.kde.kommit
flatpak install --noninteractive --user flathub com.jetbrains.PyCharm-Community
flatpak install --noninteractive --user flathub org.filezillaproject.Filezilla
flatpak install --noninteractive --user flathub org.signal.Signal
flatpak install --noninteractive --user flathub im.riot.Riot
flatpak install --noninteractive --user flathub org.libreoffice.LibreOffice
flatpak install --noninteractive --user flathub org.videolan.VLC
flatpak install --noninteractive --user flathub org.eclipse.Java
flatpak install --noninteractive --user flathub io.github.mimbrero.WhatsAppDesktop
flatpak install --noninteractive --user flathub ch.threema.threema-web-desktop
flatpak install --noninteractive --user flathub org.fritzing.Fritzing
flatpak install --noninteractive --user flathub org.freecadweb.FreeCAD
flatpak install --noninteractive --user flathub org.kicad.KiCad
flatpak install --noninteractive --user flathub net.kuribo64.melonDS
flatpak install --noninteractive --user flathub com.valvesoftware.Steam
flatpak install --noninteractive --user flathub com.teamspeak.TeamSpeak
flatpak install --noninteractive --user flathub org.gimp.GIMP
flatpak install --noninteractive --user flathub org.shotcut.Shotcut

#Make dirs
mkdir /home/$USER/git

#install yay
git clone https://aur.archlinux.org/yay.git /home/$USER/git/yay
cd /home/$USER/git/yay
makepkg -si

#install yay's
yay -S rancher-desktop
yay -S bun
yay -S jmtpfs
yay -S noisetorch

#clone PQ Crypto
git clone https://github.com/Anish-M-code/pqcrypt.git /home/$USER/git/pqcrypt
cd /home/$USER/git/pqcrypt
chmod +x arch_install.sh
sh arch_install.sh
chmod +x run.sh

#Install powerlevel10k
zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USER/git/powerlevel10k
echo 'source /home/$USER/powerlevel10k/powerlevel10k.zsh-theme' >>/home/$USER/.zshrc

#Reboot
echo "Do you want to reboot? (y/n)"
read answer
if [ "$answer" == "y" ]; then
    echo "Rebooting..."
    sudo reboot
fi
