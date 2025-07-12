#!/usr/bin/env bash

sudo mv ~/RickWotbMods /opt 2>/dev/null

SCRIPT_DIR="/opt/RickWotbMods/bin"
BASH_PATH="#!/usr/bin/env bash"

cat <<EOF >"$SCRIPT_DIR/rickmodder"
$BASH_PATH
$SCRIPT_DIR/main.sh
EOF

chmod +x "$SCRIPT_DIR/rickmodder"

sudo cp "$SCRIPT_DIR/rickmodder" /usr/local/bin
