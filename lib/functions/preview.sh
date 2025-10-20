function modPreview() {
  local modFile="$1"

  if jq -e '.[0] | has("mods")' "$modFile" > /dev/null 2>&1; then
    modLinks=()
    item=$(jq -r --arg client "$client" '[.[] | select(.mods[]? | has($client)) | .name] | unique[]' "$modFile" | gum filter --header "Choose an item below 📋")

    mapfile -t Mods < <(jq -r --arg client "$client" --arg element "$item" '.[] | select(.name == $element) | .mods[]? | select(has($client)) | .name' "$modFile" | gum filter --no-limit --header="Select mod(s) to preview 📋")

    for mod in "${Mods[@]}"; do
      echo -e "⬇️ ${BOL}${GREEN}$item${NC} ⬇️\n" >$tmpPreview
      mapfile -t Sites < <(jq -r --arg baseName "$item" --arg modName "$mod" '.[] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' "$modFile")
      for site in "${Sites[@]}"; do
        modLinks+=("$(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${SOFT_BLUE}${mod}${NC}")\n")
      done
      printf "%s\n" "${modLinks[@]}" >>$tmpPreview
    done
  else
    mapfile -t Mods < <(jq -r --arg client "$client" '[.[] | select(has($client)) | .name] | unique[]' "$modFile" | gum filter --no-limit --header "Select mod(s) to preview 📋")

    > $tmpPreview
    for mod in "${Mods[@]}"; do
      mapfile -t Sites < <(jq -r --arg modName "$mod" '.[] | select(.name == $modName) | .site' "$modFile")
      for site in "${Sites[@]}"; do
        printf "%b" "$(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${SOFT_BLUE}${mod}${NC}")\n\n" >>"$tmpPreview"
      done
    done
  fi
}
