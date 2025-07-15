function restoreItems() {
  local file="$1"
  local category="$2"

  tempSelected=$(jq -r --arg category $category '.[$category][] | .name as $mainName |"\($mainName)"' "$file")

  echo "$tempSelected" >$filterFile
  selected=$(cat $filterFile | gum filter --no-limit --height=10)

  if [ -n "$selected" ]; then
    IFS=$'\n' read -r -d '' -a selectedArray < <(echo "$selected" && printf '\0')

    >$filterFile
    for elem in "${selectedArray[@]}"; do
      jq -r --arg category "$category" --arg mainName "$elem" '.[$category][] | select(.name == $mainName) | .backupItems[]' "$file" >>$filterFile
    done

    while IFS= read -r fileName; do
      gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
    done <$filterFile

    gum format -t emoji "$selected original files applied :heavy_check_mark:"
  else
    return
  fi
}

function restoreGame() {
  gum spin -s "minidot" --title "Restoring all original game files" -- rsync -a "$wotbBackup" "$wotbData"
}
