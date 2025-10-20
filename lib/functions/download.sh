function modDownload() {
  local modFile="$1"
  local backupFile="$2"
  local complexJson=false
  checkBackupFile "$modFile" "$backupFile"

  if jq -e '.[0] | has("mods")' "$modFile" > /dev/null 2>&1; then
    complexJson=true
  fi

  if $complexJson; then 
    mapfile -t Mods < <(jq -r --arg client "$client" '.[] | .name as $mainName | .mods[]? | select(has($client)) | "\($mainName): \(.name)"' "$modFile" | gum filter --header "Choose mod(s) to download 📋" --no-limit)

    for entry in "${Mods[@]}"; do
      IFS=":" read -r mainName modName <<< "$entry"
      mainName=$(echo "$mainName" | xargs)
      modName=$(echo "$modName" | xargs)
      downloadLink=$(jq -r --arg mainName "$mainName" --arg modName "$modName" --arg downloadLink "$client" '.[] | select(.name == $mainName) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$modFile")
      downloader "$mainName" "$modName" "$downloadLink" "$backupFile"
    done
  else
    mapfile -t Mods < <(jq -r --arg client "$client" '.[] | select(has($client)) | .name' "$modFile" | gum filter --header "Choose mod(s) to download 📋" --no-limit)

    for entry in "${Mods[@]}"; do
      downloadLink=$(jq -r --arg mainName "$entry" --arg downloadLink "$client" '.[] | select(.name == $mainName) | .[$downloadLink]' "$modFile")
      downloader "" "$entry" "$downloadLink" "$backupFile"
    done
  fi
}

function downloader() {
  local mainName="$1"
  local modName="$2"
  local downloadLink="$3"
  local backupFile="$4"
  local tmpDownloadDir=$(mktemp -d)

  if [[ -n "$mainName" ]]; then
    echo -e "\n${BLUE}${BOL}📥 Installing${NC} ${BOL}${GREEN}$modName${NC} for ${BOL}${ORANGE}$mainName${NC}..."
  else
    echo -e "\n${BLUE}${BOL}📥 Installing${NC} ${BOL}${GREEN}$modName${NC}..."
    mainName="$modName"
  fi

  gum spin --title "Downloading" -a right --spinner "line" -- curl -L "$downloadLink" -o "$tmpDownloadDir"/"$modName".download

  gum spin --title "Extracting" -a right --spinner "line" -- 7z x "$tmpDownloadDir"/"$modName".download -o"$tmpDownloadDir"
  rm "$tmpDownloadDir"/*.download

  if [[ $os != "🤖 Android" ]]; then
    modFix "$tmpDownloadDir" "$mainName" "$modName" "$backupFile"
  fi
  backupDir
  installMod "$tmpDownloadDir" "$mainName" "$modName"
}

function modFix() {
  local downloadPath="$1"
  local mainName="$2"
  local modName="$3"
  local backupFile="$4"
  local tmpJson=$(mktemp --suffix=.json)

  if [[ "$modName" != *"addon"* ]]; then
    checkRestore "$backupFile" "$mainName"
  fi

  if [ -d "$downloadPath/data" ]; then
    mv "$downloadPath/data" "$downloadPath/Data"
  elif [ ! -d "$downloadPath/Data" ]; then
    mkdir -p "$downloadPath/Data"
    mv "$downloadPath"/* "$downloadPath"/Data 2>/dev/null
  fi
  rm "$downloadPath"/Data/*.command "$downloadPath"/Data/*.exe "$downloadPath"/Data/*.bat "$downloadPath"/Data/*.txt 2>/dev/null

  if [[ "$modName" != *"addon"* ]]; then
    find "$downloadPath"/Data/ -type f | sed 's|.*\(Data/.*\)|\1|' | jq -R . | jq -s --arg mainName "$mainName" --slurpfile backup "$backupFile" '. as $files | ($backup[0] | map(if .name == $mainName then .backupFiles = $files else . end))' > "$tmpJson" && mv "$tmpJson" "$backupFile"
  fi
}
