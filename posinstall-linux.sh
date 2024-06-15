#!/usr/bin/env bash

# VARIÁVEIS #
PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"
PPA_LUTRIS="ppa:lutris-team/lutris"

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"


DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"


PROGRAMAS_PARA_INSTALAR=(
    snapd
    steam-installer
    steam-devices
    steam:i386
    lutris
)

# -------- REQUESITOS -------- #
## Removendo eventuais travas do APT ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap ##
sudo apt-add-repository "$PPA_LIBRATBAG" -y
sudo add-apt-repository "$PPA_LUTRIS" -y
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"

# -------- EXECUÇÃO -------- #
## Atualizando o repositório
sudo apt uptade -y

## Download e instalação de programas externos ##

mkdir "$DIRETORIO_DOWNLOADS" 
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

# -------- LINGUAGENS -------- #
## Java ##
sudo apt install openjdk-17-jdk
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
tar -xzf jdk-17_linux-x64_bin.tar.gz
sudo mv jdk-17 /usr/local/
sudo update-alternatives --install /usr/bin/java java /usr/local/jdk-17/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/local/jdk-17/bin/javac 1

## MySQL ##
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
mysql --version

# -------- SOFTWARES EM .DEB e WGET -------- #
## Reaper ##
wget https://www.reaper.fm/files/6.x/reaper716_linux_x86_64.tar.
tar -xf reaper681_linux_x86_64.tar.xz
sudo mv reaper_linux_x86_64 /opt/reaper
sudo ln -s /opt/reaper/reaper /usr/local/bin/reaper

## IntelliJ ##
wget https://download.jetbrains.com/idea/ideaIC-2023.1.tar.gz
tar -xzf ideaIC-2023.1.tar.gz
sudo mv idea-IC-231.8109.175 /opt/intellij
sudo ln -s /opt/intellij/bin/idea.sh /usr/local/bin/idea

## Eclipse ##
wget https://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/2023-06/R/eclipse-java-2023-06-R-linux-gtk-x86_64.tar.gz
tar -xzf eclipse-java-2023-06-R-linux-gtk-x86_64.tar.gz
sudo mv eclipse /opt/eclipse
sudo ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse

## Visual Studio Code ##
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

## MySQL Workbench ##
sudo apt install mysql-workbench


## Instalando pacotes Flatpak ##
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub org.onlyoffice.desktopeditors -y

## Instalando pacotes Snap ##
sudo snap install spotify

sudo snap install photogimp

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza ##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y





















