#!/usr/bin/env bash

source /opt/RickWotbMods/lib/env/game.env
source /opt/RickWotbMods/lib/env/user.env
source /opt/RickWotbMods/lib/functions/functions.sh

while true; do
  ans=$(echo -e "$menu" | gum choose --header "Select a category to mod 👇")
 
  case "$ans" in
    "Tanks")
      if gum confirm "Choose what to do:" --affirmative "Install mods" --negative "Restore original files"; then
        selectorMods "$tanksFile" "$ans"
      else
        selectorOriginal "$tanksFile" "$ans" "$wotbTanksBackup" "$wotbTanksData"
      fi
      ;;
    "Sounds")
      selectorMods "$soundsFile" "$ans"
      ;;
    "Hangars")
      if gum confirm "Choose what to do:" --affirmative "Install mods" --negative "Restore original files"; then
        selectorMods "$hangarsFile" "$ans"
      else
        rsync -a "$wotbHangarsBackup" "$wotbHangarsData"
        gum format -t emoji "Hangar's original files applied :heavy_check_mark:"
      fi
      ;;
    "UI")
      selectorMods "$uiFile" "$ans"
      ;;
    "Quit")
      clear; break
      ;;
    "Maps")
      selectorMods "$mapsFile" "$ans"
      ;;
  esac
done
