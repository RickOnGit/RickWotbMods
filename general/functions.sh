make_folders() {
    local file="$1"
    local main_dir="$2"
    while IFS=',' read -r -a fields; do
            if [ "${#fields[@]}" -eq 2 ]; then
                type="${fields[0]}"
                link="${fields[1]}"
                mkdir -p "$main_dir/$type"
            else
                nation="${fields[0]}"
                tank="${fields[1]}"
                remodel="${fields[2]}"
                link="${fields[3]}"
                mkdir -p "$main_dir/$nation/$tank/$remodel"
            fi
    done < "$file"
    if [[ "$main_dir" == "$HOME/MY-WOTB-DATA/MODS/TANKS" ]]; then 
        welcome "Chose a nation"
        ans=$(echo -e "$(ls $main_dir)\nGo back 🔙" | gum choose --cursor="🖱️  ")
        dir="$main_dir/$ans"
        if [[ "$ans" == "Go back 🔙" ]]; then
            return 0
        fi
    else 
        dir="$main_dir"
    fi
    if gum confirm --affirmative="Download Elements" --negative="Apply elements" "What do you wanna do?"; then 
        multi_select_download "$dir" "$file"
    else
        multi_select_install "$dir" "$file"
    fi
    return 0
}

multi_select_download() {
    welcome "Selecting elements to be downloaded"
    local dir="$1"
    local file="$2"
    if [[ "$file" = "$HOME/RickWotbMods/files/tanks.csv" ]]; then 
        selected=$(find "$dir" -mindepth 2 -maxdepth 2 -type d | grep -v "/original" | awk -F/ '{print $(NF-1) "/" $NF}' | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix="🖱️  " --header="Select items:")
    else 
        selected=$(ls $dir | grep -v "original" | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    fi
    download_extract "$dir" "$file" "$selected" 
}

download_extract() {
    local dir="$1"
    local file="$2"
    shift 2
    local selected="$@"
    
    local arr=($selected)
    welcome "Downloading the selected elements:"
    for elem in "${arr[@]}"; do
        while IFS=',' read -r -a fields; do
            if [ "${#fields[@]}" -eq 2 ]; then
                type="${fields[0]}"
                link="${fields[1]}"
            else
                nation="${fields[0]}"
                tank="${fields[1]}"
                type="${fields[2]}"
                link="${fields[3]}"
            fi
            dir_name=$(dirname "$elem")
            elem_basename=$(basename "$elem")
            if [[ "$elem_basename" == "$type" ]]; then
                if [ -d "$dir/$elem/Data" ] && [ "$(ls -A "$dir/$elem/Data")" ]; then
                    gum format "$elem alreay downloaded, skipping ..."
                    continue
                fi
                gum spin --spinner="minidot" --title="Downloading $elem" -- wget -c -O "$dir/$elem/$elem_basename.download" "$link"
                gum format "✅ $elem downloaded!"
                sleep 1
                gum spin --spinner="dot" --title="Extracting $elem" -- 7z x "$dir/$elem/$elem_basename.download" -o"$dir/$elem"
                gum format "✅ $elem extracted!"                
                sleep 1
                rm "$dir/$elem/$elem_basename.download"
                if [ ! -d "$dir/$elem/Data" ]; then
                    mkdir -p $dir/$elem/Data
                    mv -f $dir/$elem/* $dir/$elem/Data/ 2>/dev/null
                fi
                if [[ "$(dirname "$dir")" == "$TANKS" ]]; then
                    tankconfig "$dir/$elem"
                fi
            fi
        done < "$file"
    done
    if gum confirm "Jump to the installer?"; then
        multi_select_install "$dir" "$file"
    fi
    return 0
}

multi_select_install() {
    welcome "Selecting elements to be installed"
    local dir="$1"
    local file="$2"
    if [[ "$file" = "$HOME/RickWotbMods/files/tanks.csv" ]]; then 
        selected=$(find "$dir" -mindepth 2 -maxdepth 2 -type d | awk -F/ '{print $(NF-1) "/" $NF}' | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items to be installed:")
    else
        selected=$(ls $dir | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    fi
    install "$dir" "$file" "$selected"
}

install() {
    local dir="$1"
    local file="$2"
    shift 2
    local selected="$@"
    local arr=($selected)
    local notdownloaded=()

    welcome "Installing selected elements"
    for elem in "${arr[@]}"; do
        dir_name=$(dirname "$elem")
        elem_basename=$(basename "$elem")
        
        if [[ "$elem_basename" == "original" ]]; then
            rsync -a "$dir/$dir_name/original/" "$WGDATA"
            gum format "✅ Stock $dir_name files applied correctly"
            sleep 1
            continue
        fi

        if [ -d "$dir/$elem/Data" ] && [ "$(ls -A "$dir/$elem/Data")" ] && [ "$file" != "$HOME/RickWotbMods/files/mods/sounds.csv" ] && [ "$file" != "$HOME/RickWotbMods/files/mods/lobby.csv" ] && [ "$file" != "$HOME/RickWotbMods/files/mods/battle-ui.csv" ]; then
            if [ -d "$dir/$dir_name/original" ]; then
                rsync -a "$dir/$dir_name/original/" "$WGDATA"
                backup "$dir/$dir_name/temp_dir" "$dir/$elem/Data" "$dir/$dir_name/original"
                gum format "✅ $elem_basename applied correctly with backup"
                sleep 1
            else
                if gum confirm --affirmative="With backup" --negative="W/o backup" "Choose an installation option"; then
                    backup "$dir/$dir_name/temp_dir" "$dir/$elem/Data" "$dir/$dir_name/original"
                    gum format "✅ $elem_basename applied correctly with backup"
                    sleep 1
                else
                    rsync -a "$dir/$elem/Data/" "$WGDATA"
                    gum format "✅ $elem_basename applied correctly w/o backup"
                    sleep 1
                fi
            fi
        else
            if [ -d "$dir/$elem/Data" ] && [ "$(ls -A "$dir/$elem/Data")" ] && [ "$file" == "$HOME/RickWotbMods/files/mods/sounds.csv" ] || [ "$file" == "$HOME/RickWotbMods/files/mods/lobby.csv" ] || [ "$file" == "$HOME/RickWotbMods/files/mods/battle-ui.csv" ]; then
                if [ -d "$dir/$dir_name/original" ]; then
                    backup "$dir/$dir_name/temp_dir" "$dir/$elem/Data" "$dir/$dir_name/original"
                    gum format "✅ $elem_basename applied correctly with backup"
                    sleep 1
                else
                    if gum confirm --affirmative="With backup" --negative="W/o backup" "Choose an installation option"; then
                        backup "$dir/$dir_name/temp_dir" "$dir/$elem/Data" "$dir/$dir_name/original"
                        gum format "✅ $elem_basename applied correctly with backup"
                        sleep 1
                    else
                        rsync -a "$dir/$elem/Data/" "$WGDATA"
                        gum format "✅ $elem_basename applied correctly w/o backup"
                        sleep 1
                    fi
                fi
            fi
            if [ ! -d "$dir/$elem/Data" ]; then
                notdownloaded+=("$elem")
            fi
        fi
    done

    if [ ${#notdownloaded[@]} -gt 0 ]; then
        echo -e "\nFiles not downloaded: ${notdownloaded[@]}\n"
        if gum confirm "Download missing files?"; then
            download_extract "$dir" "$file" "${notdownloaded[@]}"
        fi
    fi
    return 0
}

tankconfig() { 
    local elem="$1"
    
    if [ -d "$elem/Data/data" ]; then
        rsync -a "$elem/Data/data/" "$elem/Data/"
        rm -rf "$elem/Data/data"
    fi

    if [ -d "$elem/Data/3d/tanks" ]; then
        mkdir -p $elem/Data/3d/Tanks
        rsync -a "$elem/Data/3d/tanks/" "$elem/Data/3d/Tanks/"
        rm -rf "$elem/Data/3d/tanks"
    fi
    
    if [ -f "$elem/Data/camouflages.yaml.dvpl" ]; then
        rm "$elem/Data/camouflages.yaml.dvpl"
    fi
}

backup() {
    local backup_dir="$1"
    local source_dir="$2"
    local og="$3"
    mkdir -p "$backup_dir" "$og"
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/" "$WGDATA/"
    rsync -a --ignore-existing "$backup_dir/" "$og"
    rm -rf "$backup_dir"
    mkdir -p "$OG_DATA"
    rsync -a --ignore-existing "$og/" "$OG_DATA"
}