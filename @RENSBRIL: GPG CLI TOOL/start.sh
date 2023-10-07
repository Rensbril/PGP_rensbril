#!/bin/bash

# import functions
source ./key_management.sh
source ./message_encryption.sh
source ./dep_check.sh
source ./menu_content.sh



function main_menu {
    while true; do
        CHOICE=$(dialog --clear \
                        --backtitle "GnuPG CLI Tool by @Rensbril" \
                        --title "Hoofdmenu" \
                        --menu "Kies een van de volgende opties:" \
                        15 40 5 \
                        "1" "Sleutelbeheer" \
                        "2" "Versleutel een bericht" \
                        "3" "Ontsleutel een bericht" \
                        "4" "About" \
                        "5" "Exit" \
                        2>&1 >/dev/tty)

        clear
        case $CHOICE in
            1)
                key_management
                ;;
            2)
                encrypt_message
                ;;
            3)
                decrypt_message
                ;;
            4)
                show_about
                ;;
            5)
                exit 0
                ;;
            *)
                echo "Ongeldige keuze, probeer het opnieuw."
                ;;
        esac
    done
}

# Als er geen command line argumenten zijn, toon dan het hoofdmenu
if [[ $# -eq 0 ]] ; then
    print_ascii_art
    sleep 1.5
    main_menu
    exit 0
fi

# Argumenten verwerken
while [[ $# -gt 0 ]] ; do
    case $1 in
        -k | --keys)
            key_management
            exit
            ;;
        -e | --encrypt)
            encrypt_message
            exit
            ;;
        -d | --decrypt)
            decrypt_message
            exit
            ;;
        -h | --help)
            print_ascii_art
            show_help
            exit
            ;;
        *)
            echo "Ongeldige optie: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done
