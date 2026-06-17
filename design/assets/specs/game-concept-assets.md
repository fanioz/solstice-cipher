# Asset Specs — System: game-concept

> **Source**: design/gdd/game-concept.md
> **Art Bible**: design/art/art-bible.md
> **Generated**: 2026-06-10
> **Status**: 10 assets specced / 0 approved / 0 in production / 0 done

## ASSET-009 — Light Emitter (Source)

| Field | Value |
|-------|-------|
| Category | Item |
| Dimensions | Max 512x512px (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `light_emitter.webp` |
| Polycount | N/A |
| Texture Res | 512px |

**Visual Description:**
A rigid, perfect square housing with a stark, void-black shell. Its core emits a piercing, pure white light that transitions sharply into an electric cyan, creating a precise, non-diffused aura. The design feels strictly functional, radiating stark energy into the void.

**Art Bible Anchors:**
- §3 Shape Language: Perfect squares, Strict orthogonal grid
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A top-down 2D vector graphic of a futuristic high-tech light emitter. Perfect square shape, void black exterior. At the center, a pure white glowing core with a sharp electric cyan aura. Strict orthogonal lines, high contrast, clean vector art style, flat colors, no organic curves, cyberpunk hacking theme.`

**Status:** Needed

---

## ASSET-010 — Receivers / Letter Glyphs

| Field | Value |
|-------|-------|
| Category | Item |
| Dimensions | Max 2048x2048 Atlas (individual glyphs max 512x512) |
| Format | WEBP (Lossless WebP) |
| Naming | `receiver_glyphs.webp` |
| Polycount | N/A |
| Texture Res | 2048px |

**Visual Description:**
Unpowered receivers are flat, dark green hexagonal nodes that sink into the void background. When powered, they erupt into a blinding, crisp neon green, illuminating rigid, sharp-edged alphanumeric characters embedded within them.

**Art Bible Anchors:**
- §3 Shape Language: Perfect hexagons, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A top-down 2D vector graphic of a futuristic hacking node in the shape of a perfect hexagon. Inside the hexagon is a rigid, sharp-edged sans-serif letter. The node is glowing with a blinding, crisp neon green light against a pitch-black background. High contrast, clean vector art style, no organic curves.`

**Status:** Needed

---

## ASSET-011 — Active Light Beam

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | Max 128x512px (Tiling Texture) |
| Format | WEBP / Procedural Line2D |
| Naming | `vfx_active_light_beam.webp` |
| Polycount | Max 512 vertices for Line2D |
| Texture Res | 512px |

**Visual Description:**
A perfectly straight, razor-sharp cyan line slicing through the void. It lacks organic diffusion, instead presenting as a continuous, intense vector ribbon that bends only at precise 90-degree angles.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A razor-sharp, perfectly straight cyan laser beam on a pitch-black background. Continuous thick line, intense high-contrast glow, glowing edges but no soft atmospheric diffusion. Flat vector art style, minimalist futuristic aesthetic.`

**Status:** Needed

---

## ASSET-012 — Impact Flare

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | Max 512x512px |
| Format | WEBP (Lossless) / CPUParticles2D |
| Naming | `vfx_impact_flare.webp` |
| Polycount | Max 100 particles |
| Texture Res | 512px |

**Visual Description:**
A sudden, harsh red geometric burst occurring precisely at a collision point. It consists of intersecting right-angled shards and squares rather than a chaotic explosion, visually communicating immediate system denial.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "everything else is the void"

**Generation Prompt:**
`A harsh, red geometric impact flare against a black background. Composed of sharp, intersecting right-angled shards and perfect squares radiating outward. High-contrast neon red glow, flat vector art style, clean edges, zero organic smoke or fire.`

**Status:** Needed

---

## ASSET-013 — Victory Shockwave

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | Max 512x512px (Texture Mask) |
| Format | WEBP + `.gdshader` |
| Naming | `vfx_victory_shockwave.webp`, `victory_shockwave.gdshader` |
| Polycount | Max 512 vertices |
| Texture Res | 512px |

**Visual Description:**
A rapidly expanding perimeter of warm white and gold squares sweeping outward along the strict grid lines. The effect evokes a successful decryption cascade, cleanly resetting the visual space.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, Perfect squares
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A futuristic victory shockwave effect against a black background. Formed by a rapidly expanding perimeter of warm white and gold squares and right angles along an invisible grid. Neon vector aesthetic, crisp, clean geometry, cybernetic hacking theme.`

**Status:** Needed

---

## ASSET-014 — Failure Burn

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | Max 512x512px |
| Format | WEBP |
| Naming | `vfx_failure_burn.webp` |
| Polycount | N/A |
| Texture Res | 512px |

**Visual Description:**
A rigid trail of dissolving red and orange pixels, leaving behind a stark path of decay along the orthogonal grid. The decay breaks down into smaller perfect squares before vanishing completely into the void.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, Perfect squares, High-contrast vectors

**Generation Prompt:**
`A trailing visual effect of dissolving red and orange pixels on a black background. The trail breaks down into smaller, perfect squares scattered along rigid horizontal and vertical lines. High contrast neon vector style, cybernetic system failure concept, clean edges.`

**Status:** Needed

---

## ASSET-015 — Failure Grid Noise

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | 512x512px (Seamless tile, POT) |
| Format | WEBP |
| Naming | `vfx_failure_grid_noise.webp` |
| Polycount | N/A |
| Texture Res | 512px |

**Visual Description:**
A severe visual stuttering effect strictly aligned to the game’s invisible grid. It rapidly displaces sections of the void and UI into disjointed rectangular chunks, mimicking an acute digital corruption event.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "everything else is the void"

**Generation Prompt:**
`A digital glitch effect on a black background, strictly aligned to a rectangular grid. Sharp, disjointed rectangular chunks shifting horizontally and vertically. High contrast, clean vector aesthetic, stark neon glitch art, zero organic distortion.`

**Status:** Needed

---

## ASSET-016 — Briefcase Inventory

| Field | Value |
|-------|-------|
| Category | HUD |
| Dimensions | Max 2048x2048 Atlas (Base panels 128x128 with NinePatch) |
| Format | WEBP |
| Naming | `hud_briefcase_inventory.webp` |
| Polycount | N/A |
| Texture Res | 2048px |

**Visual Description:**
A highly organized, sleek interface composed of unyielding rectangular compartments separated by razor-thin, high-contrast borders. The void-black background ensures the draggable neon tools stand out entirely, embodying "luminescence is function."

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "everything else is the void"

**Generation Prompt:**
`A high-tech futuristic inventory interface UI element on a black background. Sleek, unyielding rectangular compartments divided by razor-thin, high-contrast lines. Minimalist vector art style, flat design, strict orthogonal layout, cyberpunk hacking aesthetic.`

**Status:** Needed

---

## ASSET-017 — Tool Icons

| Field | Value |
|-------|-------|
| Category | HUD |
| Dimensions | Max 1024x1024 Atlas (Icons 64x64 or 128x128, POT) |
| Format | WEBP |
| Naming | `hud_tool_icons.webp` |
| Polycount | N/A |
| Texture Res | 1024px |

**Visual Description:**
Stark, flat vector representations built exclusively from squares and straight lines. They rest dormant in dark, muted tones until selected, instantly snapping into full luminous visibility to indicate active function.

**Art Bible Anchors:**
- §3 Shape Language: Perfect squares, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A set of minimalist, futuristic tool icons on a black background. Built exclusively from perfect squares and straight 90-degree lines. Flat vector art style, stark high contrast neon outlines, no organic curves, sharp geometric cyber aesthetic.`

**Status:** Needed

---

## ASSET-018 — Cipher UI

| Field | Value |
|-------|-------|
| Category | HUD |
| Dimensions | Max 2048x2048 Atlas |
| Format | WEBP |
| Naming | `hud_cipher_ui.webp` |
| Polycount | N/A |
| Texture Res | 2048px |

**Visual Description:**
An orderly sequence of stark underscore segments laid out on a perfect horizontal axis. As decryption progresses, rigid, brightly illuminated glyphs snap into place, piercing the void with absolute clarity.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`A futuristic cipher decryption UI on a black background. An orderly sequence of stark neon glowing underscores and rigid, sharp-edged illuminated letters in a perfect horizontal line. High contrast vector art style, minimalist, hacker terminal aesthetic.`

**Status:** Needed

---

### Technical Artist Flags:
1. **Lossless WebP required:** Do not leave files truly uncompressed on disk; use WebP Lossless to preserve file size while keeping VRAM uncompressed rendering.
2. **VFX Overdraw:** CPUParticles2D and Line2D should be kept extremely simple, with a strict max of 100 particles for Impact Flare. WebGL fill rate drops fast.
3. **Pre-baked Noise:** Avoid procedural noise (`FastNoiseLite`) running every frame for Failure Grid Noise. Pre-bake it to a tileable texture.
4. **9-Slicing required:** For the Briefcase Inventory, do not use large static textures. Heavily utilize NinePatchRects.
