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
        ans=$(echo -e "$(ls $main_dir)\nGo back  󰩈" | gum choose)
        dir="$main_dir/$ans"
        if [[ "$ans" == "Go back  󰩈" ]]; then
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
        string=$(find "$dir" -mindepth 2 -maxdepth 2 -type d | grep -v "/original" | awk -F/ '{print $(NF-1) "/" $NF}' | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    else 
        string=$(ls $dir | grep -v "original" | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    fi
    download_extract "$dir" "$file" "$string" 
}

download_extract() {
    local dir="$1"
    local file="$2"
    local string="$3"
    arr=($string)
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
            elem_basename=$(echo "$elem" | sed 's|.*/||')
            if [[ "$elem_basename" == "$type" ]]; then
                if [ -d "$dir/$elem/Data" ] ; then
                    gum format "$elem alreay downloaded, skipping ..."
                    continue
                fi
                gum spin --spinner="minidot" --title="Downloading $elem" -- wget -c -O "$dir/$elem/$elem_basename.download" "$link"
                gum format "✅ $elem installed!"
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
    if gum confirm "Install elements?"; then
        multi_select_install "$dir" "$file"
    fi
    return 0
}

multi_select_install() {
    welcome "Selecting elements to be installed"
    local dir="$1"
    local file="$2"
    if [[ "$file" = "$HOME/RickWotbMods/files/tanks.csv" ]]; then 
        string=$(find "$dir" -mindepth 2 -maxdepth 2 -type d | awk -F/ '{print $(NF-1) "/" $NF}' | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    else
        string=$(ls $dir | gum choose --no-limit --unselected-prefix=" " --selected-prefix=" " --cursor-prefix=" " --header="Select items:")
    fi
    install "$dir" "$file" "$string"
}

install() {
    local dir="$1"
    local file="$2"
    local string="$3"
    arr=($string)
    local notdowloaded=()
    welcome "Installing selected elements"
    for elem in "${arr[@]}"; do
        if [ -d "$dir/$elem/Data" ] && [ "$(ls -A "$dir/$elem/Data")" ]; then
            dir_name=$(dirname "$elem")
            elem_basename=$(echo "$elem" | sed 's|.*/||')
            if gum confirm --affirmative="With backup" --negative="W/o backup" "Choose an installation option"; then
                if [ -d "$dir/$dir_name/original" ]; then
                    rsync -a "$dir/$dir_name/original/" "$WGDATA"
                fi
                mkdir -p "$dir/$dir_name/temp_dir"
                mkdir -p "$dir/$dir_name/original"
                backup "$dir/$dir_name/temp_dir" "$dir/$elem/Data" "$dir/$dir_name/original"
                gum format "✅ $elem applied correctly"
                    if gum confirm "Send $elembasename's files to a original Data folder?"; then 
                        mkdir -p "$OG_DATA"
                        rsync -a --ignore-existing "$dir/$dir_name/original/" "$OG_DATA"
                        gum format "✅ Sent correctly"
                        sleep 1
                    fi
                    if gum confirm "Send downloaded $elem_basename files to a custom data folder?"; then
                        custom_backup "$dir/$elem/Data/"
                        gum format "✅ Sent correctly"
                        sleep 1
                    fi
                continue
            else
                rsync -a "$dir/$elem/Data/" "$WGDATA"
                if gum confirm "Send custom element files to a custom Data folder?"; then
                    custom_backup "$dir/$elem/Data/"
                    gum format "✅ Sent correctly"
                    sleep 1
                fi
            fi
        else
            notdowloaded+=($elem)
            
        fi
    done
    if gum cofirm "Download missing files?"; then
        download_extract "$dir" "$file" "${notdownloaded[@]}"
    fi
    return 0
}

tankconfig() { 
    local elem="$1"
    local tank_dir="Data/3d/Tanks"
    
    if [ -d "$elem/Data/3d/tanks" ]; then
        mv "$elem/Data/3d/tanks" "$elem/$tank_dir"
    fi

    if [ ! -d "$elem/$tank_dir" ]; then 
        mkdir -p "$elem/Data/3d/Tanks"
        rm *.txt > /dev/null 2>&1
        mv "$elem/Data/3d/*" "$elem/Data/3d/Tanks" > /dev/null 2>&1
    fi
    
    if [ -f "$elem/Data/camouflages.yaml.dvpl" ]; then
        rm "$elem/Data/camouflages.yaml.dvpl"
    fi
}

backup() {
    local backup_dir="$1"
    local source_dir="$2"
    local og="$3"
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/" "$WGDATA/"
    rsync -a --ignore-existing "$backup_dir/" "$og"
    rm -rf "$backup_dir"
}

custom_backup() {
    local dir="$1"
    mkdir -p "$MOD_DATA"
    rsync -a "$dir" "$MOD_DATA"
}