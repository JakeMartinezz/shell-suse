#!/bin/bash

#Cuidar dos erros
function handle_error() {
    echo "Um erro ocorreu, tentando novamente em 5 segundos."
    sleep 5
}

# Listar funçoes disponiveis
function ajuda() {
    echo "Funções Disponíveis:"
    for function_name in "${valid_functions[@]}"; do
        echo "- $function_name"
    done
}

# Funçoes validas
valid_functions=(
    "instalar_pacotes"
    "repositorios"
    "copiar_tema"
    "aplicar_flatpak"
    "instalar_pacotes_flatpak"
    "aplicar_tema"
    "copiar_fonte"
    "copiar_tema_gedit"
    "ajuda"
    "configurar_extensao"
    "remover_pacotes"
    "configurar_lutris"
)
# Remover pacotes
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
        while true; do
            sudo zypper remove -y "$package" 
            break || handle_error
        done
    done
}

# Instalar pacotes
function instalar_pacotes() {
    local packages=(
        lutris
        bleachbit
        git
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
        while true; do
            sudo zypper install -y "$package" &&
            break || handle_error
        done
    done
}

#Adicionar Repositório Packman
function repositorios() {
    while true; do
        sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman &&
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
        sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode &&
        sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg &&
        sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo &&
        sudo zypper refresh &&
        sudo zypper dup --from packman --allow-vendor-change &&
        break || handle_error
    done
}

#Copiar Temas e Icones
function copiar_tema() {
    while true; do
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
        break || handle_error
    done
}

#Aplicar Flatpak
function aplicar_flatpak() {
    while true; do
        sudo flatpak override --filesystem=$HOME/.themes &&
        sudo flatpak override --env=GTK_THEME=Catppuccin-Mocha-Standard-Lavender-Dark &&
        flatpak --user override --filesystem=/home/$USER/.icons/:ro &&
        flatpak --user override --filesystem=/usr/share/icons/:ro &&
        break || handle_error
    done
}

#Instalar Pacotes Flatpak
function instalar_pacotes_flatpak() {
    local packages=(
        com.vysp3r.ProtonPlus
        com.mattjakeman.ExtensionManager
        org.videolan.VLC
    )

    for package in "${packages[@]}"; do
        while true; do
            sudo flatpak install flathub "$package" -y &&
            break || handle_error
        done
    done
}

#Aplicar Temas e Icones
function aplicar_tema() {
    while true; do
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Lavender-Dark' &&
        gsettings set org.gnome.desktop.interface icon-theme 'Win11' &&
        gsettings set org.gnome.desktop.interface cursor-theme 'Win-8.1-S' &&
        break || handle_error
    done
}
	
#Copiar Fonte
function copiar_fonte() {
    while true; do
        mkdir -p "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI" &&
        cp -a ./fonte/. "$HOME/.local/share/fonts/Microsoft/TrueType/Segoe UI" &&
        break || handle_error
    done
}	

#Copiar Tema Gedit
function copiar_tema_gedit() {
    while true; do
        mkdir -p ~/.local/share/gedit/styles &&
        cp -r styles ~/.local/share/gedit &&
        break || handle_error
    done    
}

# Configurar extensões
function configurar_extensao() {
    while true; do
        dconf load /org/gnome/shell/extensions/ < extensao.conf
        break || handle_error
    done    
}

# Configurar lutris
function configurar_lutris() {
    while true; do
        ln -s -v -r .config/lutris /home/$USER/.config &&
        ln -s -v -r lutris/ /home/$USER/.local/share &&
        break || handle_error
    done
}

# Definir a função pra executar
execute_functions() {
    for func in "$@"; do
        if [[ " ${valid_functions[@]} " =~ " ${func} " ]]; then
            $func
        else
            echo "Função inválida: ${func}"
        fi
    done
}

# Loop principal
while true; do
    echo "Digite a lista de funções que deseja chamar, separadas por espaço:"
    read function_list

    execute_functions $function_list

    while true; do
        echo "Deseja chamar outra função? S/N"
        read call_again

        if [ "$call_again" = "n" ]; then
            exit 0
        elif [ "$call_again" = "s" ]; then
            break
        else
            echo "Opção inválida. Digite S para sim ou N para não."
        fi
    done
done
