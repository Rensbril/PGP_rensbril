#!/bin/bash

function print_ascii_art {
    echo ".----. .----..-. .-. .----.      .----.  .---. .----.     .---.  .----.  .----. .-.   "
    echo "| {}  }| {_  |  \`| |{ {__        | {}  }/   __}| {}  }   {_   _}/  {}  \/  {}  \| |   "
    echo "| .-. \| {__ | |\  |.-._} }      | .--' \  {_ }| .--'      | |  \      /\      /| \`--."
    echo "\`-' \`-'\`----'\`-' \`-'\`----'       \`-'     \`---' \`-'         \`-'   \`----'  \`----' \`----'"
}

function show_about {
    clear
    print_ascii_art
    echo "GnuPG Tool"
    echo "Gebruik: ./start.sh"
    echo "Navigeer met de pijltjestoetsen en druk op enter om een optie te selecteren."
    echo ""

    cat << EOF
    Made by:        
     ^ ^              
    (O,O)             
    (   ) ヽ༼ ຈل͜ຈ @Rensbril Ɵ͆ل͜Ɵ͆ ༽ﾉ    
    -"-"--------------
EOF

    # Een soort progressbar ascii art die van 0 naar 100 gaat in 3 seconden
    echo -n 'Progress: ['
    for i in {1..50}; do  # 50 asterisken, elk duurt 0.06 seconden, voor een totaal van 3 seconden
        echo -n '▒▒'
        sleep 0.05
    done
    echo '] 100%'
}