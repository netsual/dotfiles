# dotfiles

## Contents

- [PowerShell profile](powershell/profile.ps1) | prompt, completion and shortcuts
- [Windows configuration](install.windows.conf.yaml) | PowerShell profile symlink
- [Ubuntu configuration](install.conf.yaml)
- [Wallpapers](wallpaper/)
- [Dotbot](dotbot/) | pinned submodule from the official repository

## Requirements

- Git and Python 3.8+ for Dotbot
- Windows symlinks: Developer Mode or administrator privileges
- Profile startup: PowerShell 7.2+ and zoxide
- Optional shortcut tools: fzf, kubectl and code
- Ubuntu setup: apt, sudo access and the Ubuntu universe repository enabled
- Ubuntu profile: Zsh, fzf and zoxide (installed by `./install`)

## Install

```sh
git clone --recurse-submodules https://github.com/netsual/dotfiles.git
cd dotfiles
```

Windows: `.\install.ps1`
Ubuntu: `./install`

Ubuntu setup installs the declared distribution packages before linking the Zsh profile. Package failures stop setup; existing conflicting files or links are not overwritten. Windows setup still only links the PowerShell profile.

## Adding a tool

Keep native configuration in a tool folder (for example, `nvim/`). For Ubuntu, add its package to the existing package command in `install.conf.yaml` and map its native configuration destination under `link`. For Windows, add configuration links to `install.windows.conf.yaml`; Windows package installation is not automated. Package-only tools need no folder. Use distribution versions by default; changes to Windows packages or tools requiring newer versions need an explicit installation decision.

Check changed YAML and script syntax, then use disposable Dotbot fixtures to verify success, failure stopping before links, reruns and preservation of existing-file conflicts. Verify the package version and tool configuration integration on the actual target platform; Windows fixture checks do not establish Ubuntu runtime compatibility.