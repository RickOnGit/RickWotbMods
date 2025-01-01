source ../lib/functions.sh
source ../lib/gum.env

category=$(yq ". | keys | .[]" ../config/mods.yaml | gum choose --header "Choose what you wanna mod")

case $category in
    "Quit the script ❌")
        gum spin --title="Quitting the script " --spinner="dot" -- sleep 1
        clear && break
        ;;
    *)
        selector "$category"
        ;;
esac