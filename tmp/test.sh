#!/usr/bin/env bash

category="Tanks"
wotbData="/home/rick/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data/"
wotbBackup="/home/rick/.local/share/Steam/steamapps/common/World of Tanks Blitz/Backup/"

tempSelected=$(jq -r --arg category $category '.[$category][] | .name as $mainName |"\($mainName)"' ../config/tanks.json)

echo "$tempSelected" >filter.txt

selected=$(cat filter.txt | gum filter --no-limit --height=10)

if [ -n "$selected" ]; then
  IFS=$'\n' read -r -d '' -a selectedArray < <(echo "$selected" && printf '\0')
  >filter.txt
  for elem in "${selectedArray[@]}"; do
    jq -r --arg category "$category" --arg mainName "$elem" '.[$category][] | select(.name == $mainName) | .backupItems[]' ../config/tanks.json >>filter.txt
  done

  while IFS= read -r fileName; do
    gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$wotbBackup" "$wotbData"
  done <filter.txt
  gum format -t emoji "$selected original files applied :heavy_check_mark:"
else
  return
fi
