function modPreview() {
  local file="$1"
  modLinks=()

  case "$os" in
  "Android") jq -r '.[] | .name as $mainName | .mods[]? | select(has("android_wg")) | "\($mainName)"' "$file" >"$tmpFile" ;; #or lesta in the jq query
  *) jq -r '.[] | .name' $file >$tmpFile ;;
  esac

  eval "selected=\$(cat \$tmpFile | gum filter --header \"Choose an item below 📋\" $gum_filter_prompt)"

  if [[ -n "$selected" ]]; then
    case "$os" in
    "Android")
      eval "selectedMods=\$(jq -r --arg element \"$selected\" '.[] | select(.name == \$element) | .mods[]? | select(has(\"android_wg\")) | .name' \"$file\" | gum filter --no-limit --header=\"Select mod(s) to preview 📋\" $gum_filter_prompt)"
      ;;
    *)
      eval "selectedMods=\$(jq -r --arg element \"$selected\" '.[] | select(.name == \$element) |  .mods[]?.name' $file | gum filter --no-limit --header=\"Select mod(s) to preview 📋\" $gum_filter_prompt)"
      ;;
    esac
  fi

  if [[ -z $selectedMods ]]; then
    return 1
  fi

  while IFS= read -r mod; do
    site=$(jq -r --arg baseName "$selected" --arg modName "$mod" ' .[] | select(.name == $baseName) | .mods[] | select(.name == $modName) | .site' $file)

    #only for UI
    modLinks+=(" $(printf '\e]8;;%s\a%s\e]8;;\a' "$site" "${BLUE}${mod}${NC}")")
  done <<<"$selectedMods"

  formattedLinks=$(printf "%s\n" "${modLinks[@]}")
  formattedTitle=$(echo -e "${BOL}${ORANGE}Mod(s) 🖼️ preview for $selected${NC}\n\n${ITAL}${GRAY}💡 (ctr+clik for preview) 💡${NC}")

  list=$(gum style --align center --border rounded --margin "1 1" --padding "1 1" "$(echo -e "$formattedTitle\n\n$formattedLinks")")
  echo "$list"
}
