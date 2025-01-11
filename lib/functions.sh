function selector() {
    local category="$1"
    string=""
    case "$category" in
        "Tanks")
            nation=$(yq "."$category" | keys | .[]" "$mods_file" | gum choose)
            tank=$(yq "."$category"."$nation" | keys | .[]" "$mods_file" | gum choose)
            string="$category.$nation.$tank"
            get_info "$string"
            ;;
        *)
            class=$(yq "."$category" | keys | .[]" "$mods_file" | gum choose)
            string="$category.$class"
            get_info "$string"
            ;;
    esac
}

function get_info() {
    local string="$1"
    local stock_path=$(yq ".$string.Stock.path" "$mods_file")

    d_remodels=()
    
    mapfile -t d_remodels < <(yq ".${string} | keys | map(select(. != \"Stock\")) | .[]" "$mods_file" | gum choose --no-limit --ordered)
    
    for elem in "${d_remodels[@]}"; do
        paths+=("$(yq ".$string.$elem.path" "$mods_file")")
        sources+=("$(yq ".$string.$elem.source" "$mods_file")")
        downloads+=("$(yq ".$string.$elem.download" "$mods_file")")
    done

    ans=$(echo -e "Download elements\nInstall Elements\nShow info elements\nGo back"| gum choose --header "Choose what you wanna do")

    case $ans in
        "Download elements")
            downloader "$string" "$mywotb/$stock_path"
            ;;
        "Install Elements")
            installer "$string"
            ;;
        "Show info elements")
            ;;
        "Go back")
            ;;
    esac
}

function downloader() {
    local string="$1"
    local stock_path="$2"

    for ((elem = 0; elem < ${#d_remodels[@]}; elem++)); do
        local path="$mywotb/${paths[$elem]}"
        local model="${d_remodels[$elem]}"
        local download="${downloads[$elem]}"
        
        mkdir -p "$path"
        
        gum spin -s "minidot" --title "Downloading $model" -- curl -L "$download" -o "$path/$model.download"
        gum spin -s "minidot" --title "Extracting $model" -- 7z x "$path/$model.download" -o"$path"
        rm "$path/$model.download"
        mod_fix "$path"
        gum format -t emoji "$model downloaded & extracted :heavy_check_mark:"
        
        if gum confirm "Install $model ?"; then
            if [ ! -d "$stock_path" ]; then
                backup "$path" "$stock_path" "$model"
            else 
                rsync -a "$stock_path/" "$wgdata/"
                backup "$path" "$stock_path" "$model"
            fi
        fi
    done
}

function mod_fix() {
    local path="$1"
    if [ ! -d "$path/Data" ]; then
        mkdir -p "$path/Data"
        mv "$path"/* "$path"/Data 2>/dev/null
    fi
}

function installer() {
    local string="$1"
    local path="$2"
    local dirname="$(dirname "$path")"
    i_remodels=()
    
    i_remodels=("$(find $dirname -maxdepth 1 -type d -not -name '.*' | sed 's|^\./||' | gum choose --no-limit --ordered)")

    mod_fix "$path"
}
        
function backup() {
    local source_dir="$1"
    local stock_dir="$2"
    local model="$3"
    local backup_dir=$(mktemp -d)
    mkdir -p "$stock_dir"

    gum spin -s "minidot" --title "Installing $model" -- sleep 2
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/Data/" "$wgdata/"
    rsync -a --ignore-existing "$backup_dir/" "$stock_dir"

    rm -rf "$backup_dir"
    gum format -t emoji "$model installed :white_check_mark:"
}

# function version_checker() {
    
# }