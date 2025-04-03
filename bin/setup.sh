#!/usr/bin/env bash

source ../lib/env/game.env

mkdir -p "$wotbBackup"

sudo cp rickmodder /usr/local/bin

sudo mv ~/RickWotbMods /opt 2>/dev/null
exit
