function modPreview() {
  local file="$1"
  local category="$2"
  BLUE='\033[0;34m' # Blue
  NC='\033[0m'      # No Color
  elem=$(jq -r --arg category "$category" '.[$category][] | .name' $file)

  echo "$elem" >$tmpFile

  selectedElem=$(cat $tmpFile | gum filter)
  mods=$(jq -r --arg category "$category" --arg element "$selectedElem" '.[$category][] | select(.name == $element) | .mods[]?.name' $file)
  selectedMods=$(echo "$mods" | gum choose --no-limit --header="Select")
  modLinks=()

  while IFS= read -r mod; do
    site=$(jq -r --arg category "$category" --arg baseName "$selectedElem" --arg modName "$mod" ' .[$category][] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' $file)

    #only for UI
    modLinks+=("• $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${BLUE}${mod}${NC}")")
  done <<<"$selectedMods"

  formattedLinks=$(printf "%s\n" "${modLinks[@]}")
  title=$(gum format -- "# Mods for $selectedElem" "(_ctrl+mouse click_)")

  list=$(gum style --border="rounded" --margin="0 1" --padding "1 5" --align="center" "$(echo -e "$title\n\n$formattedLinks")")

  echo "$list"
}
