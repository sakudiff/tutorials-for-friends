# STITCH AI MASTER PROMPT TEMPLATE
### Version 1.0 | Fill every [INPUT] before use. Brackets with defaults are optional overrides.

---

## HOW TO USE THIS TEMPLATE

1. Complete PHASE 0 first. This is the single initialization prompt. Attach your inspiration website screenshot or URL alongside it.
2. Send PHASE 1 prompts one screen at a time, in order.
3. Use PHASE 2 prompts for component-level corrections after each screen renders.
4. Use PHASE 3 to lock the design system once the first two screens look correct.
5. Use PHASE 4 for copy, language, and accessibility passes.
6. Never send two phases in one message.

---

---

# PHASE 0 — FOUNDATION INITIALIZATION PROMPT

> Send this once, at the start, with the inspiration website attached.

---

```
I am attaching a reference website for design inspiration. Study it before generating anything.

Extract and apply the following from the reference:
- Overall layout rhythm (grid density, whitespace philosophy, section padding)
- Typography hierarchy (heading scale, body weight, line height feel)
- Color mood (do not copy exact hex values, match the temperature and contrast philosophy)
- Component character (card style, button shape, border treatment, shadow depth)
- Imagery treatment (aspect ratios, overlay style, cropping behavior)
- Navigation pattern (top bar, sidebar, sticky, transparent on scroll, etc.)
- Motion tone (static, subtle hover states, animated transitions, none)

Do NOT copy the reference literally. Use it as a design language reference only.

---

PROJECT IDENTITY

Website Name: [INPUT: e.g., "Lumen Studio"]
Website Type: [INPUT: e.g., "Portfolio", "SaaS Landing Page", "E-commerce", "Agency", "Blog", "Corporate", "Product Showcase"]
Primary Purpose in One Sentence: [INPUT: e.g., "Convert visitors into booked clients for a luxury interior design firm"]
Target Audience: [INPUT: e.g., "High-net-worth homeowners aged 35-55 seeking premium renovation services"]
Brand Personality (3 adjectives): [INPUT: e.g., "Restrained, precise, editorial"]
Brand Personality (what it must NEVER feel like, 2 adjectives): [INPUT: e.g., "Playful, corporate"]

---

DESIGN SYSTEM DIRECTIVES

Primary Color: [INPUT: hex code or description, e.g., "#1A1A2E" or "deep navy"]
Secondary Color: [INPUT: hex code or description, e.g., "#C9A96E" or "warm gold"]
Accent Color: [INPUT: hex code or description, or "none"]
Background Color: [INPUT: e.g., "#F5F4F0" or "off-white warm" or "pure black"]
Surface Color (cards, panels): [INPUT: e.g., "#FFFFFF" or "5% lighter than background"]
Text Color Primary: [INPUT: e.g., "#111111" or "near-black"]
Text Color Secondary: [INPUT: e.g., "#666666" or "medium gray"]

Heading Font Style: [INPUT: e.g., "high-contrast serif, editorial weight" or "geometric sans-serif, thin weight"]
Body Font Style: [INPUT: e.g., "neutral sans-serif, 16px base, 1.6 line-height"]
Font Pairing Rule: [INPUT: e.g., "serif headings with sans body" or "single typeface family, weight contrast only"]

Border Radius: [INPUT: e.g., "0px (sharp)", "4px (slight)", "8px (moderate)", "9999px (fully rounded)"]
Shadow Depth: [INPUT: e.g., "none", "subtle (1-2px soft)", "moderate", "dramatic (deep drop shadows)"]
Button Style: [INPUT: e.g., "filled primary color, sharp corners, uppercase label" or "ghost outline, rounded, sentence case"]
Input Field Style: [INPUT: e.g., "bottom border only, no box" or "full border, 1px solid, slightly rounded"]

Spacing Philosophy: [INPUT: e.g., "generous whitespace, breathing room between sections" or "dense, information-rich layout"]
Grid Columns (desktop): [INPUT: e.g., "12-column" or "4-column wide-gap editorial"]
Section Vertical Padding: [INPUT: e.g., "large (80-120px)" or "medium (48-64px)" or "tight (24-32px)"]

Icon Style: [INPUT: e.g., "outline icons, 1.5px stroke" or "filled solid icons" or "no icons, text-only UI"]
Imagery Style: [INPUT: e.g., "high-contrast editorial photography" or "desaturated lifestyle photography" or "flat illustrations" or "no imagery, typography-driven"]
Image Overlay Treatment: [INPUT: e.g., "none" or "dark gradient from bottom" or "color wash at 30% opacity"]

---

PAGE ARCHITECTURE

List every page this website needs, in order of build priority:

Page 1: [INPUT: e.g., "Landing / Home"]
Page 2: [INPUT: e.g., "About"]
Page 3: [INPUT: e.g., "Services / Work"]
Page 4: [INPUT: e.g., "Portfolio / Case Studies"]
Page 5: [INPUT: e.g., "Contact"]
Page 6 (if needed): [INPUT or remove]
Page 7 (if needed): [INPUT or remove]

---

NAVIGATION ARCHITECTURE

Navigation Type: [INPUT: e.g., "Fixed top bar", "Transparent on scroll, solid on scroll down", "Side drawer on mobile only", "Full-screen overlay menu"]
Navigation Links: [INPUT: comma-separated list, e.g., "Work, About, Services, Journal, Contact"]
CTA in Navigation: [INPUT: e.g., "Book a Call" button in primary color, far right" or "none"]
Mobile Navigation Behavior: [INPUT: e.g., "Hamburger menu, slides in from right, full-screen dark overlay"]
Logo Position: [INPUT: e.g., "Far left, text logotype" or "Centered, wordmark"]

---

FOOTER ARCHITECTURE

Footer Style: [INPUT: e.g., "Minimal single-row with copyright and social links" or "Full-width 4-column with sitemap, contact, newsletter signup, and social links"]
Footer Background: [INPUT: e.g., "Dark background, inverted text" or "Same as page background"]
Footer Content: [INPUT: list what goes in the footer, e.g., "Logo, nav links, social icons, copyright line, privacy policy link"]

---

GLOBAL RULES (apply these to every screen)

1. Do not use stock photography placeholder gradients. Use solid color blocks or described imagery.
2. Every section must have a clear visual hierarchy: one dominant element, one supporting element, one tertiary element.
3. Maintain consistent spacing units. Do not mix tight and generous spacing within the same screen.
4. All buttons must have a defined hover state: [INPUT: e.g., "darken 10%", "invert fill and border", "underline only"].
5. No decorative elements that serve zero information purpose unless the brand personality demands it.
6. Maintain the reference website's whitespace philosophy throughout.
7. All section headings follow this hierarchy: [INPUT: e.g., "H1 for page title only, H2 for section titles, H3 for card titles, body for descriptions"].

Now generate Page 1: [INPUT: repeat your Page 1 name here]. Do not generate any other page yet.
```

