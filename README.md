# dotfiles

- [Linux configuration](install.conf.yaml) — `./install`
- [Windows configuration](install.windows.conf.yaml) — `.\install.ps1`
- [PowerShell profile](powershell/profile.ps1) — prompt, completion and shortcuts
- [Wallpapers](wallpaper/)

Uses [Dotbot](https://github.com/anishathalye/dotbot/) with Git and Python 3.8+.
The launchers initialize recursive submodules; cloning with `--recurse-submodules` fetches them upfront.
Windows linking requires permission to create symbolic links (Developer Mode where permitted, or suitable privilege/elevation).

The profile requires PowerShell 7.2+ and zoxide at startup; fzf, kubectl and code are needed only for their respective shortcuts.
Linux configuration remains empty; Windows links to `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`—compare this configured target with `$PROFILE` in your intended PowerShell 7 host before installing, as redirected Documents may differ.
An existing profile deliberately conflicts; reconcile it manually before installing, as Dotbot will not replace it.