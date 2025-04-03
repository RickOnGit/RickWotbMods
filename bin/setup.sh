#!/usr/bin/env bash

source RickWotbMods/lib/game.env

mkdir -p "$wotbBackup"

shell=$(gum choose ".bashrc\n.zshrc")

echo "alias rickmodder='/usr/local/bin/RickWotbMods/bin/rickmodder'" >> $HOME/"$shell"
