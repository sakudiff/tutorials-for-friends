# Python Quant Setup Guide — Modern Workflow (uv + VS Code)

> **Who this is for:** Anyone needing a stable, modern Python 3.12+ environment with professional tools. 
> 
> **The Stack:** `uv` (Fastest Python manager), `VS Code` (IDE), `Git`, and `GitHub CLI`.

---

## 🚀 The Automated Way (Fastest)

I have created scripts that handle the entire setup: installing the package managers, the IDE, the Python version, and the essential VS Code extensions.

### Windows Users
1. Find the file named `setup-windows.bat` in this folder.
2. **Double-click** it. 
3. The script will install:
   - Git, GitHub CLI
   - `uv` (the Python manager)
   - Visual Studio Code
   - **Extensions:** Python, Pylance, Ruff (Linting/Formatting), GitLens, and GitHub Pull Requests.
4. It will prompt for your GitHub login in the browser.

### Mac Users
1. Find the file named `setup-macos.command` in this folder.
2. **Double-click** it.
3. If it says it "cannot be opened because it is from an unidentified developer," right-click it and select **Open**.
4. The script will use Homebrew to install the same stack as Windows (uv, VS Code, Git, etc.).

---

## 🏗️ Your Daily Workflow (The `uv` Way)

We are using `uv` instead of standard `pip` or `conda` because it is up to 100x faster and more reliable.

### 1. Starting a New Project
```bash
# 1. Create a project folder
mkdir my-project
cd my-project

# 2. Initialize the project (this creates pyproject.toml)
uv init

# 3. Create a virtual environment
uv venv

# 4. Activate it
# Windows: .\.venv\Scripts\activate
# Mac/Linux: source .venv/bin/activate
```

### 2. Installing Packages
Instead of `pip install`, use:
```bash
uv add pandas numpy matplotlib ruff
```
This automatically updates your `pyproject.toml` and `uv.lock` files, ensuring everyone on your team has the exact same versions.

### 3. Running Scripts
```bash
uv run main.py
```

---

## 🛠️ VS Code Configuration

The setup script automatically installs these extensions:
- **Python (Microsoft):** Basic language support.
- **Pylance:** High-performance type checking.
- **Ruff:** The modern, fast Python linter and formatter.
- **GitLens:** Superior Git history visualization.

**Pro-tip:** When you open your project folder in VS Code, it will usually ask if you want to use the virtual environment in `.venv`. Always say **Yes**.

---

## 🆘 Common Errors

### `code` command not found
The script attempts to add VS Code to your path. If it fails:
1. Open VS Code.
2. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows).
3. Type: `Shell Command: Install 'code' command in PATH`.
4. Click it and restart your terminal.

### `uv` command not found
Restart your terminal or computer after the script finishes. Windows especially needs a reboot to see new PATH variables.

---
**Protocol:** Pull before you start. Push when you finish.
