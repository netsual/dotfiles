# dotfiles

## Contents

- [Windows configuration](windows/install.conf.yaml) and
  [PowerShell profile](windows/winget/tools/Microsoft.PowerShell/profile.ps1)
- [Ubuntu configuration](ubuntu/install.conf.yaml) and
  [Zsh profile](ubuntu/apt/tools/zsh/.zshrc)
- [Shared package installer](install-packages.py)
- [Wallpapers](wallpaper/)
- [Dotbot](dotbot/) (pinned official submodule)

## Requirements

- Git and a working `python3` command running Python 3.10+ on both platforms
  (a Windows Microsoft Store execution alias is not an installed interpreter)
- Windows: winget, PowerShell 7.2+, and Developer Mode or administrator privileges
  for symlinks
- Ubuntu: apt, sudo access, and the universe repository already enabled
- Optional profile shortcuts use `kubectl` and `code`; they are not installed here

## Install

```sh
git clone --recurse-submodules https://github.com/netsual/dotfiles.git
cd dotfiles
```

Windows: `./install.ps1` from PowerShell. Linux: `./install`.
The Linux launcher selects `<distribution ID>/install.conf.yaml` from
`/etc/os-release`; currently only the Ubuntu and Windows manifests are supplied.

Packages are installed before native configuration links are created. Package
failures warn and continue with the next tool; configuration links still run.
apt updates once per manager and installs tools individually. winget installs
interactively without upgrading existing packages or automatically accepting
agreements; an already-installed result may produce a warning.

Existing conflicting files and links are not overwritten. For a checkout using
the old `powershell/profile.ps1` or `zsh/.zshrc` paths, verify the live link's exact
target and preserve any local content before removing only the obsolete symlink
and rerunning the appropriate installer. Linux/WSL links need this check separately.
No default shell changes or repository enablement are performed.

## Adding a tool

Create `<platform>/<manager>/tools/<package ID>/README.md`, using the Linux
`os-release` ID or `windows` for the platform and the actual native package ID
for the tool folder. Keep any native configuration in the same folder and add
its destination explicitly under `link` in that platform's manifest.

The shared script reads only immediate, visible directories, ignoring symlinks
and nested contents. Manager directories select the installation command:
`apt` and `winget` are supported; another manager needs an explicit command case
in `install-packages.py`. No additional package list is needed.
