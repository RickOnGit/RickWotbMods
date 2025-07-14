function modPreview() {
  local file="$1"
  local category="$2"
  elem=$(jq -r --arg category "$category" '.[$category][] | .name' $file)

  echo "$elem" >$filterFile

  selectedElem=$(cat $filterFile | gum filter)
  mods=$(jq -r --arg category "$category" --arg element "$selectedElem" '.[$category][] | select(.name == $element) | .mods[]?.name' $file)
  selectedMods=$(echo "$mods" | gum choose --no-limit --header="Select")
  modLinks=()

  while IFS= read -r mod; do
    site=$(jq -r --arg category "$category" --arg baseName "$selectedElem" --arg modName "$mod" ' .[$category][] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' $file)

    modLinks+=("• $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "$mod")")
  done <<<"$selectedMods"

  formattedLinks=$(printf "%s\n" "${modLinks[@]}")

  list=$(gum style --padding "1 2" --border double --border-foreground 180 "$(echo -e "Mods for $selectedElem\n\n$formattedLinks")")

  echo "$list"
}
