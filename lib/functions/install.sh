function installMod() {
  local sourceDir="$1"
  local mainName="$2"
  local modName="$3"
  local tmpBackupDir=$(mktemp -d)

  checkLogs

  case "$os" in
    "Android")
      gum spin -s "line" --title "Installing" -- bash -c "adb push \"$sourceDir/net.wargaming.wot.blitz/files/\" \"$wotbData/\""
      if [[ "$modName" != "$mainName" ]]; then
        echo -e "${ITAL}${GREEN}$modName${NC} installed for ${BOL}${ORANGE}$mainName${NC}\n" >>$tmpLogs
      else
        echo -e "${ITAL}${GREEN}$modName${NC} installed\n" >>$tmpLogs
      fi
      ;;
    *)
      gum spin -s "line" -a "right" --title "Installing" -- rsync -a --backup --backup-dir="$tmpBackupDir" "$sourceDir/Data" "$wotbData"
      gum spin -s "line" -a "right" --title "Doing a file backup" -- rsync -au "$tmpBackupDir/Data" "$wotbBackup"
      rm -rf "$tmpBackupDir"
      if [[ "$modName" != "$mainName" ]]; then
        echo -e "${ITAL}${GREEN}$modName${NC} installed for ${BOL}${ORANGE}$mainName${NC}\n" >>$tmpLogs
      else
        echo -e "${ITAL}${GREEN}$modName${NC} installed\n" >>$tmpLogs
      fi
      echo "✅ Done"
      ;;
  esac
}
