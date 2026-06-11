# Story 001: Float Quantization & Geometric Data Structures

> **Epic**: puzzle-solver
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 1.0
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-12

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-002`

**ADR Governing Implementation**: ADR-0005-puzzle-solver-algorithm.md
**ADR Decision Summary**: Abandon GridMap for strict radial geometry; use float quantization (`Vector3.snapped()`) to prevent iterative float drift and retain 15-degree angular precision.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Float snapping reliability across long ray paths verification required.

**Control Manifest Rules (this layer)**:
- Required: Static typing, strict separation.
- Forbidden: GridMap for optical ray paths.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Implement a utility to snap all geometric vectors (positions and directions) to a defined precision (e.g., `Vector3(0.001, 0.001, 0.001)`).
- [ ] Ensure 15-degree angular calculations are strictly quantized to prevent floating-point drift over iterative operations.
- [ ] Provide data structures for representing off-grid nodes in a radial graph context.

---

## Implementation Notes

*Derived from ADR-0005 Implementation Guidelines:*

- Implement `func _snap_vector(vec: Vector3) -> Vector3` to explicitly quantize positions and vectors at every node evaluation step.
- Ensure the geometric data structure can natively handle coordinates derived from exactly 15-degree rotations.
- **Performance Budget**: Vector snapping operations occur on every node evaluation during raycasting and must be highly performant. The `Vector3.snapped()` calculations are mathematically negligible and should not exceed $0.1$ms total per frame even with `MAX_BOUNCES` limits in place. Graph data structure modifications happen exclusively during the level generation phase and should remain under 5ms total chunk time.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: AStar Pathfinding logic using this structure.
- Story 003: Wall generation based on the path.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Implement a utility to snap all geometric vectors (positions and directions) to a defined precision (e.g., `Vector3(0.001, 0.001, 0.001)`).**
  - **Given:** An arbitrary `Vector3` with high-precision or slightly imprecise floating-point values (e.g., `Vector3(1.0004, 2.0005, -3.0009)`).
  - **When:** The snap utility function is applied to the vector.
  - **Then:** The resulting vector precisely matches the expected quantized coordinates (e.g., `Vector3(1.000, 2.001, -3.001)`).
  - **Edge cases:** Zero vectors, extremely small values below the precision threshold, large coordinate values.

- **Test: Ensure 15-degree angular calculations are strictly quantized to prevent floating-point drift over iterative operations.**
  - **Given:** A starting angle and an iterative rotation operation of exactly 15 degrees.
  - **When:** The rotation is applied iteratively 24 times (totaling 360 degrees).
  - **Then:** The final accumulated angle precisely matches the starting angle without any floating-point drift.
  - **Edge cases:** Negative rotation angles, alternating positive and negative rotations.

- **Test: Provide data structures for representing off-grid nodes in a radial graph context.**
  - **Given:** An empty radial graph data structure.
  - **When:** Multiple off-grid nodes (defined by radius and quantized angle) are added and connected with defined edges.
  - **Then:** The graph correctly stores the nodes, retrieves connected neighbors, and calculates correct edge costs based on radial geometry.
  - **Edge cases:** Duplicate nodes, self-referencing edges, querying non-existent nodes.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/puzzle_solver/story_001_quantization_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: None
- Unlocks: Story 002
