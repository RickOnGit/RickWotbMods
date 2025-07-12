#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  BASH_PATH="/usr/bin/bash"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  BASH_PATH="/opt/homebrew/bin/bash"
else
  echo "Unsupported OS"
  exit 1
fi

sudo mv ~/RickWotbMods /opt 2>/dev/null || true

SCRIPT_DIR="/opt/RickWotbMods/bin"

cat <<EOF >"$SCRIPT_DIR/rickmodder"
#!$BASH_PATH
"$SCRIPT_DIR/main.sh"
EOF

chmod +x "$SCRIPT_DIR/rickmodder"

sudo cp "$SCRIPT_DIR/rickmodder" /usr/local/bin
