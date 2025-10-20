function modRestore() {
  local modFile="$1"
  local backupFile="$2"
  checkBackupFile "$modFile" "$backupFile"

  checkLogs
  backupDir

  mapfile -t restoreItems < <(jq -r '.[] | select(.backupFiles and (.backupFiles | length > 0)) | .name' "$backupFile" | gum filter --header "Select item(s) to restore 📋" --no-limit)

  for entry in "${restoreItems[@]}"; do
    echo -e "${BLUE}${BOL}♻️ Restoring${NC} ${BOL}${ORANGE}$entry${NC}'s stock files..."
    restore "$entry" "$backupFile"
    echo -e "${BOL}${ORANGE}$entry${NC} restored\n" >>$tmpLogs
  done
}

function restore() {
  local entry="$1"
  local backupFile="$2"
  local tmpJson=$(mktemp --suffix=.json)

  if [[ -n "$entry" ]]; then
    mapfile -t filesToRestore < <(jq -r --arg name "$entry" '.[] | select(.name == $name) | .backupFiles[]' "$backupFile")
  else
    mapfile -t filesToRestore < <(jq -r '.[] | select(.backupFiles | type == "array" and length > 0) | .backupFiles[]' "$backupFile")
  fi

  for relPath in "${filesToRestore[@]}"; do
    src="$wotbBackup/$relPath"
    dest="$wotbData/$relPath"
    if [ -f "$dest" ] && [ -f "$src" ]; then
      gum spin --title "Restoring files" -a right --spinner "line" -- cp "$src" "$dest"
    else
      gum spin --title "Clearing unused files" -a right --spinner "line" -- rm "$dest"
    fi    
  done

  # clearing unused dir -> custom mod dir
  find "$wotbData/Data" -type d -empty -delete

  if [[ -n "$entry" ]]; then
    jq --arg entry "$entry" 'map(if .name == $entry then .backupFiles = [] else . end)' "$backupFile" > "$tmpJson" && mv "$tmpJson" "$backupFile"
  else
    jq '(map(select(.backupFiles | type == "array" and length > 0)) | .[0].name) as $target | map(if .name == $target then .backupFiles = [] else . end)' "$backupFile" > "$tmpJson" && mv "$tmpJson" "$backupFile"  
  fi
}

function restoreGame() {
  echo -e "${BOLD}${GREEN}Restoring stock game files...${NC}"
  gum spin -s "line" --title "Restoring" -a right -- rsync -a "$wotbBackup/Data/" "$wotbData/Data/"
  rm "$wotbBackup/backup-files"/*
  echo -e "♻️ ${BOLD}${GREEN}Stock game files applied${NC}" >$tmpLogs
}
