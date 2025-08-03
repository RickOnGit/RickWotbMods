function update() {
  cd /opt/RickWotbMods/

  gum spin -s "pulse" --spinner.foreground="208" --title "Checking for updates..." --title.foreground="245" -- git fetch

  if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    gum spin -s "pulse" --title "Updating..." --spinner.foreground="208" --title.foreground="245" -- git pull
    checkUpdate="✅ Updated on $(date +"%d/%m/%Y %H:%M")"
  else
    checkUpdate="❌ No updates on $(date +"%d/%m/%Y %H:%M")"
  fi
  cd "$HOME"
}
