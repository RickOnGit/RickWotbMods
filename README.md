# Welcome to my Wotb modding script

- A "simple" tui script written in bash for installing and backing-up tons of mods quickly and with 0 effort.
  > **Notes:**
  >
  > - I'm not the developer of any mods (I will add the sources for each mod).
  > - All mods will be downloaded from:
  >   1. [BlitzMods](https://blitz-mods.com)
  >   2. [ForBlitz](https://forblitz.ru)
  >   3. My Google Drive (for now) for old or Discord servers mods (always with a link).

# Compatibility (Steam only)

- Linux (installed in `.local/share/Steam/...`) ✅
- Android 🔜
- Macs 🔜
- Windows ❌ (never)

# Dependencies

## Must have

- [Gum Charm](https://github.com/charmbracelet/gum)
- [rsync](https://github.com/RsyncProject/rsync)
- [7z](https://www.7-zip.org/download.html)
- [jq](https://jqlang.org/)

## Optional

- [Tmux](https://github.com/tmux/tmux)

# Installation

1. Clone the repository: `git clone https://github.com/RickOnGit/RickWotbMods ~`
2. From the terminal run: `cd RickWotbMods/bin; ./setup.sh`
   - setup.sh will create the backup folder, and add the main script (_rickmooder_) to `/usr/local/bin`
3. Just run `rickmodder` anywhere in the shell and start downloading mods !!.

# Usage

- Main menu ![Main menu](./doc//pictures/main-menu.png)

- Install and restore option (working only for tanks and hangars for now) ![Install and restore](./doc/pictures/install-restore.png)

- Download menu ![Download menu](./doc/pictures/tank-menu_ex.png)

- Downloading information ![Downloading info](./doc/pictures/download-info.png)

- Restore menu ![Restore menu](./doc//pictures/restore.png)
- _Wanna do things faster? Use tmux!!_ ![Tmux example](./doc/pictures/tmux-example.png)

# P.S.

- You may notice that some mods and features aren't implemented yet but there is time for that... just show support for the project and I will do my best to implement those 👍
