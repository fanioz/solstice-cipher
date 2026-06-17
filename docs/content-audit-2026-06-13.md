# Content Audit — 2026-06-13

## Summary
- **Total specified**: 259 content items across 7 categories
- **Total found**: 84
- **Gap**: 175 items (68% unimplemented)
- **Scope**: Full audit (all systems)

> [!NOTE]
> Counts are approximations based on file scanning. The audit cannot distinguish
> shipped content from editor/test assets. Manual verification is recommended
> for any HIGH PRIORITY gaps.

---

## Gap Table

| Category | Content Type | Specified | Found | Gap | Status |
|----------|-------------|-----------|-------|-----|--------|
| **Tools** | Gameplay tool scripts (beam mechanics) | 7 | 7 | 0 | ✅ COMPLETE |
| **Tools** | Gameplay tool scenes (.tscn) | 7 | 5 | 2 | 🟡 IN PROGRESS |
| **Tools** | Tool sprites (.webp) | 7 | 9 | 0 | ✅ COMPLETE |
| **Levels** | Hand-crafted tutorial levels (1–15) | 15 | 3 | 12 | 🔴 EARLY |
| **Levels** | Procedural levels (16–100) at runtime | 85 | 0† | 85 | ⚪ SEE NOTE |
| **Word Lists** | 3-letter words | 20 | 20 | 0 | ✅ COMPLETE |
| **Word Lists** | 4-letter words | 20 | 20 | 0 | ✅ COMPLETE |
| **Word Lists** | 5-letter words | 20 | 20 | 0 | ✅ COMPLETE |
| **Word Lists** | 6-letter words | 20 | 20 | 0 | ✅ COMPLETE |
| **Word Lists** | 7-letter words | 20 | 20 | 0 | ✅ COMPLETE |
| **Word Lists** | 8-letter words | 10 | 10 | 0 | ✅ COMPLETE |
| **UI Screens** | Title Screen | 1 | 1 | 0 | ✅ COMPLETE |
| **UI Screens** | Level Select Screen | 1 | 0 | 1 | 🔴 NOT STARTED |
| **UI Screens** | Briefcase UI | 1 | 1 | 0 | ✅ COMPLETE |
| **UI Screens** | Cipher HUD | 1 | 1 | 0 | ✅ COMPLETE |
| **UI Screens** | End/Win Screen | 1 | 1 | 0 | ✅ COMPLETE |
| **UI Screens** | Tool Reveal Animation | 1 | 0 | 1 | 🔴 NOT STARTED |
| **Proc-Gen** | Level Scaffolder | 1 | 1 | 0 | ✅ COMPLETE |
| **Proc-Gen** | Backwards Solver | 1 | 1 | 0 | ✅ COMPLETE |
| **Proc-Gen** | Optical Radial A* | 1 | 1 | 0 | ✅ COMPLETE |
| **Proc-Gen** | Wall Generator | 1 | 1 | 0 | ✅ COMPLETE |
| **Data** | Progression curve (100 levels) | 1 | 1 | 0 | ✅ COMPLETE |
| **Audio** | UI sound effects | ~5 | 0 | 5 | 🔴 NOT STARTED |
| **Audio** | Beam bounce/crystal SFX | ~5 | 0 | 5 | 🔴 NOT STARTED |
| **Audio** | Background music tracks | ~2 | 0 | 2 | 🔴 NOT STARTED |

> † Procedural levels (16–100) are generated at runtime by the scaffolder + backwards solver.
> The generator code exists and passes unit tests, but there is **no runtime integration**
> that calls it from a level-select flow or game-loop driver. Counted as a structural gap
> rather than a content gap.

---

## HIGH PRIORITY Gaps

### 🔴 Hand-Crafted Tutorial Levels — 3/15 (20%)
**Rationale**: The GDD specifies 15 hand-crafted tutorial levels (Levels 1–15) to teach
tool mechanics. Only 3 exist: `main.tscn` (Level 1, 1 glyph), `level_2.tscn` (2 glyphs),
`level_3.tscn` (3 glyphs). All three use only Mirror + Prism. 12 levels are missing,
including all tutorials for Filter, Shade, Bender, Portal, and Combiner.

**MVP impact**: HIGH — tutorials are gated before procedural generation begins. Without
them, no player-facing progression exists.

### 🔴 Missing Tool Scenes — 2/7 (71%)
**Rationale**: The beam mechanics layer has all 7 tool scripts (`mirror.gd`, `prism.gd`,
`filter.gd`, `shade.gd`, `bender.gd`, `portal.gd`, `combiner.gd`), but only 5 have
corresponding `.tscn` scene files:
- ✅ `mirror.tscn`, `splitter.tscn` (Prism), `filter.tscn`, `portal.tscn`, `combiner.tscn`
- ❌ **Missing**: `shade.tscn`, `bender.tscn`

Without scenes, Shade and Bender cannot be placed on the board via the Briefcase UI.

### 🔴 Level Select Screen — 0/1
**Rationale**: The GDD and progression spec call for a "Grid of 100 levels, locked/unlocked"
screen. No `level_select.tscn` or `level_select.gd` exists. Currently the game flows
Title → Level 1 → Level 2 → Level 3 → End Screen with no ability to select or replay levels.

