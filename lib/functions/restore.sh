function restoreItems() {
  local file="$1"
  local category="$2"

  tempSelected=$(jq -r --arg category $category '.[$category][] | .name as $mainName |"\($mainName)"' "$file")

  echo "$tempSelected" >$filterFile
  selected=$(cat $filterFile | gum filter --no-limit --height=10)

  #Only for UI decoration
  printNames=()
  while IFS= read -r name; do
    printNames+=("• $(printf "$name")")
  done <<<"$selected"
  formattedNames=$(printf "%s\n" "${printNames[@]}")
  #end UI decoration

  if [ -n "$selected" ]; then
    IFS=$'\n' read -r -d '' -a selectedArray < <(echo "$selected" && printf '\0')

    >$filterFile
    for elem in "${selectedArray[@]}"; do
      jq -r --arg category "$category" --arg mainName "$elem" '.[$category][] | select(.name == $mainName) | .backupItems[]' "$file" >>$filterFile
    done

    while IFS= read -r fileName; do
      gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
    done <$filterFile

    list=$(gum style --padding "1 2" --border double --border-foreground 180 "$(echo -e "Original files applied for\n\n$formattedNames")")
    echo "$list"
  else
    return
  fi
}

function restoreGame() {
  gum spin -s "minidot" --title "Restoring all original game files" -- rsync -a "$wotbBackup" "$wotbData"
}
