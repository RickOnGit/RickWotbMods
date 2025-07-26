function selectorMods() {
  local file="$1"
  declare -A links

  case "$os" in
  "Android") jq -r '.[] | .name as $mainName | .mods[]? | select(has("android_wg")) | "\($mainName), \(.name)"' "$file" >"$tmpFile" ;;
  *) jq -r '.[] | .name as $mainName | .mods[]?.name as $modName | "\($mainName), \($modName)"' "$file" >$tmpFile ;;
  esac

  eval "selected=\$(cat \$tmpFile | gum filter --header \"Choose mod(s) to download 📋\" --no-limit $gum_filter_prompt)"

  if [ -n "$selected" ]; then
    while IFS=',' read -r element modName; do
      element=$(echo "$element" | xargs)
      modName=$(echo "$modName" | xargs)
      link=$(jq -r --arg element "$element" --arg modName "$modName" --arg downloadLink "$client" '.[] | select(.name == $element) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$file")
      links["$element,$modName"]="$link"
    done <<<"$selected"
    downloader
  else
    return
  fi
}

function downloader() {
  for key in "${!links[@]}"; do
    downloadLink="${links[$key]}"
    baseModelName=$(echo "$key" | cut -d',' -f1)
    modName=$(echo "$key" | cut -d',' -f2)
    download "$baseModelName" "$modName" "$downloadLink"
    unset "links[$key]"
  done
}

function download() {
  local baseModelName="$1"
  local modName="$2"
  local downloadLink="$3"

  echo -e "${BLUE}${BOL}📦 Installing${NC} ${BOL}${GREEN}$modName${NC} for ${BOL}${ORANGE}$baseModelName${NC}..."

  gum spin --spinner.foreground="208" -s "pulse" --title "Downloading..." --title.foreground="245" -- curl -L "$downloadLink" -o "$tmpDir"/"$modName".download

  gum spin --spinner.foreground="208" -s "pulse" --title "Extracting..." --title.foreground="245" -- 7z x "$tmpDir"/"$modName".download -o"$tmpDir"

  rm "$tmpDir"/*.download
  if [[ $os != "Android" ]]; then
    modFix "$tmpDir"
  fi
  installer "$tmpDir" "$modName" "$baseModelName"
  rm -r "$tmpDir"
}
