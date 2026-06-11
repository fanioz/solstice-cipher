# Story 002: Custom Optical Radial A* Solver

> **Epic**: puzzle-solver
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 2.5
> **Manifest Version**: 2026-06-09
> **Last Updated**: 2026-06-12

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-002`

**ADR Governing Implementation**: ADR-0005-puzzle-solver-algorithm.md
**ADR Decision Summary**: Implement a pure GDScript A* pathfinding class (`OpticalRadialAStar`) tailored exclusively for the radial/polar geometric graph. Evaluates paths backwards from Glyphs to Source.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: Pure GDScript optimization.

**Control Manifest Rules (this layer)**:
- Required: Static typing.
- Forbidden: Using native `AStar3D` due to language context-switch overhead for custom heuristics.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Implement a pure GDScript A* solver (`OpticalRadialAStar`) without using native `AStar3D`.
- [ ] The algorithm must calculate paths backwards from the goal to the source.
- [ ] Provide heuristic calculation modes (`DIRECT`, `WINDING`, `MAXIMUM_BOUNCES`).
- [ ] Return the solved path as a strictly ordered `PackedVector3Array` of snapped waypoints.

---

## Implementation Notes

*Derived from ADR-0005 Implementation Guidelines:*

- Base class: `class_name OpticalRadialAStar extends RefCounted`
- `OpticalRadialAStar` will handle all heuristic and cost calculations locally via inline `match` statements based on an `enum DifficultyMode { DIRECT, WINDING, MAXIMUM_BOUNCES }`.
- Implement `func calculate_backwards_path(goal_pos: Vector3, source_pos: Vector3, mode: DifficultyMode) -> PackedVector3Array`.
- **Performance Budget**: The pure GDScript pathfinding traversal should complete within 5ms. Optimization is critical here to avoid frame drops during dynamic chunk generation.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: Implementing the data structures and float snapping utility.
- Story 003: Placing the wall nodes around the solved mathematical path.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Implement a pure GDScript A* solver (`OpticalRadialAStar`) without using native `AStar3D`.**
  - **Given:** A populated radial graph data structure with a known valid path between a source and goal node.
  - **When:** The `OpticalRadialAStar` solver is executed.
  - **Then:** The solver successfully finds the optimal path without instantiating or calling Godot's native `AStar3D` class.
  - **Edge cases:** Graph with no possible path, source and goal are the same node, disconnected graph segments.

- **Test: The algorithm must calculate paths backwards from the goal to the source.**
  - **Given:** A graph where forward and backward pathfinding would evaluate nodes in a distinctly different order.
  - **When:** The solver executes a search from source to goal (reversing the heuristic direction).
  - **Then:** The node evaluation order (or internal explored set) confirms the search originated at the goal and progressed toward the source.
  - **Edge cases:** Symmetrical graphs, paths requiring heavy backtracking.

- **Test: Provide heuristic calculation modes (`DIRECT`, `WINDING`, `MAXIMUM_BOUNCES`).**
  - **Given:** A complex radial graph where the optimal path differs based on the heuristic penalty (e.g., winding paths vs. direct paths).
  - **When:** The solver is run multiple times, each with a different heuristic mode (`DIRECT`, `WINDING`, `MAXIMUM_BOUNCES`).
  - **Then:** Each run returns the correct, potentially distinct path optimized for the specified heuristic.
  - **Edge cases:** Invalid heuristic mode provided, simple graph where all heuristics result in the same path.

- **Test: Return the solved path as a strictly ordered `PackedVector3Array` of snapped waypoints.**
  - **Given:** A successfully completed pathfinding operation.
  - **When:** The path result is returned.
  - **Then:** The result is of type `PackedVector3Array`, the points are in the correct sequential order from source to goal, and every point is strictly quantized using the float quantization utility.
  - **Edge cases:** Empty path returned (no solution), path with only one waypoint.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/puzzle_solver/story_002_optical_radial_astar_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: Story 003
