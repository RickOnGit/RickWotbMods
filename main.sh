source "functions/modtanks.sh"
source "functions/modmaps.sh"
source "functions/modhangars.sh"
source "functions/mods.sh"

while true; do
    welcome "Welcome to my script, choose what to do"
    ans=$(echo -e "Pick some tanks remodel 🚜\nPick a map style 🗺️\nPick an hangar 🛖\nPick some mods 📦\nApply OG Data 🔃\nQuit 🔙" | gum choose --cursor="🖱️  ")

    case "$ans" in
        "Pick some tanks remodel 🚜")
            tanksmod
            ;;
        "Pick a map style 🗺️")
            mapsmod
            ;;
        "Pick an hangar 🛖")
            hangarsmod
            ;;
        "Pick some mods 📦")
            modslist
            ;;
        "Apply OG Data 🔃")
            rsync -a "$OG_DATA/" "$WGDATA"
            gum format "Original files loaded"
            ;;
        "Quit 🔙")
            gum spin --title="Quitting the script " --spinner="dot" -- sleep 2
            clear
            break
            ;;
    esac
done