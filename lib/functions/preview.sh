function modPreview() {
  local file="$1"
  modLinks=()

  jq -r --arg client "$client" '[.[] | select(.mods[]? | has($client)) | .name] | unique[]' "$file" >"$tmpPreview"
  eval "selected=\$(cat \$tmpPreview | gum filter --header \"Choose an item below 📋\" $gum_filter_prompt)"
  
  if [[ -n "$selected" ]]; then
    eval "selectedMods=\$(jq -r --arg client "$client" --arg element \"$selected\" '.[] | select(.name == \$element) | .mods[]? | select(has(\$client)) | .name' \"$file\" | gum filter --no-limit --header=\"Select mod(s) to preview 📋\" $gum_filter_prompt)"
  fi

  if [[ -z $selectedMods ]]; then
    return 1
  fi

    
  while IFS= read -r mod; do
    site=$(jq -r --arg baseName "$selected" --arg modName "$mod" ' .[] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' "$file")

    #only for UI
    modLinks+=("⚪ $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${SOFT_BLUE}${mod}${NC}")\n")
  done <<<"$selectedMods"

  echo -e "⬇️ ${BOL}${GREEN}$selected${NC} ⬇️\n" >$tmpPreview
  printf "%s\n" "${modLinks[@]}" >>$tmpPreview
}
