#!/usr/bin/env bash

function installOrBackup() {
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

function selectorMods() {
  local file="$1"
  local category="$2"
  declare -A links

  selected=$(jq -r --arg category "$category" '.[$category][] | .name as $element | .mods[] | .name as $modName | "\($element), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some mods")
  while IFS=',' read -r element modName; do
    element=$(echo "$element" | xargs)
    modName=$(echo "$modName" | xargs)

    link=$(jq -r --arg category "$category" --arg element "$element" --arg modName "$modName" --arg downloadLink "$platform" '.[$category][] | select(.name == $element) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$file")

    links["$element,$modName"]="$link"
  done <<< "$selected"

  downloader
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
      gum spin -s "minidot" --title "Restoring stock files for $elem..."  -- rsync -a --include="*/" --include="*${fileName}*/" --include="*${fileName}*" --include="${fileName}/**" --exclude="*" "$backupDir" "$destDir"
    done

    gum format -t emoji "$elem's original files applied :heavy_check_mark:"
  done
}

function downloader() {
  for key in "${!links[@]}"; do
    downloadLink="${links[$key]}"
    baseModelName=$(echo "$key" | cut -d',' -f1)
    modName=$(echo "$key" | cut -d',' -f2)
    download "$baseModelName" "$modName" "$downloadLink"
    unset "links[$key]"
  done
}

function download() {
  baseModelName="$1"
  modName="$2"
  downloadLink="$3"
  temp_dir=$(mktemp -d)
  gum spin -s "minidot" --title "Downloading $modName for $baseModelName..." -- curl -L "$downloadLink" -o "$temp_dir"/"$modName".download
  gum spin -s "minidot" --title "Extracting $modName..." -- 7z x "$temp_dir"/"$modName".download -o"$temp_dir"
  rm "$temp_dir"/*.download
  mod_fix "$temp_dir"
  gum format -t emoji "$modName downloaded & extracted :heavy_check_mark:"
  installer "$temp_dir" "$modName"
  rm -r "$temp_dir"
}

function mod_fix() {
  local path="$1"
  if [ ! -d "$path/Data" ]; then
    mkdir -p "$path/Data"
    mv "$path"/* "$path"/Data 2>/dev/null
  fi
}

function installer() {
  local source_dir="$1"
  local model="$2"
  local backup_dir=$(mktemp -d)

  gum spin -s "minidot" --title "Installing $model..." -- rsync -a --backup --backup-dir="$backup_dir" "$source_dir/Data/" "$wotbData"
  gum spin -s "minidot" --title "Backing up..." -- rsync -au "$backup_dir/" "$wotbBackup"
  rm -rf "$backup_dir"
  gum format -t emoji "$modName installed :white_check_mark:"
}
