# Story 001: Briefcase Layout & Inventory Management

> **Epic**: ui
> **Status**: Ready
> **Layer**: Core
> **Type**: UI
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-005`

**ADR Governing Implementation**: ADR-0008-briefcase-ui.md
**ADR Decision Summary**: Manage Control nodes and handle UI input swallowing to initiate phase 1 of Drag-and-Drop.

**Engine**: Godot 4.6 | **Risk**: LOW
**Engine Notes**: Godot 4.5+ recursive Control disable feature to be used.

**Control Manifest Rules (this layer)**:
- Required: Centralized UI events via `BriefcaseManager`.
- Forbidden: 3D Math in this layer.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Position the Briefcase UI at the bottom 160px of the 720x1280 portrait viewport.
- [ ] Display unlocked tools as icons ordered left-to-right; locked future tools are completely hidden.
- [ ] Each tool icon displays a count badge; icons become greyed-out and non-draggable when the count reaches 0.
- [ ] When dragging begins, hide the 2D item, temporarily disable the UI tree to prevent stray events, and emit `drag_started`.

---

## Implementation Notes

*Derived from ADR-0008 Implementation Guidelines:*

- Implement `BriefcaseManager` with `drag_started(item_id)` and `drag_ended(success)` signals.
- Use `Control.process_mode = PROCESS_MODE_DISABLED` (Godot 4.5+) on the parent UI container to recursively block input events during a drag, preventing hover states from getting stuck.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Actually instantiating the 3D proxy object.
- Story 004: UI Glow and unlock animations.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For UI / Visual stories — manual verification specs]:**

- **Manual check: Position the Briefcase UI at the bottom 160px of the 720x1280 portrait viewport.**
  - **Setup:** Launch the game configured to a 720x1280 portrait viewport. Open a playable level.
  - **Verify:** Inspect the Briefcase UI container's position and boundaries on screen.
  - **Pass condition:** The UI container exactly occupies the bottom 160px of the screen layout without overlapping play area inadvertently.

- **Manual check: Display unlocked tools as icons ordered left-to-right; locked future tools are completely hidden.**
  - **Setup:** Load a profile/level where tools A and B are unlocked, but tool C is locked.
  - **Verify:** Look at the Briefcase UI inventory.
  - **Pass condition:** Icons for tools A and B are visible in left-to-right order. No empty slot, silhouette, or placeholder is visible for tool C.

- **Manual check: Each tool icon displays a count badge; icons become greyed-out and non-draggable when the count reaches 0.**
  - **Setup:** Load a level where a specific tool has exactly 1 charge. Drag and place that tool on the board.
  - **Verify:** Observe the tool's icon in the Briefcase. Attempt to click and drag it again.
  - **Pass condition:** The badge updates to '0', the icon visually greys out, and attempting to drag does not spawn a proxy or trigger any drag events.

- **Manual check: When dragging begins, hide the 2D item, temporarily disable the UI tree to prevent stray events, and emit `drag_started`.**
  - **Setup:** Click and drag a valid tool icon from the Briefcase UI.
  - **Verify:** Observe the 2D icon, attempt to hover/click other UI elements while dragging, and check debug monitors.
  - **Pass condition:** The 2D Briefcase icon is hidden, other UI buttons do not react to hovers/clicks during the drag, and the `drag_started` signal is verified as emitted.

---

## Test Evidence

**Story Type**: UI
**Required evidence**:
- Visual: `production/qa/evidence/story_001_briefcase_layout.md` — must contain screenshots/videos of the working UI.

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: None
- Unlocks: Story 002
