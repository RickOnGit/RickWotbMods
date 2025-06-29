#!/usr/bin/env bash

function load() {
  set -a

  for file in "$(dirname "${BASH_SOURCE[0]}")"/*.env; do
    [[ -f "$file" ]] || continue
    source "$file"
  done

  set +a
}
