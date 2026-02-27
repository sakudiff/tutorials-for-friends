#!/bin/bash
# =============================================================================
# Lazarus Implementation Engine: Python/Quant Setup (macOS)
# =============================================================================
# Objective: Modern Python workflow with uv + VS Code.
# Efficiency: O(n) where n is the number of tools/extensions.
# =============================================================================

set -o pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

cd "$(dirname "$0")"
clear

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}   Python Quant Setup: Clinical Execution    ${NC}"
echo -e "${CYAN}=============================================${NC}"

# Progress Tracking
TOTAL_STEPS=8
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

# --- Phase 1: Homebrew ---
((CURRENT_STEP++)); render_progress
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}[→] Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
else
    echo -e "${GREEN}[✓] Homebrew present.${NC}"
fi

# --- Phase 2: CLI Tools (Git, GH, uv) ---
((CURRENT_STEP++)); render_progress
echo -e "${CYAN}[→] Installing CLI Tools (Git, GitHub CLI, uv)...${NC}"
brew install git gh uv --quiet

# --- Phase 3: VS Code ---
((CURRENT_STEP++)); render_progress
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    echo -e "${YELLOW}[→] Installing VS Code...${NC}"
    brew install --cask visual-studio-code --quiet
else
    echo -e "${GREEN}[✓] VS Code present.${NC}"
fi

# --- Phase 4: VS Code Extensions ---
((CURRENT_STEP++)); render_progress
echo -e "${CYAN}[→] Installing Extensions (Python, Pylance, Ruff, GitLens)...${NC}"
# Use code CLI (ensure it is in path)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
extensions=(
    "ms-python.python"
    "ms-python.vscode-pylance"
    "charliermarsh.ruff"
    "GitHub.vscode-pull-request-github"
    "eamodio.gitlens"
    "tamasfe.even-better-toml"
)
for ext in "${extensions[@]}"; do
    code --install-extension "$ext" --force &>/dev/null
    echo -e "    ${GREEN}[✓] $ext${NC}"
done

# --- Phase 5: Git Identity ---
((CURRENT_STEP++)); render_progress
echo -e "\n${CYAN}── Git Identity ──────────────────────────────${NC}"
CURRENT_NAME=$(git config --global user.name)
if [[ -z "$CURRENT_NAME" ]]; then
    read -rp "    Full Name: " NAME
    git config --global user.name "$NAME"
fi
CURRENT_EMAIL=$(git config --global user.email)
if [[ -z "$CURRENT_EMAIL" ]]; then
    read -rp "    GitHub Email: " EMAIL
    git config --global user.email "$EMAIL"
fi

# --- Phase 6: GitHub Auth ---
((CURRENT_STEP++)); render_progress
echo -e "\n${CYAN}── GitHub Authentication ─────────────────────${NC}"
if ! gh auth status &>/dev/null; then
    gh auth login --hostname github.com --git-protocol https --web
else
    echo -e "${GREEN}[✓] Logged in.${NC}"
fi

# --- Phase 7: uv Python Check ---
((CURRENT_STEP++)); render_progress
echo -e "${CYAN}[→] Setting up default Python via uv...${NC}"
uv python install 3.12 --quiet

# --- Phase 8: Summary ---
((CURRENT_STEP++)); render_progress
echo -e "\n${GREEN}Setup Complete.${NC}"
echo -e "Python: $(uv python --version)"
echo -e "IDE: Visual Studio Code"
echo -e "\nPress [Enter] to exit."
read -r
