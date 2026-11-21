#Requires -Version 7.2

# PSReadLine
if (Import-Module PSReadLine -PassThru -ErrorAction SilentlyContinue) {
    Set-PSReadLineOption -EditMode Windows -PredictionSource History -PredictionViewStyle InlineView -HistoryNoDuplicates -BellStyle None
    Set-PSReadLineOption -Colors @{ InlinePrediction = $PSStyle.Foreground.FromRgb(100, 116, 139) }

    Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function AcceptNextSuggestionWord
}

# fzf
$env:FZF_DEFAULT_OPTS = '--height=45% --layout=reverse --border'

# General
Set-Alias -Name k -Value kubectl

function mkcd {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $Directory = New-Item -ItemType Directory -Path $Path -Force
    Set-Location -LiteralPath $Directory.FullName
}

function Edit-Profile { code $PROFILE }
function ff { fzf '--walker=file,hidden' '--walker-skip=.git,node_modules,bin,obj,.venv' @args }

# Git shortcuts bind subcommands, so they need functions rather than aliases.
function gs { git status --short --branch @args }
function gd { git diff @args }
function gds { git diff --staged @args }

# PowerShell's built-in gl alias otherwise takes precedence over the function.
Remove-Alias -Name gl -Force -ErrorAction SilentlyContinue
function gl { git log --oneline --graph --decorate -15 @args }

# Kubernetes
function kctx { kubectl config current-context }
function kns {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    kubectl config set-context --current "--namespace=$Name"
}

# Prompt
function prompt {
    # Save both statuses before Git runs. Variable names are case-insensitive.
    $LastCommandWasSuccessful = $?
    $SavedExitCode = $global:LASTEXITCODE

    $Colors = @{
        Accent  = $PSStyle.Foreground.FromRgb(94, 234, 212)
        Path    = $PSStyle.Foreground.FromRgb(203, 213, 225)
        Muted   = $PSStyle.Foreground.FromRgb(100, 116, 139)
        Warning = $PSStyle.Foreground.FromRgb(251, 191, 36)
        Error   = $PSStyle.Foreground.FromRgb(248, 113, 113)
        Reset   = $PSStyle.Reset
    }

    # Shorten home without replacing similar path prefixes.
    $Path = $PWD.Path -replace "^$([regex]::Escape($HOME))(?=[\\/]|$)", '~'
    $GitPromptText = ''

    try {
        if ($PWD.Provider.Name -eq 'FileSystem' -and (Get-Command git -ErrorAction Ignore)) {
            $GitStatus = @(git status --porcelain=v2 --branch --show-stash --untracked-files=normal 2>$null)

            if ($LASTEXITCODE -eq 0) {
                $Branch = ''
                $Staged = $Modified = $Untracked = $Conflicts = 0
                $Ahead = $Behind = $Stash = 0

                foreach ($Line in $GitStatus) {
                    if ($Line.StartsWith('# branch.head ')) {
                        $Branch = $Line.Substring(14)
                    }
                    elseif ($Line -match '^# branch\.ab \+(\d+) -(\d+)$') {
                        $Ahead = [int]$Matches[1]
                        $Behind = [int]$Matches[2]
                    }
                    elseif ($Line -match '^# stash (\d+)$') {
                        $Stash = [int]$Matches[1]
                    }
                    elseif ($Line[0] -in '1', '2') {
                        if ($Line[2] -ne '.') {
                            $Staged++
                        }
                        if ($Line[3] -ne '.') {
                            $Modified++
                        }
                    }
                    elseif ($Line[0] -eq 'u') {
                        $Conflicts++
                    }
                    elseif ($Line[0] -eq '?') {
                        $Untracked++
                    }
                }

                $Branch = $Branch -eq '(detached)' ? 'detached' : $Branch
                $GitPromptText = " $($Colors.Muted)· $($Colors.Accent)$Branch$($Colors.Reset)"

                if ($Staged) {
                    $GitPromptText += " $($Colors.Accent)+$Staged"
                }
                if ($Modified) {
                    $GitPromptText += " $($Colors.Warning)~$Modified"
                }
                if ($Untracked) {
                    $GitPromptText += " $($Colors.Muted)?$Untracked"
                }
                if ($Conflicts) {
                    $GitPromptText += " $($Colors.Error)!$Conflicts"
                }
                if ($Ahead) {
                    $GitPromptText += " $($Colors.Muted)↑$Ahead"
                }
                if ($Behind) {
                    $GitPromptText += " $($Colors.Muted)↓$Behind"
                }
                if ($Stash) {
                    $GitPromptText += " $($Colors.Muted)≡$Stash"
                }

                $GitPromptText += $Colors.Reset
            }
        }
    }
    finally {
        $global:LASTEXITCODE = $SavedExitCode
    }

    $IndicatorColor = $LastCommandWasSuccessful ? $Colors.Accent : $Colors.Error
    "$($Colors.Path)$Path$($Colors.Reset)$GitPromptText`n${IndicatorColor}❯$($Colors.Reset) "
}

# Zoxide
if (Get-Command zoxide -ErrorAction Ignore) {
    Invoke-Expression (zoxide init --hook pwd powershell | Out-String)
}
