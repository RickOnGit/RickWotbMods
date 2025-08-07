function installer() {
  local sourceDir="$1"
  local model="$2"
  local mainName="$3"

  checkLogs

  case "$os" in
  "🤖 Android")
    # gum spin -s "pulse" --spinner.foreground="208" --title "Doing a file backup..." --title.foreground="245" -- bash -c "adb pull \"$wotbData\" \"$tmpBackupDir\""
    gum spin -s "pulse" --spinner.foreground="208" --title "Installing..." --title.foreground="245" -- bash -c "adb push \"$sourceDir/net.wargaming.wot.blitz/files/\" \"$wotbData/\""
    # gum spin -s "pulse" --spinner.foreground="208" --title "Copying backup to device..." --title.foreground="245" -- bash -c "adb push \"$tmpBackupDir/\" \"$wotbBackup\""
    # rm -rf "$tmpBackupDir"
    echo -e "📥 ${BOL}${GREEN}$model${NC} installed for ${BOL}${ORANGE}$mainName${NC}\n" >>$tmpLogs
    ;;
  *)
    gum spin -s "pulse" --spinner.foreground="208" --title "Installing..." --title.foreground="245" -- rsync -a --backup --backup-dir="$tmpBackupDir" "$sourceDir/Data/" "$wotbData"
    gum spin -s "pulse" --spinner.foreground="208" --title "Doing a file backup..." --title.foreground="245" -- rsync -au "$tmpBackupDir/" "$wotbBackup"
    rm -rf "$tmpBackupDir"
    echo -e "${ITAL}${GREEN}$model${NC} installed for ${BOL}${ORANGE}$mainName${NC}\n" >>$tmpLogs
    ;;
  esac

}
