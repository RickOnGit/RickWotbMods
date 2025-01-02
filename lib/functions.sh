selector() {
    local category="$1"
    string=""
    case "$category" in
        "Sounds🔊"|"Hangars🛖")
            class=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$class"
            get_links "$string"
            ;;
        "Tanks🚜")
            nation=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            tier=$(yq "."$category"."$nation" | keys | .[]" ../config/mods.yaml | gum choose) 
            type=$(yq "."$category"."$nation"."$tier" | keys | .[]" ../config/mods.yaml | gum choose)
            tank=$(yq "."$category"."$nation"."$tier"."$type" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$nation.$tier.$type.$tank"
            get_links "$string"
            ;;
        *)
            get_links "$category"
    esac
}

get_links() {
    local string="$1"
    
    available=()
    mapfile -t available < <(yq ".$string | keys | .[]" ../config/mods.yaml)
    for elem in "${available[@]}"; do
        links+=("$(yq ".$string.$elem.download" ../config/mods.yaml)")
        sources+=("$(yq ".$string.$elem.source" ../config/mods.yaml)")
    done
    #print_info $available $sources
    
    remodels=()
    mapfile -t remodels < <(yq ".$string | keys | .[]" ../config/mods.yaml | gum choose --no-limit --ordered)

    links=()
    sources=()
    for elem in "${remodels[@]}"; do
        links+=("$(yq ".$string.$elem.download" ../config/mods.yaml)")
        sources+=("$(yq ".$string.$elem.source" ../config/mods.yaml)")
    done
}

print_info() {
    json_data="["
    for i in ${!available[@]}; do
        model="${available[$i]}"
        source="${sources[$i]}"
        json_data+="{\"model\":\"$model\",\"source\":\"$source\"},"
    done
    json_data=${json_data%,}
    json_data+="]"
    output=$(node ../lib/table.js "$json_data")
    echo "$output"
}

downloader() {
    local category="$1"
    for i in "${!links[@]}"; do
        link="${links[$i]}"
        mod="${remodels[$i]}"
        case $category in
            "Tanks🚜")
                dir="$mywotb/$category/$nation/$tier/$type/$tank/$mod"
                mkdir -p "$dir"
                ;;
            "Sounds🔊"|"Hangars🛖")
                dir="$mywotb/$category/$class/$mod"
                mkdir -p "$dir"
                ;;
            *)
                dir="$mywotb/$category/$mod"
                mkdir -p "$dir"
                ;;
        esac
        gum spin -s "minidot" --title "Downloading $mod" -- curl -L "$link" -o "$dir/$mod.download"
        gum spin -s "minidot" --title "Extracting $mod" -- 7z x "$dir/$mod.download" -o"$dir"
        rm "$dir"/*.download
        gum format -t emoji "$mod downloaded & extracted :heavy_check_mark:"
        if gum confirm "Install $mod?"; then
            installer "$dir"
        fi
    done
}


installer() {
    local dir="$1"
    parent=$(dirname "$dir")
    element=$(basename "$parent")
    
    og="$parent/og-$element"
    temp="$parent/temp"

    if [ ! -d "$dir/Data" ]; then
        mkdir -p "$dir/Data"
        mv "$dir"/* "$dir"/Data 2>/dev/null
    fi

    if [ -d "$og" ]; then
        rsync -a "$og/" "$wgdata/" #use a path variable then
        backup "$temp" "$dir/Data" "$og"
    else
        backup "$temp" "$dir/Data" "$og"
    fi
    gum format -t emoji "$mod installed :white_check_mark:"
}
        
backup() {
    local backup_dir="$1"
    local source_dir="$2"
    local og="$3"
    mkdir -p $og
    mkdir -p $backup_dir
    gum spin -s "minidot" --title "Installing $mod" -- sleep 2
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/" "$wgdata/"
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/" "$wgpacks/"
    rsync -a --ignore-existing "$backup_dir/" "$og"
    rm -rf "$backup_dir"
    
    # if [ "$path" = "$wgdata" ]; then
    #     mkdir -p "$og_data"
    #     rsync -a --ignore-existing "$og/" "$og_data/"
    # else
    #     mkdir -p "$og_packs"
    #     rsync -a --ignore-existing "$og/" "$og_packs/"
    # fi
}


#change some variables' name
#Short urls
# installer() {

# }

# backup() {

# }