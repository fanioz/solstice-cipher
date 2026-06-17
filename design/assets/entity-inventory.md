# Visual Entity & Screen Inventory

> Generated: 2026-06-10
> Sources: `design/gdd/game-concept.md`, `design/art/art-bible.md`, `design/ux/cipher-ui.md`, `design/ux/title-screen.md`

## Entities

| # | Name | Type | Description | Source | Status |
|---|------|------|-------------|--------|--------|
| 1 | The Grid / Node Sockets | Environment | Faint geometric outlines indicating tool placement sockets | art-bible.md | Needed |
| 2 | Level Boundaries | Environment | Straight neon lines bordering the playable area | art-bible.md | Needed |
| 3 | Blocked Paths / Obstacles | Environment | Dark grey grid blocks that block light | art-bible.md | Needed |
| 4 | Light Emitter (Source) | Item | Emits raw light; pure white core with cyan outer glow | art-bible.md | Needed |
| 5 | Mirrors (Reflectors) | Item | Reflects light; silver/white vector lines | game-concept.md | Needed |
| 6 | Prisms (Splitters) | Item | Splits light; neon magenta | game-concept.md | Needed |
| 7 | Color Filters | Item | Changes light color | game-concept.md | Needed |
| 8 | Portals | Item | Teleports light | game-concept.md | Needed |
| 9 | Combiners | Item | Combines multiple beams | game-concept.md | Needed |
| 10 | Receivers / Letter Glyphs | Item | Target nodes; dark green (unpowered), neon green (powered) | art-bible.md | Needed |
| 11 | Active Light Beam | VFX | Primary light trajectory; cyan, magenta, etc. | art-bible.md | Needed |
| 12 | Impact Flare | VFX | Brief red warning flare when beam hits blocked paths | art-bible.md | Needed |
| 13 | Victory Shockwave | VFX | Warm white/gold burst on level completion | art-bible.md | Needed |
| 14 | Failure Burn | VFX | Trailing red/orange decay effect | art-bible.md | Needed |
| 15 | Failure Grid Noise | VFX | Sharp, grid-aligned visual stuttering | art-bible.md | Needed |
| 16 | Title Screen Dust Particles | VFX | Floating dust particle system for atmosphere | title-screen.md | Needed |

## UI Screens

| # | Screen Name | Description | Source | Status |
|---|-------------|-------------|--------|--------|
| 1 | Title Screen | Game entry screen with background scene and 'Begin Journey' | title-screen.md | Needed |
| 2 | Level Select Menu | System map or grid for selecting levels | art-bible.md | Needed |

## HUD Elements

| # | Element | Description | Source | Status |
|---|---------|-------------|--------|--------|
| 1 | Briefcase Inventory | Sleek, high-tech interface for drag-and-drop tool placement | game-concept.md | Needed |
| 2 | Tool Icons | Flat vector icons representing tools in the briefcase | art-bible.md | Needed |
| 3 | Cipher UI | Array of letters/underscores that illuminate upon decryption | cipher-ui.md | Needed |

## Audio

| # | Name | Type (SFX / Music / Ambient) | Description | Source | Status |
|---|------|------------------------------|-------------|--------|--------|
| 1 | UI Interaction Sounds | SFX | Crisp, digital terminal feedback sounds | game-concept.md | Needed |
| 2 | Light Bounce | SFX | Satisfying crystal chimes for beam interactions | game-concept.md | Needed |
| 3 | Victory Sound | SFX | Sound for full decryption/level completion | game-concept.md | Needed |
| 4 | Failure/Short-circuit Sound | SFX | Jarring mechanical short-circuit sound | art-bible.md | Needed |
| 5 | Ambient/Music Track | Ambient | Deep space ambient tone, faint and slow-breathing | art-bible.md | Needed |
