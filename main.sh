source "functions/modtanks.sh"
source "functions/modmaps.sh"
source "functions/modhangars.sh"
source "functions/mods.sh"

while true; do
    welcome "Welcome to my script, chose what to do"
    ans=$(echo -e "Pick a tank's remodel\nPick a map style\nPick an hangar\nPick some mods\nQuit" | gum choose --cursor="󰳽 ")

    case "$ans" in
        "Pick a tank's remodel")
            tanksmod
            ;;
        "Pick a map style")
            mapsmod
            ;;
        "Pick an hangar")
            hangarsmod
            ;;
        "Pick some mods")
            modslist
            ;;
        "Quit")
            gum spin --title="Quitting the script " --spinner="dot" -- sleep 2
            clear
            break
            ;;
    esac
done