---

---

# PHASE 1 — SCREEN-BY-SCREEN BUILD PROMPTS

> Use one prompt per page. Replace inputs and send after PHASE 0 is complete.

---

## Template: Individual Page Prompt

```
Build the [INPUT: Page Name] page now. Do not modify any other page.

PAGE PURPOSE: [INPUT: one sentence, e.g., "Convert visitors by showing the firm's best work and driving them to book a consultation"]

SECTIONS ON THIS PAGE (in order, top to bottom):

Section 1 — [INPUT: Section Name, e.g., "Hero"]:
  Layout: [INPUT: e.g., "Full viewport height, left-aligned text, right-side image"]
  Headline: [INPUT: placeholder text or tone, e.g., "Short, declarative, 4-6 words, serif font"]
  Subheadline: [INPUT: e.g., "One supporting sentence, 12-16 words max, secondary text color"]
  CTA: [INPUT: e.g., "Primary button 'View Our Work', ghost button 'Learn About Us'"]
  Background: [INPUT: e.g., "Full-bleed photography, dark gradient overlay from left, text readable on left half"]
  Notes: [INPUT: any edge cases, e.g., "No logo in hero, that is handled by the nav"]

Section 2 — [INPUT: Section Name, e.g., "Social Proof / Stats"]:
  Layout: [INPUT: e.g., "3-column stat row, centered, generous padding"]
  Content: [INPUT: e.g., "3 numbers with labels: 120+ Projects, 8 Years, 40 Awards"]
  Style Notes: [INPUT: e.g., "Large number in heading font, small label in secondary color below"]

Section 3 — [INPUT: Section Name]:
  Layout: [INPUT]
  Content: [INPUT]
  Style Notes: [INPUT]

Section 4 (add or remove sections as needed): [INPUT]

---

RESPONSIVE BEHAVIOR FOR THIS PAGE:

Mobile (< 768px): [INPUT: e.g., "Stack all columns to single column. Hero text left-aligned. Hero image moves below text. Stat row becomes vertical list."]
Tablet (768px - 1024px): [INPUT: e.g., "2-column grid for project cards. Navigation collapses to hamburger."]
Desktop (> 1024px): [INPUT: e.g., "Full layout as described above."]

---

WHAT THIS PAGE MUST NOT DO:
[INPUT: e.g., "Do not add a testimonials section on this page. Do not use a carousel. Do not use icon grids."]

Generate only this page. Confirm you have preserved the design system from Phase 0.
```

