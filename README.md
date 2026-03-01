# Tutorials for Friends & Groupmates -- Dev Stack Setups

This repository provides clinical, automated setup scripts for both RStudio (Academic/Stats) and VS Code (Python/Quant) environments.

## Choose Your Path

### [RStudio Setup (for Academic Groupmates)](r-setup/readme_for_R_users.md)
- **Tools:** R, RStudio, Git, GitHub CLI, GitHub Desktop.
- **Audience:** Users who need a stable stats environment with no CLI experience.

### [Python Setup (for CS & Data Science Groupmates)](python-setup/readme_for_Python_users.md)
- **Tools:** Python (via `uv`), VS Code, Git, GitHub CLI.
- **Audience:** Specifically designed for my fellow groupmates in the Data Science class and CS students who need a professional Python environment.

### [DLSU LaTeX Templates (for Academic Papers)](DLSU_Template_Latex/Template.tex)
- **Tools:** LaTeX (Overleaf or local TeX Live), TikZ.
- **Audience:** DLSU students who want clean, standardized report templates with university branding.

---

## DLSU LaTeX Templates Tutorial

I've included two versions of the De La Salle University LaTeX template:
1. **Standard Template:** Includes a professional TikZ-generated border in DLSU Green.
2. **Clean Template:** A minimalist version without the border for stricter submissions.

### How to Use (The Quick Way - Overleaf)

1. **Create a New Project:** Log into [Overleaf](https://www.overleaf.com/).
2. **Upload Files:** Upload the `.tex` file from either `DLSU_Template_Latex/` or `DLSU_Clean_Template_Latex/`.
3. **Add the Logo:** The template expects a logo at `image/paper/dlsu_logo.png`. You must create this folder structure in Overleaf and upload the DLSU logo, or change the path in the `\includegraphics` commands.
4. **Compile:** Click "Recompile" to see your professional DLSU report.

### Customization Guide

- **Title Page:** Search for `\begin{titlepage}` and replace the placeholder text `[Project Title Here]`, `[Course Name]`, and `[Author Names]` with your actual details.
- **DLSU Green:** The templates use the official DLSU Green hex code (`#00703C`). You can reference this as `dlsugreen` in your document.
- **Structure:** The template comes pre-structured with Introduction, Methodology, Results, and Conclusion sections—standard for most DLSU CS/Data Science courses.

---
**Protocol:** Follow the README inside your specific setup folder. Do not mix environments.