### 🔴 Audio — 0/12
**Rationale**: The GDD specifies "Crisp UI sounds, satisfying crystal chimes for light bounces"
and "Moderate" audio needs. Zero audio files (`.ogg`, `.wav`, `.mp3`) exist in the project.
No `AudioStreamPlayer` nodes found in any scene.

### 🟡 Tool Reveal Animation — 0/1
**Rationale**: The spec calls for a "brief tool reveal animation" when entering a new tier.
No animation or UI for this exists.

---

## Per-System Breakdown

### Tools / Beam Mechanics
- **GDD**: [game-concept.md](file:///Users/fanioz/solstice-cipher/design/gdd/game-concept.md), [level-progression-design.md](file:///Users/fanioz/solstice-cipher/design/specs/2026-06-08-level-progression-design.md)
- **Content types audited**: Tool scripts, tool scenes, tool sprites
- **Notes**: All 7 beam mechanics scripts exist and are unit-tested (48 tests pass). Shade and Bender lack `.tscn` scene wrappers. The `main.gd` script handles spawning for mirror, prism, filter, portal, and combiner but has no `elif` branch for "shade" or "bender" tool types.

### Levels
- **GDD**: [level-progression-design.md](file:///Users/fanioz/solstice-cipher/design/specs/2026-06-08-level-progression-design.md)
- **Content types audited**: Hand-crafted level scenes, procedural generator
- **Notes**: 3 hand-crafted levels exist (main.tscn, level_2.tscn, level_3.tscn). The progression curve CSV defines all 100 levels but the first 15 are labeled "Handcrafted" — only 3 of those scene files exist. The procedural generator and backwards solver are implemented and tested but have no runtime integration path.

### Word Lists
- **GDD**: [level-progression-design.md](file:///Users/fanioz/solstice-cipher/design/specs/2026-06-08-level-progression-design.md)
- **Content types audited**: Word dictionary in `level_scaffolder.gd`
- **Notes**: All 110 curated words across 6 length categories (3–8 letters) are implemented exactly as specified. ✅ COMPLETE.

### UI Screens
- **GDD**: [game-concept.md](file:///Users/fanioz/solstice-cipher/design/gdd/game-concept.md)
- **Content types audited**: Title, Level Select, Briefcase, Cipher HUD, End Screen, Tool Reveal
- **Notes**: 4/6 UI screens are implemented. Level Select and Tool Reveal Animation are missing.

### Procedural Generation
- **GDD**: [level-progression-design.md](file:///Users/fanioz/solstice-cipher/design/specs/2026-06-08-level-progression-design.md)
- **Content types audited**: Scaffolder, Backwards Solver, A*, Wall Generator
- **Notes**: All 4 core procedural generation systems are implemented with passing unit tests. The gap is integration — no runtime level loader calls the generator from a game loop.

### Audio
- **GDD**: [game-concept.md](file:///Users/fanioz/solstice-cipher/design/gdd/game-concept.md)
- **Content types audited**: SFX, music, AudioStreamPlayer nodes
- **Notes**: Zero audio assets or audio nodes exist. The GDD describes "Moderate" audio needs with "crisp UI sounds" and "crystal chimes."

### Data / Balance
- **Source**: [progression-curve.csv](file:///Users/fanioz/solstice-cipher/design/balance/progression-curve.csv)
- **Content types audited**: Progression curve data
- **Notes**: 100-row CSV fully defines tier, type, word length, piece budget, and unlocked tool for all 100 levels. However, there is a discrepancy: the GDD spec defines 10 tiers of 10 levels, but the CSV uses only 7 tiers for 100 levels (15 levels in tier 1, 15 in tiers 2–7). This is a design consistency gap worth reviewing.

---

## Recommendation

Focus implementation effort on:

1. **Missing tool scenes** (`shade.tscn`, `bender.tscn`) + `main.gd` spawning branches — quick wins that unblock all tutorials
2. **Hand-crafted tutorial levels** (Levels 4–15) — critical for player onboarding; blocks the full game loop
3. **Level Select Screen** — required to connect the 100-level progression system to the player experience
4. **Runtime procedural integration** — wire the level scaffolder + backwards solver into the game loop so levels 16–100 actually generate at play time
5. **Audio** — can be deferred to polish phase but should be planned

---

## Unspecified Content Counts

The following GDD areas describe content qualitatively but give no explicit count.
Consider adding counts to improve auditability:

| Source | Content Type | Issue |
|--------|-------------|-------|
| game-concept.md | Audio SFX | "Crisp UI sounds, satisfying crystal chimes" — no count of distinct sounds |
| game-concept.md | Music tracks | "Moderate audio needs" — no track count specified |
| level-progression.md | Tool Reveal animations | Described as "brief animation" — no spec for animation count or duration |

---

## Progression Curve Discrepancy

> [!WARNING]
> The GDD specifies **10 tiers × 10 levels = 100 levels**, but the progression curve CSV
> uses only **7 tiers** (Tier 1: 15 levels, Tiers 2–7: ~15 levels each). Tools "Shade" and
> "Bender" from the GDD (Tiers 4 and 5) are mapped to different tiers in the CSV
> (Tier 4 = Portal, Tier 5 = Combiner). Tool_6 and Tool_7 in the CSV are unnamed.
> This should be reconciled before building more tutorials.
