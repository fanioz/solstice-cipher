# Story 003: Inventory Extraction & Budgeting

> **Epic**: procedural-generation
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-001`

**ADR Governing Implementation**: ADR-0004-procedural-generation-system.md
**ADR Decision Summary**: Establish interface for dynamic puzzle instantiation and tool management.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: `duplicate_deep()` for per-instance resources, `@abstract` for generation interface.

**Control Manifest Rules (this layer)**:
- Required: Static typing, strict separation of concerns.
- Forbidden: Untyped variables, UI dependencies in logic scripts.
- Guardrail: None explicitly defined yet.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Determine Briefcase budget: The number of tools used in the solution + 0–2 extra "red herring" pieces.
- [ ] Clear the board of solution tools (except Source and Glyphs).
- [ ] Removed tools go into the Briefcase as the player's inventory.

---

## Implementation Notes

*Derived from ADR-0004 Implementation Guidelines:*

- Once the path-solver (Story 002) successfully completes the maze, evaluate the placed interactive tool nodes (mirrors, lenses, switches).
- Generate Briefcase inventory data based on the tools found, plus 0-2 randomly injected red herring pieces matching the current tier.
- Remove the tools from the `SceneTree` / `GridMap` grid. The visual nodes will be instantiated later by the player.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Path solving.
- Briefcase UI implementation (Handled in UI Epic).

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Determine Briefcase budget (solution tools + 0–2 extra "red herring" pieces).**
  - **Given:** A generated level with a valid solution using N tools.
  - **When:** Inventory budgeting runs.
  - **Then:** The Briefcase budget is set to N + R (where R is an integer between 0 and 2).
  - **Edge cases:** Total budget exceeds the maximum UI slots available in the Briefcase.

- **Test: Clear the board of solution tools.**
  - **Given:** A board with a generated solution path (tools placed).
  - **When:** The clearing phase runs.
  - **Then:** All tool entities are removed from the board; only the Source and Glyphs remain.
  - **Edge cases:** Board already empty of tools.

- **Test: Removed tools go into the Briefcase as the player's inventory.**
  - **Given:** The set of N tools used in the solution and R red herring tools.
  - **When:** The inventory extraction runs.
  - **Then:** The Briefcase contains exactly the combined list of tools for the player to use.
  - **Edge cases:** Red herrings duplicate existing tools vs. introducing new tool types.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/procedural_generation/story_003_inventory_extraction_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 002
- Unlocks: Story 004
