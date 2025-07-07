#!/usr/bin/env bash

function load() {
  set -a

  for file in lib/env/*.env; do
    [[ -f "$file" ]] && source "$file"
  done

  for file in lib/functions/*.sh; do
    [[ -f "$file" ]] && source "$file"
  done

  for file in lib/extra/*.sh; do
    [[ -f "$file" ]] && source "$file"
  done

  set +a
}

load
update
userCheck
mainMenu
