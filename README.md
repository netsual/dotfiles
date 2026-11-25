# dotfiles

- [Ubuntu tool docs](ubuntu/apt/tools/)
- [Windows tool docs](windows/winget/tools/)
- [Wallpapers](wallpaper/)

## Install

Requires Git and a working `python3` 3.10+.
Ubuntu: apt, sudo, and universe enabled. Windows: winget, PowerShell 7.2+, and
Developer Mode or administrator privileges for symlinks.

```sh
git clone --recurse-submodules https://github.com/netsual/dotfiles.git
cd dotfiles
```

- Linux : `./install`
- Windows : `.\install.ps1`

## Development

- Add `<platform>/<manager>/tools/<package-id>/README.md` and optional native config; use native package IDs.
- Add configuration links explicitly to the platform's `install.conf.yaml`.
- Check changes on the target platform before pushing.
