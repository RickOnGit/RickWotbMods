#!/usr/bin/env bash

source /opt/RickWotbMods/lib/functions/download.sh

function menu() {
  while true; do
    ans=$(echo -e "$menu" | gum choose --header "Select a category to mod 👇")

    case "$ans" in
      "Tanks")
        installOrRestore "$tanksFile" "$ans" "$wotbTanksBackup" "$wotbTanksData"
        ;;
      "Sounds")
        installOrRestore "$soundsFile" "$ans"
        ;;
      "Hangars")
        installOrRestore "$hangarsFile" "$ans"
        ;;
      "UI")
        installOrRestore "$uiFile" "$ans"
        ;;
      "Maps")
        installOrRestore "$mapsFile" "$ans"
        ;;
      "Sights")
        installOrRestore "$sightsFile" "$ans"
        ;;
      "Quit")
        clear
        break
        ;;
    esac
  done
}

function installOrRestore() {
  local modsFile="$1"
  local category="$2"
  local backupDir="${3:-$wotbBackup}"
  local sourceDir="${4:-$wotbData}"

  if gum confirm "Choose what to do:" --affirmative "Install mods" --negative "Restore original files"; then
    selectorMods "$modsFile" "$category"
  else
    selectorOriginal "$modsFile" "$category" "$backupDir" "$sourceDir"
  fi
}

function filter() {
  local file="$1"
  ans=$(echo -e "$filters" | gum choose --header="Filter by")

  case $ans in
  "Nation")
    nation=$(echo -e "$nations" | gum choose --header="Choose a nation")
    selected=$(jq -r --arg nation "$nation" '.Tanks[] | select(.nation == $nation) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some $nation tanks")
    ;;
  "Tier")
    tier=$(echo -e "$tiers" | gum choose --header="Choose a tier")
    selected=$(jq -r --arg tier "$tier" '.Tanks[] | select(.tier == $tier) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some tier $tier tanks")
    ;;
  "Class")
    class=$(echo -e "$classes" | gum choose --header="Choose a class")
    selected=$(jq -r --arg class "$class" '.Tanks[] | select(.class == $class) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some $class tanks")
    ;;
  esac
}

function selectorMods() {
  local file="$1"
  local category="$2"
  declare -A links

  if [[ "$category" == "Tanks" ]]; then
    filter "$file"
  else
    selected=$(jq -r --arg category "$category" '.[$category][] | .name as $element | .mods[] | .name as $modName | "\($element), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some mods")
  fi

  if [ -n "$selected" ]; then
    while IFS=',' read -r element modName; do
      element=$(echo "$element" | xargs)
      modName=$(echo "$modName" | xargs)
      link=$(jq -r --arg category "$category" --arg element "$element" --arg modName "$modName" --arg downloadLink "$platform" '.[$category][] | select(.name == $element) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$file")
      links["$element,$modName"]="$link"
    done <<<"$selected"
    downloader
  else
    return
  fi
}

function selectorOriginal() {
  local file="$1"
  local category="$2"
  local backupDir="$3"
  local destDir="$4"
  readarray -t ogElems < <(jq -r --arg category "$category" '.[$category][] | .name' "$file" | gum choose --no-limit --header "Select what to restore")

  for elem in "${ogElems[@]}"; do
    readarray -t ogFiles < <(jq -r --arg category "$category" --arg name "$elem" '.[$category][] | select(.name == $name) | .backupItems[]' "$file")

    for fileName in "${ogFiles[@]}"; do
      gum spin -s "minidot" --title "Restoring stock files for $elem..." -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$backupDir" "$destDir"
    done

    gum format -t emoji "$elem's original files applied :heavy_check_mark:"
  done
}
