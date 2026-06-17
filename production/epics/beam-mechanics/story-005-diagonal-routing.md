# Story 005: Diagonal Routing (Benders)

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 1.0
> **Performance Budget**: < 2ms per bending logic iteration (Core layer requirement)
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-12

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-003`

**ADR Governing Implementation**: ADR-0006-beam-propagation-system.md
**ADR Decision Summary**: Establish core rules for beam pathing and interaction with optical tools using native Jolt Physics raycasting.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Use `@abstract` (Godot 4.5+); Jolt raycast precision verification required.

**Control Manifest Rules (this layer)**:
- Required: InputManager queries, Static Typing
- Forbidden: Never call Input directly, Never use untyped GDScript variables
- Guardrail: None explicitly defined yet

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Bender deflects the beam at 45°.
- [ ] Benders snap to 15° increments.
- [ ] The deflection angle is always 45° relative to the Bender's normal.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Implement `Bender` subclass of `OpticNode`.
- Use `Vector3.snapped()` on calculated reflection vectors to avoid Jolt float drift along diagonals, ensuring reliable grid alignment across long diagonal paths.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Core Propagation & Mirrors

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Bender deflects the beam at 45°
  - Given: A light beam and a Bender object.
  - When: The beam strikes the Bender.
  - Then: The output beam travels at a 45° angle relative to the Bender's normal.
  - Edge cases: Beam striking the back or non-routing sides of the Bender.

- **AC-2**: Benders snap to 15° increments
  - Given: A Bender object in placement/rotation mode.
  - When: The player rotates the Bender.
  - Then: The rotation snaps to the nearest 15° increment.
  - Edge cases: Rapid, continuous rotation input.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_005_diagonal_routing_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
