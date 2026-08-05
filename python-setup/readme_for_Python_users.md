# Python Development: The Automated Deployment Protocol.

Setting up a Python environment is traditionally a monument to dependency hell. This guide provides a clinical path to a modern stack using `uv`, Visual Studio Code, and the GitHub CLI. We eliminate the friction of legacy package managers.

## 🚀 The Automated Way (Clinical Execution).

Manual installation is an $O(n)$ waste of analytical time. I have provided scripts to automate the drudgery.

### Windows Deployment.
1. Find `setup-windows.bat` in this directory.
2. Execute the script via double-click.
3. The script handles Git, GitHub CLI, `uv`, and Visual Studio Code. It installs MiKTeX for LaTeX rendering and configures VS Code extensions. It requests your Git identity and initiates GitHub browser authentication.
4. Skip to Step 6 (Clone Repository) upon completion.

### macOS Deployment.
1. Find `setup-macos.command` in this directory.
2. Execute the script. Right-click and select Open if gatekeeper interferes.
3. The script installs Homebrew, Git, GitHub CLI, `uv`, and VS Code. It installs the MacTeX distribution (~3.5 GB) for PDF rendering and configures your development environment.
4. Skip to Step 6 (Clone Repository) upon completion.

---

## 1. The GitHub Mental Model.

GitHub is a ledger for code. It prevents the structural collapse that occurs when multiple actors edit a single file. 

| Term | Definition |
| :--- | :--- |
| **Repository (Repo)** | The master copy on the server. Your project's central ledger. |
| **Clone** | Creating a local instance of the repo on your machine. |
| **Pull** | Synchronizing your local copy with the latest server snapshots. |
| **Commit** | A timestamped snapshot of your local progress with a descriptive label. |
| **Push** | Uploading your snapshots to the master copy on the server. |

**The protocol. Pull before you start. Push when you finish.**

---

## 2. Infrastructure (Package Managers).

Package managers are the only reliable way to install software without manual error.

