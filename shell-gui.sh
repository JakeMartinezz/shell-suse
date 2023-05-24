#!/bin/bash

# Array de funçoes

function aplicar_flatpak() {
    sudo flatpak override --filesystem=$HOME/.themes &&
    sudo flatpak override --env=GTK_THEME=Catppuccin-Mocha-Standard-Lavender-Dark &&
    flatpak --user override --filesystem=/home/$USER/.icons/:ro &&
    flatpak --user override --filesystem=/usr/share/icons/:ro 
}

function aplicar_tema() {
    gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Lavender-Dark' &&
    gsettings set org.gnome.desktop.interface icon-theme 'Win11' &&
    gsettings set org.gnome.desktop.interface cursor-theme 'Win-8.1-S'
    gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/wallpaper.png"
}

function atualizar_funcoes_validas() {
    valid_functions=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^function[[:space:]]+([[:alnum:]_]+)[[:space:]]*\(\) ]]; then
            valid_functions+=("${BASH_REMATCH[1]}")
        fi
    done < "$0"
}

function configurar_extensao() {
    dconf load /org/gnome/shell/extensions/ < extensao.conf
}

function configurar_lutris() {
    ln -s -v -r .config/lutris /home/$USER/.config &&
    ln -s -v -r lutris/ /home/$USER/.local/share 
}

function copiar_tema() {
    cp -r .icons /home/$USER/ &&
    cp -r .themes /home/$USER/ &&
    cp -r Equalizador.json /home/$USER/.config/easyeffects/output
    cp -r .themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0 /home/$USER/.config &&
    sudo cp -r .themes/Catppuccin-Mocha-Standard-Lavender-Dark /usr/share/themes &&
    sudo cp -r .icons/Win11-dark /usr/share/icons &&
    mkdir -p /home/$USER/.config/easyeffects/output &&
    cp Equalizador.json /home/$USER/.config/easyeffects/output/ &&
    mkdir -p /home/$USER/.config/BetterDiscord &&
    cp -r BetterDiscord/ /home/$USER/.config/ &&
    sudo mkdir -p /usr/lib64/discord/resources &&
    sudo cp ./BetterDiscord/app.asar /usr/lib64/discord/resources &&
    mkdir -p ~/.local/share/gedit/styles &&
    cp -r styles ~/.local/share/gedit &&
    mkdir -p "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI" &&
    cp -a ./fonte/. "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI"
}

function instalar_pacotes() {
    local packages=(
        lutris
        bleachbit
        steam
        htop
        neofetch
        gamemoded
        libgamemode-devel
        libgamemode0
        libgamemode0-32bit
        libgamemodeauto0
        libgamemodeauto0-32bit
        easyeffects
        sublime-text
        code
        gh
        discord
        sysconfig-netconfig
    )

    for package in "${packages[@]}"; do
        sudo $package_manager install -y "$package"
    done
}

function instalar_pacotes_flatpak() {
    local packages=(
        com.vysp3r.ProtonPlus
        com.mattjakeman.ExtensionManager
        org.videolan.VLC
    )

    for package in "${packages[@]}"; do
        sudo flatpak install flathub "$package" -y 
    done
}

function main() {
    while true; do
        local selection=$(zenity --list --title="Shell-gui" --text="O que gostaria de fazer?" --column="Opções" "${valid_functions[@]}")

        if [[ -n "$selection" ]]; then
            # Executar a função selecionada
            if [[ " ${valid_functions[@]} " =~ " ${selection} " ]]; then
                "$selection"
            else
                echo "Função inválida: $selection"
            fi
        else
            break
        fi
    done
}

function presenca_discord() {
    cp -r rich\ presence/* /home/$USER/.config/autostart
}

function remover_pacotes() {
    local packages=(
        gnome-sudoku
        gnome-calculator
        gnome-screenshot
        gnome-characters
        gnome-contacts
        gnome-dictionary
        gnome-maps
        gnome-mahjongg
        gnome-weather
        gnome-mines
        gnome-logs
        gnome-clocks
        gnome-chess
        gnome-extensions
        bijiben
        system-config-printer
        seahorse
        iagno
        swell-foop
        transmission-gtk
        totem
        pidgin
        polari
        yelp
        vinagre
        quadrapassel
        simple-scan
        lightsoff
        dosbox
        evolution
        evince
        gimp
        opensuse-welcome
        cheese
        baobab
        gpk-update-viewer
        tigervnc
    )

    for package in "${packages[@]}"; do
        sudo $package_manager remove -y "$package" 
    done
}

function repositorios() {
    sudo $package_manager ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman &&
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    sudo $package_manager addrepo https://packages.microsoft.com/yumrepos/vscode vscode &&
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg &&
    sudo $package_manager addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo &&
    sudo $package_manager refresh &&
    sudo $package_manager dup --from packman --allow-vendor-change
}

function wake_on_lan() {
    sudo tee /etc/systemd/system/wol.service > /dev/null <<EOF
[Unit]
Description=Configure Wake-on-LAN
Wants=network.target
After=network.target

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s enp6s0 wol g
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    sudo chmod 644 /etc/systemd/system/wol.service
    sudo systemctl enable wol.service
    sudo systemctl start wol.service
}

# Fim do Array

function zenity_interface() {
    while true; do
        local selection=$(zenity --list --title="Shell-gui" --text="O que gostaria de fazer?" --column="Opções" "${valid_functions[@]}")

        if [[ -n "$selection" ]]; then
            # Executar a função selecionada
            if [[ " ${valid_functions[@]} " =~ " ${selection} " ]]; then
                "$selection"
            else
                echo "Função inválida: $selection"
            fi
        else
            break
        fi
    done
}

# Selecionar Distribuição
if zenity --question --text="Você está usando OpenSUSE?"; then
    package_manager="zypper"
elif zenity --question --text="Você está usando Fedora?"; then
    package_manager="dnf"
else
    # Caso a distribuição não seja compatível
    zenity --error --text="Distro Não Compátivel."
    exit 1
fi
   # Caso zenity não estiver instalado
if ! command -v zenity >/dev/null 2>&1; then
    echo "O comando 'zenity' não está disponível. Por favor, instale-o."
    exit 1
fi

valid_functions=()

atualizar_funcoes_validas

zenity_interface

