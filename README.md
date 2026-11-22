# dotfiles

## Contents

- [PowerShell profile](powershell/profile.ps1) | prompt, completion and shortcuts
- [Windows configuration](install.windows.conf.yaml) | PowerShell profile symlink
- [Linux configuration](install.conf.yaml)
- [Wallpapers](wallpaper/)
- [Dotbot](dotbot/) | pinned submodule from the official repository

## Requirements

- Git and Python 3.8+ for Dotbot
- Windows symlinks: Developer Mode or administrator privileges
- Profile startup: PowerShell 7.2+ and zoxide
- Optional shortcut tools: fzf, kubectl and code
- Linux profile: Zsh; optional fzf 0.48.0+ and zoxide

## Install

```sh
git clone --recurse-submodules https://github.com/netsual/dotfiles.git
cd dotfiles
```

Windows: `.\install.ps1`
Linux: `./install`