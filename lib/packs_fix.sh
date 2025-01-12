#!/bin/bash
#variables
wgpacks="$HOME/.local/share/Steam/steamapps/compatdata/444200/pfx/drive_c/users/steamuser/AppData/Local/wotblitz/packs"
wgdata="$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data"

no_copy=(
    "dvpl_file_info_cache.txt"
    "local_copy_server_file_table.block"
    "local_copy_server_footer.footer"
    "local_copy_server_meta.meta"
)

temp=$(mktemp -d)

for file in "${no_copy[@]}"; do
    mv "$wgpacks/$file" "$temp"
done

mv -f "$wgpacks/" "$wgdata/"
mv -f "$temp/" "$wgpacks/"
rmdir "$temp"