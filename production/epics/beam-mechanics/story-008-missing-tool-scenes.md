# Story 008: Missing Tool Scenes (Shade & Bender)

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Core
> **Type**: Integration
> **Estimate**: 1.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-13

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-003` (Tools modify beam paths)

**ADR Governing Implementation**: ADR-0006-beam-propagation-system.md
**ADR Decision Summary**: Establish core rules for beam pathing and interaction with optical tools.

**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

*From GDD and Content Audit, scoped to this story:*

- [x] Create and import `shade.tscn` and `bender.tscn` (Use exact filenames).
- [x] Ensure they have `.gd` scripts attached that inherit from `Area2D` and handle drag-and-drop gameplay, identical to `mirror.gd`.
- [x] `main.gd` contains `elif` spawning branches for `"shade"` and `"bender"` to allow placing them from the Briefcase UI.
- [x] Both scenes use their generated `.webp` textures.

## Implementation Notes

The underlying logic for Shade and Bender (`shade.gd` and `bender.gd`) is already complete and unit-tested. This story solely tracks the creation of the `.tscn` wrappers and integrating them into the Briefcase spawning system in `main.gd` so they can be placed by the player.

## QA Test Cases

- **AC-1**: Can place Shade from briefcase
  - Setup: Start a level with a Shade in the initial inventory.
  - Verify: Dragging the Shade places it correctly on the board.
  - Pass condition: Shade appears on board, blocks light, and piece count decreases.

- **AC-2**: Can place Bender from briefcase
  - Setup: Start a level with a Bender in the initial inventory.
  - Verify: Dragging the Bender places it correctly on the board.
  - Pass condition: Bender appears on board, deflects light, and piece count decreases.

## Dependencies

- Depends on: Story 004, Story 005
- Unlocks: None
