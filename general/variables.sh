export WGDATA="$HOME/.local/share/Steam/steamapps/common/World of Tanks Blitz/Data"
export OG_DATA="$HOME/MY-WOTB-DATA/OG-DATA/Data"
export MOD_DATA="$HOME/MY-WOTB-DATA/MOD-DATA/Data"

export TANKS="$HOME/MY-WOTB-DATA/MODS/TANKS"
export MAPS="$HOME/MY-WOTB-DATA/MODS/MAPS"
export HANGARS="$HOME/MY-WOTB-DATA/MODS/HANGARS"
export SOUNDS="$HOME/MY-WOTB-DATA/MODS/SOUNDS"
export SIGHTS="$HOME/MY-WOTB-DATA/MODS/SIGHTS"
export LOBBY="$HOME/MY-WOTB-DATA/MODS/LOBBY"
export BATTLEUI="$HOME/MY-WOTB-DATA/MODS/BATTLE-UI"

export tanksfile="$HOME/RickWotbMods/files/tanks.csv"
export mapsfile="$HOME/RickWotbMods/files/maps.csv"
export hangarsfile="$HOME/RickWotbMods/files/hangars.csv"
export sightsfile="$HOME/RickWotbMods/files/mods/sights.csv"
export soundsfile="$HOME/RickWotbMods/files/mods/sounds.csv"
export lobbyfile="$HOME/RickWotbMods/files/mods/lobby.csv"
export battleuifile="$HOME/RickWotbMods/files/mods/battle-ui.csv"

welcome() {
    clear
    local variable="$1"
    echo -e "$(gum style --foreground="#ffffff" --border="rounded" --border-foreground="#ffcc00" --align="center" --height=3 --width=40 --margin="1 1" --padding="1 2" --bold "$variable")"
}