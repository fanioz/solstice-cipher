---
title: "Solstice Cipher — 100 Level Progression & Briefcase System"
date: 2026-06-08
status: APPROVED
scope: Level design, tool progression, briefcase UI, procedural generation
---

# Solstice Cipher — 100 Level Progression Design

## 1. Overview

Solstice Cipher is a light-bending puzzle game where the player places optical
tools (Mirrors, Prisms, etc.) from a limited inventory ("Briefcase") onto a
board to route light beams into floating letter Glyphs, spelling out words.

The game features **100 levels** across **10 tiers** of 10 levels each. Each
tier introduces a new tool, increases word length, and tightens the piece
budget. The first ~15 levels are hand-crafted tutorials; the remaining levels
use procedural generation with curated word lists.

---

## 2. The Tools (7 Total)

### 2.1 Mirror (Tier 1, Level 1)
- **Mechanic:** Reflects the beam at 90°.
- **Visual:** A flat glass surface.
- **Player learns:** Aiming and rotating.

### 2.2 Prism (Tier 2, Level 11)
- **Mechanic:** Splits the beam — one reflected at 90°, one passes straight through.
- **Visual:** A translucent crystal.
- **Player learns:** Multi-path light routing.

### 2.3 Filter (Tier 3, Level 21)
- **Mechanic:** Tints the beam a specific color (Red, Blue, or Gold). Glyphs
  now require a matching color of light to activate. A white beam (default)
  cannot activate colored Glyphs.
- **Visual:** A colored glass lens.
- **Player learns:** Color-matching adds a constraint layer on top of routing.
- **Rules:**
  - Filters do NOT change beam direction — light passes straight through.
  - A beam can pass through multiple Filters; the last Filter's color wins.
  - Colored beams can still reflect off Mirrors and split through Prisms.

### 2.4 Shade (Tier 4, Level 31)
- **Mechanic:** Blocks light entirely. Placing a Shade stops a beam dead.
- **Visual:** A dark obsidian wall segment.
- **Player learns:** Sometimes you must PREVENT light from reaching a Glyph.
  Puzzles now have "wrong paths" that must be blocked.
- **Rules:**
  - Shades are solid — no light passes through or bounces off.
  - A Shade placed in a split beam path blocks only that branch.

### 2.5 Bender (Tier 5, Level 41)
- **Mechanic:** Deflects the beam at 45° instead of the Mirror's 90°.
- **Visual:** A curved lens or angled crystal.
- **Player learns:** Diagonal routing. Opens up paths that Mirrors alone
  cannot achieve.
- **Rules:**
  - Benders snap to 15° increments like Mirrors.
  - The deflection angle is always 45° relative to the Bender's normal.

### 2.6 Portal (Tier 6, Level 51)
- **Mechanic:** Comes in linked pairs. Light entering one Portal exits the
  other, maintaining its direction.
- **Visual:** Two glowing rings with matching color auras.
- **Player learns:** Spatial teleportation. Beams can jump across the board.
- **Rules:**
  - Portals always come in pairs — placing one Portal from the Briefcase
    places both (the second one is also draggable).
  - Light exits the second Portal traveling in the SAME direction it entered
    the first.
  - A Portal pair counts as 1 piece in the Briefcase budget.

### 2.7 Combiner (Tier 7, Level 61)
- **Mechanic:** Requires TWO separate beams hitting it simultaneously before
  it emits a single powerful beam toward a linked Glyph.
- **Visual:** A diamond-shaped crystal that glows when both inputs are active.
- **Player learns:** Multi-source convergence. Forces the player to engineer
  two independent beam paths that converge on a single point.
