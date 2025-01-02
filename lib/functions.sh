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
    print_info $available $sources
    
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
                directory_structure="$mywotb/$category/$nation/$tier/$type/$tank/$mod"
                mkdir -p "$directory_structure"
                ;;
            "Sounds🔊"|"Hangars🛖")
                directory_structure="$mywotb/$category/$class/$mod"
                mkdir -p "$directory_structure"
                ;;
            *)
                directory_structure="$mywotb/$category/$mod"
                mkdir -p "$directory_structure"
                ;;
        esac
        gum spin -s "minidot" --title "Downloading $mod" -- curl -L "$link" -o "$directory_structure/$mod.download"
        gum spin -s "minidot" --title "Extracting $mod" -- 7z x "$directory_structure/$mod.download" -o"$directory_structure"
        rm "$directory_structure"/*.download
        gum format -t emoji "$mod downloaded & extracted :heavy_check_mark:"
    done
}

#change some variables' name

# installer() {

# }

# backup() {

# }