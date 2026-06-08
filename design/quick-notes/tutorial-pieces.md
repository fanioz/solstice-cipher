---
name: "Tutorial & Pieces Flow"
description: "Lore-friendly names for puzzle elements and a progressive level tutorial flow."
argument-hint: "N/A"
user-invocable: true
allowed-tools: []
---

# /quick-design: Tutorial & Pieces Flow

### Overview
This document formalizes the lore-friendly names for the interactive puzzle elements in *Solstice Cipher* and outlines the progressive tutorial structure designed to teach mechanics without text prompts.

*(Note: No director gate review — quick-design is for sub-4h features)*

### Rules
**Piece Nomenclature:**
- **The Source:** Emits a continuous golden beam. Static.
- **The Mirror:** Solid glass. Bounces light at 90-degree angles.
- **The Prism:** Translucent crystal. Bounces half the light, lets the other half pass through straight.
- **The Glyph:** Floating cipher letters that activate when hit by light.

**Tutorial Progression:**
- **Level 1 ("I"):** Teaches dragging and rotating **Mirrors** to hit a single **Glyph**.
- **Level 2 ("ON"):** Teaches that light can pass through **Prisms** to hit multiple **Glyphs**.
- **Level 3 ("SUN"):** Tests combining **Mirrors** and **Prisms** to spell a 3-letter word.

### Acceptance Criteria
- [x] Level 1 contains 1 Mirror, 1 Glyph.
- [x] Level 2 contains 1 Prism, 1 Mirror, 2 Glyphs.
- [x] Level 3 contains multiple Prisms/Mirrors and 3 Glyphs.
- [x] All levels fit within the 720x1280 mobile portrait bounds.
- [x] Player can progress from Level 1 -> Level 2 -> Level 3 -> End Screen.