- **Rules:**
  - The Combiner has two input faces and one output face.
  - Both inputs must be lit simultaneously for the output to activate.
  - The output beam direction is fixed (based on the Combiner's rotation).

---

## 3. The 10 Tiers

### Tier 1 — "Reflection" (Levels 1–10)
- **Word Length:** 3 letters
- **Tools Available:** Mirror only
- **Briefcase Budget:** 1 → 3 mirrors
- **Philosophy:** *Learn to aim.* Simple single-bounce and multi-bounce puzzles.
- **Example words:** SUN, RAY, ARC, ORB, SKY, DAY, DIM, LIT, AWE, ZEN

### Tier 2 — "Refraction" (Levels 11–20)
- **Word Length:** 3–4 letters
- **Tools Available:** Mirror + Prism
- **Briefcase Budget:** 2 → 4 pieces
- **Philosophy:** *One beam, two paths.* Light now splits.
- **Example words:** GLOW, BEAM, DAWN, DUSK, HAZE, RISE, WARM

### Tier 3 — "Spectrum" (Levels 21–30)
- **Word Length:** 4 letters
- **Tools Available:** Mirror + Prism + Filter
- **Briefcase Budget:** 3 → 5 pieces
- **Philosophy:** *Color matters.* Match beam color to glyph color.
- **Example words:** GOLD, RUBY, IRIS, OPAL, JADE, ONYX, HALO

### Tier 4 — "Shadow" (Levels 31–40)
- **Word Length:** 4–5 letters
- **Tools Available:** Mirror + Prism + Filter + Shade
- **Briefcase Budget:** 3 → 5 pieces
- **Philosophy:** *Not everything should be lit.* Block wrong paths.
- **Example words:** SHADE, NIGHT, LUNAR, AMBER, FLARE, GLEAM

### Tier 5 — "Geometry" (Levels 41–50)
- **Word Length:** 5 letters
- **Tools Available:** Mirror + Prism + Filter + Shade + Bender
- **Briefcase Budget:** 4 → 6 pieces
- **Philosophy:** *New angles.* 45° opens diagonal routes.
- **Example words:** PRISM, LIGHT, BLAZE, EMBER, FLAME, SPARK, SHINE

### Tier 6 — "Warp" (Levels 51–60)
- **Word Length:** 5–6 letters
- **Tools Available:** Mirror + Prism + Filter + Shade + Bender + Portal
- **Briefcase Budget:** 4 → 6 pieces
- **Philosophy:** *Space bends.* Teleport beams across the board.
- **Example words:** ASTRAL, CORONA, NEBULA, ZENITH, AURORA, COSMIC

### Tier 7 — "Convergence" (Levels 61–70)
- **Word Length:** 6 letters
- **Tools Available:** All 7 tools
- **Briefcase Budget:** 5 → 7 pieces
- **Philosophy:** *Two beams, one target.* Multi-path convergence required.
- **Example words:** CIPHER, QUASAR, PHOTON, COSMOS, RADIANT, STELLAR

### Tier 8 — "Mastery" (Levels 71–80)
- **Word Length:** 6–7 letters
- **Tools Available:** All 7 tools
- **Briefcase Budget:** 5 → 7 pieces
- **Philosophy:** All tools unlocked. Tight budgets. Elegant solutions required.
- **Example words:** ECLIPSE, MONSOON, HALCYON, LUMINAL, SPECTRA

### Tier 9 — "Cipher" (Levels 81–90)
- **Word Length:** 7 letters
- **Tools Available:** All 7 tools
- **Briefcase Budget:** 5 → 6 pieces
- **Philosophy:** Fewer pieces than feels safe. Precision placement.
- **Example words:** EQUINOX, SOLARIA, STARLIT, SHIMMER, RADIANCE

### Tier 10 — "Solstice" (Levels 91–100)
- **Word Length:** 7–8 letters
- **Tools Available:** All 7 tools
- **Briefcase Budget:** 4 → 6 pieces
- **Philosophy:** Maximum constraint. Every piece must count. Level 100 spells SOLSTICE.
- **Example words:** SOLSTICE, LUMINOUS, CRESCENT, MERIDIAN, STARFALL

---

## 4. Difficulty Curve Within Each Tier

Each 10-level tier follows a mini-arc:

- **Levels X1–X3 (Intro):** Introduce the new tool in near-isolation. Minimal
  old tools on the board. The player experiments with the new mechanic safely.
- **Levels X4–X6 (Combine):** Mix the new tool with 1–2 tools from prior tiers.
  The player starts to see how the toolkit compounds.
- **Levels X7–X9 (Challenge):** Full toolkit available for this tier. Tighter
  piece budgets. Multiple valid solutions collapse to fewer options.
- **Level X0 (Boss):** Minimum possible pieces. One elegant solution. The
  "graduation exam" before the next tier unlocks.

---

## 5. Briefcase UI

### 5.1 Layout
- Positioned at the **bottom** of the 720×1280 portrait screen.
- Occupies roughly the **bottom 160px** of the viewport.
- Semi-transparent dark panel with a subtle glass/metallic border.

### 5.2 Behavior
- Shows available tools as **draggable icons** in a horizontal row.
- Each icon has a **count badge** (e.g., "×2" for 2 Mirrors available).
- **Drag to place:** Player drags an icon from the Briefcase onto the board.
  The count decreases by 1.
- **Drag back to remove:** Player can drag a placed piece back into the
  Briefcase to reclaim it.
- **Greyed-out:** When count reaches 0, the icon becomes greyed and
  non-draggable.
- **New tool unlock:** When a new tier begins, a brief "tool reveal" animation
  plays showing the new tool with its name and a one-line description.

### 5.3 Visual Hierarchy
- Tools are ordered left-to-right by unlock order (Mirror first, Combiner last).
- The newly unlocked tool has a subtle glow/pulse for the first 3 levels of
  its tier.
- Locked tools (from future tiers) are NOT shown — no spoilers.

---

## 6. Procedural Generation System

### 6.1 Strategy
- **Levels 1–15:** Hand-crafted .tscn files for curated tutorial experience.
- **Levels 16–100:** Procedurally generated at runtime from difficulty parameters.

### 6.2 Generation Algorithm (High-Level)
1. **Select word** from curated list based on tier's word length range.
2. **Place Source** at a fixed position (bottom-left of board).
3. **Place Glyphs** at random valid positions on the board (respecting minimum
   spacing and staying within the playable area, which excludes the Briefcase
   zone).
4. **Solve backwards:** Starting from the Glyphs, trace beam paths back to the
   Source, placing required tools along the path. This guarantees solvability.
5. **Determine Briefcase budget:** The number of tools used in the solution +
   0–2 extra "red herring" pieces (to add decision-making).
6. **Remove placed tools:** Clear the board of solution tools. These go into
   the Briefcase as the player's inventory.

### 6.3 Validation
- Every generated level MUST be solvable (guaranteed by the backwards-solve).
- No Glyph may overlap another Glyph or the Source.
- All Glyphs must be reachable by the available tools within the piece budget.

---

## 7. Curated Word List

Words are grouped by letter count and filtered for thematic fit (light,
celestial, nature, mystical).

### 3 Letters (~20 words)
SUN, RAY, ARC, ORB, SKY, DAY, DIM, LIT, AWE, ZEN,
DEW, FOG, ICE, GEM, OAK, SEA, AIR, EYE, RED, GOD

### 4 Letters (~20 words)
GLOW, BEAM, DAWN, DUSK, HAZE, RISE, WARM, GOLD, RUBY,
IRIS, OPAL, JADE, ONYX, HALO, MOON, STAR, FIRE, MIST,
WAVE, WIND

### 5 Letters (~20 words)
PRISM, LIGHT, BLAZE, EMBER, FLAME, SPARK, SHINE, SHADE,
NIGHT, LUNAR, AMBER, FLARE, GLEAM, OCEAN, STORM, FROST,
BLOOM, CLOUD, ABYSS, EARTH

### 6 Letters (~20 words)
CIPHER, QUASAR, PHOTON, COSMOS, ASTRAL, CORONA, NEBULA,
ZENITH, AURORA, COSMIC, LUSTER, CANDLE, SILVER, BRONZE,
SUNSET, FROZEN, MYSTIC, SPIRIT, PRIMAL, DIVINE

### 7 Letters (~20 words)
ECLIPSE, EQUINOX, SOLARIA, STARLIT, SHIMMER, HALCYON,
LUMINAL, SPECTRA, CRYSTAL, HORIZON, COMPASS, THUNDER,
MORNING, BLOSSOM, GLACIER, FIREFLY, RAINBOW, MONSOON,
LANTERN, ALCHEMY

### 8 Letters (~10 words)
SOLSTICE, LUMINOUS, CRESCENT, MERIDIAN, STARFALL, DAYBREAK,
TWILIGHT, MIDNIGHT, SPECTRUM, RADIANCE

---

## 8. Level Flow

```
Title Screen
    │
    ▼
Level Select (Grid of 100 levels, locked/unlocked)
    │
    ▼
Level Play
    ├── Briefcase (bottom panel, draggable tools)
    ├── Board (Source + Glyphs pre-placed)
    ├── Cipher HUD (top, shows _ _ _ progress)
    └── Actions: Reset / Back
    │
    ▼ (all Glyphs lit)
Level Complete Animation
    │
    ▼
Next Level / Back to Level Select
```

---

## 9. Acceptance Criteria

- [ ] 7 distinct tools with unique mechanics
- [ ] 10 tiers of 10 levels each (100 total)
- [ ] Progressive tool unlock (one new tool per tier)
- [ ] Curated word list with ~130 thematic words
- [ ] Briefcase UI with drag-to-place and piece count
- [ ] Procedural level generator for levels 16–100
- [ ] Hand-crafted tutorial levels 1–15
- [ ] All generated levels guaranteed solvable
- [ ] Level select screen with lock/unlock progression
- [ ] 720×1280 portrait, aspect="keep"
