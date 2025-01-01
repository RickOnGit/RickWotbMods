#Variables
wgpacks="$HOME/.local/share/Steam/steamapps/compatdata/444200/pfx/drive_c/users/steamuser/AppData/Local/wotblitz/packs"
wgdata="$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data"
mywotb="$HOME/"$(whoami)"_wotb"
gum_options="--header.foreground=208 --cursor.foreground=214 --cursor.background=235 --header.foreground=109 --header.background=234 --item.foreground=250 --item.background=235 --selected.foreground=214 --selected.background=235"
og_data="$mywotb/og_data/Data"
og_packs="$mywotb/og_packs/packs"


downloader() {
    for i in "${!links[@]}"; do
        link="${links[$i]}"
        model="${remodels_array[$i]}"
        dest_path="$mywotb/Tanks/$nation/$category/$tank/$model"
        mkdir -p "$dest_path"
        gum spin -s "minidot" --title "Downloading $tank $model" -- curl -L "$link" -o "$dest_path/$model.download"
        gum spin -s "minidot" --title "Extracting $tank $model" -- 7z x "$dest_path/$model.download" -o"$dest_path"
        rm "$dest_path"/*.download
        gum format -t emoji "$tank $model downloaded & extracted :heavy_check_mark:"
        if gum confirm "Install $model for $tank ?"; then
            installer "$dest_path"
        fi
    done
}

installer() {
    local remodel_path="$1"
    og="$mywotb/Tanks/$nation/$category/$tank/og_$tank"
    temp="$mywotb/Tanks/$nation/$category/$tank/temp_$tank"
    mkdir -p "$og" "$temp"

    if [ ! -d "$remodel_path/Data" ]; then
        mkdir -p "$remodel_path/Data"
        mv "$remodel_path"/* "$remodel_path"/Data 2>/dev/null
    fi

    if [ -z "$(ls -A "$og")" ]; then
        rsync -a "$og/" "$path/"
        backup "$temp" "$remodel_path/Data" "$og" "$path"
    else 
        backup "$temp" "$remodel_path/Data" "$og" "$path"
    fi
    gum format -t emoji "$tank $model installed :white_check_mark:"
}
        
backup() {
    local backup_dir="$1"
    local source_dir="$2"
    local og="$3"
    local path="$4"
    gum spin -s "minidot" --title "Installing $tank $model" -- sleep 2
    rsync -a --backup --backup-dir="$backup_dir" "$source_dir/" "$path/"
    rsync -a --ignore-existing "$backup_dir/" "$og"
    rm -rf "$backup_dir"
    if [ "$path" = "$wgdata" ]; then
        mkdir -p "$og_data"
        rsync -a --ignore-existing "$og/" "$og_data/"
    else
        mkdir -p "$og_packs"
        rsync -a --ignore-existing "$og/" "$og_packs/"
    fi
}