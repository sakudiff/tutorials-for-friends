<# :
@echo off
setlocal
title Python Dev Setup
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
# Windows Python/Quant Setup Script: winget + uv + VS Code
# =============================================================================
# Objective: Force-install the modern Python stack (uv + VS Code).
# Efficiency: O(n) where n is the number of tools/extensions.
# =============================================================================

$ErrorActionPreference = "Stop"

# Progress Tracking
$TotalSteps = 7
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

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " Python Dev Setup: Clinical Execution        " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# --- 1. winget check ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[!] winget missing. Install 'App Installer' from Store." -ForegroundColor Red
    exit 1
}
winget source update

# --- 2. Git & GitHub CLI ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing Git & GitHub CLI..." -ForegroundColor Yellow
winget install --id Git.Git --silent --accept-package-agreements --accept-source-agreements
winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
Refresh-Path

# --- 3. uv (Python Manager) ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing uv..." -ForegroundColor Yellow
winget install --id astral-sh.uv --silent --accept-package-agreements --accept-source-agreements
Refresh-Path

# --- 4. VS Code ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing VS Code..." -ForegroundColor Yellow
winget install --id Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements
Refresh-Path

# --- 5. VS Code Extensions ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing Extensions (Python, Pylance, Ruff, etc.)..." -ForegroundColor Yellow
$extensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "charliermarsh.ruff",
    "GitHub.vscode-pull-request-github",
    "eamodio.gitlens",
    "tamasfe.even-better-toml"
)
foreach ($ext in $extensions) {
    code --install-extension $ext --force | Out-Null
    Write-Host "    [ok] $ext" -ForegroundColor Green
}

# --- 6. Identity & Auth ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
$currentName  = git config --global user.name  2>$null
if (-not $currentName) {
    $gitName = Read-Host "[?] Enter your Git display name"
    git config --global user.name $gitName
}
$currentEmail = git config --global user.email 2>$null
if (-not $currentEmail) {
    $gitEmail = Read-Host "[?] Enter your Git email"
    git config --global user.email $gitEmail
}
$authStatus = gh auth status 2>&1
if ($authStatus -notmatch "Logged in") {
    Write-Host "[->] Authenticating GitHub CLI..." -ForegroundColor Yellow
    gh auth login
}

# --- 7. uv Python Install ---
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Setting up Python 3.12..." -ForegroundColor Yellow
uv python install 3.12

Write-Host "`nAll done. VS Code and uv are ready." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan
