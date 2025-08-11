function update() {
  cd /opt/RickWotbMods/

  gum spin -s "pulse" --spinner.foreground="208" --title "Checking for updates..." --title.foreground="245" -- git fetch

  if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    gum spin -s "pulse" --title "Updating..." --spinner.foreground="208" --title.foreground="245" -- git pull
    echo "updateDate=\"$(date +%d/%m/%Y)\"" >"$updateFile"
    chekUpdate="Just now"
  else
    checkUpdate="Last update: $updateDate"
  fi
  cd "$HOME"
}
