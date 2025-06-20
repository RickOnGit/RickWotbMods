#!/usr/bin/env bash

source /opt/RickWotbMods/lib/env/game.env
source /opt/RickWotbMods/lib/env/user.env
source /opt/RickWotbMods/lib/functions/functions.sh

if [ ! -d "$wotbBackup" ]; then
  mkdir -p "$wotbBackup"
fi

while true; do
  ans=$(echo -e "$menu" | gum choose --header "Select a category to mod 👇")

  case "$ans" in
  "Tanks")
    installOrBackup "$tanksFile" "$ans" "$wotbTanksBackup" "$wotbTanksData"
    ;;
  "Sounds")
    installOrBackup "$soundsFile" "$ans"
    ;;
  "Hangars")
    installOrBackup "$hangarsFile" "$ans"
    ;;
  "UI")
    installOrBackup "$uiFile" "$ans"
    ;;
  "Maps")
    installOrBackup "$mapsFile" "$ans"
    ;;
  "Sights")
    installOrBackup "$sightsFile" "$ans"
    ;;
  "Quit")
    clear
    break
    ;;
  esac
done
