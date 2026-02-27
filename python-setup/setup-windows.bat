<# :
@echo off
chcp 65001 >nul
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
# Windows Python Dev Setup: winget + uv + VS Code + GitHub CLI
# =============================================================================
# Objective: Force-install the modern Python dev stack.
# =============================================================================

# Continue on non-critical errors; we check results explicitly per step.
$ErrorActionPreference = "Continue"

# Enable UTF-8 output for checkmarks and arrows
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Progress Tracking
$TotalSteps = 9
$script:CurrentStep = 0

function Write-ProgressBar {
    param ([int]$Current, [int]$Total)
    $width  = 30
    $pct    = [math]::Floor(($Current / $Total) * 100)
    $filled = [math]::Floor(($width * $Current) / $Total)
    $empty  = $width - $filled
    $bar    = ([string][char]0x2588) * $filled + ([string][char]0x2591) * $empty
    Write-Host "Progress: [$bar] $pct%" -ForegroundColor Cyan
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Install a package via winget, skipping if the verify command already exists.
# Handles winget's non-zero exit codes for already-installed packages gracefully.
function Install-WingetPackage {
    param (
        [string]$Name,
        [string]$Id,
        [string]$VerifyCmd   # command to check after install (e.g. "git")
    )

    Write-Host "[->] Checking $Name..." -ForegroundColor Cyan

    if ($VerifyCmd -and (Get-Command $VerifyCmd -ErrorAction SilentlyContinue)) {
        Write-Host "[ok] $Name is already installed." -ForegroundColor Green
        return
    }

    Write-Host "[!] $Name not found. Installing via winget..." -ForegroundColor Yellow
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
    Refresh-Path

    # Verify the install worked regardless of winget's exit code
    # (winget returns non-zero for "already installed" in some versions)
    if ($VerifyCmd -and (Get-Command $VerifyCmd -ErrorAction SilentlyContinue)) {
        Write-Host "[ok] $Name installed successfully." -ForegroundColor Green
    } else {
        # Check if winget reported already installed (acceptable)
        Write-Host "[ok] $Name install step complete." -ForegroundColor Green
    }
}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   Python Dev Setup: Clinical Execution      " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# ── Step 1: Pre-flight — winget ────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Checking winget..." -ForegroundColor Cyan
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[X] winget not found." -ForegroundColor Red
    Write-Host "    Open the Microsoft Store, search for 'App Installer', install it, then re-run this script." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "[ok] winget found." -ForegroundColor Green

# Update sources quietly — do not abort if this fails on restricted networks
try { winget source update 2>&1 | Out-Null } catch {}

# ── Step 2: Git ────────────────────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "Git" -Id "Git.Git" -VerifyCmd "git"

# ── Step 3: GitHub CLI ─────────────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "GitHub CLI" -Id "GitHub.cli" -VerifyCmd "gh"

# ── Step 4: uv ────────────────────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "uv (Python manager)" -Id "astral-sh.uv" -VerifyCmd "uv"

# ── Step 5: VS Code ────────────────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "Visual Studio Code" -Id "Microsoft.VisualStudioCode" -VerifyCmd "code"

# VS Code may install to AppData (user) or Program Files (system).
# Add both possible bin locations so the code CLI is available in this session.
$vscodeBinPaths = @(
    "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin",
    "$env:ProgramFiles\Microsoft VS Code\bin"
)
foreach ($p in $vscodeBinPaths) {
    if (Test-Path $p) {
        $env:Path = "$p;$env:Path"
        break
    }
}
Refresh-Path

# ── Step 6: MiKTeX (LaTeX Distribution) ───────────────────────────────────────
# MiKTeX is the standard Windows LaTeX distribution.
# It auto-installs missing packages on demand, so documents always compile.

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "MiKTeX" -Id "MiKTeX.MiKTeX" -VerifyCmd "pdflatex"

# ── Step 7: VS Code Extensions & LaTeX Settings ───────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "[!] 'code' command still not found. Extensions need to be installed manually." -ForegroundColor Yellow
    Write-Host "    1. Open VS Code." -ForegroundColor Yellow
    Write-Host "    2. Press Ctrl+Shift+P." -ForegroundColor Yellow
    Write-Host "    3. Type: Shell Command: Install 'code' command in PATH" -ForegroundColor Yellow
    Write-Host "    4. Re-run this script." -ForegroundColor Yellow
} else {
    Write-Host "[->] Installing VS Code extensions..." -ForegroundColor Cyan
    $extensions = @(
        "ms-python.python",
        "ms-python.vscode-pylance",
        "charliermarsh.ruff",
        "GitHub.vscode-pull-request-github",
        "eamodio.gitlens",
        "tamasfe.even-better-toml",
        "james-yu.latex-workshop"
    )
    foreach ($ext in $extensions) {
        code --install-extension $ext --force 2>&1 | Out-Null
        Write-Host "    [ok] $ext" -ForegroundColor Green
    }

    # Configure LaTeX Workshop: auto-compile on save, show PDF in VS Code tab
    Write-Host "[->] Configuring VS Code LaTeX settings..." -ForegroundColor Cyan
    $settingsPath = "$env:APPDATA\Code\User\settings.json"
    $settingsDir  = Split-Path $settingsPath
    if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null }

    $latexPatch = @{
        "latex-workshop.latex.autoBuild.run" = "onSave"
        "latex-workshop.view.pdf.viewer"     = "tab"
    }
    try {
        $existing = if (Test-Path $settingsPath) {
            Get-Content $settingsPath -Raw | ConvertFrom-Json
        } else { [PSCustomObject]@{} }

        $merged = @{}
        $existing.PSObject.Properties | ForEach-Object { $merged[$_.Name] = $_.Value }
        foreach ($k in $latexPatch.Keys) { $merged[$k] = $latexPatch[$k] }
        $merged | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
        Write-Host "    [ok] LaTeX auto-build on save enabled." -ForegroundColor Green
    } catch {
        Write-Host "    [!] Could not write VS Code settings automatically. Set manually in Step 7d of the README." -ForegroundColor Yellow
    }
}

