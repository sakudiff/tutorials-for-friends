#!/bin/bash
# R Setup macOS

set -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cd "$(dirname "$0")"
clear

echo -e "${CYAN}   macOS Dev Setup: Clinical Execution       ${NC}"

# Pre-flight Checks

if [[ "$EUID" -eq 0 ]]; then
    echo -e "${RED}[✘] Do not run this script with sudo or as root.${NC}"
    echo -e "    Close this window and double-click the file normally."
    read -r
    exit 1
fi

OS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
if [[ "$OS_MAJOR" -lt 12 ]]; then
    echo -e "${RED}[✘] macOS 12 (Monterey) or later is required. You have $(sw_vers -productVersion).${NC}"
    read -r
    exit 1
fi

FREE_GB=$(df -g / | awk 'NR==2 {print $4}')
if [[ "$FREE_GB" -lt 8 ]]; then
    echo -e "${YELLOW}[!] Low disk space: ${FREE_GB}GB free. This install needs ~5GB.${NC}"
    if [[ "$CI" != "true" ]]; then
        read -rp "    Continue anyway? [y/N]: " DISK_CONFIRM
        [[ "$DISK_CONFIRM" =~ ^[Yy]$ ]] || exit 0
    else
        echo -e "${CYAN}[i] CI environment detected. Proceeding anyway.${NC}"
    fi
fi

# Helper Functions

retry_command() {
    local label="$1"; shift
    local n=1
    local max=3
    local delay=2
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo -e "${YELLOW}[!] Attempt $n/$max failed for '$label'. Retrying in ${delay}s...${NC}"
                sleep $delay
                delay=$((delay * 2))
            else
                echo -e "${RED}[✘] '$label' failed after $max attempts.${NC}"
                return 1
            fi
        }
    done
}

refresh_path() {
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    export PATH="/Library/TeX/texbin:$PATH"
}

# Progress Tracking
TOTAL_STEPS=10
CURRENT_STEP=0

render_progress() {
    local width=30
    local percent=$(( 100 * CURRENT_STEP / TOTAL_STEPS ))
    local filled=$(( width * CURRENT_STEP / TOTAL_STEPS ))
    local empty=$(( width - filled ))
    printf "${CYAN}Progress: ["
    [[ $filled -gt 0 ]] && printf "${GREEN}%${filled}s${NC}" "" | tr ' ' '#'
    [[ $empty -gt 0 ]] && printf "%${empty}s" "" | tr ' ' '-'
    printf "${CYAN}] %d%%${NC}\n" "$percent"
}

install_tool() {
    local tool_name="$1"
    local brew_pkg="$2"
    local verify_bin="$3"
    ((CURRENT_STEP++))
    render_progress
    echo -e "${CYAN}[->] Checking $tool_name...${NC}"
    if command -v "$verify_bin" &>/dev/null; then
        echo -e "${GREEN}[ok] $tool_name is already present.${NC}"
    else
        echo -e "${YELLOW}[!] $tool_name missing. Installing...${NC}"
        if retry_command "$tool_name" brew install "$brew_pkg"; then
            refresh_path
            echo -e "${GREEN}[ok] $tool_name successfully installed.${NC}"
        else
            echo -e "${RED}[fail] Critical failure installing $tool_name.${NC}"
            read -r
            exit 1
        fi
    fi
}

install_cask() {
    local app_name="$1"
    local cask_name="$2"
    local app_path="$3"
    ((CURRENT_STEP++))
    render_progress
    echo -e "${CYAN}[->] Checking $app_name...${NC}"
    if [ -d "$app_path" ] || command -v "$cask_name" &>/dev/null; then
        echo -e "${GREEN}[ok] $app_name is already installed.${NC}"
    else
        echo -e "${YELLOW}[!] $app_name missing. Downloading...${NC}"
        if retry_command "$app_name" brew install --cask "$cask_name"; then
            echo -e "${GREEN}[ok] $app_name installed.${NC}"
        else
            echo -e "${RED}[fail] Failed to install $app_name.${NC}"
            read -r
            exit 1
        fi
    fi
}

# Phase 1: Homebrew

((CURRENT_STEP++))
render_progress
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}[->] Homebrew missing. This will take a few minutes...${NC}"
    echo -e "${CYAN}    You may be prompted for your Mac login password.${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo -e "${RED}[fail] Homebrew install failed. Check your internet connection and try again.${NC}"
        read -r
        exit 1
    }
    if [[ "$(uname -m)" == "arm64" ]]; then
        grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null \
            || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null \
            || echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}[ok] Homebrew already installed.${NC}"
fi

# Phase 2: Update Homebrew
((CURRENT_STEP++))
render_progress
echo -e "${CYAN}[->] Updating Homebrew...${NC}"
brew update --quiet

# Phase 3: CLI Tools
install_tool "Git"        "git" "git"
install_tool "GitHub CLI" "gh"  "gh"

# Phase 4: Applications
install_cask "GitHub Desktop" "github"  "/Applications/GitHub Desktop.app"
install_cask "Quarto"         "quarto"  "/Applications/Quarto"
install_cask "R"              "r"       "/Library/Frameworks/R.framework"
install_cask "RStudio"        "rstudio" "/Applications/RStudio.app"

