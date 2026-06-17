# Story 001: Save Data Dictionary Serialization

> **Epic**: progression
> **Status**: Complete
> **Layer**: Core
> **Type**: Logic
> **Estimate**: 
> **Manifest Version**: 2026-06-09
> **Last Updated**: 

## Context

**GDD**: `design/specs/2026-06-08-level-progression-design.md`
**Requirement**: `TR-level-006`

**ADR Governing Implementation**: ADR-0009-save-system.md
**ADR Decision Summary**: Avoid ResourceSerialization to prevent ACE vulnerability. Instead, serialize data into primitive Dictionaries containing no `Object` or `Resource` types.

**Engine**: Godot 4.6 | **Risk**: LOW
**Engine Notes**: Godot Dictionary and Array typecasting.

**Control Manifest Rules (this layer)**:
- Required: Strict type checking.
- Forbidden: Using `ResourceSaver` for save files. Storing `Object` instances.

---

## Acceptance Criteria

*From GDD `design/specs/2026-06-08-level-progression-design.md`, scoped to this story:*

- [x] Aggregate game state (level unlocks, unlocked tools, current zone) into a structured `Dictionary` containing only primitives (Strings, ints, floats, Arrays, Dictionaries) and native Godot math Variants (e.g. `Vector3`).
- [x] Ensure no Godot `Object` or `Resource` instances are included in the dictionary, actively converting necessary references (like item types) into String IDs.

---

## Implementation Notes

*Derived from ADR-0009 Implementation Guidelines:*

- Implement a static helper function `func serialize_state() -> Dictionary` on the progression manager.
- If the game needs to remember an unlocked tool, store its `String` name or ID (e.g. `"prism"`), not the loaded `PackedScene` or `Resource`.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: Actually writing the dictionary to the disk.

---

## QA Test Cases

*Written by qa-lead at story creation. The developer implements against these — do not invent new test cases during implementation.*

**[For Logic / Integration stories — automated test specs]:**

- **Test: Aggregate game state (level unlocks, unlocked tools, current zone) into a structured `Dictionary` containing only primitives and native Godot math Variants.**
  - **Given:** An active game state containing mock level unlocks, tools, and a current zone.
  - **When:** The serialization function is called.
  - **Then:** It returns a Dictionary containing the correct mapped values and types.
  - **Edge cases:** Empty game state, missing non-critical fields.

- **Test: Ensure no Godot `Object` or `Resource` instances are included in the dictionary, actively converting necessary references (like item types) into String IDs.**
  - **Given:** A game state containing Godot Resource/Object instances (e.g., tool resources).
  - **When:** The serialization function is called.
  - **Then:** The resulting Dictionary contains String IDs instead of the Objects, and a recursive type check confirms no Objects exist in the dictionary tree.
  - **Edge cases:** Deeply nested arrays/dictionaries containing objects, null object references.

---

## Test Evidence

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/progression/story_001_data_serialization_test.gd` — must exist and pass

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: None
- Unlocks: Story 002
