function backupDir() {
  case "$os" in
  "🤖 Android")
    androidCheck
    if adb shell "[ ! -d \"$wotbBackup\" ]"; then
      adb shell mkdir "$wotbBackup"
    fi
    ;;
  *)
    if [ ! -d "$wotbBackup" ]; then
      mkdir -p "$wotbBackup"
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
    gum spin -s "pulse" --spinner.foreground="208" --title "No devices detected, scanning..." --title.foreground="44" -- sleep $i
    devices=$(adb devices | sed '1d' | grep -w "device")
    if [[ -n "$devices" ]]; then
      echo -e "✅ Device detected\n"
      break
    fi
  done
}

function modFix() {
  local path="$1"
  if [ -d "$path/data" ]; then
    mv "$path/data" "$path/Data"
  elif [ ! -d "$path/Data" ]; then
    mkdir -p "$path/Data"
    mv "$path"/* "$path"/Data 2>/dev/null
  fi
  rm "$path"/Data/*.command "$path"/Data/*.exe "$path"/Data/*.bat "$path"/Data/*.txt 2>/dev/null
}

function userCheck() {
  if [ ! -s /opt/RickWotbMods/lib/env/user.env ]; then
    userInfo
  elif [[ "$os" == "🤖 Android" ]]; then
    if gum confirm "Your system is set to $os, Do you want to change?" --prompt.foreground='#3C6A80' --selected.background="208"; then
      userInfo
    fi
  fi
}
