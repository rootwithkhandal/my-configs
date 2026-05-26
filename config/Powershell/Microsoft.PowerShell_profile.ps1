# Starship
$ENV:STARSHIP_CONFIG = "C:\Users\xphantom\Documents\WindowsPowerShell\starship.toml"


if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# mise
$env:MISE_PWSH_CHPWD_WARNING = 0

if (Get-Command mise -ErrorAction SilentlyContinue) {
    (&mise activate pwsh) | Out-String | Invoke-Expression
}

# oh-my-posh
$ENV:POSH_THEMES_PATH = "C:\Users\xphantom\Documents\WindowsPowerShell"
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jblab_2021.omp.json" | Invoke-Expression

# modules
Import-Module Terminal-Icons
Import-Module posh-git
# Import-Module PSFzf
# Import-Module z

# Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# choco
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


# Useful aliases
Set-Alias -Name ll    -Value Get-ChildItem
Set-Alias -Name grep  -Value Select-String
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
function mkcd($path)  { New-Item -ItemType Directory $path; Set-Location $path }
function touch($file) { New-Item -ItemType File $file }

# Quick navigation
function dev  { Set-Location C:\Dev }
function ~    { Set-Location $HOME  }

# Git shortcuts
function gs  { git status }
function ga  { git add . }
function gc  { param($msg) git commit -m $msg }
function gp  { git push }
function gpl { git pull }
function gl  { git log --oneline --graph --decorate -15 }

# Open current folder in VS Code
function c.  { code . }
if ($env:TERM_PROGRAM -eq "kiro") { . "$(kiro --locate-shell-integration-path pwsh)" }