# Story 005: Level Select Screen

> **Epic**: ui
> **Status**: Complete
> **Layer**: Presentation
> **Type**: UI
> **Estimate**: 2.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-13

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: "Grid of 100 levels, locked/unlocked" & Level Flow

**ADR Governing Implementation**: N/A - Standard UI Control nodes
**ADR Decision Summary**: N/A

**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [x] A new `src/ui/level_select.tscn` screen exists.
- [x] Displays a grid of 100 level buttons (or pages of buttons).
- [x] Buttons visually distinguish between Locked, Unlocked (Playable), and Completed levels.
- [x] Connects back to the Title Screen via a "Back" button.
- [x] Reads from the progression/save system to determine lock status.
- [x] Clicking an unlocked level loads the appropriate scene (or invokes the procedural generator).

## Implementation Notes

Use a `GridContainer` inside a `ScrollContainer` for the level buttons. Bind each button's `pressed` signal to load the correct level. For now, since procedural loading isn't wired up, just load the hand-crafted levels (1-3) and block the rest, or just print a message for procedural levels.

## QA Test Cases

- **AC-1**: Level Select Grid Rendering
  - Setup: Open the Level Select screen.
  - Verify: 100 buttons are rendered, lock status is correctly pulled from save data.
  - Pass condition: Visual hierarchy is clear and grid is scrollable.

- **AC-2**: Navigation
  - Setup: Start at Title screen.
  - Verify: Title -> Level Select -> Level 1 -> Back to Level Select -> Back to Title.
  - Pass condition: Navigation flow works without breaking.

## Dependencies

- Depends on: `progression` Epic Story 003 (Progression System Hydration)
- Unlocks: None