### Windows (Winget).
Verify winget exists via `winget --version`. If missing, install App Installer from the Microsoft Store or use PowerShell:
```powershell
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

### macOS (Homebrew).
Install via Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Add Homebrew to your PATH using the commands printed at the end of the installation. Verify via `brew --version`. Note: Apple Silicon Macs use `/opt/homebrew` while Intel Macs use `/usr/local`. The installer will specify which.

---

## 3. Git Core Installation.

Git is the underlying version control engine. It is required infrastructure.

### Windows.
Run `winget install --id Git.Git -e --source winget`. Restart your terminal to register the binary. If "command not found" persists, a full system reboot is necessary.

### macOS.
Check via `git --version`. If missing, use `xcode-select --install` or `brew install git`.

---

## 4. Git Identity Configuration.

Git requires a label for every commit. Run these commands once per machine:
```bash
git config --global user.name "Your Full Name"
git config --global user.email "youremail@example.com"
```

---

## 5. GitHub CLI and Authentication.

The GitHub CLI (`gh`) handles the authentication tax. It replaces legacy passwords and tokens.

### Installation.
- **Windows.** `winget install --id GitHub.cli`.
- **macOS.** `brew install gh`.

### Authentication Protocol.
Run `gh auth login` and follow these steps:
1. Select GitHub.com and HTTPS.
2. Choose Login with a web browser.
3. Paste the provided code into the browser. Verify via `gh auth status`.

---

## 6. The uv Python Stack.

`uv` is a modern replacement for the bloated legacy stack (pip, venv, pyenv, conda). It is significantly faster.

### Installation.
- **Windows.** `winget install --id astral-sh.uv`.
- **macOS.** `brew install uv`.

### Python 3.12 Deployment.
Run `uv python install 3.12`. Verify via `uv python list`.

---

## 7. IDE and Professional Documentation.

### Visual Studio Code.
Install the IDE:
- **Windows.** `winget install --id Microsoft.VisualStudioCode`.
- **macOS.** `brew install --cask visual-studio-code`.

Enable the `code` command in your PATH via the Command Palette (`Cmd/Ctrl + Shift + P`) -> `Shell Command: Install 'code' command in PATH`.

### Extensions.
Use the `code --install-extension` command for these diagnostic tools:
- `ms-python.python` (Core Support)
- `ms-python.vscode-pylance` (Type Checking)
- `charliermarsh.ruff` (Linter/Formatter)
- `eamodio.gitlens` (History)
- `GitHub.vscode-pull-request-github` (PR Management)
- `james-yu.latex-workshop` (LaTeX IDE)

### LaTeX Distributions.
- **macOS.** MacTeX (~3.5 GB). `brew install --cask mactex-no-gui`.
- **Windows.** MiKTeX. `winget install --id MiKTeX.MiKTeX`.

Configure auto-build in `settings.json`:
```json
{
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab"
}
```

### LaTeX Asset Management.
| Commit these | Ignore these (.gitignore) |
| :--- | :--- |
| .tex source files | .pdf output (unless specified) |
| .bib bibliographies | .aux, .log, .out, .toc, .fls |
| Image assets | .synctex.gz, .fdb_latexmk |

---

## 8. Cloning the Repository.

Cloning creates your local instance. This is a one-time operation.

1. **Invitation.** Accept your email invitation before cloning.
2. **Execute Clone.** Run `gh repo clone username/project-name` in your Documents folder.
3. **Load.** Open the folder in VS Code using `code .`.

**Warning.** Do not place the project inside OneDrive, Dropbox, or iCloud. Cloud sync conflicts with Git metadata and causes repository corruption.

---

## 9. Daily Workflow.

Operational discipline is the difference between a project and a disaster.

### The Cycle.
1. **Pull.** `git pull`. Synchronize before editing.
2. **Edit.** Modify your source files.
3. **Stage.** Add changes via the Git panel or `git add .`.
4. **Commit.** Provide a descriptive message. `git commit -m "Message"`.
5. **Push.** Upload your progress. `git push`.

### File Hygiene.
| Rule | ✅ Good | ❌ Bad |
| :--- | :--- | :--- |
| No spaces | `data_cleaning.py` | `data cleaning.py` |
| No special characters | `train-model.py` | `train (model!).py` |
| No "FINAL" markers | `analysis.py` | `analysis_FINAL_v2.py` |
| Lowercase only | `feature_engineering.py` | `Feature_Engineering.py` |

---

## 10. Virtual Environments and Project Management.

Each project requires isolation to prevent dependency contamination.

- **Initialization.** Run `uv init` in a new project.
- **Sync.** Run `uv sync` to install dependencies from `pyproject.toml`.
- **Add.** Use `uv add package-name` to install new libraries.
- **Run.** Execute via `uv run script.py`.

---

## 11. Common Failures (Errata).

| Error | Cause | Fix |
| :--- | :--- | :--- |
| **Command not found** | Stale PATH environment. | Restart your terminal or reboot (Windows). |
| **Push rejected** | Remote copy is ahead. | Run `git pull` to merge remote changes. |
| **Merge conflict** | Concurrent line edits. | Resolve markers manually in VS Code and re-commit. |
| **Permission denied** | Invitation not accepted. | Check your email for the GitHub collaborator invite. |
| **Large file rejected** | File exceeds 100MB. | Remove the large file from history; use .gitignore. |
| **Interpreter missing** | VS Code is blind to .venv. | Use `Python: Select Interpreter` and point to .venv. |
| **LaTeX Recipe Failed** | Distribution missing. | Confirm `pdflatex --version` exists in terminal. |
| **PDF Preview Blank** | Compilation error. | Check the LaTeX Workshop output panel for errors. |
| **uv sync fails** | Missing pyproject.toml. | Ensure you are in the project root directory. |
| **Authentication failed** | Session expired. | Run `gh auth login` to refresh credentials. |

### The Nuclear Option.
If your local repository is corrupted beyond recovery:
1. Backup uncommitted files to your desktop.
2. Delete the project folder entirely.
3. Re-clone via `gh repo clone`.
4. Re-insert your backup files and commit.

---

## 12. Quick Reference Commands.

| Task | Command |
| :--- | :--- |
| Log in | `gh auth login` |
| Status check | `gh auth status` |
| Clone repo | `gh repo clone user/repo` |
| Sync repo | `git pull` |
| Stage all | `git add .` |
| Commit | `git commit -m "msg"` |
| Push | `git push` |
| Install deps | `uv sync` |
| Add package | `uv add name` |
| Run script | `uv run script.py` |
| Open Jupyter | `uv run jupyter lab` |
| LaTeX Preview | `Cmd/Ctrl + Alt + V` |

---
*Part of the Tutorials for Friends clinical collection.*
