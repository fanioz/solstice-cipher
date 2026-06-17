# Story 003: Color Filtration (Filters)

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 
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

- [ ] Filter tints the beam a specific color (Red, Blue, or Gold).
- [ ] Filters do NOT change beam direction — light passes straight through.
- [ ] A beam can pass through multiple Filters; the last Filter's color wins.
- [ ] Colored beams can still reflect off Mirrors and split through Prisms.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Implement `Filter` subclass of `OpticNode`.
- When raycast strikes `Filter`, queue the output beam maintaining the same vector, but modify the color property of the data passed to the next iteration in the `BeamPropagationManager`.
- Rely on additive HDR rendering for visual glow (ADR-0007 approach applied to visuals).

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Core Propagation & Mirrors
- Story 007: Multi-source Convergence (Combiners)

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Filter tints the beam
  - Given: A white light beam and a Red Filter.
  - When: The beam passes through the Filter.
  - Then: The output beam's color property is Red and its path remains perfectly straight.
  - Edge cases: A colored beam entering a filter of its exact same color.

- **AC-2**: Last Filter's color wins
  - Given: A white light beam passing through a Red Filter, then subsequently through a Blue Filter.
  - When: The beam exits the Blue Filter.
  - Then: The final beam's color property is exclusively Blue.
  - Edge cases: Filters placed perfectly overlapping in space.

- **AC-3**: Colored beams interact with other objects
  - Given: A Red beam.
  - When: The Red beam strikes a Mirror, then passes into a Prism.
  - Then: The beam reflects at 90° retaining the Red color, and then splits into two Red beams.
  - Edge cases: N/A

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_003_color_filtration_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
