# Procedural Layout and Encounter Design: Levels 16-100

- **Area/Region**: Procedural Campaign Region (Archive Database)
- **Type**: Optical Logic / Word Puzzles
- **Pacing Cadence**: Tiers 2–10 (10 levels per tier)
- **Status**: Approved

---

## 1. Overview & Narrative Context

The Procedural Campaign Region represents the player's descent into the deep celestial cipher database of the ancient Archive. Having mastered the basic concepts in the first 15 handcrafted levels, the player must now decrypt corrupted layers of the system.

### Narrative Purpose & The Core Fantasy
The player takes on the role of the Decryptor of the ancient Archive database, tasking them with activating dormant logic lines in a crumbling celestial machine. As ciphers are solved, fragments of the Archive's ancient "Librarian" AI guide are unlocked, speaking through database triggers to reveal the history of the Solstice Cipher and the collapse of the celestial machine.

### Characters
- **The Decryptor (Player)**: A technician routing celestial beams of light to rebuild structural databases.
- **The Librarian AI**: A corrupted, fragmenting archival intelligence that guides, queries, and provides clues to the player, gradually regaining clarity as the ciphers are resolved.

### Detailed Emotional Arc
- **Tiers 2–4 (Curiosity / Booting)**: Faint signals, clean void, simple structures. The player feels a sense of quiet exploration, hearing the first distorted whispers of the Librarian AI.
- **Tiers 5–7 (Tension / Friction)**: Winding pathways, color filters, spatial portals. The narrative reveals system corruption, and the music/visuals shift to represent a complex, labyrinthine system with increasing puzzle friction.
- **Tiers 8–10 (Mastery / Overdrive)**: Massively complex circuits, converging beams, cosmic background scale. The player experiences the triumphant decryption of the ultimate Cipher Solstice, aligning the rings at Level 100 with the Librarian AI fully restored.

---

## 2. Lore & Environmental Storytelling

The Archive Database contains the remnants of stellar ciphers. Decrypting them restores the structural alignment of the celestial machine.

### Lore Mechanics
- **Data Shards**: Hexagonal frames that lock target characters. These shards represent encrypted records from the Solstice era. Hitting a shard with a light beam of the correct color decodes its character.
- **Stardust Clusters**: Small, interactive particle groups that glow brightly and emit gentle chime sounds when swept by an active light beam. They represent residual energy packets left behind by the database collapse. Capturing all clusters in a level grants a flat **+20% bonus** to the level's total energy payout.
- **Dormant Logic Lines**: Thin, desaturated vector lines (`#1F4040` at 10% opacity) that run along valid 15-degree ray paths, showing the physical guidelines of the ancient architecture.

## 3. Spatial Layout Guidelines (Dynamic Vector Geometry)

