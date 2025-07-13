function selectorMods() {
  local file="$1"
  local category="$2"
  declare -A links

  tempSelected=$(jq -r --arg category $category '.[$category][] | .name as $mainName | .mods[]?.name as $modName | "\($mainName), \($modName)"' "$file")

  echo "$tempSelected" >$filterFile
  selected=$(cat $filterFile | gum filter --no-limit --height=10)

  if [ -n "$selected" ]; then
    while IFS=',' read -r element modName; do
      element=$(echo "$element" | xargs)
      modName=$(echo "$modName" | xargs)
      link=$(jq -r --arg category "$category" --arg element "$element" --arg modName "$modName" --arg downloadLink "$client" '.[$category][] | select(.name == $element) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$file")
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
  baseModelName="$1"
  modName="$2"
  downloadLink="$3"
  temp_dir=$(mktemp -d)

  gum spin -s "minidot" --title "Downloading $modName for $baseModelName..." -- curl -L "$downloadLink" -o "$temp_dir"/"$modName".download
  gum spin -s "minidot" --title "Extracting $modName..." -- 7z x "$temp_dir"/"$modName".download -o"$temp_dir"
  rm "$temp_dir"/*.download
  modFix "$temp_dir"
  gum format -t emoji "$modName downloaded & extracted :heavy_check_mark:"
  installer "$temp_dir" "$modName"
  rm -r "$temp_dir"
}
