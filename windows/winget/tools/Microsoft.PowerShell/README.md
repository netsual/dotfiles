# PowerShell

A shell and scripting language with an object-based pipeline. `profile.ps1`
configures the prompt, history, completion and shortcuts for PowerShell 7.2+.

```powershell
Get-Command Get-ChildItem
Get-Help Get-ChildItem
Get-ChildItem | Where-Object Extension -eq '.ps1'
```
