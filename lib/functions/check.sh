function backupDir() {
  case "$os" in
    "Android")
      androidCheck
      if adb shell "[ ! -d \"$wotbBackup\" ]"; then
        adb shell mkdir "$wotbBackup"
      fi
      ;;
    *)
      if [ ! -d "$wotbBackup" ]; then
        mkdir -p "$wotbBackup/backup-files" 
      fi
      ;;
  esac
}

function androidCheck() {
  output=$(adb devices | sed '1d' | tr -d '\r')
  if [[ -z "$output" ]]; then
    waitForDevice
  fi
}

function waitForDevice() {
  while true; do
    i=3
    gum spin -s "line" --title "No devices detected, scanning" -- sleep $i
    devices=$(adb devices | sed '1d' | grep -w "device")
    if [[ -n "$devices" ]]; then
      echo -e "✅ Device detected\n"
      break
    fi
  done
}

function userCheck() {
  if [ ! -s /opt/RickWotbMods/lib/env/user.env ]; then
    userInfo
  elif [[ "$os" == "Android" ]]; then
    if gum confirm "Your system is set to $os, Do you want to change?"; then
      userInfo
    fi
  fi
}

function checkBackupFile() {
  local modFile="$1"
  local backupFile="$2"
  local tmpIn=$(mktemp --suffix=.json)
  local tmpOut=$(mktemp --suffix=.json)

  if [[ -f "$backupFile" ]]; then
    mod_count=$(jq '[.[] | select(has("name"))] | length' "$modFile")
    backup_count=$(jq '[.[] | select(has("name"))] | length' "$backupFile")

    if (( mod_count > backup_count )); then
      jq 'map({name: .name, backupFiles: []})' "$modFile" > "$tmpIn"

      jq -s 'add | unique_by(.name)' "$backupFile" "$tmpIn" > "$tmpOut"
      mv "$tmpOut" "$backupFile"
    fi
  else
    jq 'map({name: .name, backupFiles: []})' "$modFile" > "$backupFile"
  fi
}

function checkRestore() {
  local backupFile="$1"
  local mainName="$2"

  if ! jq --arg mainName "$mainName" -e '.[] | select(.name == $mainName and .backupFiles and (.backupFiles | length > 0))' "$backupFile" > /dev/null; then
    [[ "$backupFile" == "$wotbBackup/backup-files/Hangars.json" || "$backupFile" == "$wotbBackup/backup-files/Sights.json" ]] && restore "" "$backupFile"
    return
  fi

  restore "$mainName" "$backupFile"
}

function checkLogs() {
  if grep -qF "$noLogs" "$tmpLogs"; then
    >"$tmpLogs"
  fi
}

function checkPreview() {
  if grep -qF "$noPreview" "$tmpPreview"; then
    >"$tmpPreview"
  fi
}
