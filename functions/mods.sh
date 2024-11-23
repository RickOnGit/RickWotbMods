source $HOME/RickWotbMods/general/variables.sh
source $HOME/RickWotbMods/general/functions.sh

modslist() {
    while true; do
        welcome "Chose what to do"
        ans=$(echo -e "Pick a sight mod 🔫\nPick a sound mod 🔊\nPick an ui battle mod ⚔️\nPick a lobby mod 🛖\nInstall Dortebb WOT modpack 📦\nGo back 🔙" | gum choose --cursor="🖱️  ")
        case "$ans" in
            "Pick a sight mod 🔫")
                sightsmod
                ;;
            "Pick a sound mod 🔊")
                soundsmod
                ;;
            "Pick an ui battle mod ⚔️")
                battleuimod
                ;;
            "Pick a lobby mod 🛖")
                lobbymod
                ;;
            "Install Dortebb WOT modpack 📦")
                wotmodpack
                ;;
            "Go back 🔙")
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

wotmodpack() {
    if gum confirm --affirmative "Download&Install + backup the modpack" --negative "Restore original elements" "Choose what to do"; then 
        mkdir -p "$DORTEBB"
        gum spin --spinner="minidot" --title="Downloading mod pack" -- wget -c -O "$DORTEBB/wotmod.download" https://forblitz.ru/wp-content/uploads/2024/11/dortebb_pc_wg.zip
        gum format "✅ Mod pack downloaded!"
        sleep 1
        gum spin --spinner="dot" --title="Extracting mod pack" -- 7z x "$DORTEBB/wotmod.download" -o"$DORTEBB"
        gum format "✅ Mod pack extracted!"
        rm $DORTEBB/wotmod.download
        sleep 1
        backup "$DORTEBB/temp_dir" "$DORTEBB/Data/" "$DORTEBB/og"
        gum format "✅ Mod pack correctly applied!"
        sleep 1
        if gum confirm "Send modpack overwritten files to a original Data folder?"; then 
            mkdir -p "$OG_DATA"
            rsync -a --ignore-existing "$DORTEBB/og/" "$OG_DATA"
            gum format "✅ Sent correctly"
            sleep 1
        fi
    else 
        if [ -d "$DORTEBB/og" ]; then
            rsync -a "$DORTEBB/og/" "$WGDATA/"
            gum format "✅ OG Data applied!"
            sleep 1
        fi
    fi
    return 0
}