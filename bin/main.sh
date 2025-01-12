source ../lib/var.env
source ../lib/gum.env
source ../lib/functions.sh

while true; do
    ans=$(echo -e "Install some mods\nMake your own font\nInstall mods only in Data\nQuit the script ❌" | gum choose --header "Choose what you wanna do")
    
    case $ans in
        "Install some mods")
            category=$(yq ". | keys | .[]" "$mods_file" | gum choose --header "Choose what you wanna mod")
            selector "$category"
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
