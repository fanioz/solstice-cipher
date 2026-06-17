# Story 007: Multi-source Convergence (Combiners)

> **Epic**: beam-mechanics
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-004`

**ADR Governing Implementation**: ADR-0007-beam-convergence.md
**ADR Decision Summary**: Use Node-based Additive Color Blending. Two-phase accumulate-then-resolve pattern during the raycast loop.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Frame synchronization for multi-raycast hit resolution, State Resetting, HDR Glow tonemapping.

**Control Manifest Rules (this layer)**:
- Required: InputManager queries, Static Typing
- Forbidden: Never call Input directly, Never use untyped GDScript variables
- Guardrail: None explicitly defined yet

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Combiner requires TWO separate beams hitting it simultaneously on its two dedicated input faces before it emits a single beam from its output face. Beams hitting other sides are ignored.
- [ ] Both inputs must be lit simultaneously for the output to activate.
- [ ] The output beam direction is fixed (based on the Combiner's rotation).
- [ ] The output beam color is an additive blend of the two input beams (e.g., Red + Blue = Magenta).

---

## Implementation Notes

*Derived from ADR-0007 Implementation Guidelines:*

- Implement `Combiner` subclass of `OpticNode`.
- **Clear Phase**: `BeamPropagationManager` explicitly calls a clear method on all Combiners at the start of the frame's update.
- **Accumulation Pass**: Combiner stores incoming beam data (`color`, `direction`, `hit_face`) in an array.
- **Resolution Pass**: Manager calls `_resolve_convergence()`. If two distinct valid inputs are accumulated, blend colors (`blend_beam_colors()`) and return the output beam vector to enqueue in the Manager.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Core Propagation & Mirrors
- Color filtering specifics (Story 003).

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Combiner requires two inputs
  - Given: A Combiner with two input faces.
  - When: Only one beam strikes one of the input faces.
  - Then: No output beam is emitted.
  - Edge cases: A single beam split earlier in the level striking both input faces simultaneously.

- **AC-2**: Combiner emits single output when both inputs hit
  - Given: A Combiner with two input faces.
  - When: Two separate beams strike the two input faces simultaneously.
  - Then: A single output beam is emitted from the designated output face.
  - Edge cases: Input beams flickering on and off on alternating frames.

- **AC-3**: Combiner additive color blending
  - Given: A Combiner receiving a Red beam on input 1 and a Blue beam on input 2.
  - When: The Combiner activates.
  - Then: The single output beam's color property is Magenta (Additive Red + Blue).
  - Edge cases: Beams of the same color combining; a white beam combining with a colored beam.

- **AC-4**: Combiner ignores hits on non-input sides
  - Given: A Combiner object.
  - When: A beam strikes a side that is NOT one of the two dedicated input faces.
  - Then: The beam is either blocked or ignored, and does not trigger or contribute to the Combiner's output.
  - Edge cases: Beam grazing the edge between an input and non-input face.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_007_multi_source_convergence_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
