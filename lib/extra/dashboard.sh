function printDashboard() {
  clear
  formattedTitle=$(echo -e "${BOL}${ORANGE}Rick mod loader${NC}")
  formattedDevice=$(echo -e "${ITAL}${GRAY}Platform: $os${NC}")
  formattedUpdate=$(echo -e "${ITAL}${GRAY}$checkUpdate${NC}")
  formattedLogs=$(echo -e "📜 ${BOL}${ORANGE}Install and Restore logs${NC}")
  formattedLinks=$(echo -e "🔗 ${BOL}${ORANGE}My links${NC}")
  formattedPreview=$(echo -e "🖼️ ${BOL}${ORANGE}Mod(s) preview${NC}\n\n${ITAL}${GRAY}💡 (ctrl or super + clik) 💡${NC}")

  mainFrame=$(gum style --align center --width="34" --border rounded "$(echo -e "$formattedTitle\n\n$formattedDevice\n\n$formattedUpdate")")
  linksFrame=$(gum style --align center --width="34" --border rounded "$(echo -e "$formattedLinks\n\n$(printf "🪙 \e]8;;https://paypal.me/thatmfrick\a${SOFT_BLUE}Donate via Paypal${NC}\e]8;;\a\n\n📦 \e]8;;https://github.com/RickOnGit/RickWotbMods\a${SOFT_BLUE}GitHub Repo${NC}\e]8;;\a\n")")")

  logsFrame=$(gum style --align center --width="34" --border rounded "$(echo -e "$formattedLogs\n\n$(cat $tmpLogs)")")
  previewFrame=$(gum style --align center --width="34" --border rounded "$(echo -e "$formattedPreview\n\n$(cat $tmpPreview)")")
  dashboardFrame=$(gum join --horizontal "$mainFrame" "$linksFrame")
  infoFrame=$(gum join --horizontal "$previewFrame" "$logsFrame")

  gum join --vertical --align center "$dashboardFrame" "$infoFrame"
}

function printNoLogs() {
  echo -e "$noLogs" >$tmpLogs
}

function printNoPreview() {
  echo -e "$noPreview" >$tmpPreview
}
