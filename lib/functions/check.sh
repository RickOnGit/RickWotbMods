#!/usr/bin/env bash

function backupDir() {
  if [ ! -d "$wotbBackup" ]; then
    mkdir -p "$wotbBackup"
  fi
}

function modFix() {
  local path="$1"
  if [ -d "$path/data" ]; then
    mv "$path/data" "$path/Data"
  elif [ ! -d "$path/Data" ]; then
    mkdir -p "$path/Data"
    mv "$path"/* "$path"/Data 2>/dev/null
  fi
}
