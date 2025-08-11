<h3 align="center">
  
<img src="https://github.com/user-attachments/assets/41b181dd-c74a-4543-8db5-7db8a9dc0a9f" alt="logo" width="250">

[![github](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RickOnGit/RickWotbMods)
[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/thatmfrick)

![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

</h3>

<p align="center">
  <strong>A powerful CLI for installing, previewing, backing up, and restoring mods for World of Tanks Blitz — with zero hassle.</strong>
</p>



https://github.com/user-attachments/assets/380814ba-6951-4fa1-8cde-93f02ff6ae20



---

## ✨ Features

- ⚒️ Install various mod types — from tank models to UI enhancements
- 👀 Preview mods with links to original sources
- 📁 Auto-backup of game files before every mod install
- ♻️ Restore individual or all game files to stock
- 💻 Multi-platform support: Android, Linux and MacOs
- 🔁 Switch game platform/client info via in-app option (**Steam Wargaming/Android Wargaming only** for now)

---

## 📦 Installation

### 🐧 Linux

> ⚠️ General instructions — adjust for your distro.

Install dependencies:

```bash
sudo <your-package-manager> install jq p7zip-full gum rsync adb # (adb) for installing mods on android
```

> **ℹ️ Note:** Some of the required packages like `jq`, `rsync`, and `7z` may already be installed on your system.  
> You can check by running:
>
> ```bash
> jq --version
> rsync --version
> p7zip-full
> ```

- Before installing check:
  - [Gum](https://github.com/charmbracelet/gum)
  - [7z](https://www.7-zip.org/download.html) _bottom of the page_
  - [jq](https://github.com/jqlang/jq?tab=readme-ov-file)
  - [rsync](https://github.com/RsyncProject/rsync)

### 🍎 MacOs

All required dependencies will be installed automatically via [Homebrew](https://brew.sh/).
If Homebrew isn't already installed, the `setup.sh` script will install it for you with all the relatives dependencies.

> ⚠️ If you have some issues in seeing previews on the mac terminal, download another one like [ghostty](https://ghostty.org/)

### 🤖 Android

To install mods on Android, follow these steps:

1. Install `adb` on Linux.
2. Enable **Developer Options** on your Android device.
3. In the Developer Options menu, enable **USB debugging**.
   - **Important**: disable **any** revoke USB debugging/adb authorization timeout settings.
4. Connect your Android device to the PC, open the terminal, and run `adb devices`.
   - A pop-up will appear on your Android device — press **Trust this device** (your device is now set up).
5. Run `rickmodder` in the terminal and switch the platform to Android.
    - **Remember** to switch platform back to Linux when you have finished modding Android.
  


https://github.com/user-attachments/assets/f8d77724-1912-4de9-a5fd-a9340729179d



### ⚙️ CLI setup (All Platforms)

Clone the repo and run the setup script:

```bash
git clone https://github.com/RickOnGit/RickWotbMods "$HOME/RickWotbMods"
bash "$HOME/RickWotbMods/bin/setup.sh"
```

- The `setup.sh` will:
  - Move the program into `/opt`
  - Create a launcher script `rickmodder` into `/usr/local/bin`
  - Install dependencies (on MacOs)
  - Request `sudo` when needed

<https://github.com/user-attachments/assets/967c282c-495d-4527-99f3-cd9d755d5bcc>

## 🚀 Usage

After installation, launch the CLI with:

```bash
rickmodder
```

Use the interactive menu to browse, preview, install, and restore mods.

## 📝 Notes

- **I'm not the author of the mods**. I only provide this CLI tool and maintain it. When possible, I fix outdated mods for compatibility.
- Due to this it's important to check the current status of each mod via the preview option in the main menu.
- Mods will be downloaded from:
  - [BlitzMods](https://blitz-mods.com/)
  - [ForBlitz](https://forblitz.ru/)
  - Google Drive (for archived or Discord-hosted mods)
- Some mods are not yet included — they’ll be added over time as they are tested.

## 🧩 Coming soon

- 🤖 Android backup/restore
  - apk required mods
- 👀 other features

## 📫 Contributing or Issues?

Found a bug? Want to request a feature or contribute a mod source?
👉 Open an issue or pull request here: [RickWotbLoader](https://github.com/RickOnGit/RickWotbMods)
