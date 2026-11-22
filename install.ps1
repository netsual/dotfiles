# Run Dotbot using the Windows configuration and an existing Python 3.
$ErrorActionPreference = 'Stop'

$Config = 'windows/install.conf.yaml'
$DotbotDir = 'dotbot'
$BaseDir = $PSScriptRoot
$DotbotBin = Join-Path $BaseDir 'dotbot/bin/dotbot'

Set-Location -LiteralPath $BaseDir

git -C $DotbotDir submodule sync --quiet --recursive
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

git submodule update --init --recursive $DotbotDir
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& python3 $DotbotBin --exit-on-failure -d $BaseDir -c $Config @args
exit $LASTEXITCODE
