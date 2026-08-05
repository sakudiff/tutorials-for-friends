<# :
@echo off
setlocal
title R Setup
echo Starting setup...
pushd "%~dp0"
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "IEX (Get-Content '%~f0' -Raw)"
if %errorlevel% neq 0 (
    echo.
    echo [!] Something went wrong during the setup.
)
echo.
echo Setup process finished. Press any key to close this window.
if not defined CI pause
exit /b
#>

# R Setup

$ErrorActionPreference = "Stop"

# Progress Tracking
$TotalSteps = 11
$CurrentStep = 0

function Write-Progress-Bar {
    param ([int]$Current, [int]$Total)
    $width = 30
    $percent = [math]::Floor(($Current / $Total) * 100)
    $filled = [math]::Floor(($width * $Current) / $Total)
    $empty = $width - $filled
    $bar = "#" * $filled + "-" * $empty
    Write-Host "`rProgress: [$bar] $percent% " -NoNewline -ForegroundColor Cyan
    Write-Host ""
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Install-WithWinget {
    param ([string]$Id, [string]$Name)
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[->] Installing $Name..." -ForegroundColor Yellow
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements
    Write-Host "[ok] $Name installed." -ForegroundColor Green
}

# Step 1: Check winget
$script:CurrentStep++
Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { exit 1 }
winget source update

# Step 2: Git
if (Get-Command git -ErrorAction SilentlyContinue) { $script:CurrentStep++ } else { Install-WithWinget "Git.Git" "Git"; Refresh-Path }

# Step 3: GitHub CLI
if (Get-Command gh -ErrorAction SilentlyContinue) { $script:CurrentStep++ } else { Install-WithWinget "GitHub.cli" "GitHub CLI"; Refresh-Path }

# Step 4: GitHub Desktop
Install-WithWinget "GitHub.GitHubDesktop" "GitHub Desktop"

# Step 5: R
if (Get-Command Rscript -ErrorAction SilentlyContinue) { $script:CurrentStep++ } else { Install-WithWinget "RProject.R" "R"; Refresh-Path }

# Step 6: Quarto
if (Get-Command quarto -ErrorAction SilentlyContinue) { $script:CurrentStep++ } else { Install-WithWinget "Quarto.Quarto" "Quarto"; Refresh-Path }

# Step 7: RStudio
Install-WithWinget "Posit.RStudio" "RStudio"

# Step 8: MiKTeX
if (Get-Command pdflatex -ErrorAction SilentlyContinue) { $script:CurrentStep++ } else { Install-WithWinget "MiKTeX.MiKTeX" "MiKTeX"; Refresh-Path }

# Step 9: LaTeX Packages
$script:CurrentStep++
Write-Progress-Bar $script:CurrentStep $script:TotalSteps
$latexPkgs = @("geometry", "amsmath", "amssymb", "amsfonts", "pgf", "xcolor", "graphics", "booktabs", "tabularx", "tools", "listings", "setspace", "titlesec", "ms", "indentfirst", "csquotes", "hyperref", "biblatex", "biblatex-apa", "logreq", "xstring", "biber", "caption")
if (Get-Command mpm -ErrorAction SilentlyContinue) {
    foreach ($pkg in $latexPkgs) { mpm --install=$pkg --quiet 2>&1 | Out-Null }
}

# Step 10: Git Identity
if ($env:CI -ne "true") {
    $currentName = git config --global user.name 2>$null
    if (-not $currentName) { $gitName = Read-Host "Enter Git name"; git config --global user.name $gitName }
}

# Step 11: GitHub Auth
if ($env:CI -ne "true") {
    if (-not (gh auth status 2>&1 -match "Logged in")) { gh auth login }
}

# Summary
Write-Host "`nAll done! Versions:" -ForegroundColor Green
try { Write-Host " Git       : $(git --version)" } catch {}
try { Write-Host " GitHub CLI: $(gh --version | Select-Object -First 1)" } catch {}
try { Write-Host " R         : $(Rscript --version 2>&1 | Select-Object -First 1)" } catch {}
try { Write-Host " Quarto    : $(quarto --version)" } catch {}
try { Write-Host " LaTeX     : $(pdflatex --version 2>&1 | Select-Object -First 1)" } catch {}
