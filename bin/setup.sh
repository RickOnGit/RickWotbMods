#!/usr/bin/env bash

function baseSetup() {
  sudo mkdir -p /usr/local/bin /opt
  sudo mv ~/RickWotbMods /opt 2>/dev/null

  SCRIPT_DIR="/opt/RickWotbMods/bin"
  BASH_PATH="#!/usr/bin/env bash"

  cat <<EOF >"$SCRIPT_DIR/rickmodder"
  $BASH_PATH
  bash "\$SCRIPT_DIR/main.sh"
  EOF

  chmod +x "$SCRIPT_DIR/rickmodder"
  sudo cp "$SCRIPT_DIR/rickmodder" /usr/local/bin
}

function macosSetup() {
  if [ ! -d "/opt/homebrew" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install bash rsync jq gum

  if [ ! -f "$HOME/.zshrc" ]; then
    touch "$HOME/.zshrc"
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >>"$HOME/.zshrc"
    source "$HOME/.zshrc"
  fi
}

baseSetup

if [ "$OSTYPE" != "linux-gnu" ]; then
  macosSetup
fi
