# Asset Specs — Entity: the-grid-node-sockets

> **Source**: design/assets/entity-inventory.md
> **Art Bible**: design/art/art-bible.md
> **Generated**: 2026-06-10
> **Status**: 1 assets specced / 0 approved / 0 in production / 0 done

## ASSET-001 — The Grid / Node Sockets

| Field | Value |
|-------|-------|
| Category | Environment |
| Dimensions | 512×512px (Grid), 64x64px-256x256px (Sockets) |
| Format | WEBP (Lossless/VRAM Uncompressed) |
| Naming | `grid_background.webp`, `node_socket_empty.webp`, `node_socket_active.webp` |
| Polycount | Max 512 vertices per 2D polygon (Line2D) |
| Texture Res | 512px (max sprite size per Art Bible §8) |

**Visual Description:**
The Grid and its Node Sockets manifest as precise, unbroken vector outlines composed entirely of perfect hexagons and squares, adhering strictly to 45 and 90-degree angles. Emerging faintly from the Dormant Void (#0B0C10) in subtle cyan and deep blue tones, these geometric anchor points remain visually subdued so primary interactions pop. The socket outlines feature zero organic curves and gracefully fade their opacity into the background void when puzzles become active.

**Art Bible Anchors:**
- §1 Visual Identity Statement: "Luminescence is function; everything else is the void" (Dictates fade-out behavior during active puzzles).
- §3 Shape Language: Orthogonal & Angular Dominance (Strict geometric primitives, perfect hexagons, 45/90 degree angles); High-Contrast, Unbroken Vectors.
- §4 Color System: The Grid/Node Sockets use faint cyan/blue geometry against the Dormant Void (#0B0C10) background.

**Generation Prompt:**
`Minimalist sci-fi UI grid, empty node sockets, perfect hexagons and squares, unbroken precise geometric vector outlines, faint glowing cyan and deep blue lines against a pitch black void background. High-contrast orthogonal and angular dominance, strict 45 and 90 degree angles, sleek flat 2D vector style. --no organic curves, rounded corners, soft gradients, 3D rendering, realistic materials, messy details, bright glowing blooms, chaotic lines, noise`

**Technical Artist Flag:** 
Using uncompressed 2048x2048 texture atlases may exceed WebGL VRAM limits (16MB per atlas) on mobile browsers. Monitoring is required.

**Status:** Needed
