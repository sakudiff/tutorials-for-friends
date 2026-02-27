# Group Project - GitHub Setup Guide for RStudio Users

> **Who this is for:** Aaron's groupmates using RStudio on Windows or Mac who have never used Git, GitHub, or any version control before. Follow every step in order and do not skip anything.
> 
> **Who this is NOT for:** 2nd Year Computer Science Students

---

## Table of Contents

0. [**The Automated Way (Fastest)**](#-the-automated-way-fastest)
1. [What Is GitHub and Why Are We Using It](#1-what-is-github-and-why-are-we-using-it)
2. [Step 0 - Install Package Managers (Homebrew & Winget)](#2-step-0--install-package-managers-homebrew--winget)
3. [Step 1 - Install Git on Your Computer](#3-step-1--install-git-on-your-computer)
4. [Step 2 - Tell Git Who You Are](#4-step-2--tell-git-who-you-are)
5. [Step 3 - Install GitHub CLI and Log In](#5-step-3--install-github-cli-and-log-in)
6. [Step 4 - Clone the Project Repository](#6-step-4--clone-the-project-repository)
7. [Step 5 - Your Daily Workflow (Pull, Edit, Commit, Push)](#7-step-5--your-daily-workflow-pull-edit-commit-push)
8. [Working with .qmd and .rmd Files](#8-working-with-qmd-and-rmd-files)
9. [Common Errors and How to Fix Them](#9-common-errors-and-how-to-fix-them)
10. [Quick Reference - Commands You May Need](#10-quick-reference--commands-you-may-need)

---

## The Automated Way (Fastest)

If you don't want to run all these commands manually, I have created scripts that execute the entire setup clinically. They include progress bars and error handling.

### Windows Users
1. Find the file named `setup-windows.bat` in this folder.
2. **Double-click** it. 
3. The script will automatically install Git, GitHub CLI, R, RStudio, and GitHub Desktop using `winget`. It will also prompt you for your name/email and open the browser for GitHub authentication.

### Mac Users
1. Find the file named `setup-macos.command` in this folder.
2. **Double-click** it.
3. If it says it "cannot be opened because it is from an unidentified developer," right-click it and select **Open**.
4. The script will execute the following phases:
   - **Phase 1-2:** Homebrew installation/update and CLI tool setup (Git/GH).
   - **Phase 3:** Application installation (GitHub Desktop, R, RStudio).
   - **Phase 4-5:** Git Identity setup and GitHub Browser Authentication.
   - **Phase 6-7:** RStudio integration reminder and final system summary.
5. You can track progress via the visual bar in the terminal window.

After the script completes, **skip to [Step 4 - Clone the Project Repository](#6-step-4--clone-the-project-repository)**. The scripts already handle the installation, identity, and authentication steps.

---

## 1. What Is GitHub and Why Are We Using It

Think of GitHub as Google Drive for code, but smarter. When multiple people edit the same Word document in Google Drive simultaneously, things break. GitHub solves this by tracking every single change ever made to every file, by every person, with a timestamp and an author label. If something breaks, you can roll back. If two people edit the same file, GitHub tries to merge both changes automatically.

Here is the mental model you need:

**Repository (Repo):** The project folder that lives on GitHub's servers. Think of it as the master copy.

**Clone:** Downloading a full copy of that master folder onto your own laptop.

**Pull:** Fetching the latest changes other people pushed, so your copy stays up to date. You do this before starting any work session.

**Commit:** Taking a snapshot of your current changes with a short message describing what you did. Think of it like saving a named version of your file.

**Push:** Uploading your committed snapshots (changes to the code or file) to the master copy on GitHub so everyone else can see your work.

**The golden rule: Pull before you start. Push when you finish.**

---

## 2. Step 0 - Install Package Managers (Homebrew & Winget)

Package managers allow you to install and update software using only the **terminal**. This is the fastest and most reliable way to set up your environment.

### Windows (Winget)
`winget` is Windows' official package manager. It is included by default on Windows 10 (1809+) and Windows 11. To verify it, open **Command Prompt** and run:
```cmd
winget --version
```
If the command is not found, you can install it via the Microsoft Store (search for "App Installer") or via PowerShell:
```powershell
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
```

### Mac (Homebrew)
Homebrew is the standard package manager for Mac. Open **Terminal** (press `Cmd + Space`, type `Terminal`, press Enter) and run:

**1. Install Homebrew:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
The installer will ask for your Mac login password. Type it and press Enter - nothing will appear on screen while you type, that is normal.

**2. After it finishes, add Homebrew to your PATH.** The installer prints two lines at the end under "Next steps". Copy and run them. They look like this (run both lines, one at a time):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> [!IMPORTANT]
> **Copy those lines from YOUR terminal screen, not from this guide.** The exact path depends on your Mac's chip. Apple Silicon Macs (M1/M2/M3/M4) use `/opt/homebrew`. Older Intel Macs use `/usr/local`. The installer always prints the correct version for your machine - scroll up to find it under the "Next steps" heading at the bottom of the installer output.

**3. Confirm Homebrew is working:**
```bash
brew --version
```
You should see something like `Homebrew 4.x.x`. If you do, move on to Step 1.

---

## 3. Step 1 - Install Git on Your Computer

Git is the underlying engine. GitHub is just a website that hosts repos powered by Git. You need Git installed locally before anything else works.

### Windows

Open **Command Prompt** (Start Menu -> search "Command Prompt") and run:

**1. Install Git using winget:**
```cmd
winget install --id Git.Git -e --source winget
```
Accept any prompts that appear. When it finishes, **close and reopen** Command Prompt.

**2. Verify the install worked:**
```cmd
git --version
```
You should see something like `git version 2.44.0.windows.1`. If you see that, Git is installed.

> [!TIP]
> **Still getting "command not found" after reopening Command Prompt?** Restart your computer. Windows sometimes needs a full reboot to register newly installed programs in the system PATH. After restarting, open a fresh Command Prompt and try `git --version` again.

### Mac

Open **Terminal** and run:

**1. Check if Git is already installed:**

```bash
git --version
```

If it prints a version number, you are done - skip to Step 2.

If Git is not installed, you have two options:

**Option A - Install via Xcode Command Line Tools (no Homebrew required):**

```bash
xcode-select --install
```

A popup will appear asking you to install. Click **Install** and wait - this takes 5 to 15 minutes. Once it finishes, run `git --version` to confirm.

**Option B - Install via Homebrew (if you completed Step 0):**

```bash
brew install git
```

This is faster and gives you a more up-to-date version of Git. Confirm with `git --version` when done.

---

## 4. Step 2 - Tell Git Who You Are

Git needs to know your name and email address so it can label every commit with your identity. This only needs to be done once per computer.

Open **Terminal** (Mac) or **Command Prompt** (Windows) and run these two commands, replacing the placeholder text with your actual name and the email address you used to sign up for GitHub:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "youremail@example.com"
```

Use the same email address you registered with on GitHub.

To confirm it worked:

```bash
git config --global --list
```

You should see `user.name` and `user.email` listed.

---

## 5. Step 3 - Install GitHub CLI and Log In

GitHub CLI (`gh`) is an official command-line tool made by GitHub. It handles authentication for you - once you log in with `gh auth login`, all `git push`, `git pull`, and `git clone` operations will work without passwords or tokens.

### 5a - Install GitHub CLI

#### Windows

Open **Command Prompt** (Start Menu -> search "Command Prompt") and run:

```cmd
winget install --id GitHub.cli
```

If `winget` is missing, refer back to **Step 0**. Alternatively, download the `.msi` installer from [https://cli.github.com](https://cli.github.com).

After installing, **close and reopen** Command Prompt, then verify:

```cmd
gh --version
```

> [!TIP]
> **`gh` still not found after reopening?** Restart your computer. This fixes the majority of Windows PATH issues after installs. After restarting, open Command Prompt and run `gh --version` again.

#### Mac

Open **Terminal** and run:

```bash
brew install gh
```

This requires Homebrew (see **Step 0**). Alternatively, download the `.pkg` installer from [https://cli.github.com](https://cli.github.com).

Verify with:

```bash
gh --version
```

### 5b - Log In to GitHub via CLI

In your terminal, run:

```bash
gh auth login
```

You will be walked through a short series of prompts. Answer them as follows:

1. **Where do you use GitHub?** -> Select **GitHub.com** and press Enter.
2. **What is your preferred protocol for Git operations?** -> Select **HTTPS** and press Enter.
3. **How would you like to authenticate GitHub CLI?** -> Select **Login with a web browser** and press Enter.
4. GitHub CLI will display a one-time code (e.g., `XXXX-XXXX`) and open your browser. **Copy that code**, paste it into the browser page that opens, and click **Authorize GitHub CLI**.
5. You may be asked for your GitHub password to confirm. Enter it and complete the authorization.

Back in your terminal, you should see: `OK. Authentication complete.`

Verify it worked:

```bash
gh auth status
```

> [!TIP]
> **Success check:** If `gh auth status` prints something like `Logged in to github.com as [your-username]`, you are done. Move to Step 4. If it says "You are not logged into any GitHub hosts", run `gh auth login` again from the top.

### 5c - Verify RStudio Can See Git

Go to **Tools > Global Options > Git/SVN**. The field labeled **Git executable** should show a path (e.g., `C:/Program Files/Git/bin/git.exe` on Windows, or `/usr/bin/git` on Mac). If it is empty, click **Browse** and locate your Git installation manually.

Restart RStudio after any changes here.

---

## 6. Step 4 - Clone the Project Repository

Cloning creates a local copy of the repo on your laptop. You only do this once.

The project lead will share the repository name with you in the format `username/project-name`.

> [!IMPORTANT]
> **Accept your email invitation before you clone.** When the project lead adds you as a collaborator, GitHub sends you an email invite. Check your inbox - and spam folder - for an email from GitHub and click **Accept invitation**. You will not be able to push changes to the repo until you accept. Simply being "added" is not enough.

### Option A - Clone using GitHub CLI (recommended)

Open your terminal, navigate to your Documents folder, then clone the repo:

```bash
# 1. Go to your Documents folder
cd Documents

# 2. Clone the repo - replace username/project-name with the actual name from the project lead
gh repo clone username/project-name

# 3. Confirm the folder was created
ls
```

GitHub CLI will download the repo into a new subfolder inside Documents.

Then open RStudio, go to **File > Open Project**, navigate into the newly created folder, and open the `.Rproj` file inside it. The **Git** tab will appear in the top-right panel.

> [!IMPORTANT]
> **NO PROJECT = NO GIT TAB.** If the Git tab is missing from RStudio's top-right panel, it is almost certainly because you opened a `.qmd` or `.r` file directly (by double-clicking it in your file explorer). That does not load the project. You must go to **File > Open Project** and select the `.Rproj` file inside the cloned folder. Always open the project first, then open your files from within RStudio.

### Option B - Clone using RStudio's GUI

1. Open the repo on GitHub. Click the green **Code** button, make sure **HTTPS** is selected, and copy the URL.
2. In RStudio, go to **File > New Project > Version Control > Git**.
3. Paste the copied URL into the **Repository URL** field.
4. Choose where you want the project folder to live. Do not put it inside a synced cloud folder like OneDrive or Dropbox - this causes conflicts.
5. Click **Create Project**.

RStudio will download the repo, open it as a project, and a **Git** tab will appear in the top-right panel. You are now set up.

### Option C - Clone using the standard Git command

If you have the repository link (e.g., `https://github.com/username/project-name.git`), you can clone it directly. You can find this link on the GitHub page by clicking the green **Code** button, or you can ask the project owner for it.

1. Open your terminal or command prompt.
2. Navigate to where you want the folder to live (e.g., `cd Documents`).
3. Run the clone command:
   ```bash
   git clone <link>
   ```
   *(Replace `<link>` with the actual URL you copied).*

Then open RStudio, go to **File > Open Project**, navigate into the newly created folder, and open the `.Rproj` file inside it.

---

## 7. Step 5 - Your Daily Workflow (Pull, Edit, Commit, Push)

Every time you work on the project, follow this exact sequence.

### Before You Start: Pull

Click the **Git** tab in RStudio. Click the blue **Pull** button (down arrow). This fetches any changes your groupmates pushed since you last opened the project. If you skip this step and your local copy is behind, your Push will be rejected.

### While You Work: Edit Files Normally

Open and edit `.qmd`, `.rmd`, or `.r` files just like you normally would. Nothing changes here.

### When You Are Done: Stage, Commit, Push

> [!CAUTION]
> **Large file landmine.** GitHub will reject your entire push if any single file exceeds 100MB. This most commonly happens when someone accidentally stages a raw dataset (`.csv`, `.xlsx`) or a large output file (`.zip`). Before clicking Stage, check your file sizes in your file explorer. As a rule: **commit your code and analysis scripts - not raw data files.** If the dataset is small (under a few MB), it is usually fine.

**Stage:** In the Git tab, you will see a list of files you modified. Each file has a checkbox in the **Staged** column. Check the box next to every file you want to include in this snapshot. Staging means "I want to include this file in my next commit."

**Commit:** Click the **Commit** button. A window opens. Write a short message in the **Commit message** box describing what you did. Keep it honest and specific. Click **Commit**.

| | Commit Message | Why |
|---|---|---|
| ok | `Fix p-value in Table 1` | Specific and traceable |
| ok | `Add regression section to chapter 2` | The team knows exactly what changed |
| ok | `Correct axis label on Figure 3` | Understandable months later |
| fail | `update` | Update what? Nobody knows. |
| fail | `asdfasdf` | Not acceptable |
| fail | `final version` | There is no "final" - commit history is the tracker |
| fail | `changes` | What changes? |

**Push:** Click the green **Push** button (up arrow). RStudio will upload your commits to GitHub. If it succeeds, you will see a message about the branch being updated.

### If You Prefer the Terminal (or the Buttons Are Not Working)

> [!WARNING]
> **Console != Terminal.** RStudio has two separate tabs at the bottom of the screen. The **Console** tab (where R code runs) and the **Terminal** tab (where Git commands run). Typing `git pull` into the Console will produce an error. Always switch to the **Terminal** tab before running any command from this guide.

Open the **Terminal** tab in RStudio (next to the Console tab) and run these commands in order after editing your files:

```bash
# 1. Pull latest changes first (always do this before anything else)
git pull

# 2. Stage all modified files
git add .

# 3. Commit with a descriptive message
git commit -m "Add regression analysis section"

# 4. Push to GitHub
git push
```

Replace the commit message with something that describes what you actually did.

### Summary

```text
Pull -> Edit -> Stage -> Commit (with message) -> Push
```

Do this every single work session. Do not accumulate many sessions worth of changes before committing. Small, frequent commits are much easier to manage than one massive commit.

### Clean File Naming Rules

> [!IMPORTANT]
> **Bad file names break paths and make the commit history unreadable.** Follow these rules for every file you save into the project folder.

| Rule | ok Good | fail Bad |
|---|---|---|
| No spaces | `chapter_2_analysis.qmd` | `chapter 2 analysis.qmd` |
| No special characters | `regression-results.r` | `regression (results!).r` |
| No "FINAL" or version numbers | `analysis.qmd` | `analysis_FINAL2_updated.qmd` |
| Lowercase preferred | `data_cleaning.r` | `Data Cleaning V3.R` |

The commit history **is** your version tracker. A file named `analysis.qmd` with 20 descriptive commits is infinitely better than `analysis_v3_FINAL_revised.qmd` with zero commits.

---

## 8. Working with .qmd and .rmd Files

The project will primarily use **Quarto Markdown (.qmd)** files. These combine R code and text in a single document and render to PDF or HTML via LaTeX.

### Install Quarto

If you do not have Quarto installed, download it from [https://quarto.org/docs/get-started](https://quarto.org/docs/get-started) and run the installer. RStudio 2022.07 and later has Quarto built in, but installing the standalone version ensures you have the latest release.

Verify the install in RStudio's Terminal tab:

```bash
quarto --version
```

### Rendering

To render a `.qmd` file to PDF, click the **Render** button at the top of the editor. If you are rendering to PDF, you need a LaTeX distribution installed. The easiest option is to install `tinytex` directly from R:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

This is a lightweight LaTeX distribution that RStudio manages automatically. Do not install a full LaTeX distribution like MiKTeX or MacTeX unless instructed otherwise, as version conflicts between the two will cause errors.

### What to Commit

Always commit both the `.qmd` source file and the rendered output if the project requires it. Never commit the `.Rproj.user` folder or `.RData` files - these are local and will cause conflicts. The `.gitignore` file in the repo already excludes them, so they should not appear in your Git tab.

---

## 9. Common Errors and How to Fix Them

### "Git not found" or Git tab missing in RStudio

**Cause:** RStudio cannot locate your Git installation.

**Fix:** Go to **Tools > Global Options > Git/SVN**, click **Browse** next to the Git executable field, and manually navigate to `git.exe` (Windows: usually `C:\Program Files\Git\bin\git.exe`) or `/usr/bin/git` (Mac). Restart RStudio.

### Push rejected - "Updates were rejected because the remote contains work that you do not have locally"

**Cause:** Someone pushed changes after you last pulled, so your local copy is behind the remote.

**Fix:** Click **Pull** first. Git will attempt to merge the remote changes with yours. If there are no conflicts, the merge happens automatically and you can Push immediately after.

### Merge Conflict

**Cause:** You and a groupmate both edited the same lines of the same file.

**Fix:** Git will mark the conflict inside the file with symbols like `<<<<<<`, `=======`, and `>>>>>>`. Open the file, find these markers, manually decide which version to keep (or combine both), delete the markers, save the file, then Stage and Commit. If you are unsure, message the project lead before touching anything.

### "Please tell me who you are" error

**Cause:** Git config was not set up (Step 2 was skipped).

**Fix:** Run the two `git config --global` commands from **Step 2** in your terminal.

### "Authentication failed" or credential error when pushing or pulling

**Cause:** You are not logged in via GitHub CLI, or the login session expired.

**Fix:** Run `gh auth status` in your terminal to check your login state. If it shows you are not logged in, run `gh auth login` again and follow the prompts from **Step 5b**.

### GitHub CLI command not found after installing

**Cause:** The terminal session was opened before the install completed, so the new `gh` command is not in the path yet.

**Fix:** Close your terminal or Command Prompt completely and open a fresh one. Then try `gh --version` again.

### "CRLF will be replaced by LF" warning (Windows)

**Cause:** Windows uses different line endings than Mac and Linux. This is a warning, not an error.

**Fix:** This warning is harmless and can be ignored. If it becomes bothersome, run this once in your terminal:

```cmd
git config --global core.autocrlf true
```

### RStudio shows a file as modified but you did not change it

**Cause:** Usually a line ending difference or RStudio auto-formatting on open.

**Fix:** Check the diff in the Git tab. If the change is only whitespace or line endings and you did not intentionally edit the file, uncheck the **Staged** checkbox for that file before committing.

### Cannot push - "Permission denied" or "Repository not found"

**Cause:** Your GitHub account was not added as a collaborator to the repo, or you have not accepted the invite.

**Fix:** Check your email (including spam) for a GitHub collaboration invite and click **Accept invitation**. Then verify your login status with `gh auth status`. If you cannot find the email, message the project lead to resend the invite from **Settings > Collaborators** in the repo.

### The Nuclear Option - Starting Over When Everything Is Broken

**When to use this:** Your local copy is so broken that neither you nor the project lead can figure out how to fix it, and you just need a clean slate.

> [!CAUTION]
> This will permanently discard any uncommitted local changes. Before you delete anything, copy every file you have edited out of the project folder to your Desktop as a backup.

**Steps:**
1. Open your file explorer and navigate to wherever you cloned the repo (e.g., your Documents folder).
2. **Copy** any files you modified out of the project folder onto your Desktop as a backup.
3. Delete the entire project folder.
4. Go back to **Step 4 (Clone)** and clone the repo fresh.
5. Copy your backup files from the Desktop back into the newly cloned folder.
6. Stage, commit, and push normally.

This is not the "right" Git way to resolve conflicts, but it works, and it is far better than force-pushing or deleting the repo on GitHub.

---

## 10. Quick Reference - Commands You May Need

Most operations are covered by RStudio's Git tab buttons (Pull, Stage, Commit, Push). The following terminal commands are only needed if the GUI fails or you need to diagnose something.

Open the **Terminal** tab in RStudio (next to the Console tab) to run these. You do not need to navigate to the project folder first - RStudio's terminal opens directly in the project directory.

| What you want to do | Command |
|---|---|
| Check Git is installed | `git --version` |
| Check GitHub CLI is installed | `gh --version` |
| Check your GitHub login status | `gh auth status` |
| Log in to GitHub | `gh auth login` |
| Clone a repository | `gh repo clone username/repo-name` |
| See current status of files | `git status` |
| Pull latest changes | `git pull` |
| Stage all modified files | `git add .` |
| Commit staged files | `git commit -m "Your message here"` |
| Push to GitHub | `git push` |
| See your commit history | `git log --oneline` |
| See what changed in a file | `git diff filename.qmd` |
| Discard all local changes to a file (destructive, cannot undo) | `git checkout -- filename.qmd` |

---

## Quick Checklist Before Every Work Session

- [ ] Opened RStudio and the project is loaded (check top-right shows the project name)
- [ ] Clicked **Pull** in the Git tab before touching any files
- [ ] Wrote a meaningful commit message before committing
- [ ] Clicked **Push** after committing

---

*If something breaks and none of the above fixes it, try the Nuclear Option in Section 9. If that also fails, message the project lead with a screenshot of the error.*