---

---

# PHASE 2 — COMPONENT REFINEMENT PROMPTS

> Use these after a page renders, to fix specific components. Send one refinement at a time.

---

## Template: Typography Correction

```
On the [INPUT: Page Name] page, in the [INPUT: Section Name] section:

The [INPUT: element, e.g., "section heading H2"] is incorrect.
Change it to: [INPUT: e.g., "serif font, 48px desktop / 32px mobile, letter-spacing -0.02em, near-black color, left-aligned"]
Do not change anything else on this page.
```

---

## Template: Button Correction

```
On the [INPUT: Page Name] page, update the [INPUT: e.g., "primary CTA button in the hero section"]:

Fill color: [INPUT]
Text color: [INPUT]
Font: [INPUT: e.g., "uppercase, 13px, 0.1em letter-spacing"]
Border radius: [INPUT]
Padding: [INPUT: e.g., "14px vertical, 32px horizontal"]
Hover state: [INPUT: e.g., "background darkens 15%, no other changes"]
Do not change any other button or element.
```

---

## Template: Card Component Correction

```
On the [INPUT: Page Name] page, update all [INPUT: e.g., "project cards in the portfolio grid"]:

Card background: [INPUT]
Border: [INPUT: e.g., "none" or "1px solid #E0E0E0"]
Border radius: [INPUT]
Shadow: [INPUT: e.g., "none" or "0 4px 12px rgba(0,0,0,0.08)"]
Image aspect ratio: [INPUT: e.g., "16:9" or "4:3" or "1:1 square"]
Image object-fit: [INPUT: e.g., "cover" or "contain"]
Card hover state: [INPUT: e.g., "lift shadow slightly, scale image 102%, smooth 300ms transition"]
Text inside card: [INPUT: e.g., "Project title in H3, category label in small uppercase secondary text below"]
Do not modify any card outside of this section.
```

---

## Template: Navigation Correction

```
Update the navigation bar globally (applies to all pages):

Background: [INPUT: e.g., "transparent over hero, transitions to solid white on scroll down"]
Height: [INPUT: e.g., "72px desktop, 60px mobile"]
Logo: [INPUT: e.g., "text logotype in heading font, near-black, far left"]
Link style: [INPUT: e.g., "14px, medium weight, secondary text color, underline on hover"]
CTA button position: [INPUT: e.g., "far right, primary style button"]
Mobile breakpoint: [INPUT: e.g., "below 768px, collapse links, show hamburger icon at right"]
Mobile menu style: [INPUT: e.g., "slide in from right, full height, dark background, white links, large font"]
Apply this to all pages. Confirm no page layout shifts after the nav update.
```

---

## Template: Section Spacing Correction

```
On the [INPUT: Page Name] page, in the [INPUT: Section Name] section:

The vertical padding is [INPUT: e.g., "too tight / too large"].
Set top padding to: [INPUT: e.g., "96px desktop, 64px mobile"]
Set bottom padding to: [INPUT: e.g., "96px desktop, 64px mobile"]
Internal gap between columns: [INPUT: e.g., "32px"]
Do not change any other spacing on this page.
```

---

## Template: Image Treatment Correction

