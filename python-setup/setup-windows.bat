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
if not defined CI pause
exit /b
#>

# Python Dev Setup

$ErrorActionPreference = "Continue"

# Progress Tracking
$TotalSteps = 11
$script:CurrentStep = 0

function Write-Progress-Bar {
    param ([int]$Current, [int]$Total)
    $width  = 30
    $pct    = [math]::Floor(($Current / $Total) * 100)
    $filled = [math]::Floor(($width * $Current) / $Total)
    $empty  = $width - $filled
    $bar    = "#" * $filled + "-" * $empty
    Write-Host "`rProgress: [$bar] $pct% " -NoNewline -ForegroundColor Cyan
    Write-Host ""
}

function Refresh-Path {
    if ($env:CI -eq "true") { return }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
    $extraPaths = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin",
        "$env:ProgramFiles\Microsoft VS Code\bin",
        "$env:ProgramFiles\Git\bin",
        "$env:ProgramFiles\Git\cmd",
        "$env:ProgramFiles\GitHub CLI",
        "$env:USERPROFILE\.local\bin",
        "$env:ProgramFiles\MiKTeX\miktex\bin\x64",
        "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64",
        "$env:USERPROFILE\AppData\Local\Programs\uv"
    )
    foreach ($p in $extraPaths) {
        if ((Test-Path $p) -and ($env:Path -notlike "*$p*")) {
            $env:Path = "$p;$env:Path"
        }
    }
}

function Install-WingetPackage {
    param ([string]$Name, [string]$Id, [string]$VerifyCmd)
    Write-Host "[->] Checking $Name..." -ForegroundColor Cyan
    if ($VerifyCmd -and (Get-Command $VerifyCmd -ErrorAction SilentlyContinue)) {
        Write-Host "[ok] $Name is already installed." -ForegroundColor Green
        return
    }
    Write-Host "[!] $Name not found. Installing via winget..." -ForegroundColor Yellow
    winget install --id $Id --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
    Refresh-Path
    if ($VerifyCmd -and (Get-Command $VerifyCmd -ErrorAction SilentlyContinue)) {
        Write-Host "[ok] $Name installed successfully." -ForegroundColor Green
    } else {
        Write-Host "[ok] $Name install step complete." -ForegroundColor Green
    }
}

echo Python Dev Setup

# Step 1: Pre-flight (winget)
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[X] winget not found." -ForegroundColor Red
    exit 1
}
try { winget source update 2>&1 | Out-Null } catch {}

# Step 2: Git
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "Git" -Id "Git.Git" -VerifyCmd "git"

# Step 3: GitHub CLI
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "GitHub CLI" -Id "GitHub.cli" -VerifyCmd "gh"

# Step 4: uv
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "uv (Python manager)" -Id "astral-sh.uv" -VerifyCmd "uv"

# Step 5: VS Code
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "Visual Studio Code" -Id "Microsoft.VisualStudioCode" -VerifyCmd "code"
Refresh-Path

# Step 6: MiKTeX (LaTeX Distribution)
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Install-WingetPackage -Name "MiKTeX" -Id "MiKTeX.MiKTeX" -VerifyCmd "pdflatex"

# Step 7: LaTeX Packages
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Installing additional LaTeX packages..." -ForegroundColor Cyan
$latexPkgs = @("geometry", "amsmath", "amssymb", "amsfonts", "pgf", "xcolor", "graphics", "booktabs", "tabularx", "tools", "listings", "setspace", "titlesec", "ms", "indentfirst", "csquotes", "hyperref", "biblatex", "biblatex-apa", "logreq", "xstring", "biber", "caption")
if (Get-Command mpm -ErrorAction SilentlyContinue) {
    foreach ($pkg in $latexPkgs) {
        Write-Host "    Installing $pkg..." -ForegroundColor Cyan
        mpm --install=$pkg --quiet 2>&1 | Out-Null
    }
}

# Step 8: VS Code Extensions & LaTeX Settings
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if (Get-Command code -ErrorAction SilentlyContinue) {
    $extensions = @("ms-python.python", "ms-python.vscode-pylance", "charliermarsh.ruff", "GitHub.vscode-pull-request-github", "eamodio.gitlens", "tamasfe.even-better-toml", "james-yu.latex-workshop")
    foreach ($ext in $extensions) {
        code --install-extension $ext --force 2>&1 | Out-Null
    }
    $settingsPath = "$env:APPDATA\Code\User\settings.json"
    $latexPatch = @{ "latex-workshop.latex.autoBuild.run" = "onSave"; "latex-workshop.view.pdf.viewer" = "tab" }
    try {
        $existing = if (Test-Path $settingsPath) { Get-Content $settingsPath -Raw | ConvertFrom-Json } else { [PSCustomObject]@{} }
        foreach ($k in $latexPatch.Keys) { $existing.PSObject.Properties | ForEach-Object { if ($_.Name -eq $k) { $_.Value = $latexPatch[$k] } } }
        $existing | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    } catch {}
}

# Step 9: Git Identity & GitHub Auth
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
if ($env:CI -ne "true") {
    $currentName = git config --global user.name 2>$null
    $currentEmail = git config --global user.email 2>$null
    if (-not $currentName -or -not $currentEmail) {
        $newName = Read-Host "    Full Name"
        $newEmail = Read-Host "    GitHub Email"
        git config --global user.name $newName
        git config --global user.email $newEmail
    }
    if (-not (gh auth status 2>&1 -match "Logged in")) { gh auth login }
}

# Step 10: Python 3.12 via uv
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
uv python install 3.12

# Step 11: Verify LaTeX Compilation
$script:CurrentStep++; Write-Progress-Bar $script:CurrentStep $script:TotalSteps
Write-Host "[->] Verifying LaTeX installation..." -ForegroundColor Cyan
$testDir = Join-Path $env:TEMP "latex_test"
if (-not (Test-Path $testDir)) { New-Item -ItemType Directory -Path $testDir | Out-Null }
$texFile = Join-Path $testDir "test.tex"
$pdfFile = Join-Path $testDir "test.pdf"
@"
\documentclass{article}
\begin{document}
Hello World.
\end{document}
"@ | Out-File -FilePath $texFile -Encoding utf8
Push-Location $testDir
pdflatex --interaction=nonstopmode test.tex 2>&1 | Out-Null
Pop-Location
if (Test-Path $pdfFile) {
    Write-Host "[ok] LaTeX rendering works perfectly." -ForegroundColor Green
} else {
    Write-Host "[!] pdflatex failed to generate PDF." -ForegroundColor Yellow
}
Remove-Item -Path $testDir -Recurse -Force -ErrorAction SilentlyContinue

# Summary
Write-Host "`nAll done. Summary:" -ForegroundColor Green
try { Write-Host " Git     : $(git --version)" } catch {}
try { Write-Host " GitHub  : $(gh --version | Select-Object -First 1)" } catch {}
try { Write-Host " uv      : $(uv --version)" } catch {}
try { Write-Host " VS Code : $(code --version | Select-Object -First 1)" } catch {}
try { Write-Host " LaTeX   : $(pdflatex --version | Select-Object -First 1)" } catch {}
