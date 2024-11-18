source $HOME/RickWotbMods/general/variables.sh
source $HOME/RickWotbMods/general/functions.sh

modslist() {
    while true; do
        welcome "Chose what to do"
        ans=$(echo -e "Pick a sight mod 󰆤\nPick a sound mod \nPick an ui battle mod 󱡂\nPick a lobby mod 󱣉\nGo back  󰩈" | gum choose --cursor="󰳽 ")
        case "$ans" in
            "Pick a sight mod 󰆤")
                sightsmod
                ;;
            "Pick a sound mod ")
                soundsmod
                ;;
            "Pick an ui battle mod 󱡂")
                battleuimod
                ;;
            "Pick a lobby mod 󱣉")
                lobbymod
                ;;
            "Go back  󰩈")
                return 0
                ;;
        esac   
    done
}

sightsmod() {
    make_folders "$sightsfile" "$SIGHTS"
}

soundsmod() {
    make_folders "$soundsfile" "$SOUNDS"
}

lobbymod() {
    make_folders "$lobbyfile" "$LOBBY"
}

battleuimod() {
    make_folders "$battleuifile" "$BATTLEUI"
}