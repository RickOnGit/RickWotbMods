function selector() {
    local file="$1" category=""
    case "$file" in
        "$tanksfile")
            if gum confirm "Use some filters?"; then
                list=$(tankfilter)
            else 
                list=$(yq '.[] | .name' "$file")
            fi
            ;;
        *)
            list=$(yq '.[] | .name' "$file")
            ;;
    esac
    category=$(echo -e "$list\nGo back 👈" | gum choose)
    if [[ "$category" = "Go back 👈" ]]; then
        return 1
    fi
    show_info "$category" "$file"
    local stock_path=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name == \"Stock\") | .path" $file)
    if [ ! -d "$mywotb/$stock_path" ]; then
        local modlist=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name != \"Stock\") | .name" "$file")
    else 
        local modlist=$(yq ".[] | select(.name == \"$category\") | .remodels[] | .name" "$file")
    fi

    modlist=$(echo -e "$modlist\nGo back 👈")
    local selected=$(echo "$modlist" | gum choose --no-limit --header="Choose what you wanna install")
    IFS=$'\n' read -r -d '' -a selected_mods <<< "$selected"
    
    for element in "${selected_mods[@]}"; do
        if [[ "$element" = "Go back 👈" ]]; then
            return 1
        elif [[ "$element" = "Stock" ]]; then
            rsync -a "$mywotb/$stock_path/" "$wgdata/"
            gum format -t emoji "$element applied :heavy_check_mark:"
            continue
        fi
        local path=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name == \"$element\") | .path" $file)
        local stock=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name == \"Stock\") | .path" $file)
        local download=$(yq ".[] | select(.name == \"$category\") | .remodels[] | select(.name == \"$element\") | .download" $file)
        downloader "$path" "$stock" "$download" "$element"
    done
}

function downloader() {
    IFS=$'\n' read -r -d '' -a selected_path <<<"$1"
    local stock_path="$mywotb/$2"
    IFS=$'\n' read -r -d '' -a selected_download <<< "$3"
    local model="$4"
    for i in "${!selected_path[@]}"; do
        path="$mywotb/${selected_path[$i]}"
        link="${selected_download[$i]}"

        mkdir -p "$path"
        if [ "$(ls -A $path)" ]; then
            gum format -t emoji "$model already downloaded :package: on $(cat "$path/downloaded.txt")"
            if gum confirm "Redownload $model"; then
                rm -rf "$path"/*
                download "$path" "$model"
            fi
        else
            download "$path" "$model"
        fi

        if gum confirm "Install $model ?"; then
            install "$stock_path" "$path" "$model" "$link"
        fi
    done
}

function install() {
    local stock_path="$1"
    local path="$2"
    local model="$3"
    local link="$4"
    if [ ! -d "$stock_path" ]; then
        backup "$path" "$stock_path" "$model"
    else 
        rsync -a "$stock_path/" "$wgdata/"
        backup "$path" "$stock_path" "$model"
    fi
}

function download() {
    local path="$1"
    local model="$2"
    gum spin -s "minidot" --title "Downloading $model..." -- curl -L "$link" -o "$path"/"$model".download
    gum spin -s "minidot" --title "Extracting $model..." -- 7z x "$path"/"$model".download -o"$path"
    rm "$path"/*.download
    mod_fix "$path"
    echo "$(date)" > "$path"/downloaded.txt
    gum format -t emoji "$model downloaded & extracted :heavy_check_mark:"
}

function mod_fix() {
    local path="$1"
    if [ ! -d "$path/Data" ]; then
        mkdir -p "$path/Data"
        mv "$path"/* "$path"/Data 2>/dev/null
    fi
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

function tankfilter() {
    ans=$(echo -e "$filter" | gum choose --header="Choose what filters you wanna applied")
    case "$ans" in
        "Filter by nation 🏳️")
            nation=$(echo -e "$nations" | gum choose --header="Choose a nation")
            echo -e "$(yq -r ".[] | select(.nation == \"$nation\") | .name" "$tanksfile")"
            ;;
        "Filter by tier 🔢")
            tier=$(echo -e "$tiers" | gum choose --header="Choose a tier")
            echo -e "$(yq -r ".[] | select(.tier == \"$tier\") | .name" "$tanksfile")"
            ;;
        "Filter by type 📁")
            type=$(echo -e "$type" | gum choose --header="Choose a type of tank")
            echo -e "$(yq -r ".[] | select(.type == \"$type\")| .name" "$tanksfile")"
            ;;
    esac
}