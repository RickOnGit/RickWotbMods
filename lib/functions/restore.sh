function restoreItems() {
  local file="$1"
  formattedNames=() #UI decoration
  selectedArray=()

  jq -r '.[] | .name' "$file" >$tmpFile
  eval "selected=\$(cat \$tmpFile | gum filter --header \"Select item(s) to restore 📋\" --no-limit $gum_filter_prompt)"

  while IFS= read -r name; do
    selectedArray+=("$name")
  done <<<"$selected"

  if [ -n "$selected" ]; then
    >$tmpFile
    for elem in "${selectedArray[@]}"; do
      jq -r --arg mainName "$elem" '.[] | select(.name == $mainName) | .backupItems[]' "$file" >>$tmpFile
      #will write all file names to restore from backup to wotbData
      echo -e "${BLUE}${BOL}♻️ Restoring${NC} ${BOL}${ORANGE}$elem${NC}'s stock files..."
      restore $tmpFile $elem
    done
  else
    return
  fi
}

function restore() {
  local file="$1"
  local name="$2"
  while IFS= read -r fileName; do
    gum spin -s "pulse" --spinner.foreground="208" --title "Restoring..." --title.foreground="245" -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
  done <$file
  >$tmpFile
  echo -e "${BOL}${ORANGE}$elem${NC} restored ✅\n"
}

function restoreGame() {
  echo -e "${BOLD}${GREEN}Restoring stock game files...${NC}"
  gum spin -s "pulse" --spinner.foreground="208" --title.foreground="245" --title "Restoring..." -- rsync -a "$wotbBackup" "$wotbData"
  echo -e "${BOLD}${GREEN}Stock game files applied ✅${NC}\n"
}
