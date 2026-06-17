# Story 003: Drag Resolution & Return

> **Epic**: ui
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-005`

**ADR Governing Implementation**: ADR-0008-briefcase-ui.md
**ADR Decision Summary**: Handle the mouse release event. If valid, replace proxy with permanent OpticNode. If invalid, visually return to UI. Manage inventory counts via BriefcaseManager.

**Engine**: Godot 4.6 | **Risk**: LOW
**Engine Notes**: Return interpolation uses Tweens.

**Control Manifest Rules (this layer)**:
- Required: `PlacementController` must emit signals for `BriefcaseManager` to handle inventory logic. 

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] On mouse release over a valid node, replace the proxy with the actual `OpticNode` and decrement the inventory count.
- [ ] On mouse release over an invalid area, the proxy visually interpolates back to its 2D briefcase slot before unhiding the 2D item.
- [ ] If a placed `OpticNode` on the board is dragged back into the Briefcase UI area, remove the node from the board and increment the inventory count.

---

## Implementation Notes

*Derived from ADR-0008 Implementation Guidelines:*

- Use Godot Tweens (`create_tween()`) to animate the proxy's return journey on an invalid drop.
- Ensure the 2D item unhides ONLY after the Tween finishes to avoid jarring visual popping.
- Dragging an existing `OpticNode` back to the Briefcase area should utilize Godot's `Control` `mouse_entered` on the Briefcase bounds (with the UI temporarily re-enabled for hit testing, or checking Y-coordinates in the viewport).

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: The proxy raycasting and movement during the drag.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: On mouse release over a valid node, replace the proxy with the actual `OpticNode` and decrement the inventory count.**
  - **Given:** A tool with inventory > 0 being dragged, with the `PlacementProxy` snapped to a valid node.
  - **When:** The input action corresponding to mouse release is triggered.
  - **Then:** An `OpticNode` is instantiated at the proxy's exact transform, the proxy is removed, and the inventory count for that tool type decreases by 1.
  - **Edge cases:** Releasing exactly on the boundary of a valid node; releasing on a valid node that is already occupied by another item.

- **Test: On mouse release over an invalid area, the proxy visually interpolates back to its 2D briefcase slot before unhiding the 2D item.**
  - **Given:** A tool being dragged, with the `PlacementProxy` over the virtual plane (invalid area).
  - **When:** The input action corresponding to mouse release is triggered.
  - **Then:** The proxy initiates an interpolation back to the screen coordinates of the Briefcase UI slot. Upon completion, the proxy is deleted and the 2D Briefcase item is unhidden.
  - **Edge cases:** The level ends or pauses while the interpolation is in progress; the user attempts to click the interpolating proxy.

- **Test: If a placed `OpticNode` on the board is dragged back into the Briefcase UI area, remove the node from the board and increment the inventory count.**
  - **Given:** An existing `OpticNode` placed on the game board.
  - **When:** The `OpticNode` is picked up, dragged into the screen bounds of the Briefcase UI, and released.
  - **Then:** The `OpticNode` is removed from the scene tree, and the inventory count for that specific tool type increases by 1.
  - **Edge cases:** Dragging an `OpticNode` into the Briefcase when the inventory is theoretically at maximum capacity; releasing slightly outside the Briefcase UI boundary.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/ui/story_003_drag_resolution_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 002
- Unlocks: None
