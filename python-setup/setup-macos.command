#!/bin/bash
# =============================================================================
# Python Dev Setup — macOS (uv + VS Code + GitHub CLI)
# =============================================================================
# Objective: Force-install the modern Python dev stack for users who find
#            CLI setup intimidating.
# =============================================================================

set -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cd "$(dirname "$0")"
clear

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}   Python Dev Setup: Clinical Execution      ${NC}"
echo -e "${CYAN}=============================================${NC}"

# ── Pre-flight Checks ─────────────────────────────────────────────────────────

# Block root — Homebrew refuses to run as root
if [[ "$EUID" -eq 0 ]]; then
    echo -e "${RED}[✘] Do not run this script with sudo or as root.${NC}"
    echo -e "    Close this window and double-click the file normally."
    read -r
    exit 1
fi

# Require macOS 12+ (Homebrew minimum)
OS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
if [[ "$OS_MAJOR" -lt 12 ]]; then
    echo -e "${RED}[✘] macOS 12 (Monterey) or later is required. You have $(sw_vers -productVersion).${NC}"
    read -r
    exit 1
fi

# Warn on low disk space (require at least 8 GB free)
FREE_GB=$(df -g / | awk 'NR==2 {print $4}')
if [[ "$FREE_GB" -lt 8 ]]; then
    echo -e "${YELLOW}[!] Low disk space: ${FREE_GB}GB free. This install needs ~5GB.${NC}"
    read -rp "    Continue anyway? [y/N]: " DISK_CONFIRM
    [[ "$DISK_CONFIRM" =~ ^[Yy]$ ]] || exit 0
fi

# ── Helper Functions ──────────────────────────────────────────────────────────

# Retry a command up to 3 times with exponential backoff
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

# Refresh PATH so newly installed brew binaries are visible in this session
refresh_path() {
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
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
    [[ $filled -gt 0 ]] && printf "${GREEN}%${filled}s${NC}" "" | tr ' ' '█'
    [[ $empty -gt 0 ]] && printf "%${empty}s" "" | tr ' ' '░'
    printf "${CYAN}] %d%%${NC}\n" "$percent"
}

# Check and install a CLI tool via Homebrew
install_tool() {
    local tool_name="$1"
    local brew_pkg="$2"
    local verify_bin="$3"

    ((CURRENT_STEP++))
    render_progress

    echo -e "${CYAN}[→] Checking $tool_name...${NC}"
    if command -v "$verify_bin" &>/dev/null; then
        echo -e "${GREEN}[✓] $tool_name is already present.${NC}"
    else
        echo -e "${YELLOW}[!] $tool_name missing. Installing...${NC}"
        if retry_command "$tool_name" brew install "$brew_pkg"; then
            refresh_path
            echo -e "${GREEN}[✓] $tool_name installed.${NC}"
        else
            echo -e "${RED}[✘] Critical failure installing $tool_name.${NC}"
            read -r
            exit 1
        fi
    fi
}

# Check and install a GUI app via Homebrew Cask
install_cask() {
    local app_name="$1"
    local cask_name="$2"
    local app_path="$3"

    ((CURRENT_STEP++))
    render_progress

    echo -e "${CYAN}[→] Checking $app_name...${NC}"
    if [ -d "$app_path" ]; then
        echo -e "${GREEN}[✓] $app_name is already installed.${NC}"
    else
        echo -e "${YELLOW}[!] $app_name missing. Downloading...${NC}"
        if retry_command "$app_name" brew install --cask "$cask_name"; then
            echo -e "${GREEN}[✓] $app_name installed.${NC}"
        else
            echo -e "${RED}[✘] Failed to install $app_name.${NC}"
            read -r
            exit 1
        fi
    fi
}

# ── Phase 1: Homebrew ─────────────────────────────────────────────────────────

((CURRENT_STEP++))
render_progress
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}[→] Homebrew missing. This will take a few minutes...${NC}"
    echo -e "${CYAN}    You may be prompted for your Mac login password.${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo -e "${RED}[✘] Homebrew install failed. Check your internet connection and try again.${NC}"
        read -r
        exit 1
    }

    # Add brew to PATH for this session AND for future sessions
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo -e "${CYAN}[i] Apple Silicon detected. Updating .zprofile...${NC}"
        grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null \
            || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo -e "${CYAN}[i] Intel Mac detected. Updating .zprofile...${NC}"
        grep -qxF 'eval "$(/usr/local/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null \
            || echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}[✓] Homebrew already installed.${NC}"
fi

# ── Phase 2: Update Homebrew ──────────────────────────────────────────────────

((CURRENT_STEP++))
render_progress
echo -e "${CYAN}[→] Updating Homebrew...${NC}"
brew update --quiet

# ── Phase 3–5: CLI Tools ──────────────────────────────────────────────────────

install_tool "Git"        "git" "git"
install_tool "GitHub CLI" "gh"  "gh"
install_tool "uv"         "uv"  "uv"

# ── Phase 6: VS Code ──────────────────────────────────────────────────────────

install_cask "Visual Studio Code" "visual-studio-code" "/Applications/Visual Studio Code.app"

# ── Phase 7: MacTeX (LaTeX Distribution) ──────────────────────────────────────
# mactex-no-gui is the full TeX Live distribution without the GUI utilities.
# It installs pdflatex, latexmk, and every package needed for offline rendering.

install_cask "MacTeX (No GUI)" "mactex-no-gui" "/Library/TeX/texbin"

# Add TeX binaries to PATH for this session so the summary can verify them
export PATH="/Library/TeX/texbin:$PATH"