To support physically accurate 15-degree light routing, the playable arena positions components dynamically along calculated ray paths (conforming to [ADR-0005](file:///Users/fanioz/solstice-cipher/docs/architecture/adr-0005-puzzle-solver-algorithm.md)).

### The Dynamic Coordinate System
- **Size**: 720x1280 pixels coordinate space.
- **Visual Guidelines**: A Cartesian grid of `12 Columns x 18 Rows` (`BOARD_COLS = 12`, `BOARD_ROWS = 18`, cell width/height `60 pixels`) is rendered as a visual reference for players.
- **Component Placement**: Tools are placed continuously at precise floating-point coordinates along the solved light ray path, rather than being restricted to discrete cell centers. This avoids cumulative angle offsets and visual drift.
- **Angled Snapping**: Tools snap their rotations to exactly **15-degree increments** (in radians: `step = PI / 12`).
- **Quantization Rule**: All ray-casting intersection calculations are quantized using `Vector2.snapped(Vector2(0.001, 0.001))` to prevent float drift across multiple bounces.

### Boundary Shapes & Clearance Rules
As the player descends deeper, the playable space boundary shrinks or morphs to represent database corruption, forcing layouts closer to the center:
- **Tiers 2–4 (Symmetric Rectangles)**: Standard `720x1080` bounding box (representing columns 0–11, rows 0–17).
- **Tiers 5–7 (Hexagonal Void)**: Corners of the coordinate space are truncated (placements are blocked within columns 0-1 and 10-11 at the top and bottom rows).
- **Tiers 8–10 (Octagonal Void)**: Strict radial boundaries. Corners are heavily cut, concentrating placements around the central Nexus Core.

---

## 4. Difficulty & Pacing Curve (Tiers 2–10)

The campaign progression balances word length, piece budget, and path complexity. Pacing follows a **Mini-Arc** of 10 levels per tier:
1. **Levels X1–X3 (Intro)**: Introduces the tier's new tool in isolation. Simple direct paths.
2. **Levels X4–X6 (Combine)**: New tool combined with one prior mechanic. Average length paths.
3. **Levels X7–X9 (Challenge)**: Tight budgets, multiple turns, static obstacles.
4. **Level X0 (Boss / Archival Gate)**: The ultimate logic test of the tier with minimal budget.

### Curriculum Pacing Table

| Tier | Theme / Tool | Word Length | Piece Budget | Max Bounces | Min Turns | Target Winding Coeff* |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **T2** | Refraction (Prism) | 3–4 letters | 4 | 4 | 1 | 1.0 |
| **T3** | Spectrum (Filter) | 4 letters | 5 | 5 | 2 | 1.2 |
| **T4** | Shadow (Shade) | 4–5 letters | 5 | 5 | 2 | 1.3 |
| **T5** | Geometry (Bender) | 5 letters | 6 | 6 | 3 | 1.5 |
| **T6** | Warp (Portal) | 5–6 letters | 6 | 6 | 3 | 1.6 |
| **T7** | Convergence (Combiner)| 6 letters | 6–8 | 7 | 4 | 1.8 |
| **T8** | Mastery (All Tools) | 6–7 letters | 7–9 | 7 | 4 | 2.0 |
| **T9** | Cipher (High Limit) | 7 letters | 8–10 | 8 | 5 | 2.2 |
| **T10**| Solstice (Absolute) | 7–8 letters | 8–10 | 9 | 5 | 2.5 |

*\*Winding Coefficient is defined as: `(Actual Path Length) / (Straightline Distance from Source to Target)`. Higher values force the generator to reject direct routes, requiring complex geometric zig-zags.*

### Briefcase Budget Allocation ($N_B$)
The briefcase capacity $N_B(L)$ for level $L = 10(T-1) + k$ (where $T$ is the Tier and $k \in [1,10]$ is the level's position in the tier) is defined by the mini-arc difficulty cadence:
- **Intro (Levels X1–X3)**: $N_B(L) = \text{Budget}_{\min}(T)$
- **Combine (Levels X4–X6)**: $N_B(L) = \text{Budget}_{\min}(T) + 1$
- **Challenge (Levels X7–X9)**: $N_B(L) = \text{Budget}_{\max}(T)$
- **Boss (Level X0)**: $N_B(L) = \text{Budget}_{\max}(T) - 1$

Where the tier budgets are defined as:
- **Tiers 2–6**: $\text{Budget}_{\min} = T + 1$, $\text{Budget}_{\max} = T + 2$
- **Tier 7 (Convergence)**: $\text{Budget}_{\min} = 6$, $\text{Budget}_{\max} = 8$
- **Tier 8 (Mastery)**: $\text{Budget}_{\min} = 7$, $\text{Budget}_{\max} = 9$
- **Tier 9 (Cipher)**: $\text{Budget}_{\min} = 8$, $\text{Budget}_{\max} = 10$
- **Tier 10 (Solstice)**: $\text{Budget}_{\min} = 8$, $\text{Budget}_{\max} = 10$

### Padding Generation Rules
The padding set $P$ of size $N_B(L) - k_{\text{sol}}$ is populated using a weighted random distribution based on the unlocked tools pool $U_T$ for the current Tier $T$:
1. **New Tool Presence Guarantee (Tiers 2–7)**: If the introduced tool $t_{\text{new}}$ of Tier $T$ has a count of $0$ in the solution set $S$, there is a **60% probability** that $1$ unit of $t_{\text{new}}$ is added to the padding set $P$. This prevents players from meta-solving layouts.
2. **Remaining Slots Weighting**:
   - **Mirror**: 40%
   - **Prism / Splitter**: 20%
   - **Bender** (Tier 5+): 15%
   - **Filter** (Tier 3+): 10%
   - **Portal** (Tier 6+): 10%
   - **Combiner** (Tier 7+): 5%
3. **Mastery Tiers (Tiers 8–10)**: Padding is selected with equal probability across all unlocked tools, but capped at a maximum of $2$ units of any non-Mirror tool to prevent briefcase UI clutter.

### Unique Letter Caps & Vocabulary Constraints
1. **Duplicate Letter Consolidation**: The board contains exactly one physical Glyph for each unique letter in the word. The UI displays the full word, and activating the Glyph illuminates all instances of that letter.
2. **Tier Vocabulary Parameters**:
   - **Tier 2 (Levels 16-20)**: Length 3-4 letters (Max 3 unique letters). Character Pool: `S, U, N, R, A, Y, O, B, K, D, I, M, L, T, G, W, E` (17 characters).
   - **Tier 3 (Spectrum)**: Length 4 letters (Max 4 unique letters). Character Pool: Tier 2 + `H, Z` (19 characters).
   - **Tier 4 (Shadow)**: Length 4-5 letters (Max 4 unique letters). Character Pool: Tier 3 + `P, C, F` (22 characters).
   - **Tier 5 (Geometry)**: Length 5 letters (Max 5 unique letters). Character Pool: Tier 4 + `J, X` (24 characters).
   - **Tier 6 (Warp)**: Length 5-6 letters (Max 5 unique letters). Character Pool: Full English alphabet.
   - **Tier 7 (Convergence)**: Length 6 letters (Max 5 unique letters). *Note: Combiner activation requires splitting light into two inputs, reducing the budget available for unique letter routing.*
   - **Tier 8 (Mastery)**: Length 6-7 letters (Max 6 unique letters).
   - **Tier 9 (Cipher)**: Length 7 letters (Max 6 unique letters).
   - **Tier 10 (Solstice)**: Length 7-8 letters (Max 6 unique letters).
   - *Exclusion Rule*: Highly unique 7-8 letter words with >6 unique letters (e.g. `LUMINOUS`, `MERIDIAN`, `DAYBREAK`, `MIDNIGHT`, `SPECTRUM`, `RADIANCE`) are excluded, as routing to 7+ targets exceeds max splitter and routing capacities. Only words like `CRESCENT` (5 unique), `STARFALL` (6 unique), `TWILIGHT` (6 unique), and `SOLSTICE` (6 unique) are valid in Tier 10.

---

## 5. Procedural Placement Rules for Encounters

To guarantee 100% solvability and avoid "cheese" solutions, the generator executes a **Two-Pass Placement Pipeline**.

```
   [Pass 1: Backwards Solve]
   Trace mathematical path from Glyphs -> Source.
   Place minimum required tools (Mirrors, Prisms, Filters, Portals).
               │
               ▼
   [Pass 2: Forward Ray Simulation]
   Simulate light propagation from Source.
   Detect alternative routes or shortcuts.
               │
               ▼
   [Place Interference Encounters]
   Add Shades, paired Portals, or false targets to block cheats.
```

### Obstacle (Shade) Placement Rules
- **Rule 1 (Anti-Cheese)**: If a forward simulation reveals that a light ray can hit a glyph *without* passing through its required color filter or portal, the generator places a **Shade** at the intersection cell of the shortcut to block it.
- **Rule 2 (Boundary Spacing)**: Shades must never be placed on cells immediately adjacent to a player-placed tool's solved cell, ensuring players have room to rotate their pieces.

### Portal Placement Rules (Tier 6+)
- **Rule 1 (Distance Span)**: Portals must always span a minimum distance of **5 grid units** between the entry and exit nodes.
- **Rule 2 (Obstacle Bypass)**: The generator must place a solid block of static walls or Shades between the portal pairs. This forces the player to warp the beam *through* the barrier rather than routing around it.

### Filter Placement Rules (Tier 3+)
- **Rule 1 (Color Assignment)**: If a glyph requires red, green, or blue light, the filter must be placed on an intermediate cell along that glyph's path.
- **Rule 2 (No Color Mixing)**: The filter must be placed *after* any prisms that split the beam to other glyphs that require white or different colored light, preventing unwanted color propagation.

### Combiner Placement Rules (Tier 7+)
- **Rule 1 (Dual Input)**: When a glyph requires a Combiner activation, the generator splits the path backwards from the glyph at a Combiner node, creating **two separate path branches**. Both branches must be traced independently back to the source or to a Prism splitter.
- **Rule 2 (Simultaneous Strike)**: The briefcase budget must accommodate the mirrors required to align both beams to hit the Combiner node.

### A* Pathfinder Validation Parameters
- **Maximum Generator Iterations**: The level scaffolder is capped at **200 layout attempts** per level. If no valid configuration is found, it selects a different word or reduces the winding coefficient constraint.
- **Pathfinder Search Limit**: The pathfinder is capped at a maximum of **10,000 explored nodes** per single glyph-to-source route search.
- **A* State Space & Heuristic**: The search state represents coordinate and direction vectors `(x, y, dx, dy)` (supporting continuous placement validation off-grid centers). The heuristic function $h(P)$ is a standard, admissible distance metric:
  $$h(P) = \text{EuclideanDistance}(P, P_{\text{target}})$$
- **Search Step-Cost**: Transitions between search nodes $P \rightarrow P'$ enforce valid 15-degree angles using step cost penalties rather than the heuristic, avoiding heuristic dominance and local minima lockups:
  $$g(P, P') = \text{StepDistance}(P, P') + f_{\text{align}}(P')$$
  where the transition penalty $f_{\text{align}}(P') = 0$ if the vector matches a 15-degree snap angle, and $\infty$ (representing a blocked transition) otherwise.
- **State Space Cache**: Capped at **50,000 entries** (approx. 16MB) per level generation. All temporary search maps and node caches are explicitly cleared at the end of each generation cycle.

---

## 6. Entry/Exit & Transitions

### The Decryption Sequence (Level Completion)
1. **The Overcharge**: On final puzzle alignment, the cyan light beams flare into a blinding **warm gold (#FFD700)** shockwave.
2. **The Decryption Shockwave**: The gold shockwave travels backward along the paths, from the Glyphs back to the Sun Emitter.
3. **Void Collapse**: The screen snaps to pitch black for 0.5 seconds, then reveals the decrypted word in glowing, high-intensity typography.
4. **Data Sync**: The aligned rings of the background **Cipher Solstice** rotate into place with a mechanical whirr.
5. **Zoom Out**: The camera zooms out smoothly, morphing the level grid back into a single glowing point on the **Level Select Screen**.

### Dialogue Triggers (Librarian AI)
- **Archival Gates (Level X0)**: Upon completing a Boss Level (e.g., Level 20, 30, etc.), the transition to the Level Select screen is briefly interrupted. A clean monospace text terminal overlays:
  - *"Archive Sector [Tier Name] unlocked. Decrypting celestial data..."*
  - Followed by a 2-line dialogue sequence from the Librarian AI detailing the history of the Solstice Cipher.
- **Failure Dialogue**: If a player spends more than 5 minutes on a level or resets 10 times, the Librarian drops a cryptic hint about the behavior of the newly introduced tool (e.g., *"Portals do not block light; they transport its frequency. Look beyond the physical blockades."*)

---

## 7. Art Production Concepts

Governed by the visual rule: *"Luminescence is function; everything else is the void."*

### Tier-by-Tier Color Templates
1. **Tier 2 (Levels 16-20) - Cobalt Template**: Deep space navy with electric cyan active traces.
2. **Tier 3 (Levels 21-30) - Amethyst Template**: Soft, desaturated purples and violet accent lines.
3. **Tier 4 (Levels 31-40) - Emerald Template**: Dark forest voids with sharp emerald green framing.
4. **Tier 5 (Levels 41-50) - Amber Template**: Muted ochre and bronze tones with high-bloom amber accents.
5. **Tier 6 (Levels 51-60) - Ultraviolet Template**: Deep indigo with neon UV pink/magenta warp signatures.
6. **Tier 7 (Levels 61-70) - Crimson Template**: Dark burgundy void with burning ruby energy lines.
7. **Tier 8 (Levels 71-80) - Gold Template**: High-contrast, brass-tinted void with metallic gold highlights.
8. **Tier 9 (Levels 81-90) - Platinum Template**: Cool slate grey void with clean, high-intensity silver-white lines.
9. **Tier 10 (Levels 91-100) - Solar Template**: Deep dark crimson void with blazing solar-corona white-orange light sources.

### Visual Zones Specifications
- **Level Entry (Solar Emitter Void)**: Emitter casing is a void-black geometric box (`light_emitter.webp`) outlined with a crisp vector trace, centered at fixed coordinate `Vector2i(6, 16)` representing `(390, 990)` pixels. The emitter core pulses with a low-frequency breath animation (period of 3.0s).
- **Active Grid Areas**: Near-pitch black (`#050508`), grid guidelines (`#1F4040` at 10% opacity) forming a 12x18 Cartesian circuit visual reference. Active light beams are razor-sharp neon cyan ribbons drawn along continuous vector paths.
- **Landmark Areas**:
  - **Nexus Core**: A central background element. Restricts its detail level per tier (T2-T4: faint point; T5-T7: orbiting rings; T8-T10: bright singularity with gravitational lensing).
  - **Cipher Solstice**: Massive circular vector ring system framing the boundaries.
  - **Stardust Clusters**: Small, interactive particle groups that glow brightly when swept.
  - **Dormant Logic Lines**: Thin, desaturated lines (`#1F4040` at 10% opacity) showing valid 15-degree paths.
- **Level Exit (Glyph Receivers)**: Unpowered flat, dark green hexagonal frames (`#003300`). Powered states erupt into neon green (`#00FF00`) with high bloom. On victory, they flare into gold (`#FFD700`).

### Shared vs. Unique Assets Manifest
- **Shared Assets (Global Pool)**: Located at `src/assets/sprites/` (`light_emitter.webp`, `mirror.webp`, `prism.webp`, `filter.webp`, `shade.webp`, `bender.webp`, `portal.webp`, `combiner.webp`, `symbol.webp`).
- **Unique Assets**: `bg_nexus_core_[tier].webp`, `bg_solstice_ring_[tier].webp`, `boundary_rect.webp`, `boundary_hex.webp`, `boundary_oct.webp`, `grid_node_[tier].webp`, `stardust_cluster_[tier].webp`.

### Lighting Setup Parameters

| Parameter | T2-T4 (Cobalt/Amethyst/Emerald) | T5-T7 (Amber/Ultraviolet/Crimson) | T8-T10 (Gold/Platinum/Solar) |
| :--- | :--- | :--- | :--- |
| **Base Void Color** | `#050508` (Dark cool tint) | `#07050A` (Dark indigo/red tint) | `#0B0805` (Dark bronze/charcoal) |
| **Active Beam Bloom Glow Strength** | `1.5` | `1.8` | `2.2` (Overdrive glow) |
| **Beam Glow Radius** | `12 pixels` | `16 pixels` | `20 pixels` (Thick corona bloom) |
| **Emitter Halo Radius** | `40 pixels` | `50 pixels` | `60 pixels` |
| **Illumination Falloff Curve** | `Linear` | `Quadratic` | `Exponential (Sharp)` |
| **Dormant Grid Opacity** | `10%` | `8%` | `5%` (Nearly invisible visual reference grid) |

*Core parameters: Ambient Light Intensity = 0.0, Beam Core Brightness = 1.0 (additive blend, 100:1 contrast ratio).*

### VFX Requirements
- **Level Select Transition**: Camera zooms into the grid node, lines disintegrate into an implosion of code particles.
- **Decryption Shockwave**: Lines change to warm gold (`#FFD700`), custom shader draws glowing wavefront, triggering particle bursts.
- **Void Background Dust Drift**: Subtle vertical/radial dust particles drift behind the playing grid (3-5% opacity, max 50 particles).
- **Failure Reset**: Glitch shader displacement paired with orange-red decay particles (`#FF3300`, duration 0.3s).

### Production Risks & Visual Conflicts
- **Aliasing on 15-Degree Beam Snapping**: Mitigated using Godot's `Line2D` with anti-aliasing and custom vector textures with smooth alpha edges.
- **Color Clashing with Spectrum Filters in Thematic Tiers**: Mitigated by restricting background landmarks to `<=15%` saturation and `<=20%` brightness.
- **Nexus Core Occlusion in Octagonal Voids**: Mitigated by rendering the Nexus Core with a parallax depth offset and applying a slight darkening vignette beneath the grid.
- **Visual Clutter from High Bounce Counts**: Mitigated by using flat, dark grey styling for obstacles (`ASSET-025`) and routing active beams with high Z-index/bloom.

---

## 8. Accessibility & Colorblind Safety

Evaluating against WCAG 2.2 and Xbox Accessibility Guidelines, several gaps have been identified and remediations proposed.

### Identified Gaps & Gaps log (Known Gaps)
- **A11Y-01: Color-Only Spectrum Mechanics (Blocking)**: Red, Green, and Blue beams/filters are distinguished solely by hue, blocking protanopia/deuteranopia/tritanopia players.
- **A11Y-02: Low-Contrast Grid lines (Blocking)**: Dormant grid slot indicators (`#1F4040` at 10% opacity) against black (`#050508`) yield a 1.05:1 contrast ratio, making slots invisible to low-vision players.
- **A11Y-03: Lack of Assistive Input (Blocking)**: Briefcase UI relies exclusively on click-and-drag gestures, blocking players with physical/motor disabilities.
- **A11Y-04: Portal Mapping Ambiguity (Recommended)**: Multiple portal pairs on a board use the same sprite, creating cognitive overload.
- **A11Y-05: Combiner Working Memory Load (Recommended)**: Combiners require simultaneous dual-input activation with no partial solution feedback.
- **A11Y-06: Monospace scaling & screen reader support (Recommended)**: Corrupt terminal overlays are hard to scale or read out via TTS.
- **A11Y-07: Tool Orientation Ambiguity (Recommended)**: 15-degree snaps can be difficult to visually verify.
- **A11Y-08: Vestibular / Motion Sensitivity (Nice to Have)**: Gold decryption shockwaves, screen flashes, and rapid zoom out may cause motion sickness.
- **A11Y-09: Lack of Audio-Only Feedback (Nice to Have)**: Solved states and connections are communicated primarily through visual bloom.

### Proposed Technical Remediations
1. **Patterned Beams**: Represent light colors with distinct textures (Solid = White, Dashed = Red, Dotted = Green, Alternating = Blue).
2. **Geometric Filter Shapes**: Filters feature structural borders (Round = White, Triangular = Red, Square = Green, Hexagonal = Blue).
3. **Target Glyph Borders**: Outer hexagonal glyph frames morph to match the geometric filter shapes.
4. **High-Contrast Toggle**: Settings option to increase grid line opacity to 40% and draw a white outline around hovered cells.
5. **Keyboard/Controller Navigation**: Implement grid-based cursor controlled via WASD/Arrow/D-pad, selecting items with Space/Enter and rotating with R.
6. **Portal Visual Pairing & Tethers**: Pair portals using unique geometric sub-textures on the wormholes and draw a connection line on hover.
7. **Combiner Partial Feedback**: Add indicators showing which ports are currently powered, and allow saving progress on individual sub-paths.
8. **TTS & Scaling**: Provide UI font scaling up to 200% and integrate Godot's `DisplayServer.tts_speak()` for terminal text.
9. **Tool Directional Indicators**: Add a small glowing notch/arrow on the perimeter of tool sprites pointing in the reflection normal direction.

---

## 9. QA Test Plan & Playtest Checklist

### Automated Unit & Integration Tests

#### A. Generator Termination & Performance Safety (`tests/unit/procedural_generation/generator_termination_test.gd`)
- Assert that the `LevelScaffolder` terminates and returns `null` if a valid layout is not found within 200 attempts.
- Assert that the A* pathfinder terminates when explored nodes exceed 10,000 per route search.
- Assert that the visited state cache does not exceed 50,000 entries (approx. 16MB) and is cleanly deallocated.

#### B. Path Solvability Verification (`tests/integration/procedural_generation/path_solvability_test.gd`)
- Generate 100 random levels across Tiers 2-10, simulate forward raycasting, and assert that all targets are successfully illuminated.
- Assert that each Glyph receives the correct color required.
- Assert that the solved tool count is `<= Piece Budget` ($N_B$) allocated for the level.

#### C. Word Database Matching (`tests/unit/procedural_generation/word_database_test.gd`)
- Verify that selected words match target lengths per tier.
- Assert that duplicate letter consolidation functions correctly (instantiating exactly one physical Glyph per unique letter).
- Assert that UI grid synchronization activates all character slots on the UI.

#### D. Boundary & Edge Cases
- **Grid Snapping Precision (`tests/unit/physics/grid_snapping_precision_test.gd`)**: Assert tools snap to 15-degree increments. Assert raycast calculations snapped using `Vector2.snapped(Vector2(0.001, 0.001))` to prevent float drift.
- **Portal Cycle Loops (`tests/integration/physics/portal_loop_test.gd`)**: Setup cycle feedback loop, verify propagation terminates at recursion limit. Enforce portal min distance of 5 grid units and physical separation via solid walls.
- **Combiner Deadlock States (`tests/unit/physics/combiner_deadlock_test.gd`)**: Assert Combiner activates only on simultaneous input frame strike. Reject levels where budget is insufficient to route both branches.

### Playtest Checklist

#### A. Pacing & Progression
- [ ] Verify that complexity and winding coefficients escalate smoothly from Level X1 to Level X0.
- [ ] Verify that Tier $T+1$ unlocks on the map when cumulative Energy Nodes reach the threshold (70% average levels solved).
- [ ] Verify Librarian AI terminal overlay triggers on completing Level X0, and tips trigger on 5 minutes elapsed or 10 resets.

#### B. Controls & Snapping Feedback
- [ ] Drag tool: verify responsive snap to grid node.
- [ ] Rotate tool: verify snapping to exactly 15-degree increments.
- [ ] Right-click tool: verify instant return to briefcase.
- [ ] Mobile touch test: verify fingers do not block drag accuracy.

#### C. Visuals & Audio Signalling
- [ ] Verify decryption victory sequence (gold shockwave $\rightarrow$ void collapse to black $\rightarrow$ glowing gold letters $\rightarrow$ Solstice ring rotate $\rightarrow$ zoom out).
- [ ] Verify crystal chimes on sweeping Stardust, connection chimes, and decay sounds on reset.
- [ ] Verify readability of beams against all 9 tier color templates.

### Definition of Done & Level Completion Criteria
A level is marked **DONE** and progression updated when:
- [ ] **Simultaneous Strike**: All target glyphs representing the unique letters of the word are simultaneously hit by active beams of matching color.
- [ ] **Word Decryption UI**: The spelling tracker highlights all letter slots and plays the decryption transition (completes in exactly 0.5 seconds at 60fps).
- [ ] **Save Game Persisted**: Level status is saved to local JSON save registry (`completed: true`).
- [ ] **Energy Node Calibration**: Energy is added to the player's lifetime cumulative total. Awarded amount matches:
  $$\mathcal{E} = 10 \times N_{\text{unique}} \times (1.0 + (T-1) \times 0.2)$$
  *Note: Add +20% bonus if all optional Stardust Clusters were swept by active beams.*
- [ ] **Map Progression Unlock**: Cumulative lifetime energy is updated, and if it meets the next tier's threshold (e.g. T2 at 100, T3 at 300, etc.), the next tier is marked as `unlocked: true`.

### Playtest Checklist & Verification Criteria (A11Y & Controls)
- [ ] **Drag & Drop Snapping**: Moving a tool snaps its center to the nearest continuous placement coordinate vector within a 5-pixel tolerance boundary.
- [ ] **Keyboard Cursor**: Pressing arrow keys moves the navigation grid selector cursor from slot to slot (movement transition completes within 3 frames at 60fps).
- [ ] **Contrast Verification**: In the high-contrast grid setting, grid lines measure at least a **3:1** contrast ratio against the void background using a luminance test tool.
- [ ] **Audio Feedback**: Resolving a connection plays the connection chime (volume matches -12dB peaks), and completing a level plays the gold decryption chord (-6dB peak).
