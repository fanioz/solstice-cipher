# Story 001: Level Scaffolding & Word Placement

> **Epic**: procedural-generation
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-001`

**ADR Governing Implementation**: ADR-0004-procedural-generation-system.md
**ADR Decision Summary**: Establish interface for dynamic puzzle instantiation using a backwards-solve approach.

**Engine**: Godot 4.6 | **Risk**: HIGH
**Engine Notes**: `duplicate_deep()` for per-instance resources, `@abstract` for generation interface. Verification required for loading screen freezing behavior.

**Control Manifest Rules (this layer)**:
- Required: Static typing, strict architectural separation (UI decoupled from Core).
- Forbidden: Untyped variables, singletons with global states that are modified unpredictably.
- Guardrail: Maintain fast initial load (sub 2s).

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [ ] Select word from curated list based on tier's word length range.
- [ ] Place Source at a fixed position (bottom-left of board).
- [ ] Place Glyphs at random valid positions on the board.
- [ ] No Glyph may overlap another Glyph or the Source.
- [ ] Glyphs must stay within the playable area (excluding the Briefcase zone).

---

## Implementation Notes

*Derived from ADR-0004 Implementation Guidelines:*

- Use `RandomNumberGenerator` instantiated locally with the `difficulty_seed` rather than using global `randi()`, guaranteeing determinism.
- Implement `@abstract class_name ProceduralPuzzleGenerator extends Node` interface.
- Grid positions should be represented by `Vector2i` and validated against a defined playable area configuration, leaving the bottom 160px for the Briefcase UI zone.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Backwards solver path routing.
- Story 003: Inventory extraction.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Select word from curated list based on tier's word length range.**
  - **Given:** A level generation request for a specific tier (e.g., Tier 1 with word length 3-4).
  - **When:** The word selector is invoked.
  - **Then:** The selected word is from the curated list and its length falls strictly within the tier's range.
  - **Edge cases:** Tier requests for lengths not present in the curated list; empty curated list.

- **Test: Place Source at a fixed position.**
  - **Given:** A new level board initialization.
  - **When:** Board scaffolding is run.
  - **Then:** The Source entity is present exactly at the designated bottom-left grid coordinate.
  - **Edge cases:** Board size configured too small to contain the fixed coordinate.

- **Test: Place Glyphs at random valid positions on the board.**
  - **Given:** A selected word of length N and an initialized board.
  - **When:** Glyph placement runs.
  - **Then:** Exactly N Glyphs are instantiated on the board at valid integer grid coordinates.
  - **Edge cases:** Maximum word length on the smallest valid board size (density check).

- **Test: No Glyph may overlap another Glyph or the Source.**
  - **Given:** A board undergoing Glyph placement.
  - **When:** Multiple Glyphs and the Source are placed.
  - **Then:** All placed entities have unique grid coordinates with no intersections.
  - **Edge cases:** Grid space is smaller than the number of entities to place.

- **Test: Glyphs must stay within the playable area (excluding the Briefcase zone).**
  - **Given:** A board with defined playable bounds and Briefcase bounds.
  - **When:** Glyph placement runs.
  - **Then:** No Glyph coordinates intersect the Briefcase zone or lie outside the playable bounds.
  - **Edge cases:** Placement attempts directly on the boundary edge of the Briefcase zone.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/procedural_generation/story_001_scaffolding_test.gd` — must exist and pass

**Status**: [x] COVERED

---

## Dependencies

- Depends on: None
- Unlocks: Story 002
