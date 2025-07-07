#!/usr/bin/env bash

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
  modFix "$temp_dir"
  gum format -t emoji "$modName downloaded & extracted :heavy_check_mark:"
  installer "$temp_dir" "$modName"
  rm -r "$temp_dir"
}
