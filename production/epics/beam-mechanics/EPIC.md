# Epic: Beam Mechanics

> **Layer**: Foundation
> **GDD**: design/specs/2026-06-08-level-progression-design.md
> **Architecture Module**: Beam Propagation & Convergence
> **Status**: Ready
> **Stories**: 7 stories created

## Stories

| # | Story | Type | Status | ADR |
|---|-------|------|--------|-----|
| 001 | Core Propagation & Mirrors | Logic | Ready | ADR-0006 |
| 002 | Beam Splitting (Prisms) | Logic | Ready | ADR-0006 |
| 003 | Color Filtration (Filters) | Logic | Ready | ADR-0006 |
| 004 | Path Blocking (Shades) | Logic | Ready | ADR-0006 |
| 005 | Diagonal Routing (Benders) | Logic | Ready | ADR-0006 |
| 006 | Spatial Teleportation (Portals) | Logic | Ready | ADR-0006 |
| 007 | Multi-source Convergence (Combiners) | Logic | Ready | ADR-0007 |
| 008 | Missing Tool Scenes (Shade & Bender) | Integration | Ready | ADR-0006 |
## Overview

This epic implements the core physics and logic of the light propagation engine. It establishes the physical rules by which a light beam travels, reflects, refracts, splits, and changes color through interaction with tools (like mirrors, prisms, and filters). It also covers logic gates via beam convergence (e.g. combiners requiring two simultaneous inputs to emit an output), creating the foundational interactive mechanics for the game's spatial logic puzzles.

## Governing ADRs

| ADR | Decision Summary | Engine Risk |
|-----|-----------------|-------------|
| ADR-0006-beam-propagation-system.md | Establish core rules for beam pathing and interaction with optical tools | HIGH |
| ADR-0007-beam-convergence.md | Implement multi-source beam combination as cryptographic logic gates | HIGH |

## GDD Requirements

| TR-ID | Requirement | ADR Coverage |
|-------|-------------|--------------|
| TR-level-003 | Tools (Mirrors, Prisms, Filters, etc.) modify beam paths and colors. | ADR-0006 ✅ |
| TR-level-004 | Combiner requires two simultaneous input beams to emit one output. | ADR-0007 ✅ |

## Definition of Done

This epic is complete when:
- All stories are implemented, reviewed, and closed via `/story-done`
- All acceptance criteria from `design/specs/2026-06-08-level-progression-design.md` are verified
- All Logic and Integration stories have passing test files in `tests/`
- All Visual/Feel and UI stories have evidence docs with sign-off in `production/qa/evidence/`

## Next Step

Run `/create-stories beam-mechanics` to break this epic into implementable stories.
