function modPreview() {
  local file="$1"
  modLinks=()

  jq -r --arg client "$client" '.[] | select(has("mods")) | .name as $mainName | select(.mods | any(has($client))) | $mainName' "$file" >"$tmpPreview" #or lesta in the jq query

  eval "selected=\$(cat \$tmpPreview | gum filter --header \"Choose an item below 📋\" $gum_filter_prompt)"

  if [[ -n "$selected" ]]; then
    eval "selectedMods=\$(jq -r --arg element \"$selected\" '.[] | select(.name == \$element) | .mods[]? | .name' \"$file\" | gum filter --no-limit --header=\"Select mod(s) to preview 📋\" $gum_filter_prompt)"
  fi

  if [[ -z $selectedMods ]]; then
    return 1
  fi

  while IFS= read -r mod; do
    site=$(jq -r --arg baseName "$selected" --arg modName "$mod" ' .[] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' "$file")

    #only for UI
    modLinks+=(" $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${BLUE}${mod}${NC}")")
  done <<<"$selectedMods"

  formattedLinks=$(printf "%s\n" "${modLinks[@]}")
  formattedTitle=$(echo -e "${BOL}${ORANGE}Mod(s) 🖼️ preview for $selected${NC}\n\n${ITAL}${GRAY}💡 (ctrl+clik for preview) 💡${NC}")

  previewFrame=$(gum style --align center --border rounded "$(echo -e "$formattedTitle\n\n$formattedLinks")")
}
