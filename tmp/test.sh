#!/bin/bash

lowerdir="$wgdata"
upperdir="$mywotb"
workdir="$HOME/wotb_mods"
overlay="$wgdata/Data_overlay"

mkdir -p "$upperdir" "$workdir" "$overlay"

sudo mount -t overlay overlay \
    -o lowerdir="$lowerdir",upperdir="$upperdir",workdir="$workdir" \
    "$overlay"
