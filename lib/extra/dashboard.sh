function printDashboard() {
  clear
  formattedTitle=$(echo -e "${BOL}${ORANGE}Rick mod loader${NC}")
  formattedDevice=$(echo -e "${ITAL}${GRAY}System: $os${NC}")
  formattedUpdate=$(echo -e "${ITAL}${GRAY}$checkUpdate${NC}")
  formattedLogs=$(echo -e "${BOL}${ORANGE}Install/Restore logs${NC}")
  dashboard=$(gum style --align center --border rounded "$(echo -e "$formattedTitle\n\n$formattedDevice\n\n$formattedUpdate")")
  logsFrame=$(gum style --align center --border rounded "$(echo -e "$formattedLogs\n\n$(cat $tmpLogs)")")
  infoFrame=$(gum join --horizontal "$logsFrame" "$previewFrame")
  gum join --vertical --align="center" "$dashboard" "$infoFrame"
}
