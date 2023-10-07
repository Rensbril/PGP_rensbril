#!/bin/bash

source ./key_management.sh

function search_public_key {
    echo "Zoek publieke sleutel functie"
    read -p "Voer het e-mailadres in van de sleutel die je wilt zoeken: " email
    
    # Controleer eerst de lokale sleutelring
    RESULT=$(gpg --list-keys "$email" 2>&1)
    
    if [[ -n $RESULT ]]; then
        echo "Sleutel gevonden in de lokale sleutelring."
    else
        # Als de sleutel niet lokaal wordt gevonden, zoek dan op de keyserver
        RESULT2=$(gpg --keyserver keyserver.openpgp.org --search-keys "$email" 2>&1)
        if [[ $RESULT2 == *"No results found"* ]]; then
            echo "Sleutel niet gevonden, zowel lokaal als op de keyserver."
            exit 1  # Stop het script als de sleutel niet wordt gevonden
        else
            echo "Sleutel gevonden op de keyserver."
            # Optioneel: importeer de sleutel van de keyserver
            gpg --keyserver keyserver.openpgp.org --locate-keys $email
        fi
    fi
    echo $email > recipient_email.txt
}


function encrypt_message {
    echo "Versleutel bericht functie"
    search_public_key
    recipient_email=$(cat recipient_email.txt)  # haal het e-mailadres op uit het bestand
    
    # Open een text editor om het bericht te schrijven
    TEMP_FILE=$(mktemp)  # maak een tijdelijk bestand aan voor het bericht
    dialog --backtitle "Encrypt Message" \
           --title "Schrijf een bericht" \
     --editbox $TEMP_FILE 20 60 2> $TEMP_FILE
    
    # Versleutel het bericht
    OUTPUT_FILE="messages/encrypted_message_$(date +%F_%T).txt.asc"
    gpg --encrypt --sign --armor -r $recipient_email -o $OUTPUT_FILE $TEMP_FILE
    
    # Verwijder het tijdelijke bestand en het bestand met het e-mailadres
    rm $TEMP_FILE recipient_email.txt
    
    echo "Bericht versleuteld en opgeslagen als $OUTPUT_FILE"
    exit 0
}

function decrypt_message {
    echo "Ontsleutel bericht functie"
    # Selecteer het bestand dat je wilt ontsleutelen
    FILE=$(dialog --stdout --backtitle "Decrypt Message" \
                  --title "Selecteer een bestand met spatie en tab" \
                  --fselect "messages/" 14 48)

    # Controleer of een bestand is geselecteerd
    if [[ -z $FILE ]]; then
        echo "Geen bestand geselecteerd. Beëindigen."
        exit 1
    fi

    # Ontsleutel het bestand
    gpg --decrypt $FILE | tee decrypted/decrypted_message_$(date +%F_%T).txt
    echo "Bericht ontsleuteld en opgeslagen in de messages map."
    exit 0
}

