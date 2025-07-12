function installer() {
  local source_dir="$1"
  local model="$2"
  local backup_dir=$(mktemp -d)

  gum spin -s "minidot" --title "Installing $model..." -- rsync -a --backup --backup-dir="$backup_dir" "$source_dir/Data/" "$wotbData"
  gum spin -s "minidot" --title "Backing up..." -- rsync -au "$backup_dir/" "$wotbBackup"
  rm -rf "$backup_dir"
  gum format -t emoji "$modName installed :white_check_mark:"
}
