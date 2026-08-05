# Tutorials for Friends. The Clinical Stack.

Automated setup guides for academic and professional work. Pick the track that matches your situation, follow it exactly, do not improvise.

## Choose Your Track

| Track | Tools | For You If |
|-------|-------|------------|
| R Setup | R, RStudio, Quarto, Git, GitHub Desktop | You need a stable statistics environment |
| Python Setup | uv, VS Code, Git, GitHub CLI, MacTeX or MiKTeX | You are in CS or Data Science |
| DLSU LaTeX Templates | XeLaTeX, Biber, Overleaf | You need a typeset academic paper |
| Microsoft Office | VL Serializer, Office-Reset | You want Office on macOS without a subscription |

## The Tracks

### R Setup. For Statistics and Academic Work.

[Guide](r-setup/readme_for_R_users.md) — R, RStudio, Git, GitHub CLI, Quarto, GitHub Desktop. This is the track for a stable statistical environment with zero command line friction. If you are in a stats or research course, start here.

### Python Setup. For CS and Data Science.

[Guide](python-setup/readme_for_Python_users.md) — Python via uv, VS Code, Git, GitHub CLI, LaTeX via MacTeX or MiKTeX. The uv package manager eliminates the disasters that pip and conda cause. If you have touched a requirements.txt in the last six months, start here.

### DLSU LaTeX Templates. For Academic Papers.

[Guide](DLSU_Template_Latex/main.tex) — two modular templates, bordered and clean, both splitting chapters into Introduction, Methodology, Results, Discussion, and Conclusion. The bordered template carries the DLSU green TikZ border. The clean template is for submissions that prohibit decorative elements. Compile with xelatex, biber, then xelatex twice, or run both on Overleaf with the XeLaTeX compiler and Biber bibliography.

### Microsoft Office. Permanent Acquisition Protocol.

[Guide](Microsoft_Office_MAC/README.md) — the Volume License method for activating Office on macOS permanently. No subscriptions, no third party scripts. If you want Word, Excel, and PowerPoint without paying Microsoft a monthly tithe, start here.

## Repository Structure

- `r-setup/` — automated .command and .bat scripts for the full R stack
- `python-setup/` — uv based setup for Python, VS Code, and a local LaTeX distribution
- `DLSU_Template_Latex/` — bordered template, main.tex plus chapters/
- `DLSU_Clean_Template_Latex/` — clean template, main.tex plus chapters/
- `Microsoft_Office_MAC/` — Office activation tools and guide

## Operational Protocol

Open the README inside your specific folder. Follow the steps in order. Do not mix environments. Small, frequent commits are mandatory. Deviating from the sequence is the primary cause of failure.
