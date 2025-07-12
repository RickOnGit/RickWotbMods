#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  BASH_PATH="/usr/bin/bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  BASH_PATH="/opt/homebrew/bin/bash"
else
  echo "Unsupported OS"
  exit 1
fi

echo "#!$BASH_PATH" >rickmodder
echo "/opt/RickWotbMods/bin/main.sh" >>rickmodder

chmod +x rickmodder

sudo mkdir -p /usr/local/bin

sudo cp rickmodder /usr/local/bin

sudo mv ~/RickWotbMods /opt 2>/dev/null

exit
