function packs_workaround() {
    
    no_copy=(
        "dvpl_file_info_cache.txt"
        "local_copy_server_file_table.block"
        "local_copy_server_footer.footer"
        "local_copy_server_meta.meta"
    )

    mkdir -p "$mywotb"/temp

    for file in "${no_copy[@]}"; do
        mv "$wgpacks/$file" "$mywotb"/temp
    done

    mv -f "$wgpacks"/* "$wgdata"
    mv -f "$mywotb"/temp/* "$packs/"
    rmdir "$mywotb"/temp
}