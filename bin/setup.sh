#!/usr/bin/env bash
set -euo pipefail

function baseSetup() {
  sudo mkdir -p /usr/local/bin /opt

  if [ -d "$HOME/RickWotbMods" ] && [ ! -d "/opt/RickWotbMods" ]; then
    sudo mv "$HOME/RickWotbMods" /opt
  fi

  local SCRIPT_DIR="/opt/RickWotbMods/bin"
  sudo chmod +x "$SCRIPT_DIR/rickmodder"
  sudo cp "$SCRIPT_DIR/rickmodder" /usr/local/bin
  echo -e "updateDate=\"Error 404\"" > /opt/RickWotbMods/lib/env/update.env
  echo "Setup finished !! , run rickmodder and start modding the game :)"
}

function macosSetup() {
  if [ ! -d "/opt/homebrew" ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Load Homebrew environment for this session
  eval "$(/opt/homebrew/bin/brew shellenv)"

  brew install bash rsync jq gum
  brew install --cask ghostty

  if [ ! -f "$HOME/.zshrc" ]; then
    touch "$HOME/.zshrc"
  fi

  if ! grep -q 'export PATH="/opt/homebrew/bin:$PATH"' "$HOME/.zshrc"; then
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >>"$HOME/.zshrc"
  fi

  source "$HOME/.zshrc"
}

baseSetup

if [[ "$OSTYPE" == "darwin"* ]]; then
  macosSetup
fi
