# Story 003: Off-Grid Wall Generation

> **Epic**: puzzle-solver
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-002`

**ADR Governing Implementation**: ADR-0005-puzzle-solver-algorithm.md
**ADR Decision Summary**: Generate physical boundary walls structurally encompassing the solved mathematical path in an off-grid manner.

**Engine**: Godot 4.6 | **Risk**: MEDIUM
**Engine Notes**: Abandoning `GridMap` loses internal batching optimizations.

**Control Manifest Rules (this layer)**:
- Required: Static typing.
- Forbidden: Generating walls before the mathematical path is calculated.
- Guardrail: Manage draw calls (e.g., CSG merging or MultiMeshInstance3D).

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Accept a solved valid mathematical path (`PackedVector3Array`).
- [ ] Generate and instantiate physical boundary walls structurally encompassing the solved path.
- [ ] The walls must not intersect the valid ray paths.

---

## Implementation Notes

*Derived from ADR-0005 Implementation Guidelines:*

- The generation pipeline strictly requires that the mathematical path is calculated *first* (in a pure data format) before walls are generated.
- Physical walls are generated *around* the active light paths to create a viable corridor.
- Wall geometry must properly encapsulate the paths without intercepting raycasts necessary for puzzle solvability.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Actual solving of the mathematical path.
- Mesh baking optimizations (deferred to Polish/Performance phases).

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Accept a solved valid mathematical path (`PackedVector3Array`).**
  - **Given:** A valid `PackedVector3Array` representing a solved path.
  - **When:** The wall generation system is initialized with this path.
  - **Then:** The system accepts the data structure and prepares for generation without throwing errors.
  - **Edge cases:** Empty array, array with invalid or non-contiguous points.

- **Test: Generate and instantiate physical boundary walls structurally encompassing the solved path.**
  - **Given:** A valid mathematical path loaded into the wall generation system.
  - **When:** The generation function is called.
  - **Then:** Physical boundary wall nodes (e.g., `StaticBody3D` with collision shapes) are instantiated into the scene tree, forming a structural corridor around the path.
  - **Edge cases:** Highly complex winding paths, extremely short paths, paths that cross over themselves.

- **Test: The walls must not intersect the valid ray paths.**
  - **Given:** A fully generated set of physical boundary walls encompassing a valid path.
  - **When:** Physics raycasts are fired along every segment of the original valid mathematical path.
  - **Then:** The raycasts successfully reach their endpoints without colliding with any of the generated boundary walls.
  - **Edge cases:** Sharp corners where walls might overlap, very narrow corridor configurations, edges of the grid.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/puzzle_solver/story_003_off_grid_walls_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 002
- Unlocks: None
