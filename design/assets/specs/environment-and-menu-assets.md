# Asset Specs — System: environment-and-menu

> **Source**: design/gdd/game-concept.md, design/ux/title-screen.md
> **Art Bible**: design/art/art-bible.md
> **Generated**: 2026-06-11
> **Status**: 3 assets specced / 0 approved / 0 in production / 0 done

## ASSET-024 — Level Boundaries (Environment)

| Field | Value |
|-------|-------|
| Category | Environment |
| Dimensions | Max 512x512px per tile (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `level_boundary.webp` |
| Polycount | Max 512 vertices (if 2D Polygon) |
| Texture Res | 512px |

**Visual Description:**
The level boundaries manifest as stark, high-contrast neon lines conforming perfectly to the overarching orthogonal grid. They pierce the surrounding void to clearly delineate navigable space, adhering strictly to right angles without any organic curvature or gradient falloff.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, High-contrast vectors, No organic curves
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`Cyberpunk minimalist 2D game asset, glowing high-contrast neon vector line on pure black background, strict orthogonal grid, straight lines, perfect 90-degree angles, luminescent functionality, stark void, clean flat vector art style, absolutely no organic curves.`

**Status:** Needed

---

## ASSET-025 — Blocked Paths / Obstacles (Environment)

| Field | Value |
|-------|-------|
| Category | Environment |
| Dimensions | Max 512x512px (POT) |
| Format | WEBP (Lossless WebP) |
| Naming | `obstacle_wall.webp`, `blocked_path.webp` |
| Polycount | Max 512 vertices (for LightOccluder2D, ideally < 8) |
| Texture Res | 512px |

**Visual Description:**
These obstacles exist as perfect, light-absorbing dark grey hexagons and squares anchored directly to the grid structure. They act as the inverse of functional elements by explicitly consuming luminescence, functioning as monolithic, inorganic voids within the play area.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, perfect hexagons/squares, No organic curves
- §1 Visual Identity Statement: "everything else is the void"

**Generation Prompt:**
`Cyberpunk minimalist 2D game asset, perfect dark grey grid block, light absorbing hexagon and square shapes, high-contrast against minimal ambient neon light, strict orthogonal grid structure, pure black void background, clean flat vector art style, zero organic shapes.`

**Status:** Needed

---

## ASSET-026 — Level Select Menu (UI)

| Field | Value |
|-------|-------|
| Category | UI |
| Dimensions | Max 2048x2048px (Atlas) |
| Format | WEBP (Lossless WebP) |
| Naming | `level_select_menu.webp`, `level_button.webp` |
| Polycount | N/A |
| Texture Res | 2048px |

**Visual Description:**
The menu is designed as an interconnected system map composed of perfect geometric nodes (hexagons and squares) linked by rigid, orthogonal vector paths. Active or selectable levels glow with functional luminescence to guide the player, standing out sharply against a pure void background.

**Art Bible Anchors:**
- §3 Shape Language: Strict orthogonal grid, perfect hexagons/squares, High-contrast vectors
- §1 Visual Identity Statement: "Luminescence is function"

**Generation Prompt:**
`UI design for minimalist sci-fi game level select menu, strict orthogonal grid network, perfect hexagon and square nodes, high-contrast neon glowing active paths, pure dark void background, sharp flat vector graphics, UI wireframe layout, no organic curves.`

**Status:** Needed

---

### Technical Artist Flags:
1. **Background Resolution Limits:** The Level Select Menu cannot use a single full-screen texture. It must construct its background using a repeating/tiled PoT texture (e.g., 256x256), a `NinePatchRect`, or a TileMap grid to adhere to the 512x512 max limit.
2. **WebGL Shadow Performance:** LightOccluder2D vertices must be kept as low as possible (ideally < 8 vertices per tile) for the Blocked Paths. If performance drops heavily on mobile browsers, real-time 2D shadows will need to be baked directly into the textures.
3. **Lossless WebP:** For all assets, use WEBP Lossless. Mipmaps OFF. Filter: Nearest.
