#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  BASH_PATH="/usr/bin/bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  BASH_PATH="/opt/homebrew/bin/bash"
else
  echo "Unsupported OS"
  exit 1
fi

touch ~/RickWotbMods/bin/rickmodder

echo "#!$BASH_PATH" >~/RickWotbMods/bin/rickmodder
echo "/opt/RickWotbMods/bin/main.sh" >>~/RickWotbMods/bin/rickmodder

chmod +x ~/RickWotbMods/bin/rickmodder

sudo mkdir -p /usr/local/bin

sudo cp ~/RickWotbMods/bin/rickmodder /usr/local/bin

sudo mv ~/RickWotbMods /opt 2>/dev/null
