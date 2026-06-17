# Story 002: Backwards Solver Algorithm

> **Epic**: procedural-generation
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-002`

**ADR Governing Implementation**: ADR-0004-procedural-generation-system.md
**ADR Decision Summary**: We will implement a backwards-solve path-tracing algorithm (tracing paths from the Glyphs back to the Source) to procedurally generate solvable optical logic puzzles.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: `@abstract` for generation interface. Verification required for loading screen freezing behavior.

**Control Manifest Rules (this layer)**:
- Required: Static typing, deterministic RNG using `difficulty_seed`.
- Forbidden: Untyped variables, singletons with global states.
- Guardrail: Max-retry limit needed to fallback if solver fails.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Starting from the Glyphs, trace beam paths back to the Source, placing required tools along the path.
- [ ] Every generated level MUST be solvable (guaranteed by the backwards-solve).
- [ ] All Glyphs must be reachable by the available tools within the piece budget.

---

## Implementation Notes

*Derived from ADR-0004 Implementation Guidelines:*

- Trace logic from Goal Nodes (Glyphs) backwards towards the Source.
- Instantiate required mirrors and logic nodes along the traced path on a strict grid.
- Implement a max-retry limit that silently regenerates with a slight seed perturbation if the solver gets stuck (path-tracing fails to find a valid source path).

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 003: Calculating the Briefcase budget from the solution and extracting tools to inventory.
- Story 004: Async chunking across frames.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Starting from the Glyphs, trace beam paths back to the Source, placing required tools.**
  - **Given:** A board with placed Source and Glyphs.
  - **When:** The backwards solver runs.
  - **Then:** A connected path of tools is generated from the Source to all Glyphs.
  - **Edge cases:** Glyphs placed such that paths must intersect (requiring splitters/prisms); no valid path exists within board bounds.

- **Test: Every generated level MUST be solvable.**
  - **Given:** A generated level with Source, Glyphs, and placed tools.
  - **When:** The forward gameplay simulation (validator) evaluates the board.
  - **Then:** The beams from the Source successfully activate all Glyphs simultaneously.
  - **Edge cases:** Tools placed creating infinite loops; beams hitting the wrong face of a target.

- **Test: All Glyphs must be reachable by the available tools within the piece budget.**
  - **Given:** A tier with a specific piece budget limit.
  - **When:** The backwards solver runs.
  - **Then:** The total number of tools placed is less than or equal to the piece budget.
  - **Edge cases:** Budget is too small for the spatial distance between Source and Glyphs (should cleanly trigger a retry or board rejection).

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/procedural_generation/story_002_backwards_solver_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: Story 001
- Unlocks: Story 003
