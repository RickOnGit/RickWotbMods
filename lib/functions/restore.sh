function restoreItems() {
  local file="$1"
  local category="$2"
  readarray -t ogElems < <(jq -r --arg category "$category" '.[$category][] | .name' "$file" | gum choose --no-limit --header "Select what to restore")

  for elem in "${ogElems[@]}"; do
    readarray -t ogFiles < <(jq -r --arg category "$category" --arg name "$elem" '.[$category][] | select(.name == $name) | .backupItems[]' "$file")

    for fileName in "${ogFiles[@]}"; do
      gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
    done

    gum format -t emoji "$elem's original files applied :heavy_check_mark:"
  done
}

function restoreGame() {
  gum spin -s "minidot" --title "Restoring all original game files" -- rsync -a "$wotbBackup" "$wotbData"
}
