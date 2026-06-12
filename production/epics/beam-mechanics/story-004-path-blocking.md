# Story 004: Path Blocking (Shades)

> **Epic**: beam-mechanics
> **Status**: Ready
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 0.5
> **Performance Budget**: < 2ms per bending logic iteration (Core layer requirement)
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

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

- [ ] Placing a Shade stops a beam dead.
- [ ] Shades are solid — no light passes through or bounces off.
- [ ] A Shade placed in a split beam path blocks only that branch.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Implement `Shade` subclass of `OpticNode` or standard static body on `LAYER_OPTICS`.
- The `BeamPropagationManager` must naturally terminate the beam path when striking a `Shade` (do not enqueue further bounces).
- Ensure raycast correctly distinguishes between Shade and Walls, even though both block light.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Beam Splitting (Prisms)

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Shade stops a beam dead
  - Given: A light beam and a Shade placed in its path.
  - When: The beam strikes the Shade.
  - Then: The beam is terminated precisely at the Shade's surface; no light passes through or reflects.
  - Edge cases: Beam hitting the exact corner or grazing the edge of the Shade.

- **AC-2**: Shade in a split path blocks only that branch
  - Given: A beam split by a Prism into Branch A and Branch B.
  - When: A Shade is placed in the path of Branch A.
  - Then: Branch A is blocked, but Branch B continues to propagate unaffected.
  - Edge cases: Shade placed extremely close to the split origin point.

- **AC-3**: Multiple beams striking the same Shade
  - Given: Two or more light beams converging on the same Shade from different angles.
  - When: Both beams strike the Shade.
  - Then: Both beams are terminated; neither passes through nor reflects, and no overlapping logic errors occur.
  - Edge cases: Beams hitting the exact same coordinate on the Shade simultaneously.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_004_path_blocking_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
