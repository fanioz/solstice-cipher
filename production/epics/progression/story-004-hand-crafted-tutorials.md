# Story 004: Hand-crafted Tutorials (Levels 4–15)

> **Epic**: progression
> **Status**: Complete
> **Layer**: Content
> **Type**: Config/Data
> **Estimate**: 3.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-13

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: Hand-crafted tutorial levels 1–15

**ADR Governing Implementation**: N/A - Level content creation
**ADR Decision Summary**: N/A

**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [x] Levels 4–10 created as `.tscn` files, introducing only Mirror mechanics with increasing complexity, matching the progression-curve CSV.
- [x] Levels 11–15 created as `.tscn` files, introducing the Prism tool.
- [x] Each level correctly sets its `initial_inventory` and `next_level_path`.
- [x] Levels 4-15 are structurally sound (Sun marker, BoardDropZone, CipherUI, BriefcaseUI).

## Implementation Notes

Use `level_2.tscn` and `level_3.tscn` as templates. You do not need to write new scripts, just create the scenes, place the `Symbol` nodes for the correct words, and configure the `initial_inventory` on the root node.

## QA Test Cases

- **AC-1**: Playthrough Levels 4-15
  - Setup: Start at level 4.
  - Verify: Play through to level 15.
  - Pass condition: All levels are solvable, provide the correct inventory, and chain to the next level correctly.

## Dependencies

- Depends on: None
- Unlocks: None
