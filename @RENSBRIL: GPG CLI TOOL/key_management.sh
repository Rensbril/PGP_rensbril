#!/bin/bash

function upload_keys {
    echo "Upload sleutels functie"
    read -p "Voer je e-mailadres in: " EMAIL
    KEYID=$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/pub/{print $5}')
    echo "KEYID: $KEYID"
    gpg --send-keys --keyserver keys.openpgp.org "$KEYID"
    echo "Sleutel geupload, check je e-mail voor de bevestigingslink."
    exit 0
}

function check_if_key_exists {
    gpg --locate-keys $1
}

function generate_key_pair {
    echo "Genereer sleutelpaar"
    read -p "Voer je e-mailadres in: " email
    check_if_key_exists $email
    if [[ $? -eq 0 ]]; then
        echo "Sleutelpaar bestaat al"
    else
        echo "Sleutelpaar bestaat nog niet"
        gpg --gen-key
    fi
    exit 0
}

function import_key_pair {
    echo "Importeer sleutelpaar"
    echo "Op dit moment is het alleen mogelijk om sleutels te importeren van keyserver.openpgp.org"
    read -p "Voer het e-mailadres in van de sleutel die je wilt importeren: " email
    gpg --keyserver keyserver.openpgp.org --locate-keys $email
    exit 0
}

function export_key_pair {
    echo "Exporteer sleutelpaar"
    # TODO
    exit 0
}

function delete_key_pair {
    echo "Verwijder sleutelpaar"
    read -p "Voer het e-mailadres in van de sleutel die je wilt verwijderen: " email
    gpg --delete-keys $email
    exit 0
}

function show_key_pair {
    echo "Toon sleutelpaar"
    read -p "Voer het e-mailadres in van de sleutel die je wilt tonen: " email
    gpg --list-keys $email
    exit 0
}


function key_management {
    while true; do
        CHOICE=$(dialog --clear \
                        --backtitle "Sleutelbeheer" \
                        --title "Maak een keuze" \
                        --menu "Kies een van de volgende opties:" \
                        15 40 5 \
                        "1" "Genereer sleutelpaar" \
                        "2" "Importeer sleutelpaar" \
                        "3" "Exporteer sleutelpaar" \
                        "4" "Verwijder sleutelpaar" \
                        "5" "Toon sleutelpaar" \
                        "6" "Upload sleutelpaar" \
                        2>&1 >/dev/tty)

        # Controleer de exit status van het dialog commando
        local EXIT_STATUS=$?
        # Als de exit status 1 is, heeft de gebruiker op "Cancel" geklikt
        if [[ $EXIT_STATUS -eq 1 ]]; then
            # Breek de while lus en keer terug naar het hoofdmenu of sluit het script af
            break
        fi
        
        clear
        case $CHOICE in
            1)
                generate_key_pair
                ;;
            2)
                import_key_pair
                ;;
            3)
                export_key_pair
                ;;
            4)
                delete_key_pair
                ;;
            5)
                show_key_pair
                ;;
            6)
                upload_keys
                ;;
            *)
                echo "Ongeldige keuze, probeer het opnieuw."
                ;;
        esac
    done
}

