#!/usr/bin/env bash

function userInfo() {
  ans1=$(echo -e "$system" | gum choose --header="Select your OS")
  echo "os=$ans1" >/opt/RickWotbMods/lib/env/user.env
  ans2=$(echo -e "$clients" | gum choose)
  if [[ "$ans1" == "MacOs" && "$ans2" == "WG" ]]; then
    echo "client=pc_wg" >>/opt/RickWotbMods/lib/env/user.env
    echo "wotbData=\"$HOME/Library/Application Support/Steam/steamapps/common/World of Tanks Blitz/World of Tanks Blitz.app/Contents/Resources/Data/\"" >>/opt/RickWotbMods/lib/env/user.env
    echo "wotbBackup=\"$HOME/Library/Application Support/Steam/steamapps/common/World of Tanks Blitz/World of Tanks Blitz.app/Contents/Resources/Backup/\"" >>/opt/RickWotbMods/lib/env/user.env
  elif [[ "$ans1" == "Linux" && "$ans2" == "WG" ]]; then
    echo "client=pc_wg" >>/opt/RickWotbMods/lib/env/user.env
    echo "wotbData=\"$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data/\"" >>/opt/RickWotbMods/lib/env/user.env
    echo "wotbBackup=\"$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Backup/\"" >>/opt/RickWotbMods/lib/env/user.env
    echo "wotbPacks=\"$HOME/.local/share/Steam/steamapps/compatdata/444200/pfx/drive_c/users/steamuser/AppData/Local/wotblitz/packs/\"" >>/opt/RickWotbMods/lib/env/user.env
  fi
  source /opt/RickWotbMods/lib/env/user.env
}
