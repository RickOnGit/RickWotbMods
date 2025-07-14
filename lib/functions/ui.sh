function mainMenu() {
  while true; do
    ans=$(echo -e "$mainMenu" | gum choose --header "Select what to do 👇")

    case "$ans" in
    "Install mods" | "Mods preview" | "Restore items")
      modMenu "$ans"
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

function modMenu() {
  local x="$1"

  if [[ "$x" == "Install mods" ]]; then
    fun="selectorMods"
  elif [[ "$x" == "Mods preview" ]]; then
    fun="modPreview"
  elif [[ "$x" == "Restore items" ]]; then
    fun="restoreItems"
  fi

  ans=$(echo -e "$modMenu" | gum choose --header "Select a category 👇")

  case "$ans" in
  "Tanks")
    $fun "$tanksFile" "$ans"
    ;;
  "Sounds")
    $fun "$soundsFile" "$ans"
    ;;
  "Hangars")
    $fun "$hangarsFile" "$ans"
    ;;
  "UI")
    $fun "$uiFile" "$ans"
    ;;
  "Maps")
    $fun "$mapsFile" "$ans"
    ;;
  "Sights")
    $fun "$sightsFile" "$ans"
    ;;
  esac
}