# Phase 5: LaTeX Distribution (MacTeX)
install_cask "MacTeX (No GUI)" "mactex-no-gui" "/Library/TeX/texbin"
refresh_path

# Phase 6: LaTeX Packages
((CURRENT_STEP++))
render_progress
echo -e "${CYAN}[->] Installing additional LaTeX packages...${NC}"
if command -v tlmgr &>/dev/null; then
    sudo tlmgr update --self --all --quiet 2>/dev/null
    latex_pkgs=(
        "geometry" "amsmath" "amssymb" "amsfonts" "pgf" "xcolor" "graphics" 
        "booktabs" "tabularx" "tools" "listings" "setspace" 
        "titlesec" "ms" "indentfirst" "csquotes" "hyperref" 
        "biblatex" "biblatex-apa" "logreq" "xstring" "biber" "caption"
    )
    for pkg in "${latex_pkgs[@]}"; do
        echo -ne "    Installing $pkg... \r"
        sudo tlmgr install "$pkg" --quiet 2>/dev/null && echo -e "    ${GREEN}[ok] $pkg${NC}          " || echo -e "    ${YELLOW}[!] $pkg (check manually)${NC}          "
    done
else
    echo -e "${YELLOW}[!] tlmgr not found. Skipping package installation.${NC}"
fi

# Phase 7: Git Identity
if [[ "$CI" == "true" ]]; then
    echo -e "\n${CYAN}[i] CI environment detected. Skipping interactive identity setup.${NC}"
else
    echo -e "\n${CYAN}# Git Identity${NC}"
    while true; do
        CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
        CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
        if [[ -z "$CURRENT_NAME" || -z "$CURRENT_EMAIL" ]]; then
            echo -e "${YELLOW}[?] Git needs your name and email to label your commits.${NC}"
            read -rp "    Full Name  : " NEW_NAME
            read -rp "    GitHub Email: " NEW_EMAIL
            if [[ -n "$NEW_NAME" && -n "$NEW_EMAIL" ]]; then
                git config --global user.name  "$NEW_NAME"
                git config --global user.email "$NEW_EMAIL"
                echo -e "${GREEN}[ok] Identity set.${NC}"
                break
            else
                echo -e "${RED}[!] Both fields are required. Try again.${NC}"
            fi
        else
            echo -e "${GREEN}[ok] Already set: $CURRENT_NAME <$CURRENT_EMAIL>${NC}"
            break
        fi
    done
fi

# Phase 8: GitHub Authentication
if [[ "$CI" == "true" ]]; then
    echo -e "\n${CYAN}[i] CI environment detected. Skipping interactive login.${NC}"
else
    echo -e "\n${CYAN}# GitHub Authentication${NC}"
    if gh auth status &>/dev/null; then
        echo -e "${GREEN}[ok] Already logged into GitHub CLI.${NC}"
    else
        echo -e "${YELLOW}[!] Not logged in. Your browser will open -- sign in and come back here.${NC}"
        echo -e "${CYAN}    When prompted, choose HTTPS and then 'Login with a web browser'.${NC}"
        until gh auth status &>/dev/null; do
            gh auth login --hostname github.com --git-protocol https --web
            if gh auth status &>/dev/null; then
                echo -e "${GREEN}[ok] Authentication complete.${NC}"
            else
                echo -e "${RED}[!] Login failed or cancelled. Trying again...${NC}"
            fi
        done
    fi
fi

# Phase 9: RStudio Git Integration Reminder
GIT_PATH=$(command -v git)
echo -e "\n${CYAN}# RStudio Setup Reminder${NC}"
echo -e " 1. Open RStudio (in /Applications)."
echo -e " 2. Go to: Tools -> Global Options -> Git/SVN"
echo -e " 3. Check 'Enable version control interface for RStudio projects'."
echo -e " 4. Git executable should auto-fill as: ${YELLOW}$GIT_PATH${NC}"
echo -e "    If it's blank, paste that path in manually."
echo -e " 5. Click OK, then restart RStudio."

# Phase 10: Final Summary
echo -e "\n${GREEN}   All done. Summary:                        ${NC}"
echo -e " Homebrew : $(brew --version | head -n 1)"
echo -e " Git      : $(git --version | awk '{print $3}')"
echo -e " GitHub   : $(gh --version | head -n 1 | awk '{print $3}')"
echo -e " Quarto   : $(quarto --version 2>/dev/null || echo 'check /Applications')"
echo -e " R        : $(R --version 2>/dev/null | head -n 1 | awk '{print $3}' || echo 'check /Applications')"
echo -e " LaTeX    : $(pdflatex --version 2>/dev/null | head -n 1 || echo 'check /Library/TeX/texbin')"
echo -e " GitHub Desktop and RStudio are in /Applications."
echo -e "\nAll tools verified."

if [[ "$CI" != "true" ]]; then
    echo -e "\nPress [Enter] to close this window."
    read -r
fi
