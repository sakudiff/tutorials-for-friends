# RStudio Development: The Statistical Deployment Protocol.

Setting up an R environment is often a monument to package version conflict. This guide provides a clinical path to a functional R stack using Git, GitHub, and Quarto. We assume you prefer statistical accuracy over terminal configuration.

## 🚀 The Automated Way (Clinical Execution).

Manual setup is an $O(n)$ waste of analytical time. I have provided scripts to handle the infrastructure for you.

### Windows Deployment.
1. Find `setup-windows.bat` in this folder.
2. Execute via double-click. 
3. The script handles Git, GitHub CLI, R, Quarto, RStudio, and GitHub Desktop. It configures your identity and initiates browser authentication.
4. Skip to Step 4 (Clone Project) upon completion.

### macOS Deployment.
1. Find `setup-macos.command` in this folder.
2. Execute the script. Right-click and select Open if gatekeeper interferes.
3. The script installs Homebrew, the CLI tools, and the full R application stack (GitHub Desktop, Quarto, R, RStudio).
4. Skip to Step 4 (Clone Project) upon completion.

---

## 1. The GitHub Mental Model.

GitHub is a ledger for your code. It prevents the structural collapse of collaborative research that occurs when actors edit files simultaneously.

| Term | Definition |
| :--- | :--- |
| **Repository (Repo)** | The master copy on the server. Your project's central ledger. |
| **Clone** | Creating a local instance of the repo on your laptop. |
| **Pull** | Synchronizing your local copy with the latest server snapshots. |
| **Commit** | A timestamped snapshot of your progress with a descriptive label. |
| **Push** | Uploading your snapshots to the master copy on the server. |

**The protocol. Pull before you start. Push when you finish.**

---

## 2. Infrastructure (Package Managers).

Package managers are the only reliable way to install software without manual error.

### Windows (Winget).
Verify via `winget --version`. If missing, install App Installer from the Microsoft Store or use PowerShell:
```powershell
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

### macOS (Homebrew).
Install via Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Add Homebrew to your PATH using the commands printed at the end of the installation. Verify via `brew --version`. Note: Apple Silicon Macs use `/opt/homebrew` while Intel Macs use `/usr/local`.

---

## 3. Git Identity and Authentication.

Git requires a label for your contributions. Run these commands once per machine using your GitHub credentials.
```bash
git config --global user.name "Your Full Name"
git config --global user.email "youremail@example.com"
```

### GitHub CLI Authentication.
Log in via `gh auth login`:
1. Select GitHub.com and HTTPS.
2. Choose Login with a web browser.
3. Authorize the CLI in your browser. Verify via `gh auth status`.

---

## 4. Cloning the Project Repository.

Cloning creates your local instance. This is a one-time operation.

1. **Accept Invitation.** Check your email and spam folder for the GitHub invitation. You cannot push without accepting.
2. **Execute Clone.** Run `gh repo clone username/project-name` in your Documents folder.
3. **Load Project.** Open RStudio. Go to **File > Open Project** and select the `.Rproj` file in the cloned folder. 

**NO PROJECT = NO GIT TAB.** Opening a single `.qmd` file does not load the version control environment. Always open the project file first.

---

## 5. Daily Workflow.

Operational discipline ensures your code remains functional across the team.

### The Cycle.
1. **Pull.** Synchronize before you touch a single line of code.
2. **Edit.** Modify your `.qmd` or `.R` files.
3. **Stage.** Check the boxes in RStudio's Git tab for the files you wish to include.
4. **Commit.** Provide a descriptive message. "Update" is not a description.
5. **Push.** Upload your progress to the server.

### File Hygiene.
| Rule | ✅ Good | ❌ Bad |
| :--- | :--- | :--- |
| No spaces | `data_cleaning.R` | `data cleaning.R` |
| No special characters | `regression-results.qmd` | `regression (results!).qmd` |
| No "FINAL" markers | `analysis.qmd` | `analysis_v3_FINAL.qmd` |
| Lowercase only | `feature_engineering.R` | `Feature_Engineering.R` |

---

## 6. Quarto and LaTeX Rendering.

The project utilizes Quarto for professional reporting. Rendering to PDF requires a LaTeX distribution.

### TinyTeX.
Run these commands in the RStudio console if you lack a LaTeX distribution:
```r
install.packages("tinytex")
tinytex::install_tinytex()
```
TinyTeX is a lightweight distribution managed directly by RStudio. It avoids the bloat of full TeX installations.

---

## 7. Common Failures (Errata).

| Error | Cause | Fix |
| :--- | :--- | :--- |
| **Git tab missing** | Project not loaded correctly. | Use **File > Open Project** to select the .Rproj file. |
| **Push rejected** | Remote copy is ahead. | Run `git pull` to merge remote changes. |
| **Merge conflict** | Concurrent line edits. | Resolve markers manually in the source file and re-commit. |
| **Permission denied** | Invitation not accepted. | Check your email for the GitHub collaborator invite. |
| **Large file rejected** | File exceeds 100MB. | Remove the large file from history; use .gitignore. |
| **Quarto failed** | LaTeX missing or broken. | Run `tinytex::install_tinytex()` in the R console. |
| **Authentication error** | Session expired. | Run `gh auth login` to refresh credentials. |
| **Git Executable blank** | RStudio PATH blindness. | Go to Tools -> Global Options -> Git/SVN and set the Git path. |

### The Nuclear Option.
If your local repository is corrupted beyond recovery:
1. Backup uncommitted files to your desktop.
2. Delete the project folder entirely.
3. Re-clone via `gh repo clone`.
4. Re-insert your backup files and commit.

---

## 8. Quick Reference Commands.

Open the **Terminal** tab in RStudio (not the Console) to run these.

| Task | Command |
| :--- | :--- |
| Log in | `gh auth login` |
| Status check | `gh auth status` |
| Clone repo | `gh repo clone user/repo` |
| Sync repo | `git pull` |
| Stage all | `git add .` |
| Commit | `git commit -m "msg"` |
| Push | `git push` |
| History | `git log --oneline` |
| PDF Preview | `Cmd/Ctrl + Alt + V` |

---
*Part of the Tutorials for Friends clinical collection.*
