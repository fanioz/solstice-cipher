# Procedural Campaign Region - Production Concept Specs (Levels 16-100)

> **Art Director Sign-Off (AD-PROC-CONCEPTS)**: APPROVED
> **Source**: [art-bible.md](file:///Users/fanioz/solstice-cipher/design/art/art-bible.md), [procedural-layout-design.md](file:///Users/fanioz/solstice-cipher/design/levels/procedural-layout-design.md), [level-progression.md](file:///Users/fanioz/solstice-cipher/design/gdd/level-progression.md)
> **Target Region**: Archive Database (Levels 16-100)

## 1. Overview & Visual Progression
This document details the production-ready concept specifications for the 'Procedural Campaign Region' (Levels 16-100) of Solstice Cipher. Following the "Neon Cipher" visual rule: *"Luminescence is function; everything else is the void,"* the art progression must scale in alignment with mechanical complexity across Tiers 2 through 10.

### Tier-by-Tier Color Templates
The visual themes of the region evolve through nine progression color templates. Each template shifts the ambient color of the void background, the passive grid outline, and the highlights of active elements.

1. **Tier 2 (Levels 16-20) - Cobalt Template**: Deep space navy with electric cyan active traces. Emphasizes clean, basic debugging.
2. **Tier 3 (Levels 21-30) - Amethyst Template**: Soft, desaturated purples and violet accent lines. Introduces light filters.
3. **Tier 4 (Levels 31-40) - Emerald Template**: Dark forest voids with sharp emerald green framing. Emphasizes the presence of blocking shades.
4. **Tier 5 (Levels 41-50) - Amber Template**: Muted ochre and bronze tones with high-bloom amber accents. Introduces diagonal routing benders.
5. **Tier 6 (Levels 51-60) - Ultraviolet Template**: Deep indigo with neon UV pink/magenta warp signatures. Reflects portal wormholes.
6. **Tier 7 (Levels 61-70) - Crimson Template**: Dark burgundy void with burning ruby energy lines. Represents beam convergence.
7. **Tier 8 (Levels 71-80) - Gold Template**: High-contrast, brass-tinted void with metallic gold highlights. Represents system mastery.
8. **Tier 9 (Levels 81-90) - Platinum Template**: Cool slate grey void with clean, high-intensity silver-white lines. Represents final encryption gates.
9. **Tier 10 (Levels 91-100) - Solar Template**: Deep dark crimson void with blazing solar-corona white-orange light sources. The ultimate Solstice alignment.

---

## 2. Visual Specifications of Key Layout Areas

To maintain visual cohesion, the hybrid Cartesian-radial grid layout is split into four primary functional zones:

### A. Level Entry: The Solar Emitter Void
- **Description**: The starting point of all optical logic. The emitter node rests at a fixed cell, anchoring the coordinate system.
- **Visual Appearance**:
  - The Emitter casing is a void-black geometric box (`light_emitter.webp`) outlined with a crisp vector trace.
  - The core of the Emitter houses a brilliant white source casting a local, high-contrast glow matching the active tier's template color (e.g., violet glow in Tier 3, gold glow in Tier 8).
  - Faint, desaturated dormant socket indicators converge at the Emitter node, representing the entry vector.
- **Animation & Lighting**:
  - The Emitter core pulses with a subtle, low-frequency breath animation (period of 3.0s).
  - On level startup, the Emitter shoots its beam forward, igniting the active light path.

### B. Key Puzzle Zones: Active Grid Areas
- **Description**: The playable arena where players position optical tools.
- **Visual Appearance**:
  - The background is near-pitch black (`#050508`), tinted slightly by the active tier's color template.
  - Faint, grid-aligned node sockets (`#1F4040` at 10% opacity) form a 12x18 Cartesian circuit board.
  - Grid cell highlights glow briefly in the active tier's color when a tool is dragged over them.
  - The active light beam slices through the space as a razor-sharp, uniform-width neon cyan ribbon (tinted by color filters where appropriate).
  - Reflections off mirrors and splits from prisms happen at mathematically precise intersection points, creating sharp neon corners.

### C. Landmark Areas: Background & Navigation Guidance
- **Nexus Core**: A central background element (located at the center of the void, behind the grid). It is a cyan-white glowing singularity that remains visible throughout the puzzles.
  - *Tiers 2-4*: A faint, distant stardust-like point.
  - *Tiers 5-7*: A defined geometric ring structure orbiting the singularity.
  - *Tiers 8-10*: A highly structured, bright singularity casting a subtle warp (gravitational lensing effect via shader).
- **Cipher Solstice**: A massive, circular vector ring system framing the boundaries of the level select and the active board. It is dormant, lighting up section by section as words are decrypted.
- **Stardust Clusters**: Small, interactive particle groups that glow brightly and emit gentle chimes when swept by active beams, providing optional target landmarks for bonus points.
- **Dormant Logic Lines**: Thin, desaturated lines (`#1F4040` at 10% opacity) showing valid 15-degree ray paths, aiding spatial routing visualization.

### D. Level Exit: The Glyph Receivers
- **Description**: The terminal points representing the target word characters.
- **Visual Appearance**:
  - Unpowered state: Flat, dark green hexagonal frames (`#003300`) with recessed, unlit characters.
  - Powered state: Erupts into neon green (`#00FF00`) with high-intensity bloom. If hit by a filtered beam, the outer glow matches the filtered color (Red, Green, or Blue), but the letter remains crisp neon green.
  - Letters are displayed in a modern, sans-serif terminal font.
  - On level completion, the receivers flare into a brilliant gold (`#FFD700`) and the decrypted word is displayed.

---

## 3. Art Assets Manifest: Shared vs. Unique

To support clean asset packaging and performance targets on WebGL, assets are categorized into a shared global pool and region-specific unique files.

### Shared Assets (Global Pool)
These assets are located at `src/assets/sprites/` and are utilized across all levels 1-100:
- **`light_emitter.webp`** (ASSET-009): The main emitter source, 512x512px.
- **`mirror.webp`** (ASSET-002): The standard 90-degree reflector.
- **`prism.webp`** (ASSET-003): The prism/splitter.
- **`filter.webp`** (ASSET-004): The color filter.
- **`shade.webp`** (ASSET-005): The static path obstacle.
- **`bender.webp`** (ASSET-006): The 45-degree bender.
- **`portal.webp`** (ASSET-007): The bidirectional wormhole portal.
- **`combiner.webp`** (ASSET-008): The dual-beam combiner node.
- **`symbol.webp`** (ASSET-010): Base letter glyph hexagonal frames.

### Unique/Region-Specific Assets
These assets are generated specifically for levels 16-100 to differentiate the Tiers and boundary profiles:
- **`bg_nexus_core_[tier].webp`**: 9 unique background textures (512x512px) for the central singularity.
- **`bg_solstice_ring_[tier].webp`**: 9 unique concentric outer ring textures (1024x1024px) for the Cipher Solstice.
- **`boundary_rect.webp`** (ASSET-024): 12x18 bounding box vector lines.
- **`boundary_hex.webp`**: Truncated hexagonal board boundary lines for Tiers 5-7.
- **`boundary_oct.webp`**: Tight radial octagonal boundary lines for Tiers 8-10.
- **`grid_node_[tier].webp`**: Node socket textures matching the tier color palette (e.g., cobalt, amethyst, gold) to visually tint placement sockets.
- **`stardust_cluster_[tier].webp`**: Tiny particle texture arrays (128x128px) for optional light-sensitive chimes.

---

## 4. Sight-Line & Lighting Setup Rules

In accordance with the art bible's contrast strategy, there is zero ambient light. Lighting is strictly functional.

### Core Contrast Parameters
- **Ambient Light Intensity**: `0.0` (pure black void).
- **Beam Core Brightness**: `1.0` (peak luminance, absolute white center).
- **Beam Bloom/Glow Mode**: Additive blend mode.
- **Contrast Ratio**: `100:1` (between active beams and the True Void).

### Lighting Setup per Tier

| Parameter | T2-T4 (Cobalt/Amethyst/Emerald) | T5-T7 (Amber/Ultraviolet/Crimson) | T8-T10 (Gold/Platinum/Solar) |
| :--- | :--- | :--- | :--- |
| **Base Void Color** | `#050508` (Dark cool tint) | `#07050A` (Dark indigo/red tint) | `#0B0805` (Dark bronze/charcoal) |
| **Active Beam Bloom Glow Strength** | `1.5` | `1.8` | `2.2` (Overdrive glow) |
| **Beam Glow Radius** | `12 pixels` | `16 pixels` | `20 pixels` (Thick corona bloom) |
| **Emitter Halo Radius** | `40 pixels` | `50 pixels` | `60 pixels` |
| **Illumination Falloff Curve** | `Linear` | `Quadratic` | `Exponential (Sharp)` |
| **Dormant Grid Opacity** | `10%` | `8%` | `5%` (Nearly invisible void) |

---

## 5. VFX Requirements (Region Specific)

The procedural campaign region requires highly synchronized, grid-aligned particle systems to communicate progress, failure, and state transitions.

### A. Level Select Transition (Zoom In/Out)
- **Visual Description**: When entering a level, the camera zooms into the grid node on the map. The map lines disintegrate into an implosion of code particles that vanish, leaving the clean level void.
- **Implementation**: `GPUParticles2D` with an attract-to-center curve.
- **Particle Count**: Max 120 particles.
- **Color**: Matching the active tier's base color template.

### B. Decryption Shockwave (Victory Cascade)
- **Visual Description**: On final alignment, the light beams change from cyan to warm gold (`#FFD700`). A fast, grid-aligned shockwave travels backward along the solved paths, from the Glyph receivers back to the Solar Emitter, overcharging the circuit.
- **Implementation**: Custom `ShaderMaterial` drawing a glowing wave-front along the Line2D paths, triggering localized particle bursts.
- **Color**: `#FFD700` (Gold) and `#FFF8E7` (Warm White).

### C. Void Background Dust Drift
- **Visual Description**: Extremely subtle, flat-vector dust particles and code fragments floating slowly in the background void. They drift vertically or radially away from the Nexus Core, providing depth.
- **Implementation**: Slow-moving CPU/GPU particles running behind the playing grid.
- **Particle Count**: Max 50 active particles.
- **Opacity**: `3%` to `5%` (barely visible to maintain contrast hierarchy).

### D. Failure Reset (The Void Claims)
- **Visual Description**: When the player resets or severs a path, the beams break down into jaggy, grid-aligned glitch fragments that flicker out instantly.
- **Implementation**: Glitch shader displacement paired with orange-red decay particles (`#FF3300`).
- **Duration**: `0.3 seconds` (fast and responsive).

---

## 6. Production Risks & Visual Conflicts

The procedural nature of the layout creates potential visual conflicts with the approved Step 1 Art Direction targets. Below are identified risks and their mitigation strategies:

### Risk 1: Aliasing (Jaggies) from 15-Degree Beam Snapping
- **Conflict**: The shape language demands "razor-sharp, unbroken vectors" and "orthogonal dominance". However, the 15-degree snaps introduce diagonal lines that can cause heavy aliasing (pixel jaggedness) on low-res screens.
- **Mitigation**: Beams must be drawn using Godot's `Line2D` with anti-aliasing enabled and custom vector textures with smooth alpha-channel edges. Node sockets must feature circular, clear "alignment teeth" to make the 15-degree snaps look intentional.

### Risk 2: Color Clashing with Spectrum Filters in Thematic Tiers
- **Conflict**: Tier 3 (Spectrum) introduces color filters (Red, Green, Blue beams). However, if the active tier's template is Amethyst (violet/magenta) or Crimson (ruby), the filtered beams may clash with or blend into the background highlights, breaking readability.
- **Mitigation**: Background landmarks (Nexus Core, grid lines) must restrict their saturation to `<=15%` and brightness to `<=20%`. Semantic colors (Red, Green, Blue beams) are reserved strictly for the active beam's core and immediate receiver status.

### Risk 3: Nexus Core Occlusion in Octagonal Voids (Tiers 8-10)
- **Conflict**: In T8-T10, the boundaries shrink into tight octagonal voids, concentrating layout generation around the center. This places puzzle tools directly over the background Nexus Core, creating visual clutter and contrast problems.
- **Mitigation**: Render the Nexus Core with a parallax depth offset (`ParallaxBackground` or depth shader). Apply a slight darkening vignette or mask underneath the active board grid, ensuring playing tools stand out against the core.

### Risk 4: Visual Clutter from High Bounce Counts (Tiers 9-10)
- **Conflict**: Tiers 9 and 10 feature up to 9 max bounces and winding coefficients of 2.5, creating highly complex ray paths. Combined with static obstacles (Shades), the board can look extremely cluttered, contradicting the "True Void" aesthetic.
- **Mitigation**: Obstacles must use the strict flat dark grey visual styling of `ASSET-025` to blend into the background void. Active beam paths must be rendered with a higher Z-Index and bloom to cleanly float above the playing plane.
