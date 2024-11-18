source $HOME/RickWotbMods/general/variables.sh
source $HOME/RickWotbMods/general/functions.sh

mapsmod() {
    welcome "Creating map's remodels folders"
    make_folders "$mapsfile" "$MAPS"
    if gum confirm --affirmative="Download Elements" --negative="Apply elements" "What do you wanna do?"; then 
        multi_select_download "$MAPS" "$mapsfile"
    else
        multi_select_install "$MAPS" "$mapsfile"
    fi
    return 0
}