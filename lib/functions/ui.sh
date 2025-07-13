function modMenu() {
  ans=$(echo -e "$modMenu" | gum choose --header "Select a category to mod 👇")

  case "$ans" in
  "Tanks")
    selectorMods "$tanksFile" "$ans"
    ;;
  "Sounds")
    selectorMods "$soundsFile" "$ans"
    ;;
  "Hangars")
    selectorMods "$hangarsFile" "$ans"
    ;;
  "UI")
    selectorMods "$uiFile" "$ans"
    ;;
  "Maps")
    selectorMods "$mapsFile" "$ans"
    ;;
  "Sights")
    selectorMods "$sightsFile" "$ans"
    ;;
  esac
}

function mainMenu() {
  while true; do
    ans=$(echo -e "$mainMenu" | gum choose --header "Select what to do 👇")

    case "$ans" in
    "Install mods")
      modMenu
      ;;
    "Restore items")
      restoreMenu
      ;;
    "Restore all")
      restoreGame
      ;;
    "Change platform")
      userInfo
      ;;
    "Quit")
      clear
      break
      ;;
    esac
  done
}

function restoreMenu() {
  ans=$(echo -e "$modMenu" | gum choose --header "Select a category to restore 👇")

  case "$ans" in
  "Tanks")
    restoreItems "$tanksFile" "$ans"
    ;;
  "Sounds")
    restoreItems "$soundsFile" "$ans"
    ;;
  "Hangars")
    restoreItems "$hangarsFile" "$ans"
    ;;
  "UI")
    restoreItems "$uiFile" "$ans"
    ;;
  "Maps")
    restoreItems "$mapsFile" "$ans"
    ;;
  "Sights")
    restoreItems "$sightsFile" "$ans"
    ;;
  esac
}
