source ../lib/var.env
source ../lib/gum.sh
source ../lib/functions.sh

while true; do
    #version
    welcome
    ans=$(echo -e "$menulist" | gum choose --header "Choose what you wanna do")
    
    case $ans in
        "Install some mods ✏️")
            while true; do
                ans=$(echo -e "$modlist" | gum choose --header "Choose what you wanna do")
                case "$ans" in
                    "Tanks 🚜")
                        selector "$tanksfile"
                        ;;
                    "Maps 🗺️")
                        selector "$mapsfile"
                        ;;
                    "Sights 🔭")
                        selector "$sightsfile"
                        ;;
                    "Hangars 🏡")
                        selector "$hangarsfile"
                        ;;
                    "Sounds 🔊")
                        selector "$soundsfile"
                        ;;
                    "UI & more ➕")
                        selector "$uifile"
                        ;;
                    "Go Back 👈")
                        break
                        ;;
                esac
            done
            ;;
        "Make your own font 🔤")
            ../lib/./font-maker.sh
            ;;
        "Install mods only in Data 📦")
            ../lib/./packs_fix.sh
            ;;
        "Quit the script ❌")
            gum spin --title="Quitting the script " --spinner="dot" -- sleep 1
            clear && break
            ;;
    esac
done
