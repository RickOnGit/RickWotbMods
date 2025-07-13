function restoreItems() {
  local file="$1"
  local category="$2"

  tempSelected=$(jq -r --arg category $category '.[$category][] | .name as $mainName |"\($mainName)"' "$file")

  echo "$tempSelected" >$filterFile
  selected=$(cat $filterFile | gum filter --no-limit --height=10)

  if [ -n "$selected" ]; then
    for elem in "${selected[@]}"; do
      readarray -t ogFiles < <(jq -r --arg category "$category" --arg name "$elem" '.[$category][] | select(.name == $name) | .backupItems[]' "$file")

      for fileName in "${ogFiles[@]}"; do
        gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
      done
      gum format -t emoji "$elem's original files applied :heavy_check_mark:"
    done
  else
    return
  fi
}

function restoreGame() {
  gum spin -s "minidot" --title "Restoring all original game files" -- rsync -a "$wotbBackup" "$wotbData"
}
