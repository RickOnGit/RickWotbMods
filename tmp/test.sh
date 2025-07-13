#!/usr/bin/env bash

tanks=$(jq -r '.Tanks[] | .name as $tankName | .mods[]?.name as $modName | "\($tankName), \($modName)"' ../config/tanks.json)
echo "$tanks" >tankList.txt

selectedTanks=$(cat tankList.txt | gum filter --no-limit --height=10)

list=$(gum style --padding "1 5" --border double --border-foreground 212 "$(echo "$selectedTanks")")

echo "$list"
