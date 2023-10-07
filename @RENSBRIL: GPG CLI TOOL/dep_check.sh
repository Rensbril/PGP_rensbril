#!/bin/bash

# Functie om te controleren of een commando beschikbaar is
check_command() {
    command -v $1 >/dev/null 2>&1
}

# Functie om de gebruiker te vragen of hij/zij de afhankelijkheden wil installeren
install_dependencies() {
    echo "De vereiste afhankelijkheden zijn niet geïnstalleerd."
    read -p "Wilt u ze nu installeren? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Instructie voor installeren afhankelijkheden
        cat << EOF
        # Instructie voor installeren afhankelijkheden
        GnuPG (GPG)
        Mac gebruikers: installeer gpg met 'brew install gnupg'
        Linux gebruikers: installeer gpg met 'sudo apt install gnupg'

        Dialog
        Mac gebruikers: installeer dialog met 'brew install dialog'
        Linux gebruikers: installeer dialog met 'sudo apt install dialog'

        jq
        Mac gebruikers: installeer jq met 'brew install jq'
        Linux gebruikers: installeer jq met 'sudo apt install jq'
EOF
    else
        exit 1
    fi
}

# Functie om de afhankelijkheden te controleren
check_dependencies() {
    check_command gpg || install_dependencies
    check_command dialog || install_dependencies
}

# Controleren of de settings.json bestaat, zo niet, maak er een aan met deps_installed als false
if [[ ! -f settings.json ]]; then
    echo '{"deps_installed": false}' > settings.json
fi

# Lees de waarde van deps_installed uit settings.json
DEPS_INSTALLED=$(jq -r '.deps_installed' settings.json)

# Als deps_installed false is, controleer dan de afhankelijkheden
if [[ $DEPS_INSTALLED == "false" ]]; then
    check_dependencies
    # Als de afhankelijkheden zijn geïnstalleerd, update dan settings.json
    echo '{"deps_installed": true}' > settings.json
fi