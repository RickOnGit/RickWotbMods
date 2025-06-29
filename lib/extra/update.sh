#!/usr/bin/env bash

function update() {
  cd /opt/RickWotbMods/

  gum spin -s "minidot" --title "Checking for updates..." -- git fetch

  if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    gum spin -s "minidot" --title "Updating..." -- git pull
    gum format -t emoji "Successfully updated :heavy_check_mark:"
    sleep 1
  else
    gum format -t emoji "Up to date :heavy_check_mark:"
    sleep 1
  fi

  cd "$HOME";
}
