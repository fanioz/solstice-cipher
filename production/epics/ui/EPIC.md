# Epic: UI

> **Layer**: Core
> **GDD**: design/specs/2026-06-08-level-progression-design.md
> **Architecture Module**: Drag-and-Drop Interaction & Briefcase UI
> **Status**: Ready
> **Stories**: 4 stories created

## Stories

| # | Story | Type | Status | ADR |
|---|-------|------|--------|-----|
| 001 | Briefcase Layout & Inventory Management | UI | Ready | ADR-0008 |
| 002 | 3D Proxy Raycasting | Integration | Ready | ADR-0008 |
| 003 | Drag Resolution & Return | Logic | Ready | ADR-0008 |
| 004 | Tool Reveal Animations | Visual/Feel | Ready | ADR-0008 |
| 005 | Level Select Screen | UI | Ready | N/A |
## Overview

This epic implements the player input and UX mechanics for the 160px bottom-panel Briefcase UI. This includes the drag-to-place tool inventory, giving players tactile control over placing mirrors, prisms, and other optic tools on the game grid. This interaction mechanism is essential for manual playtesting and verifying other systems.

## Governing ADRs

| ADR | Decision Summary | Engine Risk |
|-----|-----------------|-------------|
| ADR-0008-briefcase-ui.md | Manage Control nodes and Viewport input event consumption | HIGH |

## GDD Requirements

| TR-ID | Requirement | ADR Coverage |
|-------|-------------|--------------|
| TR-level-005 | Briefcase UI bottom 160px panel with drag-to-place tool inventory. | ADR-0008 ✅ |

## Definition of Done

This epic is complete when:
- All stories are implemented, reviewed, and closed via `/story-done`
- All acceptance criteria from `design/specs/2026-06-08-level-progression-design.md` are verified
- All Logic and Integration stories have passing test files in `tests/`
- All Visual/Feel and UI stories have evidence docs with sign-off in `production/qa/evidence/`

## Next Step

Run `/create-stories ui` to break this epic into implementable stories.
