function mainMenu() {
  while :; do
    printDashboard
    menuOpts=$(echo -e "$mainMenu" | gum choose --header "Select what to do 👇")

    case "$menuOpts" in
      "Install mods")
        selectType
        modDownload "$modsfile" "$backupfile"
        ;;
      "Mods preview")
        selectType
        modPreview "$modsfile"
        ;;
      "Restore items")
        selectType
        modRestore "$modsfile" "$backupfile"
        ;;
      "Restore all") restoreGame ;;
      "Change platform") userInfo ;;
      "Packs folder fix") packFix ;;
      "Clear logs") printNoLogs ;;
      "Clear preview") printNoPreview ;;
      "Clear backup folder") rm -rf "$wotbBackup" "$wotbBackupFiles";;
      "Quit") clear && break ;;
    esac
  done
}

function selectType() {
  ans=$(echo -e "$modMenu" | gum choose --header "Select a category 📋")
  backupfile="$wotbBackup/backup-files/${ans}.json"
  modsfile="$wotbMods/${ans}.json"
}
