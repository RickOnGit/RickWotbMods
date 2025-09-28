function mainMenu() {
  while :; do
    printDashboard
    eval "ans=\$(echo -e \"$mainMenu\" | gum choose --header \"Select what to do 👇\" $gum_choose_prompt)"

    case "$ans" in
    "🧩 Install mods" | "🔍 Mods preview" | "♻️ Restore items") modMenu "$ans" ;;
    "💥 Restore all") restoreGame ;;
    "🔄 Change platform") userInfo ;;
    "🧹 Clear logs") printNoLogs ;;
    "🧹 Clear preview") printNoPreview ;;
    "🗑️ Clear backup folder") rm -rf "$wotbBackup" ;;
    "❌ Quit") clear && break ;;
    esac
  done
}

function modMenu() {
  local x="$1"

  case "$x" in
  "🧩 Install mods") fun="selectorMods" ;;
  "🔍 Mods preview") fun="modPreview" ;;
  "♻️ Restore items")
    if [[ "$os" != "🤖 Android" ]]; then
      fun="restoreItems"
    else
      echo -e "This feature is not supported yet on Android\n"
      return 1
    fi
    ;;
  esac

  eval "ans=\$(echo -e \"$modMenu\" | gum choose --header \"Select a category 📋\" $gum_choose_prompt)"

  case "$ans" in
  "🛡️ Tanks") $fun "$tanksFile" "$tankFilters" ;;
  "🔊 Sounds") $fun "$soundsFile" ;;
  "🏰 Hangars") $fun "$hangarsFile" "$hangarFilters" ;;
  "🎨 UI") $fun "$uiFile" "$uiFilters" ;;
  "🗺️ Maps") $fun "$mapsFile" ;;
  "🎯 Sights") $fun "$sightsFile" ;;
  esac
}
