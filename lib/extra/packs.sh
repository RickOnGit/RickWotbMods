function packFix() {
  gum spin --spinner "line" -a "right" --title "Merging files" -- rsync -a --remove-source-files --exclude='dvpl_file_info_cache.txt' --exclude='local*' --exclude='.directory' "$wotbPacks/packs/" "$wotbData/Data/"
  find "$wotbPacks/packs" -type d -empty -delete
}
