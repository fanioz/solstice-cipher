# Story 002: 3D Proxy Raycasting

> **Epic**: ui
> **Status**: Ready
> **Layer**: Core
> **Type**: Integration
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-005`

**ADR Governing Implementation**: ADR-0008-briefcase-ui.md
**ADR Decision Summary**: Implement Decoupled Physics-based 3D Proxy Dragging to project the 2D drag operation into 3D space, snapping to procedural nodes.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Must use `Node3D.reset_physics_interpolation()` (Godot 4.5 API) when snapping proxy.

**Control Manifest Rules (this layer)**:
- Required: Input routing strictly via `InputManager`. Jolt Physics specific collision masks.
- Forbidden: Using `_get_drag_data()` from `Control` for 3D crossovers.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] `PlacementController` intercepts input via `_input` to avoid framerate desync, instancing a 3D `PlacementProxy` on `drag_started`.
- [ ] Perform physics raycasting against a strictly isolated "Placement Layer" Jolt physics mask to find valid procedural graph nodes.
- [ ] Snap the proxy to a virtual floating plane at a fixed depth when the raycast misses valid nodes.
- [ ] Call `Node3D.reset_physics_interpolation()` whenever the proxy snaps between the virtual plane and a hard grid node.

---

## Implementation Notes

*Derived from ADR-0008 Implementation Guidelines:*

- Use `Camera3D.project_ray_origin` and `project_ray_normal`.
- Use `PhysicsDirectSpaceState3D.intersect_ray()` using a strict bitmask (e.g., `CollisionMasks.PLACEMENT_LAYER`).
- Ensure `PlacementController` hooks into the global `InputManager` to read mouse position and release events robustly.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: The 2D UI initiation.
- Story 003: Instantiating the permanent OpticNode and handling the inventory decrement.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: `PlacementController` intercepts input via `_input` to avoid framerate desync, instancing a 3D `PlacementProxy` on `drag_started`.**
  - **Given:** A running scene with an active `PlacementController` listening to `drag_started`.
  - **When:** The `drag_started` signal is emitted with a specific tool type payload.
  - **Then:** `PlacementController` successfully instances a `PlacementProxy` of the corresponding type into the 3D scene tree.
  - **Edge cases:** Emitting the signal twice rapidly; emitting with an invalid or null tool type.

- **Test: Perform physics raycasting against a strictly isolated "Placement Layer" Jolt physics mask to find valid procedural graph nodes.**
  - **Given:** A 3D scene containing target nodes on the "Placement Layer" and obstacle nodes on other physics layers. A drag is in progress.
  - **When:** The `PlacementController` evaluates the raycast from the camera through the mouse position.
  - **Then:** The raycast exclusively returns collisions with nodes on the "Placement Layer", completely ignoring nodes on other layers.
  - **Edge cases:** Raycasting exactly through a UI element; nodes from different layers perfectly overlapping.

- **Test: Snap the proxy to a virtual floating plane at a fixed depth when the raycast misses valid nodes.**
  - **Given:** An active `PlacementProxy` and the mouse cursor positioned over an area with no valid "Placement Layer" nodes.
  - **When:** The raycast returns no collision.
  - **Then:** The `PlacementProxy`'s global 3D transform is updated to intersect with the predefined virtual floating plane at the fixed depth.
  - **Edge cases:** Mouse positioned at the absolute edge of the viewport; camera angled parallel to the plane (no mathematical intersection possible).

- **Test: Call `Node3D.reset_physics_interpolation()` whenever the proxy snaps between the virtual plane and a hard grid node.**
  - **Given:** A `PlacementProxy` currently hovering over the virtual plane.
  - **When:** The mouse is moved so the proxy snaps to a valid grid node.
  - **Then:** `reset_physics_interpolation()` is called on the `PlacementProxy` node exactly once during the transition.
  - **Edge cases:** Rapidly oscillating the mouse between the virtual plane and a grid node; snapping between two adjacent grid nodes (does not trigger the plane-to-grid condition).

---

## Test Evidence

**Story Type**: Integration
**Required evidence**:
- Integration: `tests/integration/ui/story_002_3d_proxy_raycasting_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001
- Unlocks: Story 003
