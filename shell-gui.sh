#!/bin/bash

# Executa a função selecionada
if [[ -n "$selection" ]]; then
	${valid_functions[$selection-1]}
fi

# Funçoes disponiveis no script
valid_functions=(
    "aplicar_flatpak"
    "aplicar_tema"
    "configurar_extensao"
    "configurar_lutris"
    "copiar_tema"
    "instalar_pacotes"
    "instalar_pacotes_flatpak"
    "remover_pacotes"
    "repositorios"
)

# Array de funçoes
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
        opensuse-welcome
        cheese
        baobab
        gpk-update-viewer
        tigervnc
        
    )

    for package in "${packages[@]}"; do
            sudo zypper remove -y "$package" 
    done
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
    )

    for package in "${packages[@]}"; do
            sudo zypper install -y "$package"
        done
}

function repositorios() {
        sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman &&
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
        sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode &&
        sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg &&
        sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo &&
        sudo zypper refresh &&
        sudo zypper dup --from packman --allow-vendor-change
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
        sudo cp app.asar /usr/lib64/discord/resources &&
        mkdir -p ~/.local/share/gedit/styles &&
        cp -r styles ~/.local/share/gedit &&
        mkdir -p "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI" &&
        cp -a ./fonte/. "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI"
}

function aplicar_flatpak() {
        sudo flatpak override --filesystem=$HOME/.themes &&
        sudo flatpak override --env=GTK_THEME=Catppuccin-Mocha-Standard-Lavender-Dark &&
        flatpak --user override --filesystem=/home/$USER/.icons/:ro &&
        flatpak --user override --filesystem=/usr/share/icons/:ro 
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

function aplicar_tema() {
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Lavender-Dark' &&
        gsettings set org.gnome.desktop.interface icon-theme 'Win11' &&
        gsettings set org.gnome.desktop.interface cursor-theme 'Win-8.1-S'
}

function configurar_extensao() {
        dconf load /org/gnome/shell/extensions/ < extensao.conf
}

function configurar_lutris() {
        ln -s -v -r .config/lutris /home/$USER/.config &&
        ln -s -v -r lutris/ /home/$USER/.local/share 
}

# Mostra a caixa de dialogo para a escolha
function main() {
    local options=("${valid_functions[@]}")

    while true; do
        local selection=$(zenity --list --title="Shell-gui" --text="O que gostaria de fazer?" --column="Opções" "${options[@]}")

        if [[ -n "$selection" ]]; then
            ${selection}
        else
            break
        fi
    done
}

main

