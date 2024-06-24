#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

#Update all
sudo pacman -Syu --noconfirm

#serial permissions
sudo usermod -a -G uucp $USER
sudo wget https://raw.githubusercontent.com/micronucleus/micronucleus/master/commandline/49-micronucleus.rules -O /etc/udev/rules.d/49-micronucleus.rules
sudo wget https://raw.githubusercontent.com/Nitrokey/nitrokey-udev-rules/main/41-nitrokey.rules -O /etc/udev/rules.d/41-nitrokey.rules

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
sudo pacman -S --noconfirm python jdk-openjdk go lua ruby git bash-completion zsh flatpak qemu-full xorg-xwayland keepassxc minicom syncthing restic gedit vim gparted ghex android-tools mtpfs gvfs-mtp monero cmake autoconf gnupg seahorse python-pip astyle cmake gcc ninja openssl python-pytest python-pytest-xdist unzip libxslt doxygen graphviz valgrind veracrypt nodejs npm p7zip unp mono torbrowser-launcher monero-gui docker docker-compose gnupg pcsclite ccid hopenpgp-tools zsh k9s rsync kubectl talosctl kustomize helm helm k9s tmux tmate talosctl jq python-pipx neofetch lolcat figlet libfido2 firefox dvd+rw-tools growisofs 

#nitrokey
pipx install pynitrokey
pipx ensurepath
sudo systemctl enable pcscd.service
sudo systemctl start pcscd.service

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

systemctl --user enable syncthing.service
systemctl --user start syncthing.service

#Instal pips
pip3 install cryptography --break-system-packages
pip3 install argon2-cffi --break-system-packages

#Install flatpaks
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
export RUSTDESK_VERSION=$(curl  "https://api.github.com/repos/rustdesk/rustdesk/tags" | jq -r '.[1].name')
wget -P /home/$USER/git/rustdesk.flatpak https://github.com/rustdesk/rustdesk/releases/download/$RUSTDESK_VERSION/rustdesk-$RUSTDESK_VERSION-x86_64.flatpak
flatpak install --noninteractive --user rustdesk.flatpak
flatpak install --noninteractive --user flathub com.visualstudio.code
flatpak install --noninteractive --user flathub com.discordapp.Discord
flatpak install --noninteractive --user flathub com.github.Eloston.UngoogledChromium
flatpak install --noninteractive --user flathub flathub info.mumble.Mumble
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
mkdir /home/$USER/backup
mkdir /home/$USER/shared

#install yay
git clone https://aur.archlinux.org/yay.git /home/$USER/git/yay
cd /home/$USER/git/yay
makepkg -si

#install yay's
yay -S rancher-desktop
yay -S bun
yay -S jmtpfs
yay -S noisetorch
yay -S schildichat-desktop

#Install powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USER/git/powerlevel10k
echo "set -g mode-mouse on" >>/home/$USER/.tmux.conf
echo "\nsource /home/$USER/powerlevel10k/powerlevel10k.zsh-theme\ntmux source-file ~/.tmux.conf" >>/home/$USER/.zshrc
echo -e "if [ \"$TMUX\" = \"\" ]; then tmux; fi\n$(cat /home/$USER/.zshrc)" >>/home/$USER/.zshrc
echo "\npaste <(figlet Trinami.org) <(neofetch --off) | column -s $'\t' -t | lolcat" >>/home/$USER/.zshrc
echo "\ntypeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet" >>/home/$USER/.p10k.zsh
echo "\nexec zshrc" >>/home/$USER/.bashrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source /home/$USER/git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /home/$USER/.zshrc
cd /home/$USER/.oh-my-zsh/plugins && git clone https://github.com/zsh-users/zaw.git && echo "source ${PWD}/zaw/zaw.zsh" >> /home/$USER/.zshrc && sed -i 's\plugins=(git)\plugins=(zaw git)\g' /home/$USER/.zshrc && echo "bindkey '^r' zaw-history" >> /home/$USER/.zshrc

#trinami github
cd /home/$USER/git
curl "https://api.github.com/users/trinami/repos?per_page=1000" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone

#Reboot
echo "Do you want to reboot? (y/n)"
read answer
if [ "$answer" == "y" ]; then
    echo "Rebooting..."
    sudo reboot
fi
