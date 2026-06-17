# Story 001: Core Propagation & Mirrors

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 1.5
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-11

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-003`

**ADR Governing Implementation**: ADR-0006-beam-propagation-system.md
**ADR Decision Summary**: Establish core rules for beam pathing and interaction with optical tools using native Jolt Physics raycasting with an iterative bounce limit.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Use `@abstract` (Godot 4.5+); Jolt raycast precision verification required.

**Control Manifest Rules (this layer)**:
- Required: InputManager queries, Static Typing
- Forbidden: Never call Input directly, Never use untyped GDScript variables
- Guardrail: None explicitly defined yet

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Mirrors reflect the beam at 90°.
- [ ] Mirrors snap to 15° increments.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Use `PhysicsDirectSpaceState3D` raycasting (Jolt Physics) for propagation.
- Implement strict integer `max_bounces` loop to prevent infinite loops.
- Use explicit collision layers (`LAYER_OPTICS`, `LAYER_WALLS`) to ignore dynamic debris.
- Address float drift: explicit `Vector3.is_equal_approx()` and snap to grid (`Vector3.snapped()`) before calculating bounce reflection.
- Create `@abstract class_name OpticNode extends Node3D` which interactive nodes inherit from.
- Centralize logic in `BeamPropagationManager`.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Beam Splitting (Prisms)
- Story 003: Color Filtration (Filters)

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Mirror reflects beam at 90°
  - Given: A standard light beam and a Mirror angled at 45° relative to the beam.
  - When: The beam strikes the center of the Mirror.
  - Then: The output beam is generated traveling at a 90° angle to the input beam's path.
  - Edge cases: Beam striking the back (non-reflective) side of the mirror (should be blocked/ignored).

- **AC-2**: Mirrors snap to 15° increments
  - Given: A Mirror object in placement/rotation mode.
  - When: The player attempts to rotate the mirror by an arbitrary amount (e.g., 7° or 18°).
  - Then: The mirror's final rotation snaps to the nearest 15° boundary (0° or 15° respectively).
  - Edge cases: Rotation input landing exactly on a 7.5° halfway boundary.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_001_core_propagation_test.gd` — must exist and pass

**Status**: [x] Created

---

## Dependencies

- Depends on: None
- Unlocks: Story 002, Story 003, Story 004, Story 005, Story 006, Story 007

## Completion Notes
**Completed**: 2026-06-11
**Criteria**: 2/2 passing 
**Deviations**: None
**Test Evidence**: Logic: test file at `tests/unit/beam_mechanics/story_001_core_propagation_test.gd`
**Code Review**: Complete
