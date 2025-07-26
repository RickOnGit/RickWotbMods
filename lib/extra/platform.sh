function userInfo() {
  set -e
  eval "ans1=\$(echo -e \"$system\" | gum choose --header \"Select your OS 💻\" $gum_choose_prompt)"
  eval "ans2=\$(echo -e \"$clients\" | gum choose --header \"Select your client 👤\" $gum_choose_prompt)"

  if [[ -n "$ans1" && -n "$ans2" ]]; then
    echo "os=$ans1" >$userFile
  else
    echo "Error no platform info provided, Quitting"
    exit 1
  fi

  case "$ans1" in
  "Android")
    if [[ "$ans2" == "WG" ]]; then
      echo -e "$Android_WG" >>$userFile
    fi
    ;;
  "Linux")
    if [[ "$ans2" == "WG" ]]; then
      echo -e "$Linux_WG" >>$userFile
    fi
    ;;
  "MacOs")
    if [[ "$ans2" == "WG" ]]; then
      echo -e "$MacOs_WG" >>$userFile
    fi
    ;;
  esac

  source $userFile
  set +e
}
