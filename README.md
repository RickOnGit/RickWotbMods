# Welcome to my Wotb modding script

- A "simple" tui script written in bash for installing and backing-up tons of mods quickly and with 0 effort.

# Compatibility (Steam only):

- Linux ✅
- Android 🔜
- Macs 🔜
- Windows ❌ (never)

# Dependencies

- Gum Charm (https://github.com/charmbracelet/gum)
- rsync (https://github.com/RsyncProject/rsync)
- 7z (https://www.7-zip.org/download.html)
- jq (https://jqlang.org/)

NOTE: _Those dependencies are necessary for using the script_

# Installation

1. Clone the repository (in home)
2. From the terminal run: `cd RickWotbMods/bin; ./setup.sh`
   - setup.sh will create the backup folder, and add the main script (_rickmooder_) to `/usr/local/bin`
3. Just run `rickmodder` anywhere in the shell and start downloading mods !!.

# Usage

- As said before the script aims to install mods with 0 effort and this was also possible tanks to gum charm, here there are some examples:
- Main menu: ![[config/pictures/main-menu.png]]
- Install and restore option (working only for tanks and hangars for now)
  ![[config/pictures/install-restore.png]]
- Download menu
  ![[config/pictures/tank-menu_ex.png]]
- Downloading information
  ![[config/pictures/download-info.png]]
- Restore menu
  ![[config/pictures/restore.png]]

# P.S.

- You may notice that some mods and features aren't implemented yet but there is time for that... just show support for the project and I will do my best to implement those 👍
