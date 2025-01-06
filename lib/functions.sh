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
                mkdir -p "$dir"
                ;;
            *)
                dir="$mywotb/$category/$class/$mod"
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

    case $category in
        "Tanks🚜")
            if [ -d "$og" ]; then
                rsync -a "$og/" "$wgdata/" #use a path variable then
            fi
            backup "$temp" "$dir/Data" "$og"
            ;;
        *)
            backup "$temp" "$dir/Data" "$og"
            ;;
    esac 
    #meh

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
    
    # if [ "$path" = "$wgdata" ]; then
    #     mkdir -p "$og_data"
    #     rsync -a --ignore-existing "$og/" "$og_data/"
    # else
    #     mkdir -p "$og_packs"
    #     rsync -a --ignore-existing "$og/" "$og_packs/"
    # fi
}

version_check() {
    mkdir -p $mywotb/verison
    cp $wgdata/version.txt.dvpl $mywotb/version
    cd $mywotb/version
    dvpl decompress
    version=$(< version.txt)
    if [ "$version" = "$current_version"]; then
        gum format -t "markdown" "**No new version detected**"
    else
        gum format -t "markdown" "**New version detected**"
        new_version #function to be called
    fi
    current_version="$version"
}

new_version() {
    rsync -a "$wgpacks" "$wgdata"

}

#change some variables' name
#Short urls
# installer() {

# }

# backup() {

# }