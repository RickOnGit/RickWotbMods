source ../lib/var.env
source ../lib/gum.sh
source ../lib/functions.sh

while true; do
    version
    ans=$(echo -e "Install some mods\nMake your own font\nInstall mods only in Data\nQuit the script ❌" | gum choose --header "Choose what you wanna do")
    
    case $ans in
        "Install some mods")
            while true; do
                ans=$(echo -e "$modlist" | gum choose --header "Choose what you wanna do")
                case "$ans" in
                    "Tanks")
                        selector "$tanksfile"
                        ;;
                    "Maps")
                        selector "$mapsfile"
                        ;;
                    "Sights")
                        selector "$sightsfile"
                        ;;
                    "Hangars")
                        selector "$hangarsfile"
                        ;;
                    "Sounds")
                        selector "$soundsfile"
                        ;;
                    "UI & more")
                        selector "$uifile"
                        ;;
                    "Go Back 👈")
                        break
                        ;;
                esac
            done
            ;;
        "Make your own font")
            ../lib/./font-maker.sh
            ;;
        "Install mods only in Data")
            ../lib/./packs_fix.sh
            ;;
        "Quit the script ❌")
            gum spin --title="Quitting the script " --spinner="dot" -- sleep 1
            clear && break
            ;;
    esac
done
