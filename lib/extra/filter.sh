function filter() {
  local filterMenu="$1"
  local file="$2"
  eval "ans=\$(echo -e \"$filterMenu\"| gum choose --header \"Choose a filter criteria\" $gum_choose_prompt)"
  case $ans in
    "Nation") tankFilter "${ans,,}" "$nations" ;;
    "Tier") tankFilter "${ans,,}" "$tiers" ;;
    "Class") tankFilter "${ans,,}" "$classes" ;;
    *) selected="$ans"; ans="type" ;;
  esac

  jq -r --arg filterBy "${ans,,}" --arg selected "$selected" --arg client "$client" '.[] | select(.[$filterBy] == $selected)| .name as $mainName | .mods[]? | select(has($client)) | "\($mainName): \(.name)"' "$file" >"$tmpFilter"
  cat "$tmpFilter" >"$tmpDownload"
}

function tankFilter() {
  local filterBy="$1"
  local type="$2"
  eval "selected=\$(echo -e \"$type\" | gum choose --header \"Choose a \$filterBy\" $gum_choose_prompt)"
}
