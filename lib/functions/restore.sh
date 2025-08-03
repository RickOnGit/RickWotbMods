function restoreItems() {
  local file="$1"
  selectedArray=()

  jq -r '.[] | select(has("backupDir") or has("backupFiles")) | .name' "$file" >"$tmpRestore"
  eval "selected=\$(cat \$tmpRestore | gum filter --header \"Select item(s) to restore 📋\" --no-limit $gum_filter_prompt)"

  while IFS= read -r name; do
    selectedArray+=("$name")
  done <<<"$selected"

  if [ -n "$selected" ]; then
    >$tmpRestore
    for elem in "${selectedArray[@]}"; do
      for type in "Dir" "Files"; do
        jq -r --arg mainName "$elem" ".[] | select(.name == \$mainName) | .backup${type}[]" "$file" >>$tmpRestore 2>/dev/null

        if [ -s "$tmpRestore" ]; then
          echo -e "${BLUE}${BOL}♻️ Restoring${NC} ${BOL}${ORANGE}$elem${NC}'s stock files..."
          restore "$tmpRestore" "$elem" "$type"
        fi

        >$tmpRestore
      done
    done
  else
    return
  fi
}

function restore() {
  local file="$1"
  local name="$2"
  local type="$3"

  while IFS= read -r fileName; do
    if [[ "$type" == "Files" ]]; then
      includePattern="*${fileName}*"
    else
      includePattern="${fileName}/**"
    fi

    backupDir
    gum spin -s "pulse" --spinner.foreground="208" --title "Restoring..." --title.foreground="245" -- rsync -a --include="*/" --include="$includePattern" --exclude="*" "$wotbBackup" "$wotbData"
  done <"$file"

  echo -e "♻️ ${BOL}${ORANGE}$name${NC} restored" >>$tmpLogs

}

function restoreGame() {
  echo -e "${BOLD}${GREEN}Restoring stock game files...${NC}"
  gum spin -s "pulse" --spinner.foreground="208" --title.foreground="245" --title "Restoring..." -- rsync -a "$wotbBackup" "$wotbData"
  echo -e "♻️ ${BOLD}${GREEN}Stock game files applied${NC}" >>$tmpLogs
}