```
On the [INPUT: Page Name] page, update the [INPUT: e.g., "hero background image / project thumbnail images / team photo"]:

Image description: [INPUT: e.g., "architectural interior, warm lighting, minimal furniture, shot from low angle"]
Aspect ratio: [INPUT]
Overlay: [INPUT: e.g., "none" or "linear gradient from bottom, black 0% to 60% opacity"]
Object position: [INPUT: e.g., "center center" or "top center"]
Corner radius on image: [INPUT: e.g., "0" or "8px"]
Do not modify any other image on this page.
```

---

---

# PHASE 3 — DESIGN SYSTEM LOCK PROMPT

> Send this once you have at least two pages confirmed and looking correct. It freezes the design system.

---

```
The current design across [INPUT: Page 1 name] and [INPUT: Page 2 name] represents the approved design system.

Extract and lock the following as the global standard for all remaining pages:
- Primary and secondary color values exactly as rendered
- Typography scale exactly as rendered (H1 through body and caption sizes)
- Button styles (filled, ghost, text-link) exactly as rendered
- Card and container shadow and border-radius values exactly as rendered
- Section padding and internal grid gap values exactly as rendered
- Navigation style exactly as rendered
- Icon set and stroke weight exactly as rendered

Apply this locked system to all future pages without deviation.
If any new page requires a component not yet seen, derive it from the existing design system tokens, do not invent new visual patterns.

Confirm the design system has been locked before proceeding.
```

---

---

# PHASE 4 — COPY, LANGUAGE, AND ACCESSIBILITY PROMPTS

> Use these for final polish passes.

---

## Template: Language / Locale Switch

```
Switch all visible text on all pages to [INPUT: language, e.g., "Filipino / Tagalog"].
This includes navigation links, button labels, section headings, body copy, placeholder text, and footer text.
Preserve all layout, spacing, and design system properties exactly.
Do not modify any visual element.
```

---

## Template: Copy Tone Correction

```
On the [INPUT: Page Name] page, rewrite the copy in the [INPUT: Section Name] section.

Current tone problem: [INPUT: e.g., "Too casual / Too corporate / Too generic"]
Desired tone: [INPUT: e.g., "Authoritative and restrained, speaks to a discerning audience, avoids superlatives and filler phrases"]
Heading word count limit: [INPUT: e.g., "5 words maximum"]
Subheading word count limit: [INPUT: e.g., "15 words maximum"]
Body copy length: [INPUT: e.g., "2 sentences max per paragraph"]
Do not change any design or layout element.
```

---

## Template: Accessibility Pass

```
Perform an accessibility review pass on the [INPUT: Page Name] page.

Apply the following:
1. Ensure all text on colored backgrounds meets WCAG AA contrast minimum (4.5:1 for body, 3:1 for large text).
2. All interactive elements (buttons, links, inputs) must have visible focus states.
3. All images must have descriptive alt text placeholders.
4. Form inputs must have visible labels, not placeholder-only labels.
5. Font size must not go below 14px for any body or label text.
6. Touch targets on mobile must be minimum 44x44px.

Report what was changed and what was already compliant.
Do not change any visual design decisions that already pass these standards.
```

---

---

# QUICK-REFERENCE CHEAT SHEET

> Copy and paste these micro-prompts for fast fixes.

```
// Lock a color
"Set [element] to exactly [hex code]. Do not adjust any other color."

// Fix alignment
"Left-align all text in the [section] on [page]. Do not change font size or weight."

// Remove an element
"Remove the [element] from [section] on [page]. Adjust spacing to fill the gap naturally."

// Duplicate a component
"The [component] on [page A] is correct. Apply the same component style to [page B, section name]."

// Reset a section
"The [section] on [page] is incorrect. Remove it entirely and rebuild it using only: [describe what should be there]."

// Force consistency
"Audit all pages for consistency of [element, e.g., 'H2 heading style']. Apply the version from [Page Name] as the standard."

// Add hover state
"Add a hover state to [element] on [page]: [describe exactly what changes on hover and transition duration]."

// Whitespace correction
"The [section] on [page] feels crowded. Increase the vertical padding to [value] and the gap between elements to [value]."
```

---

*Template ends. All [INPUT] fields require completion before submission. Phases must be sent sequentially.*
