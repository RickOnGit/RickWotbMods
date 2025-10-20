function update() {
  cd /opt/RickWotbMods/

  gum spin -s line --title "Checking for updates" -a right  -- git fetch

  if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    gum spin -s line --title "Updating" -a right -- git pull
    echo "updateDate=\"$(date +%d/%m/%Y)\"" >"$updateFile"
    chekUpdate="Just now"
  else
    checkUpdate="Last update: $updateDate"
  fi
  cd "$HOME"
}
