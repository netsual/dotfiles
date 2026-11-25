# PowerShell

A shell and scripting language with an object-based pipeline. `profile.ps1`
configures the prompt, history, completion and shortcuts for PowerShell 7.2+.

When `fzf` is available, **Ctrl+R** searches PSReadLine's currently loaded history,
newest first. Selecting a command inserts it for editing without executing it;
Escape cancels without changing the current input.

```powershell
Get-Command Get-ChildItem
Get-Help Get-ChildItem
Get-ChildItem | Where-Object Extension -eq '.ps1'
```
