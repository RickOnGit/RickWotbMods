function installer() {
  local sourceDir="$1"
  local model="$2"

  case "$os" in
  "Android")
    # gum spin -s "pulse" --spinner.foreground="208" --title "Doing a file backup..." --title.foreground="245" -- bash -c "adb pull \"$wotbData\" \"$backupDir\""
    gum spin -s "pulse" --spinner.foreground="208" --title "Installing..." --title.foreground="245" -- bash -c "adb push \"$sourceDir/net.wargaming.wot.blitz/files/\" \"$wotbData/\""
    # gum spin -s "pulse" --spinner.foreground="208" --title "Copying backup to device..." --title.foreground="245" -- bash -c "adb push \"$backupDir/\" \"$wotbBackup\""
    # rm -rf "$backupDir"
    echo -e "${BOL}${ORANGE}$model${NC} installed ✅\n"
    ;;
  *)
    gum spin -s "pulse" --spinner.foreground="208" --title "Installing..." --title.foreground="245" -- rsync -a --backup --backup-dir="$backupDir" "$sourceDir/Data/" "$wotbData"
    gum spin -s "pulse" --spinner.foreground="208" --title "Doing a file backup..." --title.foreground="245" -- rsync -au "$backupDir/" "$wotbBackup"
    rm -rf "$backupDir"
    echo -e "${BOL}${ORANGE}$model${NC} installed ✅\n"
    ;;
  esac

}
