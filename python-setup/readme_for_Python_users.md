# Python Dev Setup Guide — uv + VS Code + GitHub

> **Who this is for:** Groupmates & Friends setting up a modern Python 3.12+ environment for data science or software projects. Assumes basic terminal familiarity but no prior Git or Python environment experience required.
>
> **The Stack:** `uv` (Python manager), `VS Code` (IDE), `Git`, `GitHub CLI`.

---

## Table of Contents

0. [**The Automated Way (Fastest)**](#-the-automated-way-fastest)
1. [What Is GitHub and Why Are We Using It](#1-what-is-github-and-why-are-we-using-it)
2. [Step 0 — Install Package Managers (Homebrew & Winget)](#2-step-0--install-package-managers-homebrew--winget)
3. [Step 1 — Install Git on Your Computer](#3-step-1--install-git-on-your-computer)
4. [Step 2 — Tell Git Who You Are](#4-step-2--tell-git-who-you-are)
5. [Step 3 — Install GitHub CLI and Log In](#5-step-3--install-github-cli-and-log-in)
6. [Step 4 — Install uv and Python](#6-step-4--install-uv-and-python)
7. [Step 5 — Install VS Code, Extensions, and LaTeX](#7-step-5--install-vs-code-and-extensions)
8. [Step 6 — Clone the Repository and Open It](#8-step-6--clone-the-repository-and-open-it)
9. [Step 7 — Your Daily Workflow (Pull, Edit, Commit, Push)](#9-step-7--your-daily-workflow-pull-edit-commit-push)
10. [Working with Python Files and Virtual Environments](#10-working-with-python-files-and-virtual-environments)
11. [Common Errors and How to Fix Them](#11-common-errors-and-how-to-fix-them)
12. [Quick Reference — Commands You May Need](#12-quick-reference--commands-you-may-need)

---

## 🚀 The Automated Way (Fastest)

If you don't want to run all these commands manually, I have created scripts that do it for you.

### Windows Users

1. Find the file named `setup-windows.bat` in this folder.
2. **Double-click** it.
3. The script will automatically:
   - Check that `winget` is available
   - Install Git, GitHub CLI, `uv` (the Python manager), and Visual Studio Code
   - Install MiKTeX (the Windows LaTeX distribution with automatic package management)
   - Install VS Code extensions: Python, Pylance, Ruff, GitLens, Even Better TOML, GitHub Pull Requests, and **LaTeX Workshop**
   - Configure LaTeX Workshop to auto-compile `.tex` files on save
   - Ask for your **full name and GitHub email** to set up your Git identity
   - Open your browser so you can **log in to GitHub**
   - Install Python 3.12 via `uv`
4. When it finishes, it will print your installed versions in a summary.

After the script completes, **skip to [Step 6 — Clone the Repository](#8-step-6--clone-the-repository-and-open-it)**. The script handles everything before that.

### Mac Users

1. Find the file named `setup-macos.command` in this folder.
2. **Double-click** it.
3. If it says it "cannot be opened because it is from an unidentified developer," right-click it and select **Open**.
4. The script will automatically:
   - Install Homebrew (and add it to your PATH)
   - Install Git, GitHub CLI, `uv` (the Python manager), and Visual Studio Code
   - Install Homebrew (and add it to your PATH)
   - Install Git, GitHub CLI, `uv` (the Python manager), and Visual Studio Code
   - Install MacTeX (the full offline LaTeX distribution, ~3.5 GB — needed for PDF rendering)
   - Install VS Code extensions: Python, Pylance, Ruff, GitLens, Even Better TOML, GitHub Pull Requests, and **LaTeX Workshop**
   - Configure LaTeX Workshop to auto-compile `.tex` files on save
   - Ask for your **full name and GitHub email** to set up your Git identity
   - Open your browser so you can **log in to GitHub**
   - Install Python 3.12 via `uv`
5. When it finishes, it will print your installed versions in a summary.

After the script completes, **skip to [Step 6 — Clone the Repository](#8-step-6--clone-the-repository-and-open-it)**. The script handles everything before that.

---

## 1. What Is GitHub and Why Are We Using It

Think of GitHub as Google Drive for code, but smarter. When multiple people edit the same file in Google Drive simultaneously, things break. GitHub solves this by tracking every single change ever made to every file, by every person, with a timestamp and an author label. If something breaks, you can roll back. If two people edit the same file, GitHub tries to merge both changes automatically.

Here is the mental model you need:

**Repository (Repo):** The project folder that lives on GitHub's servers. Think of it as the master copy.

**Clone:** Downloading a full copy of that master folder onto your own laptop.

**Pull:** Fetching the latest changes other people pushed, so your copy stays up to date. You do this before starting any work session.

**Commit:** Taking a snapshot of your current changes with a short message describing what you did. Think of it like saving a named version of your file.

**Push:** Uploading your committed snapshots to the master copy on GitHub so everyone else can see your work.

**The golden rule: Pull before you start. Push when you finish.**

---

## 2. Step 0 — Install Package Managers (Homebrew & Winget)

Package managers let you install and update software from the terminal in one command. This is the fastest and most reliable way to set up your environment.

### Windows (Winget)

`winget` is Windows' official package manager. It is included by default on Windows 10 (1809+) and Windows 11. To verify it, open **Command Prompt** and run:

```cmd
winget --version
```

If the command is not found, install it via the Microsoft Store (search for "App Installer") or via PowerShell:

```powershell
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

### Mac (Homebrew)

Homebrew is the standard package manager for Mac. Open **Terminal** (press `Cmd + Space`, type `Terminal`, press Enter) and run:

**1. Install Homebrew:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The installer will ask for your Mac login password. Type it and press Enter — nothing will appear on screen while you type, that is normal.

**2. After it finishes, add Homebrew to your PATH.** The installer prints two lines at the end under "Next steps". Copy and run them. They look like this (run both lines, one at a time):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> [!IMPORTANT]
> **Copy those lines from YOUR terminal screen, not from this guide.** The exact path depends on your Mac's chip. Apple Silicon Macs (M1/M2/M3/M4) use `/opt/homebrew`. Older Intel Macs use `/usr/local`. The installer always prints the correct version for your machine — scroll up to find it under the "Next steps" heading.

**3. Confirm Homebrew is working:**

```bash
brew --version
```

You should see something like `Homebrew 4.x.x`. If you do, move on to Step 1.

---

## 3. Step 1 — Install Git on Your Computer

Git is the underlying version control engine. GitHub is just a website that hosts repos powered by Git. You need Git installed locally before anything else works.

### Windows

Open **Command Prompt** (Start Menu → search "Command Prompt") and run:

**1. Install Git using winget:**

```cmd
winget install --id Git.Git -e --source winget
```

Accept any prompts that appear. When it finishes, **close and reopen** Command Prompt.

**2. Verify the install worked:**

```cmd
git --version
```

You should see something like `git version 2.44.0.windows.1`.

> [!TIP]
> **Still getting "command not found" after reopening Command Prompt?** Restart your computer. Windows sometimes needs a full reboot to register newly installed programs in the system PATH.

### Mac

Open **Terminal** and run:

**1. Check if Git is already installed:**

```bash
git --version
```

If it prints a version number, skip to Step 2.

If Git is not installed:

**Option A — Install via Xcode Command Line Tools:**

```bash
xcode-select --install
```

A popup will appear. Click **Install** and wait 5–15 minutes. Confirm with `git --version`.

**Option B — Install via Homebrew (if you completed Step 0):**

```bash
brew install git
```

This is faster and gives a more up-to-date version. Confirm with `git --version` when done.

---

## 4. Step 2 — Tell Git Who You Are

Git needs your name and email to label every commit with your identity. This only needs to be done once per computer.

Open **Terminal** (Mac) or **Command Prompt** (Windows) and run these two commands, replacing the placeholder text with your actual name and the email you used to sign up for GitHub:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "youremail@example.com"
```

To confirm it worked:

```bash
git config --global --list
```

You should see `user.name` and `user.email` listed.

---

## 5. Step 3 — Install GitHub CLI and Log In

GitHub CLI (`gh`) is an official tool made by GitHub. It handles authentication — once you log in with `gh auth login`, all `git push`, `git pull`, and `git clone` operations work without passwords or tokens.

### 5a — Install GitHub CLI

#### Windows

```cmd
winget install --id GitHub.cli
```

Close and reopen Command Prompt, then verify:

```cmd
gh --version
```

> [!TIP]
> **`gh` still not found after reopening?** Restart your computer. This fixes the majority of Windows PATH issues after installs.

#### Mac

```bash
brew install gh
```

Verify with:

```bash
gh --version
```

### 5b — Log In to GitHub via CLI

Run:

```bash
gh auth login
```

Answer the prompts as follows:

1. **Where do you use GitHub?** → Select **GitHub.com** and press Enter.
2. **What is your preferred protocol for Git operations?** → Select **HTTPS** and press Enter.
3. **How would you like to authenticate GitHub CLI?** → Select **Login with a web browser** and press Enter.
4. GitHub CLI will display a one-time code (e.g., `XXXX-XXXX`) and open your browser. **Copy that code**, paste it into the browser page that opens, and click **Authorize GitHub CLI**.
5. You may be asked for your GitHub password to confirm.

Back in your terminal, you should see: `✓ Authentication complete.`

Verify it worked:

```bash
gh auth status
```

> [!TIP]
> **Success check:** If `gh auth status` prints something like `Logged in to github.com as [your-username]`, you are done. Move to Step 4. If it says "You are not logged into any GitHub hosts", run `gh auth login` again from the top.

---

## 6. Step 4 — Install uv and Python

### What Is uv and Why Are We Using It

`uv` is a modern Python package and project manager written in Rust. It replaces `pip`, `venv`, `pyenv`, and `conda` with a single, significantly faster tool. The key advantages:

- **Speed:** Installing packages is 10–100x faster than pip.
- **Reproducibility:** `uv.lock` files ensure everyone on the team installs the exact same package versions.
- **Isolation:** Each project gets its own virtual environment automatically.
- **Python management:** `uv` can install and switch between Python versions without needing pyenv or Anaconda.

You do not need to install Python separately — `uv` manages it for you.

### Install uv

#### Windows

```cmd
winget install --id astral-sh.uv
```

Close and reopen Command Prompt, then verify:

```cmd
uv --version
```

#### Mac

```bash
brew install uv
```

Verify with:

```bash
uv --version
```

### Install Python 3.12

Once `uv` is installed, install Python itself:

```bash
uv python install 3.12
```

Confirm it worked:

```bash
uv python list
```

You should see `3.12.x` listed.

---

## 7. Step 5 — Install VS Code, Extensions, and LaTeX

### Install VS Code

#### Windows

```cmd
winget install --id Microsoft.VisualStudioCode
```

#### Mac

```bash
brew install --cask visual-studio-code
```

Verify by opening **Visual Studio Code** from your Applications folder (Mac) or Start Menu (Windows).

### 7a — Install the `code` Command (Mac / First-Time Setup)

After installing VS Code, you need to enable the `code` command in your terminal so you can open projects from the command line.

1. Open VS Code.
2. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows).
3. Type `Shell Command: Install 'code' command in PATH` and click it.
4. Restart your terminal.

Verify with:

```bash
code --version
```

### 7b — Install Extensions

Open your terminal and run each line:

```bash
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension charliermarsh.ruff
code --install-extension eamodio.gitlens
code --install-extension GitHub.vscode-pull-request-github
code --install-extension tamasfe.even-better-toml
code --install-extension james-yu.latex-workshop
```

| Extension | Purpose |
|---|---|
| `ms-python.python` | Core Python language support |
| `ms-python.vscode-pylance` | High-performance type checking and autocomplete |
| `charliermarsh.ruff` | Fast Python linter and formatter (replaces Black + Flake8) |
| `eamodio.gitlens` | Git history and blame annotations inside VS Code |
| `GitHub.vscode-pull-request-github` | Manage pull requests without leaving VS Code |
| `tamasfe.even-better-toml` | Syntax highlighting for `pyproject.toml` |
| `james-yu.latex-workshop` | Full LaTeX IDE: compile, preview PDF, syntax highlighting, auto-complete |

### 7c — Select the Python Interpreter in VS Code

When you open a project folder that contains a `.venv` folder (created by `uv venv`), VS Code will usually ask:

> "We noticed a virtual environment at .venv. Do you want to select it?"

Always click **Yes**. If it does not ask automatically:

1. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows).
2. Type `Python: Select Interpreter`.
3. Choose the option that shows `.venv` in its path (e.g., `.venv/bin/python`).

### 7d — LaTeX: Install Distribution and Configure Auto-Compile

LaTeX Workshop needs an actual LaTeX distribution installed on your machine to compile `.tex` files into PDFs. The setup scripts install the right one for your OS automatically. If you skipped the script or need to install it manually:

#### Mac — MacTeX

MacTeX is the full TeX Live distribution for macOS. It includes `pdflatex`, `latexmk`, and every common package so documents compile offline without any "missing package" errors.

```bash
brew install --cask mactex-no-gui
```

This is ~3.5 GB. After it finishes, restart your terminal so `/Library/TeX/texbin` is in your PATH. Confirm with:

```bash
pdflatex --version
```

#### Windows — MiKTeX

MiKTeX is the standard Windows LaTeX distribution. Its key feature is automatic package installation on demand — if a document needs a package you do not have, MiKTeX downloads it silently when you first compile.

```cmd
winget install --id MiKTeX.MiKTeX
```

After installing, restart your terminal and confirm with:

```cmd
pdflatex --version
```

> [!TIP]
> On first compile after a fresh MiKTeX install, you may see a dialog asking permission to install missing packages. Click **Install** and allow it. After that first run, everything is cached locally and works fully offline.

#### Configure VS Code to Auto-Compile on Save

The setup scripts configure this automatically. If you need to set it manually:

1. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows).
2. Type `Preferences: Open User Settings (JSON)` and press Enter.
3. Add these two lines inside the outermost `{}`:

```json
"latex-workshop.latex.autoBuild.run": "onSave",
"latex-workshop.view.pdf.viewer": "tab"
```

Save the file. From now on, every time you save a `.tex` file, VS Code will compile it and update the PDF preview automatically.

#### Using the LaTeX PDF Preview

1. Open any `.tex` file in VS Code.
2. Click the **Preview** button (the split-view icon at the top-right of the editor) — or press `Ctrl + Alt + V` (Windows) / `Cmd + Alt + V` (Mac).
3. A PDF preview opens in a side-by-side tab. It updates automatically every time you save.

You can also click anywhere in the PDF preview and press `Ctrl + Click` (Windows) or `Cmd + Click` (Mac) to jump to the corresponding line in the `.tex` source (SyncTeX forward/backward sync).

#### What to Commit

| Commit these | Do not commit these |
|---|---|
| `.tex` source files | `.pdf` output (unless required by the project lead) |
| `.bib` bibliography files | `.aux`, `.log`, `.out`, `.toc`, `.fls`, `.fdb_latexmk` |
| Images used in the document | `.synctex.gz` |

Add this block to your `.gitignore` to automatically exclude LaTeX build artifacts:

```gitignore
# LaTeX build artifacts
*.aux
*.bbl
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.synctex.gz
*.toc
```

---

## 8. Step 6 — Clone the Repository and Open It

Cloning creates a local copy of the repo on your laptop. You only do this once.

The project lead will share the repository name with you in the format `username/project-name`.

> [!IMPORTANT]
> **Accept your email invitation before you clone.** When the project lead adds you as a collaborator, GitHub sends you an email invite. Check your inbox — and spam folder — for an email from GitHub and click **Accept invitation**. You will not be able to push changes until you accept.

### Option A — Clone using GitHub CLI (recommended)

Open your terminal, navigate to your Documents folder, then clone the repo:

```bash
# 1. Go to your Documents folder
cd Documents

# 2. Clone the repo — replace username/project-name with the actual name
gh repo clone username/project-name

# 3. Navigate into the folder
cd project-name

# 4. Open it in VS Code
code .
```

VS Code will open the project folder. The **Source Control** icon in the left sidebar (looks like a branch) is your Git interface.

### Option B — Clone using the standard Git command

If you have the repository URL (e.g., `https://github.com/username/project-name.git`):

1. Open your terminal.
2. Navigate to where you want the folder (e.g., `cd Documents`).
3. Run:
   ```bash
   git clone <URL>
   cd project-name
   code .
   ```

### Option C — Clone using VS Code's GUI

1. Open VS Code.
2. Press `Ctrl + Shift + P` (Windows) or `Cmd + Shift + P` (Mac).
3. Type `Git: Clone` and press Enter.
4. Paste the repository URL and choose a folder to save it in.
5. VS Code will ask if you want to open the cloned repo. Click **Open**.

> [!IMPORTANT]
> **Do not put the project folder inside OneDrive, Dropbox, or iCloud.** Cloud sync tools conflict with Git and cause corrupted repos. Keep the project folder in your regular Documents folder.

---

## 9. Step 7 — Your Daily Workflow (Pull, Edit, Commit, Push)

Every time you work on the project, follow this exact sequence.

### Before You Start: Pull

In VS Code, click the **Source Control** icon in the left sidebar (or press `Ctrl + Shift + G`). Click the **...** menu at the top of the panel and select **Pull**. This fetches any changes your teammates pushed since you last worked. If you skip this step, your Push will likely be rejected.

Or in the terminal:

```bash
git pull
```

### While You Work: Edit Files Normally

Open and edit `.py`, `.ipynb`, or any other files as you normally would. Nothing changes here.

### When You Are Done: Stage, Commit, Push

> [!CAUTION]
> **Large file landmine.** GitHub will reject your entire push if any single file exceeds 100MB. This most commonly happens when someone accidentally stages a large dataset (`.csv`, `.parquet`) or model weights. Before staging, check your file sizes. As a rule: **commit your code — not raw data files or model weights.**

**Using VS Code's Source Control panel:**

1. Click the **Source Control** icon.
2. You will see a list of changed files under **Changes**. Click the **+** icon next to each file you want to stage (or click the **+** next to "Changes" to stage all).
3. Type a short, descriptive message in the **Message** box at the top.
4. Click the **✓ Commit** button.
5. Click **Sync Changes** (or the **Push** button) to upload to GitHub.

**Using the terminal:**

```bash
# 1. Pull latest changes first (always do this before anything else)
git pull

# 2. Stage all modified files
git add .

# 3. Commit with a descriptive message
git commit -m "Add data cleaning pipeline for Q3 dataset"

# 4. Push to GitHub
git push
```

### Commit Message Rules

| | Commit Message | Why |
|---|---|---|
| ✅ | `Add logistic regression baseline model` | Specific and traceable |
| ✅ | `Fix NaN handling in feature engineering step` | The team knows exactly what changed |
| ✅ | `Update data loader to support Parquet format` | Understandable months later |
| ❌ | `update` | Update what? Nobody knows. |
| ❌ | `asdfasdf` | Not acceptable |
| ❌ | `final version` | There is no "final" — commit history is the tracker |
| ❌ | `changes` | What changes? |

### Summary

```text
Pull → Edit → Stage → Commit (with message) → Push
```

Do this every single work session. Small, frequent commits are far easier to manage than one massive commit at the end.

### Clean File Naming Rules

> [!IMPORTANT]
> **Bad file names break imports and make the commit history unreadable.** Follow these rules for every file in the project.

| Rule | ✅ Good | ❌ Bad |
|---|---|---|
| No spaces | `data_cleaning.py` | `data cleaning.py` |
| No special characters | `train-model.py` | `train (model!).py` |
| No "FINAL" or version numbers | `analysis.py` | `analysis_FINAL2_v3.py` |
| Lowercase preferred | `feature_engineering.py` | `Feature Engineering V2.py` |

---

## 10. Working with Python Files and Virtual Environments

### What Is a Virtual Environment

A virtual environment is an isolated copy of Python with its own set of packages. It means you can have Project A using `pandas 2.0` and Project B using `pandas 1.5` on the same machine without them conflicting. Every project should have its own virtual environment.

With `uv`, this is nearly automatic.

### Setting Up a New Project

```bash
# 1. Create and enter the project folder
mkdir my-project
cd my-project

# 2. Initialize the project (creates pyproject.toml — the project's config file)
uv init

# 3. Create a virtual environment inside the folder
uv venv

# 4. Activate the virtual environment
# Mac/Linux:
source .venv/bin/activate
# Windows (Command Prompt):
.venv\Scripts\activate
# Windows (PowerShell):
.venv\Scripts\Activate.ps1
```

Your terminal prompt will show `(.venv)` at the front when the environment is active.

### If You Are Joining an Existing Project

When you clone a project that already has a `pyproject.toml` and `uv.lock`, run this to install all dependencies in one command:

```bash
uv sync
```

This reads the lock file and installs the exact same package versions everyone else is using.

### Installing Packages

Do not use `pip install`. Use `uv add` instead:

```bash
uv add pandas numpy matplotlib scikit-learn
```

This installs the package, adds it to `pyproject.toml`, and updates `uv.lock`. **Commit both files** after adding packages so your teammates' environments stay in sync.

### Running Scripts

```bash
# Run directly (uv uses the project's virtual environment automatically)
uv run main.py

# Or activate first, then run normally
source .venv/bin/activate
python main.py
```

### Running Jupyter Notebooks

```bash
uv add --dev jupyterlab
uv run jupyter lab
```

### Removing a Package

```bash
uv remove package-name
```

### What to Commit

| Commit these | Do not commit these |
|---|---|
| `.py`, `.ipynb` source files | `.venv/` folder (it's huge and auto-generated) |
| `pyproject.toml` | Raw data files over a few MB |
| `uv.lock` | Model weights, `.pkl` files |
| Config files, READMEs | `__pycache__/`, `.pyc` files |

The `.gitignore` file in the repo should already exclude `.venv/`, `__pycache__/`, and similar folders. If something you did not intend to commit keeps showing up in your Git panel, check `.gitignore`.

---

## 11. Common Errors and How to Fix Them

### `git` command not found after installing

**Cause:** The terminal session was opened before the install, so the new binary is not in PATH yet.

**Fix:** Close your terminal completely and open a fresh one. On Windows, a full computer restart is often needed. Run `git --version` again.

### `gh` command not found after installing

**Cause:** Same PATH issue as above.

**Fix:** Close and reopen your terminal. If still missing on Windows, restart your computer.

### `uv` command not found after installing

**Cause:** Same PATH issue, especially common on Windows.

**Fix:** Close and reopen your terminal. On Windows, restart your computer. Then run `uv --version` to confirm.

### `code` command not found in terminal

**Cause:** VS Code's CLI was not added to your PATH.

**Fix:**
1. Open VS Code.
2. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows).
3. Type: `Shell Command: Install 'code' command in PATH`
4. Click it and restart your terminal.

### Push rejected — "Updates were rejected because the remote contains work that you do not have locally"

**Cause:** Someone pushed changes after you last pulled, so your local copy is behind.

**Fix:** Run `git pull` first. Git will attempt to merge the remote changes with yours. If there are no conflicts, the merge happens automatically and you can push immediately after.

### Merge Conflict

**Cause:** You and a teammate both edited the same lines of the same file.

**Fix:** Git will mark the conflict inside the file with symbols like `<<<<<<`, `=======`, and `>>>>>>`. Open the file, find these markers, manually decide which version to keep (or combine both), delete the markers, save the file, then stage and commit. VS Code highlights merge conflicts in the editor with Accept/Reject buttons — use those if you prefer a visual interface.

### "Please tell me who you are" error

**Cause:** Git identity was not configured (Step 2 was skipped).

**Fix:** Run the two `git config --global` commands from **Step 2** in your terminal.

### "Authentication failed" or credential error when pushing or pulling

**Cause:** You are not logged in via GitHub CLI, or the session expired.

**Fix:** Run `gh auth status` to check. If not logged in, run `gh auth login` and follow the prompts from **Step 5b**.

### "CRLF will be replaced by LF" warning (Windows)

**Cause:** Windows uses different line endings than Mac/Linux. This is a warning, not an error.

**Fix:** This is harmless and can be ignored. To silence it permanently:

```cmd
git config --global core.autocrlf true
```

### Python interpreter not found in VS Code

**Cause:** VS Code cannot see the virtual environment for this project, or you opened a single `.py` file instead of the project folder.

**Fix:**
1. Make sure you opened the **folder** in VS Code (`File > Open Folder`), not just a single file.
2. Press `Cmd + Shift + P` / `Ctrl + Shift + P` → `Python: Select Interpreter`.
3. Choose the option ending in `.venv/bin/python` (Mac) or `.venv\Scripts\python.exe` (Windows).
4. If `.venv` is missing, run `uv venv` in the terminal from the project root, then repeat.

### `uv sync` fails with "No pyproject.toml found"

**Cause:** You are not in the project root directory, or the repo does not have a `pyproject.toml` yet.

**Fix:** Make sure you are inside the cloned project folder (`cd project-name`). If the project uses requirements.txt instead of pyproject.toml, run `uv pip install -r requirements.txt` instead.

### Cannot push — "Permission denied" or "Repository not found"

**Cause:** Your GitHub account was not added as a collaborator, or you have not accepted the invite.

**Fix:** Check your email (including spam) for a GitHub invite and click **Accept invitation**. Then verify with `gh auth status`. If you cannot find the email, message the project lead to resend from **Settings > Collaborators** in the repo.

### LaTeX Workshop says "Recipe terminated with fatal error"

**Cause:** The LaTeX distribution (`pdflatex`) is not installed or not in PATH.

**Fix:** Confirm with `pdflatex --version` in your terminal. If the command is not found, install MacTeX (Mac) or MiKTeX (Windows) per **Step 7d** and restart VS Code completely.

### PDF preview is blank or does not update

**Cause:** The document has a compile error, or the PDF viewer setting is wrong.

**Fix:**
1. Check the **LaTeX Workshop** output panel in VS Code: click **View > Output** and select **LaTeX Workshop** from the dropdown. Scroll to find the error.
2. If the viewer is not showing, press `Ctrl + Alt + V` (Windows) or `Cmd + Alt + V` (Mac) to open the preview.
3. Confirm your settings have `"latex-workshop.view.pdf.viewer": "tab"` — see **Step 7d**.

### "Package X not found" error on Mac

**Cause:** The document requires a TeX package that is not included in BasicTeX. This does not happen with the full MacTeX install.

**Fix:** Install the missing package via `tlmgr` in your terminal:

```bash
sudo tlmgr install package-name
```

If you used the setup script (which installs the full `mactex-no-gui`), you should not see this error.

### MiKTeX shows a package install dialog on first compile (Windows)

**Cause:** MiKTeX installs packages on demand — this is expected behaviour on first use.

**Fix:** Click **Install** and wait. The package is downloaded once and cached permanently. Subsequent compiles work fully offline.

### "Recipe terminated" after MiKTeX install — `latexmk` not found

**Cause:** `latexmk` is a required build tool that MiKTeX may not install by default.

**Fix:** Open MiKTeX Console from your Start Menu, go to **Packages**, search for `latexmk`, and install it. Then restart VS Code.

### The Nuclear Option — Starting Over When Everything Is Broken

**When to use this:** Your local copy is so broken that neither you nor the project lead can figure out how to fix it, and you just need a clean slate.

> [!CAUTION]
> This will permanently discard any uncommitted local changes. Before you delete anything, copy every file you have edited out of the project folder to your Desktop as a backup.

**Steps:**
1. Copy any modified files out of the project folder onto your Desktop.
2. Delete the entire project folder.
3. Go back to **Step 6 (Clone)** and clone the repo fresh.
4. Copy your backup files from the Desktop back into the newly cloned folder.
5. Stage, commit, and push normally.

---

## 12. Quick Reference — Commands You May Need

Open a terminal (VS Code's built-in terminal works: press `` Ctrl + ` `` or go to **Terminal > New Terminal**).

| What you want to do | Command |
|---|---|
| Check Git is installed | `git --version` |
| Check GitHub CLI is installed | `gh --version` |
| Check uv is installed | `uv --version` |
| Check your GitHub login status | `gh auth status` |
| Log in to GitHub | `gh auth login` |
| Clone a repository | `gh repo clone username/repo-name` |
| Open current folder in VS Code | `code .` |
| See current status of files | `git status` |
| Pull latest changes | `git pull` |
| Stage all modified files | `git add .` |
| Commit staged files | `git commit -m "Your message"` |
| Push to GitHub | `git push` |
| See commit history | `git log --oneline` |
| See what changed in a file | `git diff filename.py` |
| Discard local changes to a file (destructive) | `git checkout -- filename.py` |
| Install project dependencies | `uv sync` |
| Add a package | `uv add package-name` |
| Remove a package | `uv remove package-name` |
| Run a Python script | `uv run script.py` |
| List installed Python versions | `uv python list` |
| Open Jupyter Lab | `uv run jupyter lab` |
| Check LaTeX is installed | `pdflatex --version` |
| Compile a .tex file manually | `pdflatex document.tex` |
| Full build with bibliography | `latexmk -pdf document.tex` |
| Install a missing TeX package (Mac) | `sudo tlmgr install package-name` |
| Open LaTeX PDF preview in VS Code | `Ctrl+Alt+V` (Win) / `Cmd+Alt+V` (Mac) |

---

## Quick Checklist Before Every Work Session

- [ ] Terminal is open and you are inside the project folder (`cd project-name`)
- [ ] Run `git pull` before touching any files
- [ ] Virtual environment is active (prompt shows `(.venv)`) or you are using `uv run`
- [ ] Wrote a meaningful commit message before committing
- [ ] Ran `git push` after committing

---

*If something breaks and none of the above fixes it, try the Nuclear Option in Section 11. If that also fails, message the project lead with a screenshot of the error.*