# ── Phase 8: VS Code Extensions ───────────────────────────────────────────────

((CURRENT_STEP++))
render_progress

# Ensure the code CLI is in PATH — VS Code installs it here
CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$CODE_BIN:$PATH"

if ! command -v code &>/dev/null; then
    echo -e "${YELLOW}[!] VS Code 'code' command not found in PATH.${NC}"
    echo -e "    Open VS Code, press Cmd+Shift+P, type:"
    echo -e "    ${CYAN}Shell Command: Install 'code' command in PATH${NC}"
    echo -e "    Then re-run this script to install extensions."
else
    echo -e "${CYAN}[→] Installing VS Code extensions...${NC}"
    extensions=(
        "ms-python.python"
        "ms-python.vscode-pylance"
        "charliermarsh.ruff"
        "GitHub.vscode-pull-request-github"
        "eamodio.gitlens"
        "tamasfe.even-better-toml"
        "james-yu.latex-workshop"
    )
    for ext in "${extensions[@]}"; do
        code --install-extension "$ext" --force 2>&1 | grep -q "successfully installed\|already installed" \
            && echo -e "    ${GREEN}[✓] $ext${NC}" \
            || { code --install-extension "$ext" --force &>/dev/null && echo -e "    ${GREEN}[✓] $ext${NC}"; }
    done

    # Configure LaTeX Workshop: auto-compile on save, show PDF in VS Code tab
    echo -e "${CYAN}[→] Configuring VS Code LaTeX settings...${NC}"
    SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    /usr/bin/python3 - <<'PYEOF'
import json, os
path = os.path.expanduser("~/Library/Application Support/Code/User/settings.json")
try:
    with open(path, 'r') as f:
        content = f.read().strip()
        settings = json.loads(content) if content else {}
except FileNotFoundError:
    settings = {}
except json.JSONDecodeError:
    import shutil
    shutil.copy(path, path + ".bak")
    settings = {}
settings["latex-workshop.latex.autoBuild.run"] = "onSave"
settings["latex-workshop.view.pdf.viewer"] = "tab"
with open(path, 'w') as f:
    json.dump(settings, f, indent=4)
PYEOF
    echo -e "    ${GREEN}[✓] LaTeX auto-build on save enabled.${NC}"
fi

# ── Phase 9: Git Identity & GitHub Auth ───────────────────────────────────────

((CURRENT_STEP++))
render_progress

echo -e "\n${CYAN}── Git Identity ──────────────────────────────${NC}"
while true; do
    CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -z "$CURRENT_NAME" || -z "$CURRENT_EMAIL" ]]; then
        echo -e "${YELLOW}[?] Git needs your name and email to label your commits.${NC}"
        read -rp "    Full Name   : " NEW_NAME
        read -rp "    GitHub Email: " NEW_EMAIL

        if [[ -n "$NEW_NAME" && -n "$NEW_EMAIL" ]]; then
            git config --global user.name  "$NEW_NAME"
            git config --global user.email "$NEW_EMAIL"
            echo -e "${GREEN}[✓] Identity set.${NC}"
            break
        else
            echo -e "${RED}[!] Both fields are required. Try again.${NC}"
        fi
    else
        echo -e "${GREEN}[✓] Already set: $CURRENT_NAME <$CURRENT_EMAIL>${NC}"
        break
    fi
done

echo -e "\n${CYAN}── GitHub Authentication ─────────────────────${NC}"
if gh auth status &>/dev/null; then
    echo -e "${GREEN}[✓] Already logged into GitHub CLI.${NC}"
else
    echo -e "${YELLOW}[!] Not logged in. Your browser will open — sign in and come back here.${NC}"
    echo -e "${CYAN}    When prompted, choose HTTPS and then 'Login with a web browser'.${NC}"
    until gh auth status &>/dev/null; do
        gh auth login --hostname github.com --git-protocol https --web
        if gh auth status &>/dev/null; then
            echo -e "${GREEN}[✓] Authentication complete.${NC}"
        else
            echo -e "${RED}[!] Login failed or cancelled. Trying again...${NC}"
        fi
    done
fi

# ── Phase 10: Python via uv & Summary ─────────────────────────────────────────

((CURRENT_STEP++))
render_progress

echo -e "${CYAN}[→] Installing Python 3.12 via uv...${NC}"
if uv python install 3.12; then
    echo -e "${GREEN}[✓] Python 3.12 installed.${NC}"
else
    echo -e "${YELLOW}[!] uv python install returned a warning — Python may already be present.${NC}"
fi

echo -e "\n${CYAN}=============================================${NC}"
echo -e "${GREEN}   All done. Summary:                        ${NC}"
echo -e "${CYAN}=============================================${NC}"
echo -e " Homebrew : $(brew --version | head -n 1)"
echo -e " Git      : $(git --version | awk '{print $3}')"
echo -e " GitHub   : $(gh --version | head -n 1 | awk '{print $3}')"
echo -e " uv       : $(uv --version)"
echo -e " Python   : $(uv python list --only-installed 2>/dev/null | head -n 1 | awk '{print $1}' || echo 'run: uv python list')"
echo -e " VS Code  : $(code --version 2>/dev/null | head -n 1 || echo 'check /Applications')"
echo -e " LaTeX    : $(pdflatex --version 2>/dev/null | head -n 1 || echo 'check /Library/TeX/texbin')"
echo -e "${CYAN}=============================================${NC}"
echo -e " Visual Studio Code is in /Applications."
echo -e "${CYAN}=============================================${NC}"
echo -e "\nPress [Enter] to close this window."
read -r
