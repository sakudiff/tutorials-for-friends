# Tutorials for Friends. The Clinical Stack.

So you want a working dev environment without spending three hours on Stack Overflow. Good instincts. This repository is a collection of opinionated, automated setup guides for academic and professional work. Pick the one that matches your situation. Follow it exactly. Do not improvise.

## The Guides.

### [R Setup. For Statistics and Academic Work.](r-setup/readme_for_R_users.md)
Tools: R, RStudio, Git, GitHub CLI, Quarto, GitHub Desktop. This is the track for users who need a stable statistical environment with zero command line friction. If you are in a stats or research course, start here.

### [Python Setup. For CS and Data Science.](python-setup/readme_for_Python_users.md)
Tools: Python via `uv`, VS Code, Git, GitHub CLI, LaTeX via MacTeX or MiKTeX. This is the track for groupmates in Data Science and CS. The `uv` package manager eliminates the disasters that `pip` and `conda` cause. If you have touched a `requirements.txt` in the last six months, start here.

### [DLSU LaTeX Templates. For Academic Papers.](DLSU_Template_Latex/Template.tex)
Tools: LaTeX via Overleaf, or a local TeX Live or MiKTeX installation. Two versions are provided. The standard template includes the DLSU green TikZ border. The clean template is for submissions that prohibit decorative elements. If your professor wants a PDF that looks like it was typeset professionally, start here.

### [STITCH AI Master Prompt. For Web Design.](Stitch_Prompt/stitch-master-prompt-template.md)
Tools: Any capable LLM. Claude 3.5 Sonnet is the recommended model. This is a four-phase prompting protocol that prevents AI hallucination drift during web generation. It locks your design system early and enforces it through every subsequent prompt. If you are building a website with AI assistance and the output keeps diverging from your vision, start here.

### [Microslop Office. Permanent Acquisition Protocol.](Microsoft_Office_MAC/README.md)
Tools: Microsoft Office VL Serializer, Office-Reset utility. The Volume License method for activating Office on macOS permanently. No subscriptions. No third party scripts. No mess. If you want Word, Excel, and PowerPoint without paying Microsoft a monthly tithe, start here.

## Repository Structure.

- `r-setup/`: Automated `.command` scripts for Mac and `.bat` scripts for Windows. Installs the full R stack unattended.
- `python-setup/`: Automated `uv`-based setup for Python, VS Code, and a local LaTeX distribution.
- `DLSU_Template_Latex/`: Standard DLSU report template with the professional green TikZ border.
- `DLSU_Clean_Template_Latex/`: Minimalist DLSU template. No border. For strict formal submissions.
- `Stitch_Prompt/`: The STITCH AI Master Prompt Template for phase-based web generation.
- `Microsoft_Office_MAC/`: The tools and guide for permanent Office activation on macOS.

## Operational Protocol.

Open the README inside your specific folder. Follow the steps in order. Do not mix environments. Small, frequent commits are mandatory. Deviating from the sequence is the primary cause of failure.

---
*Part of the Tutorials for Friends clinical collection.*
