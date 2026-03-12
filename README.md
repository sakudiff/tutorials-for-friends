# Tutorials for Friends & Groupmates — The Dev Stack

A clinical, opinionated collection of automated setup scripts, templates, and prompt engineering frameworks designed for academic and professional development.

## Choose Your Path

### [RStudio Setup (for Academic/Stats)](r-setup/readme_for_R_users.md)
- **Tools:** R, RStudio, Git, GitHub CLI, Quarto, GitHub Desktop.
- **Audience:** Users needing a stable statistical environment with zero CLI friction.

### [Python Setup (for CS & Data Science)](python-setup/readme_for_Python_users.md)
- **Tools:** Python (via `uv`), VS Code, Git, GitHub CLI, LaTeX (MacTeX/MiKTeX).
- **Audience:** Fellow groupmates in Data Science and CS who need a professional, high-performance Python environment.

### [DLSU LaTeX Templates (Academic Papers)](DLSU_Template_Latex/Template.tex)
- **Tools:** LaTeX (Overleaf or local TeX Live/MiKTeX), TikZ.
- **Audience:** DLSU students wanting clean, standardized report templates with university branding.

### [STITCH AI Master Prompt (Web Design)](Stitch_Prompt/stitch-master-prompt-template.md)
- **Tools:** LLM (Claude 3.5 Sonnet recommended).
- **Audience:** Designers and developers using AI to build websites from inspiration to final polish using a structured, phase-based protocol.

---

## Repository Structure

- `r-setup/`: Automated `.command` (Mac) and `.bat` (Windows) scripts for the R stack.
- `python-setup/`: Automated `uv`-based setup for Python, VS Code, and local LaTeX.
- `DLSU_Template_Latex/`: Standard DLSU template with the professional green TikZ border.
- `DLSU_Clean_Template_Latex/`: Minimalist DLSU template for strict formal submissions.
- `Stitch_Prompt/`: The **STITCH AI Master Prompt Template** for phase-based web generation.

---

## Feature Highlights

### The "Clinical" Python Setup
The Python track now utilizes **`uv`**, the fastest Python package manager available. It eliminates the complexities of `pip` or `conda`. The setup scripts automatically configure VS Code extensions (Ruff, Pylance, LaTeX Workshop) and install a full LaTeX distribution (MacTeX/MiKTeX) for seamless local PDF rendering.

### DLSU LaTeX Templates Tutorial
I've included two versions of the De La Salle University LaTeX template:
1. **Standard Template:** Includes a professional TikZ-generated border in DLSU Green.
2. **Clean Template:** A minimalist version without the border for stricter submissions.

#### How to Use (The Quick Way - Overleaf)
1. **Create a New Project:** Log into [Overleaf](https://www.overleaf.com/).
2. **Upload Files:** Upload the `.tex` and `.bib` files from the template folder.
3. **Add the Logo:** The template expects a logo at `image/paper/dlsu_logo.png`. Create this folder structure in Overleaf and upload the DLSU logo.
4. **Compile:** Click "Recompile" to see your professional DLSU report.

### STITCH AI Framework
A 4-phase prompting protocol to prevent AI "hallucination drift" and maintain design system integrity during web generation:
- **Phase 0:** Foundation Initialization & Design System Lock.
- **Phase 1:** Screen-by-Screen Build Prompts.
- **Phase 2:** Component-Level Refinement.
- **Phase 3/4:** Global System Lock and Accessibility/Copy Passes.

---

**Protocol:** Follow the README inside your specific folder. Do not mix environments. Small, frequent commits are the law.
