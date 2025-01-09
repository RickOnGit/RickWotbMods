selector() {
    local category="$1"
    string=""
    case "$category" in
        "Tanks🚜")
            nation=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            tank=$(yq "."$category"."$nation" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$nation.$tank"
            get_links "$string"
            ;;
        *)
            class=$(yq "."$category" | keys | .[]" ../config/mods.yaml | gum choose)
            string="$category.$class"
            get_links "$string"
            ;;
    esac
}

get_links() {
    local string="$1"
    
    remodels=()
    mapfile -t remodels < <(yq ".$string | keys | .[]" ../config/mods.yaml | gum choose --no-limit --ordered)

    links=()
    sources=()
    for elem in "${remodels[@]}"; do
        links+=("$(yq ".$string.$elem.download" ../config/mods.yaml)")
        sources+=("$(yq ".$string.$elem.source" ../config/mods.yaml)")
    done
}

downloader() {
    local category="$1"
    for i in "${!links[@]}"; do
        link="${links[$i]}"
        mod="${remodels[$i]}"

        case $category in
            "Tanks🚜")
                dir="$mywotb/$category/$nation/$tank/$mod"
                og="$mywotb/$category/$nation/$tank/stock-$tank"
                mkdir -p $og
                
                temp="$mywotb/$category/$nation/$tank/temp-$tank"
                ;;
            *)
                dir="$mywotb/$category/$class/$mod"
                og="$mywotb/$category/stock-$category"
                mkdir -p $og
                
                temp="$mywotb/$category/temp-$category"
                ;;
        esac

        mkdir -p "$dir"
        if [ $mod = stock-$tank ] || [ $mod = stock-$category ]; then
            rsync -a "$og"/ "$wgdata"
            gum format -t emoji "$og applied :heavy_check_mark:"
        else 
            gum spin -s "minidot" --title "Downloading $mod" -- curl -L "$link" -o "$dir/$mod.download"
            gum spin -s "minidot" --title "Extracting $mod" -- 7z x "$dir/$mod.download" -o"$dir"
            rm "$dir"/*.download
            gum format -t emoji "$mod downloaded & extracted :heavy_check_mark:"
        fi
    
        if gum confirm "Install $mod?"; then
            installer "$category" "$dir" "$og" "$temp"
        fi
    done
}

installer() {
    local category="$1"
    local dir="$2"
    local og="$3" 
    local temp="$4"

    if [ ! -d "$dir/Data" ]; then
        mkdir -p "$dir/Data"
        mv "$dir"/* "$dir"/Data 2>/dev/null
    fi

    if  [ "$category" = "Tanks🚜" ] && [ -d "$og" ]; then
        rsync -a "$og/" "$wgdata/"
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
    rsync -a --ignore-existing "$backup_dir/" "$og"
    rm -rf "$backup_dir"
}