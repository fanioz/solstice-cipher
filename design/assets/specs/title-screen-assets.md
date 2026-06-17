# Asset Specs — System: title-screen

> **Source**: design/ux/title-screen.md
> **Art Bible**: design/art/art-bible.md
> **Generated**: 2026-06-11
> **Status**: 5 assets specced / 0 approved / 0 in production / 0 done

## ASSET-019 — Title Screen Background (Environment)

| Field | Value |
|-------|-------|
| Category | Environment |
| Dimensions | Max 512x512px (Tileable) |
| Format | WEBP (Lossless WebP) |
| Naming | `title_screen_background.webp` |
| Polycount | Max 512 vertices (if 2D Polygon) |
| Texture Res | 512px |

**Visual Description:**
A deep, oppressive void rendered in near-pitch black (#0d0d14) that serves as the foundation for all luminescent elements. Faint, perfectly orthogonal grid lines subtly intersect in the distance, enforcing the rigid geometric nature of the world without distracting from the active foreground.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid
- §1 Visual Identity Statement: "Luminescence is function; everything else is the void"

**Generation Prompt:**
`Dark void background, near pitch black #0d0d14, subtle geometric orthogonal grid lines, perfect squares, high-contrast vector art style, minimalist, no organic elements, sci-fi cyberpunk aesthetic, 8k resolution.`

**Status:** Needed

---

## ASSET-020 — Title Screen Dust Particles (VFX)

| Field | Value |
|-------|-------|
| Category | VFX |
| Dimensions | Max 512x512px (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `title_screen_dust_particles.webp` |
| Polycount | N/A |
| Texture Res | 512px |

**Visual Description:**
Atmospheric dust particles suspended in the void, rendered strictly as perfect, subtly glowing geometric micro-shapes (squares and hexagons). They provide a sense of depth and scale while strictly avoiding any natural, irregular, or organic curves.

**Art Bible Anchors:**
- §3 Shape Language: Perfect hexagons/squares, High-contrast vectors, No organic curves

**Generation Prompt:**
`Floating geometric dust particles, tiny glowing squares and perfect hexagons, slow atmospheric movement, dark void background, high-contrast vector style, sharp edges, no organic shapes, abstract tech atmosphere.`

**Status:** Needed

---

## ASSET-021 — Title Typography (UI)

| Field | Value |
|-------|-------|
| Category | UI |
| Dimensions | Max 2048x2048px (Atlas) |
| Format | WEBP (Lossless WebP) |
| Naming | `title_typography.webp` |
| Polycount | N/A |
| Texture Res | 2048px |

**Visual Description:**
The title is constructed with rigid, orthogonal geometry and sharp angles, entirely eliminating organic curves from the letterforms. It glows intensely in a stark gold (#FFD700), functioning as a primary luminescent focal point that pierces the dark background.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, No organic curves
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`Typography reading "SOLSTICE CIPHER", glowing gold #FFD700 text, strict orthogonal grid design, sharp angles, no organic curves, geometric font, high-contrast vector art, luminescent HDR glow, dark void background.`

**Status:** Needed

---

## ASSET-022 — "Begin Journey" Button (UI)

| Field | Value |
|-------|-------|
| Category | UI |
| Dimensions | Max 256x64px or 128x32px (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `begin_journey_button.webp` |
| Polycount | Max 512 vertices (if UI polygon) |
| Texture Res | 256px |

**Visual Description:**
A minimalist UI element featuring sharp, cyan (#00FFFF) text enclosed by a perfect geometric container, emitting a subtle HDR glow. Its brilliant luminescence explicitly communicates interactivity, adhering to the principle that functional gameplay elements must light up the void.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`Sci-fi UI button reading "Begin Journey", bright cyan #00FFFF text and geometric borders, subtle HDR glow, strict orthogonal grid layout, perfect squares, sharp vector graphics, dark void background, interactive UI design.`

**Status:** Needed

---

## ASSET-023 — Dummy Laser Setup (Environment/VFX)

| Field | Value |
|-------|-------|
| Category | Environment |
| Dimensions | Max 512x512px (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `dummy_laser_setup.webp` |
| Polycount | Max 512 vertices (for 2D Polygon) |
| Texture Res | 512px |

**Visual Description:**
A purely geometric light emitter and a precisely angled hexagonal mirror resting on the grid, firing a high-contrast, razor-sharp laser beam across the screen. The active components and the beam itself glow fiercely, perfectly embodying the core mechanic's visual dichotomy.

**Art Bible Anchors:**
- §3 Shape Language: Perfect hexagons/squares, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`Geometric laser emitter and perfect hexagonal mirror, shooting a bright high-contrast laser beam across the scene, strict orthogonal grid, luminescent HDR glow, high-contrast vector style, minimalist sci-fi, dark void background #0d0d14, sharp edges.`

**Status:** Needed

---

### Technical Artist Flags:
1. **Resolution Constraints:** A standard full-screen background (1920x1080) violates the 512x512 sprite max and POT rule. Resolution: Title Screen Background must be tiled/sliced into <= 512x512 textures packed into an atlas.
2. **Typography Filter Conflict:** MSDF fonts require linear filtering. If nearest filtering is strictly enforced globally for crisp vectors, avoid MSDF and use pre-rasterized bitmap fonts.
3. **Lossless WebP:** For all assets, use WEBP Lossless, avoid raw PNG due to HTML5 load time constraints.