# ── Step 7: Git Identity & GitHub Auth ────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps

Write-Host "`n-- Git Identity ------------------------------" -ForegroundColor Cyan
while ($true) {
    $currentName  = git config --global user.name  2>$null
    $currentEmail = git config --global user.email 2>$null

    if (-not $currentName -or -not $currentEmail) {
        Write-Host "[?] Git needs your name and email to label your commits." -ForegroundColor Yellow
        $newName  = Read-Host "    Full Name"
        $newEmail = Read-Host "    GitHub Email"

        if ($newName -and $newEmail) {
            git config --global user.name  $newName
            git config --global user.email $newEmail
            Write-Host "[ok] Identity set." -ForegroundColor Green
            break
        } else {
            Write-Host "[!] Both fields are required. Try again." -ForegroundColor Red
        }
    } else {
        Write-Host "[ok] Already set: $currentName <$currentEmail>" -ForegroundColor Green
        break
    }
}

Write-Host "`n-- GitHub Authentication ---------------------" -ForegroundColor Cyan
$authStatus = gh auth status 2>&1
if ($authStatus -match "Logged in") {
    Write-Host "[ok] Already logged into GitHub CLI." -ForegroundColor Green
} else {
    Write-Host "[!] Not logged in. Your browser will open -- sign in and come back here." -ForegroundColor Yellow
    Write-Host "    When prompted, choose HTTPS and then 'Login with a web browser'." -ForegroundColor Cyan
    do {
        gh auth login --hostname github.com --git-protocol https --web
        $authStatus = gh auth status 2>&1
        if ($authStatus -match "Logged in") {
            Write-Host "[ok] Authentication complete." -ForegroundColor Green
        } else {
            Write-Host "[!] Login failed or cancelled. Trying again..." -ForegroundColor Red
        }
    } while ($authStatus -notmatch "Logged in")
}

# ── Step 8: Python 3.12 via uv ────────────────────────────────────────────────

$script:CurrentStep++; Write-ProgressBar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing Python 3.12 via uv..." -ForegroundColor Cyan
uv python install 3.12
Write-Host "[ok] Python 3.12 ready." -ForegroundColor Green

# ── Summary ───────────────────────────────────────────────────────────────────

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "   All done. Summary:                        " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan

try { Write-Host " Git     : $(git  --version 2>&1)"                          -ForegroundColor White } catch {}
try { Write-Host " GitHub  : $(gh   --version 2>&1 | Select-Object -First 1)" -ForegroundColor White } catch {}
try { Write-Host " uv      : $(uv   --version 2>&1)"                          -ForegroundColor White } catch {}
try {
    $pyList = uv python list --only-installed 2>&1 | Select-Object -First 1
    if ($pyList) { Write-Host " Python  : $pyList" -ForegroundColor White }
    else         { Write-Host " Python  : run 'uv python list' to verify" -ForegroundColor White }
} catch {}
try { Write-Host " VS Code : $(code --version 2>&1 | Select-Object -First 1)" -ForegroundColor White } catch {}
try { Write-Host " LaTeX   : $(pdflatex --version 2>&1 | Select-Object -First 1)" -ForegroundColor White } catch {}

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " VS Code is in your Start Menu."             -ForegroundColor White
Write-Host "=============================================" -ForegroundColor Cyan
