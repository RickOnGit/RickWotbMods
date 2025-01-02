source ../lib/var.env
source ../lib/gum.env
source ../lib/functions.sh

while true; do
    category=$(yq ". | keys | .[]" ../config/mods.yaml | gum choose --header "Choose what you wanna mod")

    case $category in
        "Quit the script ❌")
            gum spin --title="Quitting the script " --spinner="dot" -- sleep 1
            clear && break
            ;;
        *)
            selector "$category"
            if gum confirm --affirmative="Download" --negative="Install" "What you wanna do?";then
                downloader "$category"
            else
                installer "$category"
            fi
            ;;
    esac
done

