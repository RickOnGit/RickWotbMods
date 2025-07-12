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

function filter() {
  local file="$1"
  ans=$(echo -e "$filters" | gum choose --header="Filter by")

  case $ans in
  "Nation")
    nation=$(echo -e "$nations" | gum choose --header="Choose a nation")
    selected=$(jq -r --arg nation "$nation" '.Tanks[] | select(.nation == $nation) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some $nation tanks")
    ;;
  "Tier")
    tier=$(echo -e "$tiers" | gum choose --header="Choose a tier")
    selected=$(jq -r --arg tier "$tier" '.Tanks[] | select(.tier == $tier) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some tier $tier tanks")
    ;;
  "Class")
    class=$(echo -e "$classes" | gum choose --header="Choose a class")
    selected=$(jq -r --arg class "$class" '.Tanks[] | select(.class == $class) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some $class tanks")
    ;;
  "All (expect some empty results)")
    nation=$(echo -e "$nations" | gum choose --header="Choose a nation")
    tier=$(echo -e "$tiers" | gum choose --header="Choose a tier")
    class=$(echo -e "$classes" | gum choose --header="Choose a class")
    selected=$(jq -r --arg nation "$nation" --arg class "$class" --arg tier "$tier" '.Tanks[] | select(.nation == $nation and .class == $class and .tier == $tier) | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some tanks")
    ;;
  esac
}

function selectorMods() {
  local file="$1"
  local category="$2"
  declare -A links

  if [[ "$category" == "Tanks" ]]; then
    filter "$file"
  else
    selected=$(jq -r --arg category "$category" '.[$category][] | .name as $element | .mods[] | .name as $modName | "\($element), \($modName)"' "$file" | gum choose --ordered --no-limit --header "Select some mods")
  fi

  if [ -n "$selected" ]; then
    while IFS=',' read -r element modName; do
      element=$(echo "$element" | xargs)
      modName=$(echo "$modName" | xargs)
      link=$(jq -r --arg category "$category" --arg element "$element" --arg modName "$modName" --arg downloadLink "$client" '.[$category][] | select(.name == $element) | .mods[] | select(.name == $modName) | .[$downloadLink]' "$file")
      links["$element,$modName"]="$link"
    done <<<"$selected"
    downloader
  else
    return
  fi
}
