# Story 002: Beam Splitting (Prisms)

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 1.0
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

- [ ] Prism splits the beam — one reflected at 90° relative to the prism's face normal (always to the prism's local 'right'), one passes straight through.
- [ ] Beam is blocked completely if it strikes any of the non-splitting faces (the flat sides or the back) of the prism.
- [ ] The prism respects the `max_bounces` limit; if a beam strikes it when the limit is reached, it terminates and emits nothing.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Implement `Prism` subclass of `OpticNode`.
- When raycast strikes `Prism`, the logic should queue *two* new beams back into the `BeamPropagationManager` iterative loop (one reflecting at 90°, one traveling straight).
- Both beams must deduct from `max_bounces` to prevent runaway geometric explosion.
- **Performance Budget**: Because prisms cause exponential geometric beam growth ($O(2^n)$ beams where $n$ is depth), the recursive raycast loop must complete in under 2ms per frame. The `max_bounces` limit guarantees this ceiling.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Core Propagation & Mirrors
- Story 003: Color Filtration (Filters)

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Prism splits the beam straight and right
  - Given: A light beam and a Prism aligned with the beam's path.
  - When: The beam strikes the Prism.
  - Then: Two output beams are produced; one continues perfectly straight, and the other travels at a 90° angle to the Prism's local right.
  - Edge cases: Beam striking the prism off-center or grazing the edge; beam striking non-splitting faces of the prism.

- **AC-2**: Prism blocks beams from invalid angles
  - Given: A light beam and a Prism aligned perpendicular to the beam's path.
  - When: The beam strikes the flat, non-splitting side of the Prism.
  - Then: Zero output beams are produced (the beam is blocked).

- **AC-3**: Prism respects bounce limits
  - Given: A light beam with its bounce counter equal to `MAX_BOUNCES` and a Prism in its path.
  - When: The beam strikes the splitting face of the Prism.
  - Then: The propagation halts and no new beams are queued into the active rays array.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_002_beam_splitting_test.gd` — must exist and pass

## Completion Notes
**Completed**: 2026-06-11
**Criteria**: 3/3 passing
**Deviations**: None
**Test Evidence**: Logic: test file at `tests/unit/beam_mechanics/story_002_beam_splitting_test.gd`
**Code Review**: Complete

**Status**: [X] Complete

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
