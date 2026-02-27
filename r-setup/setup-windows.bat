<# :
@echo off
setlocal
title Windows Dev Setup
echo Starting setup...
pushd "%~dp0"
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "IEX (Get-Content '%~f0' -Raw)"
if %errorlevel% neq 0 (
    echo.
    echo [!] Something went wrong during the setup.
)
echo.
echo Setup process finished. Press any key to close this window.
pause
exit /b
#>

# =============================================================================
# Windows Setup Script: winget + GitHub CLI + GitHub Desktop + RStudio
# =============================================================================
# Objective: Force-install the dev stack for users who find CLI intimidating.
# Efficiency: O(n) where n is the number of tools.
# =============================================================================

$ErrorActionPreference = "Stop"

# Progress Tracking
$TotalSteps = 8
$CurrentStep = 0

function Write-Progress-Bar {
    param (
        [int]$Current,
        [int]$Total
    )
    $width = 30
    $percent = [math]::Floor(($Current / $Total) * 100)
    $filled = [math]::Floor(($width * $Current) / $Total)
    $empty = $width - $filled

    $bar = "#" * $filled + "-" * $empty
    Write-Host "`rProgress: [$bar] $percent% " -NoNewline -ForegroundColor Cyan
    Write-Host "" # New line for the next message
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " Windows Dev Setup: Clinical Execution       " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# -- Helper function -----------------------------------------------------------
function Install-WithWinget {
    param (
        [string]$Id,
        [string]$Name
    )
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[->] Installing $Name..." -ForegroundColor Yellow
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements
    Write-Host "[ok] $Name installed." -ForegroundColor Green
}

# -- 1. Check winget is available ---------------------------------------------
$script:CurrentStep++
Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[!] winget is not available." -ForegroundColor Red
    Write-Host "    Install the 'App Installer' from the Microsoft Store,"
    Write-Host "    then re-run this script."
    exit 1
}

Write-Host "[ok] winget found." -ForegroundColor Green
winget source update

# -- 2. Git --------------------------------------------------------------------
if (Get-Command git -ErrorAction SilentlyContinue) {
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[ok] Git already installed - skipping." -ForegroundColor Green
} else {
    Install-WithWinget "Git.Git" "Git"
    # Refresh PATH so git is available in this session
    Refresh-Path
}

# -- 3. GitHub CLI (gh) --------------------------------------------------------
if (Get-Command gh -ErrorAction SilentlyContinue) {
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[ok] GitHub CLI already installed - skipping." -ForegroundColor Green
} else {
    Install-WithWinget "GitHub.cli" "GitHub CLI"
    Refresh-Path
}

# -- 4. GitHub Desktop ---------------------------------------------------------
$githubDesktop = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "GitHub Desktop" }

if ($githubDesktop) {
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[ok] GitHub Desktop already installed - skipping." -ForegroundColor Green
} else {
    Install-WithWinget "GitHub.GitHubDesktop" "GitHub Desktop"
}

# -- 5. R ----------------------------------------------------------------------
if (Get-Command Rscript -ErrorAction SilentlyContinue) {
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[ok] R already installed - skipping." -ForegroundColor Green
} else {
    Install-WithWinget "RProject.R" "R"
    Refresh-Path
}

# -- 6. RStudio ----------------------------------------------------------------
$rstudio = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "RStudio*" }

if ($rstudio) {
    $script:CurrentStep++
    Write-Progress-Bar $script:CurrentStep $script:TotalSteps
    Write-Host "[ok] RStudio already installed - skipping." -ForegroundColor Green
} else {
    Install-WithWinget "Posit.RStudio" "RStudio"
}

# -- 7. Configure Git (only if not already set) --------------------------------
$script:CurrentStep++
Write-Progress-Bar $script:CurrentStep $script:TotalSteps
$currentName  = git config --global user.name  2>$null
$currentEmail = git config --global user.email 2>$null

if (-not $currentName) {
    $gitName = Read-Host "[?] Enter your Git display name"
    git config --global user.name $gitName
}

if (-not $currentEmail) {
    $gitEmail = Read-Host "[?] Enter your Git email"
    git config --global user.email $gitEmail
}

# -- 8. Authenticate GitHub CLI ------------------------------------------------
$script:CurrentStep++
Write-Progress-Bar $script:CurrentStep $script:TotalSteps
$authStatus = gh auth status 2>&1
if ($authStatus -match "Logged in") {
    Write-Host "[ok] GitHub CLI already authenticated - skipping." -ForegroundColor Green
} else {
    Write-Host "[->] Authenticating GitHub CLI (browser will open)..." -ForegroundColor Yellow
    gh auth login
}


# ── 9. Summary ────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " All done! Versions installed:"               -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " Git       : $(git --version)"
Write-Host " GitHub CLI: $(gh --version | Select-Object -First 1)"
Write-Host " R         : $(Rscript --version 2>&1 | Select-Object -First 1)"
Write-Host ""
Write-Host " GitHub Desktop and RStudio are in your Start Menu."
Write-Host ""
Write-Host " Next steps:"
Write-Host "  1. Open RStudio → Tools → Global Options → Git/SVN"
Write-Host "     and confirm the Git executable path is set"
Write-Host "     (usually C:\Program Files\Git\bin\git.exe)."
Write-Host "  2. Run 'gh auth status' to verify GitHub login."
Write-Host "=============================================" -ForegroundColor Cyan
