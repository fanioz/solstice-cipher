# Story 006: Spatial Teleportation (Portals)

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

- [ ] Portals always come in pairs.
- [ ] Portals are fully bidirectional: light entering A exits B, light entering B exits A.
- [ ] Portals process multiple distinct simultaneous beams independently.
- [ ] Light entering one Portal exits the other, maintaining its direction relative to the exit portal's rotation.
- [ ] Light exits the second Portal traveling in the SAME relative direction it entered the first.

---

## Implementation Notes

*Derived from ADR-0006 Implementation Guidelines:*

- Implement `Portal` subclass of `OpticNode` with a strict paired reference (`linked_portal`).
- When `BeamPropagationManager` raycast hits a `Portal`, calculate the entry angle relative to the entry portal's local transform. Translate this local vector to the `linked_portal`'s global transform to enqueue the next raycast bounce.
- `max_bounces` must correctly decrement to prevent infinite bouncing between portals (e.g. facing each other).

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Core Propagation & Mirrors
- Briefcase placement pairing logic (handled in UI epic).

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **AC-1**: Portals maintain relative direction
  - Given: Linked Portal A and Portal B, with Portal B rotated 90° relative to Portal A. A beam enters Portal A perfectly perpendicular to its face.
  - When: The beam exits Portal B.
  - Then: The exit beam travels perfectly perpendicular to Portal B's face, preserving its entry angle relative to the portal.
  - Edge cases: Beam entering at an extreme grazing angle.

- **AC-2**: Portals are fully bidirectional
  - Given: A linked pair of Portal A and Portal B.
  - When: A beam enters Portal A, and a completely separate beam enters Portal B.
  - Then: The first beam exits Portal B, and the second beam exits Portal A.
  - Edge cases: Infinite loops caused by a beam entering A, exiting B, hitting a mirror, and re-entering B.

- **AC-3**: Portals process multiple distinct simultaneous beams
  - Given: Linked Portal A and Portal B.
  - When: Two separate parallel beams enter Portal A at different offset points.
  - Then: Both beams exit Portal B maintaining their exact relative offsets and trajectories.
  - Edge cases: Two beams intersecting exactly at the portal's threshold plane.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/beam_mechanics/story_006_spatial_teleportation_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: None
