#!/bin/bash

# lowerdir="$wgdata"
# upperdir="$mywotb"
# workdir="$HOME/wotb_mods"
# overlay="$wgdata/Data_overlay"

# mkdir -p "$upperdir" "$workdir" "$overlay"

# sudo mount -t overlay overlay \
#     -o lowerdir="$lowerdir",upperdir="$upperdir",workdir="$workdir" \
#     "$overlay"



# yq '.Guns[] | "🟠 " +.name + " 👉 " + .source' sounds.yml


selection=$(yq 'to_entries | .[] | (.value[] | select(has("info")) | .info)' sounds.yml | gum choose);
key=$(yq 'to_entries | .[] | select(.value[] | has("info") and .value[].info == "'"$selection"'") | .key' sounds.yml);
elems=$(yq ".\"$key\"[] | select(has(\"name\") and .name != \"Stock\") | .name" sounds.yml | gum choose --no-limit); echo "${elems[@]}"

