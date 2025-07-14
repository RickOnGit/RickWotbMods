#!/usr/bin/env bash

tanks=$(jq -r '.Tanks[] | .name' ../config/tanks.json)
echo "$tanks" >filter.txt
selectedElem=$(cat filter.txt | gum filter)

mods=$(jq -r --arg element "$selectedElem" '.Tanks[] | select(.name == $element) | .mods[]?.name' ../config/tanks.json)
selectedMods=$(echo "$mods" | gum choose --no-limit --header="Select")

modLinks=()

while IFS= read -r mod; do
  site=$(jq -r --arg baseName "$selectedElem" --arg modName "$mod" '.Tanks[] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' ../config/tanks.json)

  modLinks+=("• $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "$mod")")
done <<<"$selectedMods"

formattedLinks=$(printf "%s\n" "${modLinks[@]}")

list=$(gum style --padding "1 2" --border double --border-foreground 180 "$(echo -e "Mods for $selectedElem\n\n$formattedLinks")")

echo "$list"
