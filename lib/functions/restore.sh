function restoreItems() {
  local file="$1"
  selectedArray=()

  checkLogs

  jq -r '.[] | select(has("backupDir") or has("backupFiles")) | .name' "$file" >"$tmpRestore"
  eval "selected=\$(cat \$tmpRestore | gum filter --header \"Select item(s) to restore 📋\" --no-limit $gum_filter_prompt)"

  while IFS= read -r name; do
    selectedArray+=("$name")
  done <<<"$selected"

  if [ -n "$selected" ]; then
    >$tmpRestore
    for elem in "${selectedArray[@]}"; do
      echo -e "${BLUE}${BOL}♻️ Restoring${NC} ${BOL}${ORANGE}$elem${NC}'s stock files..."
      for type in "Dir" "Files"; do
        jq -r --arg mainName "$elem" ".[] | select(.name == \$mainName) | .backup${type}[]" "$file" >>$tmpRestore 2>/dev/null
        restore "$tmpRestore" "$type" "$elem"
      done
      echo -e "${BOL}${ORANGE}$elem${NC} restored\n" >>$tmpLogs
      >$tmpRestore
    done
  else
    return
  fi
}

function restore() {
  local file="$1"
  local type="$2"
  local elem="$3"

  while IFS= read -r fileName; do
    if [[ "$type" == "Files" ]]; then
      includePattern="*${fileName}*"
    else
      includePattern="${fileName}/**"
    fi

    backupDir
    gum spin -s "pulse" --spinner.foreground="208" --title "Restoring..." --title.foreground="245" -- rsync -a --include="*/" --include="$includePattern" --exclude="*" "$wotbBackup" "$wotbData"
  done <"$file"
}

function restoreGame() {
  echo -e "${BOLD}${GREEN}Restoring stock game files...${NC}"
  gum spin -s "pulse" --spinner.foreground="208" --title.foreground="245" --title "Restoring..." -- rsync -a "$wotbBackup" "$wotbData"
  echo -e "♻️ ${BOLD}${GREEN}Stock game files applied${NC}" >>$tmpLogs
}
